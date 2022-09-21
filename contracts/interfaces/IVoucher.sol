// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

interface IVoucher{
    function mint(address _to) external;
    function redeem (address _customer) external;
}