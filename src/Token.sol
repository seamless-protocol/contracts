// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {ERC20Upgradeable} from "openzeppelin-contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20PermitUpgradeable} from
    "openzeppelin-contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import {AccessControlUpgradeable} from "openzeppelin-contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

interface GeyserVaultFactory {
    function isInstance(address instance) external view returns (bool validity);
}

abstract contract TokenStorage {
    GeyserVaultFactory public geyserVaultFactory;
}

/**
 * @title Token
 * @author Seamless Protocol
 * @notice An ERC-20 token that is upgradeable and can only be transfered by addresses with the TRANSFER_ROLE.
 */
contract Token is
    Initializable,
    ERC20Upgradeable,
    ERC20PermitUpgradeable,
    AccessControlUpgradeable,
    UUPSUpgradeable,
    TokenStorage
{
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initializes the token and inherited contracts.
     * @param name Token name
     * @param symbol Token symbol
     */
    function initialize(string memory name, string memory symbol) external initializer {
        __ERC20_init(name, symbol);
        __ERC20Permit_init(name);
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(UPGRADER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(TRANSFER_ROLE, msg.sender);
    }

    /// @inheritdoc UUPSUpgradeable
    function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}

    function setGeyserVaultFactory(address factory) external onlyRole(DEFAULT_ADMIN_ROLE) {
        geyserVaultFactory = GeyserVaultFactory(factory);
    }

    /**
     * @dev See {ERC20Upgradeable-_mint}.
     */
    function mint(address account, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(account, amount);
    }

    /**
     * @dev See {ERC20Upgradeable-_burn}.
     */
    function burn(address account, uint256 amount) external onlyRole(MINTER_ROLE) {
        _burn(account, amount);
    }

    function isGeyserVault(address vault) public view returns (bool) {
        return geyserVaultFactory.isInstance(vault);
    }

    /// @inheritdoc ERC20Upgradeable
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        require(
            from == address(0) || to == address(0) || hasRole(TRANSFER_ROLE, from) || hasRole(TRANSFER_ROLE, to)
                || isGeyserVault(from),
            "ERC20: token is not transferable"
        );
    }
}
