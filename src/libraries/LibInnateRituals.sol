// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibDiamond} from "../../lib/cu-osc-diamond-template/src/libraries/LibDiamond.sol";
import {LibValidate} from "../../lib/cu-osc-common/src/libraries/LibValidate.sol";

/// @custom:storage-location erc7201:games.laguna.Rituals.InnateRituals
library LibInnateRituals {
    // Position to store the innate rituals storage
    bytes32 private constant INNATE_RITUALS_STORAGE_POSITION =
        keccak256(
            abi.encode(
                uint256(keccak256("games.laguna.Rituals.InnateRituals")) - 1
            )
        ) & ~bytes32(uint256(0xff));
    struct LibInnateRitualsStorage {
        // Owner for innate rituals
        address innateRitualsOwner;
    }

    function setInnateRitualsOwner(address newInnateRitualsOwner) internal {
        LibValidate.enforceNonZeroAddress(newInnateRitualsOwner);
        innateRitualsStorage().innateRitualsOwner = newInnateRitualsOwner;
    }

    function innateRitualsOwner()
        internal
        view
        returns (address _innateRitualsOwner)
    {
        _innateRitualsOwner = innateRitualsStorage().innateRitualsOwner;
    }

    /// @dev Retrieves the storage position for LibRewardsStorage using inline assembly.
    /// This function accesses the storage location associated with the constant REWARD_STORAGE_POSITION.
    /// @return lrs The reference to LibRewardsStorage structure in storage.
    function innateRitualsStorage()
        internal
        pure
        returns (LibInnateRitualsStorage storage lrs)
    {
        bytes32 position = INNATE_RITUALS_STORAGE_POSITION;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            lrs.slot := position
        }
    }
}
