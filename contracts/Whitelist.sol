// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.10;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @author Opyn Team
 * @title Whitelist Module
 * @notice The whitelist module keeps track of all valid Otoken contracts.
 */
contract Whitelist is Ownable {
    mapping(bytes32 => bool) internal isSupportedProduct;

    event ProductWhitelisted(
        bytes32 productHash,
        address indexed underlying,
        address indexed collateral,
        address indexed strike
    );

    /**
     * @notice check if a product is supported
     * @dev product = the hash of underlying, collateral and strike asset
     * @param _underlying option underlying asset address
     * @param _collateral option collateral asset address
     * @param _strike option strike asset address
     * @return boolean, true if product is supported
     */
    function isProductSupported(
        address _underlying,
        address _strike,
        address _collateral
    ) external view returns (bool) {
        bytes32 productHash = keccak256(abi.encode(_underlying, _collateral, _strike));

        return isSupportedProduct[productHash];
    }

    /**
     * @notice whitelist a product
     * @dev a product is the hash of the underlying, collateral and strike assets
     * can only be called from owner address
     * @param _underlying option underlying asset address
     * @param _collateral option collateral asset address
     * @param _strike option strike asset address
     * @return product hash
     */
    function whitelistProduct(
        address _underlying,
        address _collateral,
        address _strike
    ) external onlyOwner returns (bytes32) {
        bytes32 productHash = keccak256(abi.encode(_underlying, _collateral, _strike));

        _setIsSupportedProduct(productHash);

        emit ProductWhitelisted(productHash, _underlying, _collateral, _strike);

        return productHash;
    }

    /**
     * @notice set a product hash as supported
     * @param _productHash product hash in bytes
     */
    function _setIsSupportedProduct(bytes32 _productHash) internal {
        require(isSupportedProduct[_productHash] == false, "Product already supported");

        isSupportedProduct[_productHash] = true;
    }
}
