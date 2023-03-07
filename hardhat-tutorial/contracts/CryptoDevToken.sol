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

       function claim() public {
        addrss sender = msg.sender;

        // Get the number of CryptoDev NFT's held by a given sender address
        uint256 balance = CryptoDevsNFT.balanceOf(sender);
         // If the balance is zero, revert the transaction
         require(balance > 0, "Your balance is too small for this transaction");
         // amount keeps track of number of unclaimed tokenIds
         uint256 amount = 0;
         // loop over the balance and get the token ID owned by `sender` at a given `index` of its token list.

         for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
             // if the tokenId has not been claimed, increase the amount
             if(tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
             }
             // If all the token Ids have been claimed, revert the transaction;
            require(amount > 0, "You have claimed all the tokens");
            _mint(msg.sender, amount * tokensPerNFT);
         }
       }

       /**
        * @dev withdraws all ETH sent to this contract
        * Requirements:
        * wallet connected must be owner's address
        */

        function withdraw() public onlyOwner {
            uint256 amount = address(this).balance;
            require(amount > 0, "nothing to withdraw, account is empty");

            address _owner = owner();
            (bool sent,) = owner.call{value: amount}("");
            require(sent, "Failed to send Ether");
        }

        // Function to receive Ether. msg.data must be empty
      receive() external payable {}

      // Fallback function is called when msg.data is not empty
      fallback() external payable {}
  }