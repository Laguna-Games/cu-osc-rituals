/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibRituals} from "../libraries/LibRituals.sol";
import {LibHatchery} from "../libraries/LibHatchery.sol";
import {LibRitualComponents} from "../../lib/cu-osc-common/src/libraries/LibRitualComponents.sol";
import {LibConstraints} from "../../lib/cu-osc-common/src/libraries/LibConstraints.sol";

contract ObjectPoolFacet {
    function poolRitual() external returns (uint256 ritualTokenId) {
        LibHatchery.enforceIsMinionHatchery();
        ritualTokenId = LibRituals.poolRitual();
    }

    function populateRitualFromPool(
        uint256 ritualTokenId,
        address to,
        string calldata name,
        uint8 rarity,
        LibRitualComponents.RitualCost[] memory costs,
        LibRitualComponents.RitualProduct[] memory products,
        LibConstraints.Constraint[] memory constraints,
        uint256 charges,
        bool soulbound
    ) external {
        LibHatchery.enforceIsMinionHatchery();
        LibRituals.populateRitualFromPool(
            ritualTokenId,
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
