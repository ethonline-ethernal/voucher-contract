// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract TokenGatedVoucher is ERC1155 , Ownable , AccessControl {
    uint256 constant voucher = 1;
    uint256 constant usedVoucher = 2;
    uint256 public quantity;
    string public name;
    string public symbol;
    string internal baseURI;
    mapping (uint256 => bool) public mintedTokenID;
    address public tokenGated;
    bytes32 public constant VAULT = keccak256("VAULT");
    event GrantAccess(address indexed account);

    constructor(string memory _name ,string memory _symbol , string memory _baseURI , uint256 _quantity , address _tokenGated) 
    ERC1155(_baseURI) {
        name = _name;
        symbol = _symbol;
        baseURI = _baseURI;
        quantity = _quantity;
        tokenGated = _tokenGated;
    }

    function mint(address _to , uint256 _tokenID) public {
       // require(isNFTOwner(_tokenID , _to), "This address is not the owner of the TokenGated NFT");
        require(!isMint(_tokenID), "This NFT tokenID is already mint voucher");
        _mint(_to,voucher, 1, "Ethernal Voucher");
        mintedTokenID[_tokenID] = true;
    }

    function redeem (address _customer, uint256 _tokenID) public onlyRole(VAULT) {
        require(isMint(_tokenID), "This NFT tokenID is not mint voucher");
        _burn(_customer,voucher, 1);
        _mint(_customer,usedVoucher, 1, "Used Voucher");
    }

    function isMint(uint256 _tokenID) public view returns (bool) {
        if (mintedTokenID[_tokenID] == true) {
            return true;
        }
        return false;
    }

    function isNFTOwner(
        uint256 _tokenId ,
        address _account
    ) public view returns (bool) {
        return _account == IERC721(tokenGated).ownerOf(_tokenId);
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