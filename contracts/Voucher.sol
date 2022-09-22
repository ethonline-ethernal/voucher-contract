// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Voucher is ERC1155  , Ownable , AccessControl {
    uint256 constant voucher = 1;
    uint256 constant usedVoucher = 2;
    uint256 public quantity;
    string public name;
    string public symbol;
    string internal baseURI;
    mapping (address => bool) public mintedAddress;
    bytes32 public constant VAULT = keccak256("VAULT");
    event GrantAccess(address indexed account);

    constructor(string memory _name ,string memory _symbol , string memory _baseURI , uint256 _quantity) 
    ERC1155(_baseURI) {
        name = _name;
        symbol = _symbol;
        baseURI = _baseURI;
        quantity = _quantity;
    }

    function mint(address _to) public{
        require(!isMint(_to), "This address is already mint voucher");
        _mint(_to,voucher, 1, "Ethernal Voucher");
        mintedAddress[_to] = true;
    }

    function redeem (address _customer , bytes calldata _signature) public onlyRole(VAULT) {
        require(isMint(_customer), "This address is not minted");
        require(_verify(_hash(_customer), _signature), "Invalid signature");
        _burn(_customer,voucher, 1);
        _mint(_customer,usedVoucher, 1, "Used Voucher");
    }

    function isMint(address _to) public view returns (bool) {
        if (mintedAddress[_to] == true) {
            return true;
        }
        return false;
    }

    function uri(uint256 _id) public view override returns (string memory) {
        return string(abi.encodePacked(baseURI, Strings.toString(_id), ".json"));
    }

    function giveAccessToVault(address _vault) public onlyOwner {
        _grantRole(VAULT, _vault);
        emit GrantAccess(_vault);
    }

     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _hash (address _to) internal pure returns (bytes32) {
        return ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(_to)));
    }

    function _verify(bytes32 _digest, bytes memory _signature) internal view returns (bool) {
        return hasRole(VAULT,ECDSA.recover(_digest, _signature));
    }
}