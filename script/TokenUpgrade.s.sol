
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import {ERC1967Proxy} from "openzeppelin-contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Token} from "../src/Token.sol";

contract TokenUpgradeScript is Script {
    address constant proxyAddress = 0x5607718c64334eb5174CB2226af891a6ED82c7C6;

    function getChainId() public view returns (uint256) {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        return chainId;
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        console.log("Deployer address: ", deployerAddress);
        console.log("Deployer balance: ", deployerAddress.balance);
        console.log("BlockNumber: ", block.number);
        console.log("ChainId: ", getChainId());

        console.log("Deploying...");

        vm.startBroadcast(deployerPrivateKey);

        Token tokenImplementation = new Token();

        console.log("Deployed new implementation to: ", address(tokenImplementation));
        
        Token proxy = Token(proxyAddress);
        if (proxy.hasRole(proxy.UPGRADER_ROLE(), deployerAddress)) {
            proxy.upgradeTo(address(tokenImplementation));
            console.log("Proxy implementation updated");
        } else {
            console.log("Deployer does not have upgrader role");
        }

        vm.stopBroadcast();
    }
}
