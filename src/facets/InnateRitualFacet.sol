// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {LibContractOwner} from "../../lib/cu-osc-diamond-template/src/libraries/LibContractOwner.sol";
import {LibInnateRituals} from "../libraries/LibInnateRituals.sol";

contract InnateRitualFacet {
    function setInnateRitualsOwner(address _owner) external {
        LibContractOwner.enforceIsContractOwner();
        LibInnateRituals.setInnateRitualsOwner(_owner);
    }

    function getInnateRitualsOwner() external view returns (address) {
        return LibInnateRituals.innateRitualsOwner();
    }
}
