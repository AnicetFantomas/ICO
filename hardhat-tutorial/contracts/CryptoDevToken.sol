// SPDX-License-Identifier: MIT
  pragma solidity ^0.8.0;

  import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
  import "@openzeppelin/contracts/access/Ownable.sol";
  import "./ICryptoDevs.sol";

  constract CryptoDevToken is ERC20, Ownable {
          // Price of one Crypto Dev token
          uint256 public constant tokenPrice = 00.1 ether;

        // Each NFT would give the user 10 tokens
        uint256 public constant tokensPerNFT = 10 * 10**18;

        // the max total supply is 10000 for Crypto Dev Tokens
        uint256 public constant maxTotalSupply = 10000 * 10**18;

        // CryptoDevsNFT contract instance
        ICryptoDevs CryptoDevsNFT;

        // Mapping to keep track of which tokenIds have been claimed
        mapping(uint256 => bool) public tokenIdsClaimed;

        constructor (address _cryptoDevsContract) ERC20("Crypto Dev Token", "CD") {
            CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
        }

         /**
       * @dev Mints `amount` number of CryptoDevTokens
       * Requirements:
       * - `msg.value` should be equal or greater than the tokenPrice * amount
       */

       function mint(uint256 amount) public payable {
        // the value of ether that should be equal or greater than tokenPrice * amount;
        uint256 _requiredAmount = tokenPrice * amount;
        require(msg.value >= _requiredAmount, "Ether sent is not a valid amount");
         // total tokens + amount <= 10000, otherwise revert the transaction
         uint256 amountWithDecimals = amount * 10**18;

         require(amountWithDecimals + _requiredAmount <= maxTotalSupply, "Exceeds the max total supply available.");
        // call the internal function from Openzeppelin's ERC20 contract
        _mint(msg.sender, amountWithDecimals)

       }

       

  }