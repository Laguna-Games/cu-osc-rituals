/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibTokenURI} from '../libraries/LibTokenURI.sol';

contract RitualTokenURIFacet {
    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return LibTokenURI.generateTokenURI(tokenId);
    }
}
