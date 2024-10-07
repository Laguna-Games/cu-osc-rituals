// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// @custom:storage-location erc7201:games.laguna.Rituals.ImageData
library LibImageData {
    bytes32 private constant LIBIMAGEDATA_STORAGE_POSITION =
        keccak256(abi.encode(uint256(keccak256('games.laguna.Rituals.ImageData')) - 1)) & ~bytes32(uint256(0xff));

    struct LibImageDataStorage {
        mapping(address => string) erc20TokenName;
        mapping(address => mapping(uint256 => string)) erc1155TokenNameByPoolId;
        mapping(address => mapping(uint256 => string)) erc1155TypeByPoolId;
        mapping(uint256 => string) constraintNameByConstraintType;
        string baseImageURL;
    }

    function libImageDataStorage() internal pure returns (LibImageDataStorage storage lids) {
        bytes32 position = LIBIMAGEDATA_STORAGE_POSITION;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            lids.slot := position
        }
    }

    function setERC20TokenName(address tokenAddress, string memory tokenName) internal {
        libImageDataStorage().erc20TokenName[tokenAddress] = tokenName;
    }

    function setERC1155TokenNameByPoolId(address tokenAddress, uint256 poolId, string memory name) internal {
        libImageDataStorage().erc1155TokenNameByPoolId[tokenAddress][poolId] = name;
    }

    function setERC1155TypeByPoolId(address tokenAddress, uint256 poolId, string memory tokenType) internal {
        libImageDataStorage().erc1155TypeByPoolId[tokenAddress][poolId] = tokenType;
    }

    function setConstraintNameByConstraintType(uint256 constraintType, string memory constraintName) internal {
        libImageDataStorage().constraintNameByConstraintType[constraintType] = constraintName;
    }

    function setBaseImageURL(string memory url) internal {
        libImageDataStorage().baseImageURL = url;
    }

    function getBaseImageURL() internal view returns (string memory) {
        return libImageDataStorage().baseImageURL;
    }
}
