// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibImageData} from "../libraries/LibImageData.sol";
import {LibContractOwner} from "../../lib/cu-osc-diamond-template/src/libraries/LibContractOwner.sol";

contract ImageDataFacet {
    function setERC20TokenName(
        address tokenAddress,
        string memory tokenName
    ) external {
        LibContractOwner.enforceIsContractOwner();
        LibImageData.setERC20TokenName(tokenAddress, tokenName);
    }

    function setERC1155TokenNameByPoolId(
        address tokenAddress,
        uint256 poolId,
        string memory name
    ) external {
        LibContractOwner.enforceIsContractOwner();
        LibImageData.setERC1155TokenNameByPoolId(tokenAddress, poolId, name);
    }

    function setERC1155TypeByPoolId(
        address tokenAddress,
        uint256 poolId,
        string memory tokenType
    ) external {
        LibContractOwner.enforceIsContractOwner();
        LibImageData.setERC1155TypeByPoolId(tokenAddress, poolId, tokenType);
    }

    function setConstraintNameByConstraintType(
        uint256 constraintType,
        string memory constraintName
    ) external {
        LibContractOwner.enforceIsContractOwner();
        LibImageData.setConstraintNameByConstraintType(
            constraintType,
            constraintName
        );
    }

    function setBaseImageURL(string memory url) external {
        LibContractOwner.enforceIsContractOwner();
        LibImageData.setBaseImageURL(url);
    }

    function getERC20TokenName(
        address tokenAddress
    ) external view returns (string memory) {
        return LibImageData.libImageDataStorage().erc20TokenName[tokenAddress];
    }

    function getERC1155TokenNameByPoolId(
        address tokenAddress,
        uint256 poolId
    ) external view returns (string memory) {
        return
            LibImageData.libImageDataStorage().erc1155TokenNameByPoolId[
                tokenAddress
            ][poolId];
    }

    function getERC1155TypeByPoolId(
        address tokenAddress,
        uint256 poolId
    ) external view returns (string memory) {
        return
            LibImageData.libImageDataStorage().erc1155TypeByPoolId[
                tokenAddress
            ][poolId];
    }

    function getConstraintNameByConstraintType(
        uint256 constraintType
    ) external view returns (string memory) {
        return
            LibImageData.libImageDataStorage().constraintNameByConstraintType[
                constraintType
            ];
    }

    function getBaseImageURL() external view returns (string memory) {
        return LibImageData.getBaseImageURL();
    }
}
