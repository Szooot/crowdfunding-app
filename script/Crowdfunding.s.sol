// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CrowdfundingFactory} from "../src/CrowdfundingFactory.sol";

contract CrownfundingScript is Script {
    CrowdfundingFactory public newContract;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        newContract = new CrowdfundingFactory();

        vm.stopBroadcast();
    }
}
