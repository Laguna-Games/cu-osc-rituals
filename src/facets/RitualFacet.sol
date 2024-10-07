/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibRituals} from "../libraries/LibRituals.sol";
import {LibHatchery} from "../libraries/LibHatchery.sol";
import {LibRitualComponents} from "../../lib/cu-osc-common/src/libraries/LibRitualComponents.sol";
import {LibConstraints} from "../../lib/cu-osc-common/src/libraries/LibConstraints.sol";
import {LibRitualData} from "../../lib/cu-osc-common/src/libraries/LibRitualData.sol";
import {IRitualFacet} from "../../lib/cu-osc-common/src/interfaces/IRitualFacet.sol";

contract RitualFacet is IRitualFacet {
    /// @notice This function creates a ritual and mints it to the target user. It can only be called by minion hatchery.
    /// @param to The user that the ritual should be minted to.
    /// @param name The ritual's name.
    /// @param rarity The ritual's rarity expressed in integer value.
    /// @param costs The costs to pay to consume a ritual charge expressed in components.
    /// @param products The outcome of consuming a ritual charge expressed in components.
    /// @param constraints The restrictions to consume a ritual charge expressed in constraints.
    /// @param charges The amount of times the ritual can consume a charge to exchange costs for products.
    //  @param soulbound Flag to indicate if the ritual is soulbound or not.
    function createRitual(
        address to,
        string calldata name,
        uint8 rarity,
        LibRitualComponents.RitualCost[] memory costs,
        LibRitualComponents.RitualProduct[] memory products,
        LibConstraints.Constraint[] memory constraints,
        uint256 charges,
        bool soulbound
    ) external returns (uint256 ritualTokenId) {
        LibHatchery.enforceIsMinionHatchery();
        ritualTokenId = LibRituals.createRitual(
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

    /// @notice This function returns the entire ritual data that is relevant for the minion hatchery.
    /// @param ritualId The id of the ritual.
    /// @return Ritual (name, rarity, costs, products, constraints and charges).
    function getRitualDetails(
        uint256 ritualId
    ) external view returns (LibRitualData.Ritual memory) {
        return LibRituals.getRitualDetails(ritualId);
    }

    /// @notice This function consumes a ritual charge, can only be called by minion hatchery.
    /// @param ritualId The id of the ritual.
    function consumeRitualCharge(uint256 ritualId) external {
        LibHatchery.enforceIsMinionHatchery();
        LibRituals.consumeRitualCharge(ritualId);
    }

    // @notice This function validates that the address that wants to consume a charge
    // is the owner of the ritual and that is has charges left, then
    // returns the ritual details, can only be called by minion hatchery.
    // @param ritualId The id of the ritual.
    // @param ritualOwner The owner of the ritual.
    // @return Ritual (name, rarity, costs, products, constraints and charges).
    function validateChargesAndGetRitualDetailsForConsume(
        uint256 ritualId,
        address ritualOwner
    ) external view returns (LibRitualData.Ritual memory) {
        return
            LibRituals.validateChargesAndGetRitualDetailsForConsume(
                ritualId,
                ritualOwner
            );
    }

    function getRitualsByOwner(
        address owner
    ) external view returns (uint256[] memory, LibRitualData.Ritual[] memory) {
        return LibRituals.getRitualsByOwner(owner);
    }
    function getRitualsByOwnerPaginated(
        address owner,
        uint256 page
    )
        external
        view
        returns (uint256[] memory, LibRitualData.Ritual[] memory, bool)
    {
        return LibRituals.getRitualsByOwnerPaginated(owner, page);
    }
}
