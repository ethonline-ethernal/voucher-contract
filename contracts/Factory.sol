// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./Voucher.sol";

contract Factory {

    mapping (string => address) public voucherAddress;
    mapping (uint256 => string) public voucherName;
    event VoucherCreated(address indexed voucherAddress, string name);
    using Counters for Counters.Counter;
    address constant private vault = 0xCfc597a8793E0ca94FC8310482D9e11367cfCA24;

    Counters.Counter private collectionIds;
    Voucher public _voucher;

    function createVoucher(string memory _collectionName ,string memory _collectionSymbol, string memory _baseURI , uint256 _maxSupply) public{
        require(voucherAddress[_collectionName] == address(0), "Collection name can not be duplicated");
        Voucher voucher = new Voucher(_collectionName,_collectionSymbol, _baseURI , _maxSupply);
        voucher.giveAccessToVault(msg.sender);
        voucher.giveAccessToVault(vault);
        voucher.transferOwnership(msg.sender);
        uint256 collectionId = collectionIds.current();
        voucherName[collectionId] = _collectionName;
        voucherAddress[_collectionName] = address(voucher);
        collectionIds.increment();
        emit VoucherCreated(address(voucher), _collectionName);
    }
}
