//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {

        // Anything before startBroadcast -> Not a "real" tx, it will simulate it in a simultate environment 

        HelperConfig helperConfig = new HelperConfig(); // We do this before the broadcast because we don't want to spend gas to deploy that on a real chain
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        // After startBroadcast -> "real" tx
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}