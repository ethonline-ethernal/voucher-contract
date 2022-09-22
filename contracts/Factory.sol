// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/IVoucher.sol";
import "./interfaces/ITokenGated.sol";
import "./Voucher.sol";
import "./TokenGatedVoucher.sol";

library TokenGateHelper{
    function deployTokenGate(string memory _collectionName ,string memory _collectionSymbol, string memory _baseURI , uint256 _quantity , address _tokenGatedAddress)public returns(address){
        return address(new TokenGatedVoucher(_collectionName,_collectionSymbol, _baseURI , _quantity, _tokenGatedAddress));
    }
}

library VoucherHelper{
    function deployVoucher(string memory _collectionName ,string memory _collectionSymbol, string memory _baseURI , uint256 _quantity)public returns(address){
        return address(new Voucher(_collectionName,_collectionSymbol, _baseURI , _quantity));
    }
}

contract Factory {

    mapping (string => address) public voucherAddress;
    mapping (uint256 => string) public voucherName;
    event VoucherCreated(address indexed voucherAddress, string name);
    using Counters for Counters.Counter;
    address constant private vault_address = 0xCfc597a8793E0ca94FC8310482D9e11367cfCA24;

    Counters.Counter private collectionIds;
    Voucher public _voucher;

    function createVoucher(string memory _collectionName ,string memory _collectionSymbol, string memory _baseURI , uint256 _quantity) public{
        require(voucherAddress[_collectionName] == address(0), "Collection name can not be duplicated");
        address voucher = VoucherHelper.deployVoucher(_collectionName,_collectionSymbol, _baseURI , _quantity);
        IVoucher(voucher).giveAccessToVault(msg.sender);
        IVoucher(voucher).giveAccessToVault(vault_address);
        IVoucher(voucher).transferOwnership(msg.sender);
        collectionIds.increment();
        uint256 collectionId = collectionIds.current();
        voucherName[collectionId] = _collectionName;
        voucherAddress[_collectionName] = address(voucher);
        emit VoucherCreated(address(voucher), _collectionName);
    }

    function createTokenGatedVoucher (string memory _collectionName ,string memory _collectionSymbol, string memory _baseURI , uint256 _quantity, address _tokenGatedAddress) public {
        require(voucherAddress[_collectionName] == address(0), "Collection name can not be duplicated");
        address voucher = TokenGateHelper.deployTokenGate(_collectionName,_collectionSymbol, _baseURI , _quantity, _tokenGatedAddress);
        ITokenGated(voucher).giveAccessToVault(msg.sender);
        ITokenGated(voucher).giveAccessToVault(vault_address);
        ITokenGated(voucher).transferOwnership(msg.sender);
        collectionIds.increment();
        uint256 collectionId = collectionIds.current();
        voucherName[collectionId] = _collectionName;
        voucherAddress[_collectionName] = address(voucher);
        emit VoucherCreated(address(voucher), _collectionName);
    }

    function getVoucherAddress(string memory _collectionName) public view returns (address) {
        return voucherAddress[_collectionName];
    }
}
