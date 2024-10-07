// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../../lib/@openzeppelin/contracts/utils/Strings.sol";
import {LibRituals} from "./LibRituals.sol";
import {LibRitualComponents} from "../../lib/cu-osc-common/src/libraries/LibRitualComponents.sol";
import {LibConstraints} from "../../lib/cu-osc-common/src/libraries/LibConstraints.sol";
import {LibRitualData} from "../../lib/cu-osc-common/src/libraries/LibRitualData.sol";
import {LibRarity} from "./LibRarity.sol";
import {LibString} from "../../lib/cu-osc-common/src/libraries/LibString.sol";
import {LibBase64} from "../../lib/cu-osc-common/src/libraries/LibBase64.sol";
import {LibImageData} from "./LibImageData.sol";
import {LibToken} from "../../lib/cu-osc-common/src/libraries/LibToken.sol";
import {LibERC721Attribute} from "./LibERC721Attribute.sol";
import {LibERC721Description} from "./LibERC721Description.sol";
import {LibConstraintOperator} from "../../lib/cu-osc-common/src/libraries/LibConstraintOperator.sol";

library LibTokenURI {
    function generateTokenURI(
        uint256 tokenId
    ) internal view returns (string memory) {
        return
            string.concat(
                "data:application/json;base64,",
                LibBase64.encode(bytes(tokenURIData(tokenId)))
            );
    }

    function tokenURIData(
        uint256 tokenId
    ) internal view returns (string memory) {
        LibRitualData.Ritual memory ritual = LibRituals.getRitualDetails(
            tokenId
        );
        return
            string.concat(
                '{"token_id":"',
                Strings.toString(tokenId),
                '", "description":"',
                LibERC721Description.getRarityDescription(ritual.rarity),
                '","name":"',
                ritual.name,
                '","external_url":"https://www.cryptounicorns.fun","metadata_version":1,',
                '"image":"',
                generateImageURL(ritual),
                '",',
                addAttributes(ritual),
                "}"
            );
    }

    function generateImageURL(
        LibRitualData.Ritual memory ritual
    ) internal view returns (string memory url) {
        url = LibImageData.getBaseImageURL();
        uint256 maxCosts = 4;
        if (ritual.costs.length < maxCosts) {
            maxCosts = ritual.costs.length;
        }
        for (uint256 i = 0; i < maxCosts; i++) {
            if (ritual.costs[i].component.assetType == LibToken.TYPE_ERC20) {
                if (i == 0) {
                    url = string.concat(
                        url,
                        "?p",
                        Strings.toString(i * 2),
                        "=",
                        LibImageData.libImageDataStorage().erc20TokenName[
                            ritual.costs[i].component.asset
                        ]
                    );
                } else {
                    url = string.concat(
                        url,
                        "&p",
                        Strings.toString(i * 2),
                        "=",
                        LibImageData.libImageDataStorage().erc20TokenName[
                            ritual.costs[i].component.asset
                        ]
                    );
                }
                url = string.concat(
                    url,
                    "&p",
                    Strings.toString((2 * i) + 1),
                    "=",
                    Strings.toString(ritual.costs[i].component.amount)
                );
            } else if (
                ritual.costs[i].component.assetType == LibToken.TYPE_ERC1155
            ) {
                if (i == 0) {
                    url = string.concat(
                        url,
                        "?p",
                        Strings.toString(i * 2),
                        "=",
                        LibImageData
                            .libImageDataStorage()
                            .erc1155TokenNameByPoolId[
                                ritual.costs[i].component.asset
                            ][ritual.costs[i].component.poolId]
                    );
                } else {
                    url = string.concat(
                        url,
                        "&p",
                        Strings.toString(i * 2),
                        "=",
                        LibImageData
                            .libImageDataStorage()
                            .erc1155TokenNameByPoolId[
                                ritual.costs[i].component.asset
                            ][ritual.costs[i].component.poolId]
                    );
                }
                url = string.concat(
                    url,
                    "&p",
                    Strings.toString((2 * i) + 1),
                    "=",
                    Strings.toString(ritual.costs[i].component.amount)
                );
            }
        }

        url = string.concat(url, "&p8=", getChargesValue(ritual.charges, true));

        if (ritual.products[0].component.assetType == LibToken.TYPE_ERC20) {
            url = string.concat(
                url,
                "&p9=",
                LibImageData.libImageDataStorage().erc20TokenName[
                    ritual.products[0].component.asset
                ]
            );
        } else {
            url = string.concat(
                url,
                "&p9=",
                LibImageData.libImageDataStorage().erc1155TokenNameByPoolId[
                    ritual.products[0].component.asset
                ][ritual.products[0].component.poolId]
            );
        }
        url = string.concat(
            url,
            "&p10=",
            LibImageData.libImageDataStorage().erc1155TypeByPoolId[
                ritual.products[0].component.asset
            ][ritual.products[0].component.poolId]
        );

        uint256 maxConstraints = 4;
        if (ritual.constraints.length < maxConstraints) {
            maxConstraints = ritual.constraints.length;
        }
        for (uint256 i = 0; i < maxConstraints; i++) {
            if (
                LibConstraints.ConstraintType(
                    ritual.constraints[i].constraintType
                ) == LibConstraints.ConstraintType.SHADOWCORN_RARITY
            ) {
                url = string.concat(
                    url,
                    "&p",
                    Strings.toString(i + 11),
                    "=rarity-",
                    Strings.toString(ritual.constraints[i].value)
                );
            } else if (
                LibConstraints.ConstraintType(
                    ritual.constraints[i].constraintType
                ) == LibConstraints.ConstraintType.SHADOWCORN_CLASS
            ) {
                url = string.concat(
                    url,
                    "&p",
                    Strings.toString(i + 11),
                    "=class-",
                    Strings.toString(ritual.constraints[i].value)
                );
            } else {
                url = string.concat(
                    url,
                    "&p",
                    Strings.toString(i + 11),
                    "=",
                    LibImageData
                        .libImageDataStorage()
                        .constraintNameByConstraintType[
                            ritual.constraints[i].constraintType
                        ]
                );
            }
        }

        // Add first product amount
        url = string.concat(
            url,
            "&p15=",
            Strings.toString(ritual.products[0].component.amount)
        );

        // Add ritual rarity
        url = string.concat(url, "&p16=", Strings.toString(ritual.rarity));
    }

    // @dev - Helper functions to convert costn structs to string
    // @param costs - array of costs
    // @return costText - text of costs
    // @custom:example 1000 Dark Marks, 8 Lock of Unicorn Hair
    function costsToString(
        LibRitualComponents.RitualCost[] memory costs
    ) internal view returns (string memory costText) {
        for (uint256 i = 0; i < costs.length; i++) {
            if (i > 0) {
                costText = string.concat(costText, ",");
            }

            string memory cost;

            string memory tokenAmount;
            string memory tokenName;
            LibRitualComponents.RitualComponent memory costComponent = costs[i]
                .component;
            if (costComponent.assetType == LibToken.TYPE_ERC20) {
                tokenName = LibERC721Attribute.getERC20TokenName(
                    costComponent.asset
                );
                tokenAmount = Strings.toString(costComponent.amount / 10 ** 18);
            } else if (costComponent.assetType == LibToken.TYPE_ERC1155) {
                tokenName = LibERC721Attribute.getERC1155TokenNameByPoolId(
                    costComponent.asset,
                    costComponent.poolId
                );
                tokenAmount = Strings.toString(costComponent.amount);
            }

            cost = string.concat(
                '{"trait_type": "Cost: ',
                tokenName,
                '", "value": "',
                tokenAmount,
                '"}'
            );

            costText = string.concat(costText, cost);
        }
    }

    // @dev - Helper functions to convert product structs to string
    // @param products - array of products
    // @return productText - text of products
    // @custom:example 50 Fire Husks
    function productsToString(
        LibRitualComponents.RitualProduct[] memory products
    ) internal view returns (string memory productText) {
        for (uint256 i = 0; i < products.length; i++) {
            if (i > 0) {
                productText = string.concat(productText, ",");
            }

            string memory product;

            string memory tokenName;
            string memory tokenAmount;
            LibRitualComponents.RitualComponent memory costComponent = products[
                i
            ].component;
            if (costComponent.assetType == LibToken.TYPE_ERC20) {
                tokenName = LibERC721Attribute.getERC20TokenName(
                    costComponent.asset
                );
                tokenAmount = Strings.toString(costComponent.amount / 10 ** 18);
            } else if (costComponent.assetType == LibToken.TYPE_ERC1155) {
                tokenName = LibERC721Attribute.getERC1155TokenNameByPoolId(
                    costComponent.asset,
                    costComponent.poolId
                );
                tokenAmount = Strings.toString(costComponent.amount);
            }

            product = string.concat(
                '{"trait_type": "Product: ',
                tokenName,
                '", "value": "',
                tokenAmount,
                '"}'
            );

            productText = string.concat(productText, product);
        }
    }

    // @dev - Helper functions to convert constraints structs to string
    // @param constraints - array of constraints
    // @return constraintText - text of constraints
    // @custom:example Hatchery Level >= 5
    function constraintsToString(
        LibConstraints.Constraint[] memory constraints
    ) internal view returns (string memory constraintText) {
        for (uint256 i = 0; i < constraints.length; i++) {
            if (i > 0) {
                constraintText = string.concat(constraintText, ",");
            }

            string memory constraint;

            string memory constraintOperator;

            if (
                LibConstraintOperator.ConstraintOperator(
                    constraints[i].operator
                ) == LibConstraintOperator.ConstraintOperator.LESS_THAN
            ) {
                constraintOperator = "<";
            }
            if (
                LibConstraintOperator.ConstraintOperator(
                    constraints[i].operator
                ) == LibConstraintOperator.ConstraintOperator.LESS_THAN_OR_EQUAL
            ) {
                constraintOperator = "<=";
            }
            if (
                LibConstraintOperator.ConstraintOperator(
                    constraints[i].operator
                ) == LibConstraintOperator.ConstraintOperator.EQUAL
            ) {
                constraintOperator = "=";
            }
            if (
                LibConstraintOperator.ConstraintOperator(
                    constraints[i].operator
                ) ==
                LibConstraintOperator.ConstraintOperator.GREATER_THAN_OR_EQUAL
            ) {
                constraintOperator = ">=";
            }
            if (
                LibConstraintOperator.ConstraintOperator(
                    constraints[i].operator
                ) == LibConstraintOperator.ConstraintOperator.GREATER_THAN
            ) {
                constraintOperator = ">";
            }
            if (
                LibConstraintOperator.ConstraintOperator(
                    constraints[i].operator
                ) == LibConstraintOperator.ConstraintOperator.NOT_EQUAL
            ) {
                constraintOperator = "!=";
            }

            string memory constraintValue = Strings.toString(
                constraints[i].value
            );

            if (
                LibConstraints.ConstraintType(constraints[i].constraintType) ==
                LibConstraints.ConstraintType.SHADOWCORN_RARITY
            ) {
                if (constraints[i].value == 1) {
                    constraintValue = "Common";
                }
                if (constraints[i].value == 2) {
                    constraintValue = "Rare";
                }
                if (constraints[i].value == 3) {
                    constraintValue = "Mythic";
                }
            }

            if (
                LibConstraints.ConstraintType(constraints[i].constraintType) ==
                LibConstraints.ConstraintType.SHADOWCORN_CLASS
            ) {
                if (constraints[i].value == 1) {
                    constraintValue = "Fire";
                }
                if (constraints[i].value == 2) {
                    constraintValue = "Slime";
                }
                if (constraints[i].value == 3) {
                    constraintValue = "Volt";
                }
                if (constraints[i].value == 4) {
                    constraintValue = "Soul";
                }
                if (constraints[i].value == 5) {
                    constraintValue = "Nebula";
                }
            }

            constraint = string.concat(
                '{"trait_type": "Constraint: ',
                LibERC721Attribute.getConstraintNameByConstraintType(
                    constraints[i].constraintType
                ),
                '", "value": "',
                constraintOperator,
                " ",
                constraintValue,
                '"}'
            );

            constraintText = string.concat(constraintText, constraint);
        }

        if (constraints.length > 0) {
            constraintText = string.concat(",", constraintText);
        }
    }

    function addAttributes(
        LibRitualData.Ritual memory ritual
    ) internal view returns (string memory attributes) {
        attributes = string.concat(
            '"attributes":[{"trait_type":"Rarity","value":"',
            LibRarity.getRarityNameById(ritual.rarity),
            '"},',
            costsToString(ritual.costs),
            ",",
            productsToString(ritual.products),
            constraintsToString(ritual.constraints),
            ',{"trait_type":"Charges","value":"',
            getChargesValue(ritual.charges, false),
            '"}]'
        );
    }

    function getChargesValue(
        uint256 charges,
        bool isImage
    ) internal pure returns (string memory) {
        if (charges == type(uint256).max) {
            if (isImage) {
                return "infinity";
            } else {
                return "Unlimited";
            }
        } else {
            return Strings.toString(charges);
        }
    }
}
