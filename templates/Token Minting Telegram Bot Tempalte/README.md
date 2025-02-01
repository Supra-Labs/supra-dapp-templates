# SupraToken Telegram Bot

## Overview

SupraToken Telegram Bot allows users to mint tokens via Telegram command and utilizes the Supra SDK and framework to perform blockchain transactions seamlessly.

## **Mint Tokens:** 
Users can mint tokens by sending a `/mint` command in Telegram.

## How it works?

The backend logic is deployed on Supra MoveVM Testnet and drafting logic to manage and mint tokens. Here's an overview of how the project works:

### Supra Move Testnet

The smart contract is deployed on the Supra Move testnet. The contract manages token minting and balance retrieval, leveraging the capabilities of the Supra framework to ensure seamless blockchain interactions.

### How It Works

1. **Telegram Bot:** Listens for `/mint` commands from users.
2. **Minting Process:** When a mint command is received, the bot calls the `mintToken` function, which interacts with the Supra blockchain to mint tokens.
3. **Balance Retrieval:** After minting, the bot fetches the balance from the blockchain and sends a confirmation message to the user.

## Project Structure

The project is structured as follows:

```plaintext
Supratokentg/
├── src/
│   ├── bot.js
│   └── tokenService.js
├── package.json
├── Source/
│   ├── SupraToken.move
├── Move.toml
└── node_modules/
```
### `src/bot.js`
The main file that configures and starts the Telegram bot. It listens for commands and interacts with the token service to perform blockchain operations.

### `src/tokenService.js`
Handles the interaction with the Supra blockchain using the Supra SDK.

Key Functions:
- `mintToken`: Mints tokens for a specified account.
- `getTokenDetails`: Retrieves the balance of tokens for a specified account.

## Deployment
To deploy the Telegram bot, follow these steps:

### Clone the Repository:
`
git clone https://github.com/YOUR_USERNAME/Supratokentg-bot.git
cd Supratokentg-bot
`

### Install Dependencies:
`
npm install
`

### Update Environment Variables:
Set your Telegram bot token and other necessary credentials.

### Start the Bot:
`
node src/bot.js
`

### Mint Tokens
To mint tokens, send the following command in your Telegram chat with the bot:
`
/mint <amount>
`

## Contribution
Feel free to contribute to this project by submitting pull requests or opening issues, all contributions that enhance the functionality or user experience of this project are welcome.
