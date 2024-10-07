// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// @custom:storage-location erc7201:games.laguna.Rituals.ERC721Description
library LibERC721Description {
    bytes32 private constant LIBERC721DESCRIPTION_STORAGE_POSITION =
        keccak256(abi.encode(uint256(keccak256('games.laguna.Rituals.ERC721Description')) - 1)) &
            ~bytes32(uint256(0xff));

    struct LibERC721DescriptionStorage {
        mapping(uint256 => string) rarityToDescription;
    }

    function libERC721DescriptionStorage() internal pure returns (LibERC721DescriptionStorage storage lids) {
        bytes32 position = LIBERC721DESCRIPTION_STORAGE_POSITION;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            lids.slot := position
        }
    }

    function setRarityDescription(uint256 rarity, string memory description) internal {
        libERC721DescriptionStorage().rarityToDescription[rarity] = description;
    }

    function getRarityDescription(uint256 rarity) internal view returns (string memory) {
        return libERC721DescriptionStorage().rarityToDescription[rarity];
    }
}
