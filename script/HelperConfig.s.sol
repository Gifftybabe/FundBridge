//SPDX-License-Identifier: MIT

// 1. deploy mocks when we are on a local anvil chain
// 2. Keep track of contract address across different chains e.g Sepolia ETH/USD, Mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    // If wew are on a local anvil, we going to deploy the mock addresses
    // Otherwise, grab the existing address from the live network

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig { // necessary incase we want to return more data from our configuration network.

        address priceFeed; // ETH/USD price feed address

    }

    constructor() {
        if(block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
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

    function getAnvilEthConfig() public  returns (NetworkConfig memory) {
        // price feed address

        // 1. Deploy the mocks: A Mock contract is more like a dummy/fake contract
        // 2. Return the mock address
    }
}