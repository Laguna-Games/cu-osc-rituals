// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CutERC721Diamond} from "../../lib/cu-osc-common-tokens/src/implementation/CutERC721Diamond.sol";
import {LibRitualComponents} from "../../lib/cu-osc-common/src/libraries/LibRitualComponents.sol";
import {LibConstraints} from "../../lib/cu-osc-common/src/libraries/LibConstraints.sol";
import {LibRitualData} from "../../lib/cu-osc-common/src/libraries/LibRitualData.sol";

/// @title Dummy "implementation" contract for LG Diamond interface for ERC-1967 compatibility
/// @dev adapted from https://github.com/zdenham/diamond-etherscan?tab=readme-ov-file
/// @dev This interface is used internally to call endpoints on a deployed diamond cluster.
contract RitualsImplementation is CutERC721Diamond {
    function getInnateRitualsOwner() external view returns (address) {}
    function createRitual(
        address to,
        string calldata name,
        uint8 rarity,
        LibRitualComponents.RitualCost[] memory costs,
        LibRitualComponents.RitualProduct[] memory products,
        LibConstraints.Constraint[] memory constraints,
        uint256 charges,
        bool soulbound
    ) external returns (uint256 ritualTokenId) {}
    function getRitualDetails(
        uint256 ritualId
    ) external view returns (LibRitualData.Ritual memory) {}
    function consumeRitualCharge(uint256 ritualId) external {}
    function validateChargesAndGetRitualDetailsForConsume(
        uint256 ritualId,
        address ritualOwner
    ) external view returns (LibRitualData.Ritual memory) {}
    function getRitualsByOwner(
        address owner
    ) external view returns (uint256[] memory, LibRitualData.Ritual[] memory) {}
    function getRitualsByOwnerPaginated(
        address owner,
        uint256 page
    )
        external
        view
        returns (uint256[] memory, LibRitualData.Ritual[] memory, bool)
    {}
}
