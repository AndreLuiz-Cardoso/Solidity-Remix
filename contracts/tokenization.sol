// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import OpenZeppelin contracts for standard ERC-20 functionality and access control
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title LuxembourgGoldToken
 * @dev ERC-20 token backed by physical gold reserves
 * Each token represents a claim on actual gold stored in secure vaults
 * Maintains 1:1 backing ratio between digital tokens and physical gold
 */
contract LuxembourgGoldToken is ERC20, Ownable {
    
    /**
     * @dev Total amount of physical gold backing the tokens
     * Measured in the same units as token supply (typically grams or ounces)
     * This creates transparency and maintains the backing ratio
     */
    uint256 public totalGoldReserves;
    
    /**
     * @dev Constructor initializes the gold-backed token
     * Sets the deployer as the initial owner who can mint/manage tokens
     * No tokens exist initially - they must be minted when gold is deposited
     */
    constructor() 
        ERC20("Luxembourg Gold Token", "LUXGOLD")  // Token name and symbol
        Ownable(msg.sender)  // Set deployer as owner
    {
        // Initially no tokens exist until gold is deposited and verified
        // This ensures tokens are always backed by real gold reserves
    }
    
    /**
     * @dev Mints new tokens when physical gold is deposited
     * Only the owner can mint, ensuring controlled token creation
     * Simultaneously increases both token supply and recorded gold reserves
     * 
     * @param to Address that will receive the newly minted tokens
     * @param amount Number of tokens to mint (should equal gold deposited)
     * 
     * Requirements:
     * - Caller must be contract owner
     * - Physical gold must be deposited and verified before calling
     * - Amount should correspond to actual gold deposited
     */
    function mint(address to, uint256 amount) public onlyOwner {
        // Create new tokens for the recipient
        _mint(to, amount);
        // Increase recorded gold reserves to maintain backing ratio
        totalGoldReserves += amount;
        
        // Note: In production, this should include verification that
        // corresponding physical gold has actually been deposited
    }
    
    /**
     * @dev Burns tokens when holder wants to redeem physical gold
     * Anyone can burn their own tokens to redeem gold
     * Reduces both token supply and recorded gold reserves
     * 
     * @param amount Number of tokens to burn and redeem for gold
     * 
     * Requirements:
     * - Caller must own sufficient tokens
     * - Physical gold withdrawal process should be initiated
     */
    function burn(uint256 amount) public {
        // Destroy tokens from caller's balance
        _burn(msg.sender, amount);
        // Reduce recorded gold reserves proportionally
        totalGoldReserves -= amount;
        
        // Note: In production, this should trigger physical gold
        // withdrawal process from secure storage
    }
    
    /**
     * @dev Calculates how much gold each token represents
     * Provides transparency about the backing ratio
     * Returns value with decimal precision matching token decimals
     * 
     * @return Amount of gold per token (with decimal precision)
     * 
     * Example: If 1000 tokens backed by 1000g gold, returns 1000000000000000000 (1.0 with 18 decimals)
     */
    function getGoldPerToken() public view returns (uint256) {
        // Prevent division by zero if no tokens exist
        if (totalSupply() == 0) return 0;
        
        // Calculate gold per token with proper decimal handling
        // Multiply reserves by 10^decimals to maintain precision
        return (totalGoldReserves * 10**decimals()) / totalSupply();
    }
}