// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibContractOwner} from "../../lib/cu-osc-diamond-template/src/libraries/LibContractOwner.sol";

import {ITestnetDebugRegistry} from "../../lib/cu-osc-common/src/interfaces/ITestnetDebugRegistry.sol";
import {LibResourceLocator} from "../../lib/cu-osc-common/src/libraries/LibResourceLocator.sol";
import {LibRituals} from "../libraries/LibRituals.sol";
import {LibRitualComponents} from "../../lib/cu-osc-common/src/libraries/LibRitualComponents.sol";
import {LibConstraints} from "../../lib/cu-osc-common/src/libraries/LibConstraints.sol";

contract RitualFaucetFacet {
    function faucetMint(
        address to,
        string calldata name,
        uint8 rarity,
        LibRitualComponents.RitualCost[] memory costs,
        LibRitualComponents.RitualProduct[] memory products,
        LibConstraints.Constraint[] memory constraints,
        uint256 charges,
        bool soulbound
    ) external {
        ITestnetDebugRegistry(LibResourceLocator.testnetDebugRegistry())
            .enforceDebugger(msg.sender);

        LibRituals.createRitual(
            to,
            name,
            rarity,
            costs,
            products,
            constraints,
            charges,
            soulbound
        );
    }
}
