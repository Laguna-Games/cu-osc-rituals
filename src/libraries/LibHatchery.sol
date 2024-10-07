// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import {LibResourceLocator} from "../../lib/cu-osc-common/src/libraries/LibResourceLocator.sol";

library LibHatchery {
    function enforceIsMinionHatchery() internal view {
        require(
            msg.sender == LibResourceLocator.shadowForge(),
            "LibHatchery: Must be minion hatchery."
        );
    }
}
