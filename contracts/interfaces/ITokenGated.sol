// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

interface ITokenGated{
    function mint(address _to , uint256 _tokenID) external;
    function redeem (address _customer , uint256 _tokenID) external;
    function giveAccessToVault (address _vault) external;
    function transferOwnership(address newOwner) external;
}