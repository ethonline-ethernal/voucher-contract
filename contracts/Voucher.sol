// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Voucher is ERC1155  , Ownable , AccessControl {
    uint256 constant voucher = 1;
    uint256 constant usedVoucher = 2;
    uint256 public maxSupply;
    string public name;
    string public symbol;
    string internal baseURI;
    bytes32 public constant VAULT = keccak256("VAULT");
    event GrantAccess(address indexed account);

    constructor(string memory _name ,string memory _symbol , string memory _baseURI , uint256 _maxSupply) 
    ERC1155(_baseURI) {
        name = _name;
        symbol = _symbol;
        baseURI = _baseURI;
        maxSupply = _maxSupply;
    }

    function mint(address _to) public onlyRole(VAULT) {
        _mint(_to,voucher, 1, "Ethernal Voucher");
    }

    function redeem (address _customer) public onlyRole(VAULT) {
        _burn(_customer,voucher, 1);
        _mint(_customer,usedVoucher, 1, "Used Voucher");
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
}