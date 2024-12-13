//SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";


contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; 
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumUsdIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testContractOwner() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }


    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

function testFundFailsWithoutEnoughEth() public {
    // Expect the transaction to revert due to insufficient funds
    vm.expectRevert(); // This indicates the next line is expected to fail
    fundMe.fund(); // Send 0 value

  // Expect the custom error to be triggered
    // vm.expectRevert(FundMe_NotEnoughEth.selector); 
    // fundMe.fund{value: 0}(); // Send 0 value

//     function testFundFailsBelowMinimumEth() public {
//     // Expect the custom error for insufficient funds
//     vm.expectRevert(FundMe_NotEnoughEth.selector);
//     fundMe.fund{value: 4e18}(); // Send less than the minimum value
// }

}

function testFundUpdatesFundedDataSgtructure() public {
    vm.prank(USER); // The next tx will be sent by USER

    fundMe.fund{value: SEND_VALUE}();

    uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
    assertEq(amountFunded, SEND_VALUE);
}


}