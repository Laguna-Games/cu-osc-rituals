// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// @custom:storage-location erc7201:games.laguna.Rituals.ERC721Attribute
library LibERC721Attribute {
    bytes32 private constant LIBERC721ATTRIBUTE_STORAGE_POSITION =
        keccak256(abi.encode(uint256(keccak256('games.laguna.Rituals.ERC721Attribute')) - 1)) & ~bytes32(uint256(0xff));

    struct LibERC721AttributeStorage {
        mapping(address => string) erc20TokenName;
        mapping(address => mapping(uint256 => string)) erc1155TokenNameByPoolId;
        mapping(address => mapping(uint256 => string)) erc1155TypeByPoolId;
        mapping(uint256 => string) constraintNameByConstraintType;
    }

    function libERC721AttributeStorage() internal pure returns (LibERC721AttributeStorage storage lids) {
        bytes32 position = LIBERC721ATTRIBUTE_STORAGE_POSITION;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            lids.slot := position
        }
    }

    function setERC20TokenName(address tokenAddress, string memory tokenName) internal {
        libERC721AttributeStorage().erc20TokenName[tokenAddress] = tokenName;
    }

    function getERC20TokenName(address tokenAddress) internal view returns (string memory) {
        return libERC721AttributeStorage().erc20TokenName[tokenAddress];
    }

    function setERC1155TokenNameByPoolId(address tokenAddress, uint256 poolId, string memory name) internal {
        libERC721AttributeStorage().erc1155TokenNameByPoolId[tokenAddress][poolId] = name;
    }

    function getERC1155TokenNameByPoolId(address tokenAddress, uint256 poolId) internal view returns (string memory) {
        return libERC721AttributeStorage().erc1155TokenNameByPoolId[tokenAddress][poolId];
    }

    function setERC1155TypeByPoolId(address tokenAddress, uint256 poolId, string memory tokenType) internal {
        libERC721AttributeStorage().erc1155TypeByPoolId[tokenAddress][poolId] = tokenType;
    }

    function getERC1155TypeByPoolId(address tokenAddress, uint256 poolId) internal view returns (string memory) {
        return libERC721AttributeStorage().erc1155TypeByPoolId[tokenAddress][poolId];
    }

    function setConstraintNameByConstraintType(uint256 constraintType, string memory constraintName) internal {
        libERC721AttributeStorage().constraintNameByConstraintType[constraintType] = constraintName;
    }

    function getConstraintNameByConstraintType(uint256 constraintType) internal view returns (string memory) {
        return libERC721AttributeStorage().constraintNameByConstraintType[constraintType];
    }
}
