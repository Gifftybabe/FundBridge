//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error FundMe_NotOwner();
error FundMe_NotEnoughETHSent();
error FundMe_NoFundsToWithdraw();
error FundMe_callFailed();

contract FundMe {

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;
    address[] public fundersAddress;
    address public immutable i_owner;

    mapping(address => uint256) public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }

    modifier onlyOwner {
        // require(msg.sender == i_owner, 'You are not the owner');
        if(msg.sender != i_owner) {
            revert FundMe_NotOwner();
        }
        _;
    }

    function fund() public payable {
        // require(msg.value.getConversionRate() >= MINIMUM_USD, 'Not enough ETH sent');
        if(msg.value.getConversionRate() < MINIMUM_USD) {
            revert FundMe_NotEnoughETHSent();
        }

        fundersAddress.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public onlyOwner {
        uint256 totalBalance = address(this).balance;
        // require(totalBalance > 0, "No funds to withdraw");
        if(totalBalance < 0) {
            revert FundMe_NoFundsToWithdraw();
        }

        // Iterate over funders, resetting their balances
        for(uint256 funderIndex = 0; funderIndex < fundersAddress.length; funderIndex++){
            address funder = fundersAddress[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // Reset fundersAddress array after withdrawing
        delete fundersAddress;

        // Ensure there's enough gas to complete the withdrawal
        (bool callSuccess, ) = payable(msg.sender).call{value: totalBalance}("");
        // require(callSuccess, "Call failed");
        if(!callSuccess) {
            revert FundMe_callFailed();
        }
    }

    // You can add a getter for funders addresses if needed
    function getFunders() public view returns (address[] memory) {
        return fundersAddress;
    }
}