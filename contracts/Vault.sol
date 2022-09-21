// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "./interfaces/IVoucher.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vault is Ownable{
    function mint(address _voucher, address _to) public onlyOwner {
        IVoucher(_voucher).mint(_to);
    }
    function redeem (address _voucher, address _customer) public onlyOwner {
        IVoucher(_voucher).redeem(_customer);
    }

    function withdraw(uint256 _amount) public payable onlyOwner {
        payable(msg.sender).transfer(_amount);
    }
}
