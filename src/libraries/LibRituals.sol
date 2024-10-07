// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibRitualComponents} from "../../lib/cu-osc-common/src/libraries/LibRitualComponents.sol";
import {LibConstraints} from "../../lib/cu-osc-common/src/libraries/LibConstraints.sol";
import {LibRitualData} from "../../lib/cu-osc-common/src/libraries/LibRitualData.sol";
import {LibERC721} from "../../lib/cu-osc-common-tokens/src/libraries/LibERC721.sol";
import {LibInnateRituals} from "./LibInnateRituals.sol";

/// @custom:storage-location erc7201:games.laguna.Rituals.Rituals
library LibRituals {
    bytes32 private constant RITUALS_STORAGE_POSITION =
        keccak256(
            abi.encode(uint256(keccak256("games.laguna.Rituals.Rituals")) - 1)
        ) & ~bytes32(uint256(0xff));

    event RitualChargeConsumed(
        uint256 indexed ritualId,
        uint256 indexed previousCharges,
        uint256 indexed currentCharges
    );

    struct RitualsStorage {
        // mapping from ritual tokenId to ritual details
        mapping(uint256 => LibRitualData.BasicRitual) basicRitualDetailsByRitualId;
        mapping(uint256 => LibRitualComponents.RitualCost[]) ritualCostsByRitualId;
        mapping(uint256 => LibRitualComponents.RitualProduct[]) ritualProductsByRitualId;
        mapping(uint256 => LibConstraints.Constraint[]) constraintsByRitualId;
    }

    function ritualsStorage()
        internal
        pure
        returns (RitualsStorage storage rs)
    {
        bytes32 position = RITUALS_STORAGE_POSITION;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            rs.slot := position
        }
    }

    function poolRitual() internal returns (uint256 ritualTokenId) {
        RitualsStorage storage rs = ritualsStorage();
        ritualTokenId = LibERC721.mintNextToken(address(this), false);
        rs.basicRitualDetailsByRitualId[ritualTokenId] = LibRitualData
            .BasicRitual("-", 1, 1, false);
        rs.ritualCostsByRitualId[ritualTokenId].push(
            LibRitualComponents.RitualCost(
                LibRitualComponents.RitualComponent(
                    1,
                    1,
                    1,
                    0x000000000000000000000000000000000000dEaD
                ),
                LibRitualComponents.RitualCostTransferType.TRANSFER
            )
        );

        rs.ritualCostsByRitualId[ritualTokenId].push(
            LibRitualComponents.RitualCost(
                LibRitualComponents.RitualComponent(
                    1,
                    1,
                    1,
                    0x000000000000000000000000000000000000dEaD
                ),
                LibRitualComponents.RitualCostTransferType.TRANSFER
            )
        );

        rs.ritualProductsByRitualId[ritualTokenId].push(
            LibRitualComponents.RitualProduct(
                LibRitualComponents.RitualComponent(
                    1,
                    1,
                    1,
                    0x000000000000000000000000000000000000dEaD
                ),
                LibRitualComponents.RitualProductTransferType.TRANSFER
            )
        );

        rs.ritualProductsByRitualId[ritualTokenId].push(
            LibRitualComponents.RitualProduct(
                LibRitualComponents.RitualComponent(
                    1,
                    1,
                    1,
                    0x000000000000000000000000000000000000dEaD
                ),
                LibRitualComponents.RitualProductTransferType.TRANSFER
            )
        );

        rs.constraintsByRitualId[ritualTokenId].push(
            LibConstraints.Constraint(1, 1, 1)
        );

        rs.constraintsByRitualId[ritualTokenId].push(
            LibConstraints.Constraint(1, 1, 1)
        );

        rs.constraintsByRitualId[ritualTokenId].push(
            LibConstraints.Constraint(1, 1, 1)
        );

        return ritualTokenId;
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
    ) internal {
        LibERC721.ERC721Storage storage ds = LibERC721.erc721Storage();
        RitualsStorage storage rs = ritualsStorage();
        rs.basicRitualDetailsByRitualId[ritualTokenId].name = name;
        rs.basicRitualDetailsByRitualId[ritualTokenId].rarity = rarity;
        rs.basicRitualDetailsByRitualId[ritualTokenId].charges = charges;
        rs.basicRitualDetailsByRitualId[ritualTokenId].soulbound = soulbound;

        LibERC721.transfer(address(this), to, ritualTokenId);
        ds.soulboundedTokens[ritualTokenId] = soulbound;

        delete rs.ritualCostsByRitualId[ritualTokenId];
        for (uint256 i = 0; i < costs.length; i++) {
            rs.ritualCostsByRitualId[ritualTokenId].push(costs[i]);
        }

        delete rs.ritualProductsByRitualId[ritualTokenId];
        for (uint256 i = 0; i < products.length; i++) {
            rs.ritualProductsByRitualId[ritualTokenId].push(products[i]);
        }

        delete rs.constraintsByRitualId[ritualTokenId];
        for (uint256 i = 0; i < constraints.length; i++) {
            rs.constraintsByRitualId[ritualTokenId].push(constraints[i]);
        }
    }

    //  @notice This function creates a ritual and mints it to the target user,
    //  can only be called by minion hatchery.
    //  @param to The user that the ritual should be minted to.
    //  @param name The ritual's name.
    //  @param rarity The ritual's rarity expressed in integer value.
    //  @param costs The costs to pay to consume a ritual charge expressed in components.
    //  @param products The outcome of consuming a ritual charge expressed in components.
    //  @param constraints The restrictions to consume a ritual charge expressed in constraints.
    //  @param charges The amount of times the ritual can consume a charge to exchange costs for products.
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
    ) internal returns (uint256 ritualTokenId) {
        LibRitualData.BasicRitual memory basicRitual = LibRitualData
            .BasicRitual(name, rarity, charges, soulbound);
        RitualsStorage storage rs = ritualsStorage();
        ritualTokenId = LibERC721.mintNextToken(to, soulbound);
        rs.basicRitualDetailsByRitualId[ritualTokenId] = basicRitual;
        for (uint256 i = 0; i < costs.length; i++) {
            rs.ritualCostsByRitualId[ritualTokenId].push(costs[i]);
        }
        for (uint256 i = 0; i < products.length; i++) {
            rs.ritualProductsByRitualId[ritualTokenId].push(products[i]);
        }
        for (uint256 i = 0; i < constraints.length; i++) {
            rs.constraintsByRitualId[ritualTokenId].push(constraints[i]);
        }
    }

    //  @notice This function returns the entire ritual data that is relevant for the minion hatchery.
    //  @param ritualId The id of the ritual
    //  @return Ritual details (name, rarity, costs, products, constraints, charges and soulbound)
    function getRitualDetails(
        uint256 ritualId
    ) internal view returns (LibRitualData.Ritual memory) {
        RitualsStorage storage rs = ritualsStorage();
        LibRitualData.BasicRitual memory basicRitual = rs
            .basicRitualDetailsByRitualId[ritualId];
        LibRitualComponents.RitualCost[] memory costs = rs
            .ritualCostsByRitualId[ritualId];
        LibRitualComponents.RitualProduct[] memory products = rs
            .ritualProductsByRitualId[ritualId];
        LibConstraints.Constraint[] memory constraints = rs
            .constraintsByRitualId[ritualId];
        LibRitualData.Ritual memory ritual = LibRitualData.Ritual(
            basicRitual.name,
            basicRitual.rarity,
            costs,
            products,
            constraints,
            basicRitual.charges,
            LibERC721.isSoulbound(ritualId)
        );
        return ritual;
    }

    //  @notice This function decreases a ritual's amount of charges by 1 as long
    //  as it hast charges remaining, can only be called by the minion hatchery.
    //  @param ritualId The id of the ritual
    function consumeRitualCharge(uint256 ritualId) internal {
        RitualsStorage storage rs = ritualsStorage();
        LibRitualData.BasicRitual memory basicRitual = rs
            .basicRitualDetailsByRitualId[ritualId];
        uint256 previousCharges = basicRitual.charges;
        if (basicRitual.charges < type(uint256).max) {
            basicRitual.charges = previousCharges - 1;
            rs.basicRitualDetailsByRitualId[ritualId] = basicRitual;
        }
        emit RitualChargeConsumed(
            ritualId,
            previousCharges,
            basicRitual.charges
        );
        emit LibERC721.MetadataUpdate(ritualId);
        if (basicRitual.charges == 0) {
            LibERC721.burn(ritualId);
        }
    }

    //  @notice This function validates that the ritual has charges remaining and
    //  returns the entire ritual data that is relevant for the minion hatchery.
    //  @param ritualId The id of the ritual.
    //  @param ritualOwner The owner of the ritual.
    //  @return Ritual (name, rarity, costs, products, constraints and charges).
    function validateChargesAndGetRitualDetailsForConsume(
        uint256 ritualId,
        address ritualOwner
    ) internal view returns (LibRitualData.Ritual memory) {
        RitualsStorage storage rs = ritualsStorage();
        LibRitualData.BasicRitual memory basicRitual = rs
            .basicRitualDetailsByRitualId[ritualId];
        require(
            LibERC721.ownerOf(ritualId) == ritualOwner ||
                LibERC721.ownerOf(ritualId) ==
                LibInnateRituals.innateRitualsOwner(),
            "LibRituals: Ritual does not belong to caller or it's not a starter ritual."
        );
        require(
            basicRitual.charges >= 1,
            "LibRituals: Insufficient amount of charges."
        );
        return getRitualDetails(ritualId);
    }

    function getRitualsByOwner(
        address owner
    ) internal view returns (uint256[] memory, LibRitualData.Ritual[] memory) {
        uint256[] memory ownerTokens = LibERC721.getAllTokensByOwner(owner);
        LibRitualData.Ritual[] memory rituals = new LibRitualData.Ritual[](
            ownerTokens.length
        );
        for (uint256 i = 0; i < ownerTokens.length; i++) {
            rituals[i] = getRitualDetails(ownerTokens[i]);
        }
        return (ownerTokens, rituals);
    }

    function getRitualsByOwnerPaginated(
        address owner,
        uint256 page
    )
        internal
        view
        returns (uint256[] memory, LibRitualData.Ritual[] memory, bool)
    {
        uint256 balance = LibERC721.balanceOf(owner);
        uint256 perPage = 50;
        uint start = page * perPage;
        uint count = balance - start;
        bool moreEntriesExist = false;

        if (count > perPage) {
            count = perPage;
            moreEntriesExist = true;
        }

        LibRitualData.Ritual[] memory rituals = new LibRitualData.Ritual[](
            count
        );
        uint256[] memory tokenIds = new uint256[](count);

        mapping(uint256 => uint256) storage ownedTokens = LibERC721
            .erc721Storage()
            .ownedTokens[owner];
        for (uint i = 0; i < count; ++i) {
            uint256 indx = start + i;
            uint256 tokenId = ownedTokens[indx];
            tokenIds[i] = tokenId;
            rituals[i] = getRitualDetails(tokenId);
        }
        return (tokenIds, rituals, moreEntriesExist);
    }
}
