//SPDX-License-Identifier: MIT

// 1. deploy mocks when we are on a local anvil chain
// 2. Keep track of contract address across different chains e.g Sepolia ETH/USD, Mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If wew are on a local anvil, we going to deploy the mock addresses
    // Otherwise, grab the existing address from the live network

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig { // necessary incase we want to return more data from our configuration network.

        address priceFeed; // ETH/USD price feed address

    }

    constructor() {
        if(block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) { // this will return the configuration for everything we need in sepolia or any chain 
        // price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;

    }

     function getMainnetEthConfig() public pure returns (NetworkConfig memory) { 
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethConfig;

    }

    function getOrCreateAnvilEthConfig() public  returns (NetworkConfig memory) {

        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        // price feed address

        // 1. Deploy the mocks: A Mock contract is more like a dummy/fake contract
        // 2. Return the mock address

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}