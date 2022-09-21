//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract Voucher is ERC1155  , Ownable  {
    uint256 constant voucher = 1;
    uint256 constant usedVoucher = 2;
    string public name;
    string internal baseURI;

    constructor(string memory _name ,string memory _baseURI ) 
    ERC1155(_baseURI) {
        name = _name;
        baseURI = _baseURI;
    }
    function mint(address _to) public onlyOwner {
        _mint(_to,voucher, 1, "Ethernal Voucher");
    }

    function redeem (address _customer) public onlyOwner {
        _burn(_customer,voucher, 1);
        _mint(_customer,usedVoucher, 1, "Used Voucher");
    }

    function uri(uint256 _id) public view override returns (string memory) {
        return string(abi.encodePacked(baseURI, Strings.toString(_id), ".json"));
    }
}