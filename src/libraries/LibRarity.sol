// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// @custom:storage-location erc7201:games.laguna.Rituals.Rarity
library LibRarity {
    bytes32 private constant RARITY_STORAGE_POSITION =
        keccak256(abi.encode(uint256(keccak256('games.laguna.Rituals.Rarity')) - 1)) & ~bytes32(uint256(0xff));

    struct RarityStorage {
        // mapping from ritual tokenId to ritual details
        mapping(uint256 => string) rarityNameById;
    }

    function rarityStorage() internal pure returns (RarityStorage storage rs) {
        bytes32 position = RARITY_STORAGE_POSITION;
        assembly {
            rs.slot := position
        }
    }

    function getRarityNameById(uint256 rarity) internal view returns (string memory) {
        return rarityStorage().rarityNameById[rarity];
    }

    function setRarityName(uint256 rarityId, string memory rarityName) internal {
        rarityStorage().rarityNameById[rarityId] = rarityName;
    }
}
