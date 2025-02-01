## Overview 
Sample dapp build on [Supra](supra.com) MoveVM Testnet with [Starkey Wallet](starkey.app). The dapp is a Spin the Wheel Game with a minimalist UI aiming to provide a guide template for building on Supra MoveVM and Integrate Starkey for Devs trying out first hand with Layer 1. This project showcases how to create a simple game where users can spin a wheel and get random results like "Win," "Lose," or "Try Again."

## Wokring 

### Backend: Smart Contract on Supra MoveVM Testnet 

The backend of this project is built using the Move and deployed on the Supra MoveVM. The smart contract includes the `Move.toml` file and module called `SpinTheWheel`, which contains the following functions:
- `initialize:` Initializes the Result resource with a default value.
- `spin:` Generates a random result and updates the Result resource.

Deploy the Smart Contract on Supra MoveVM Testnet using the guide at: https://docs.supra.com/move/ 

### Frontend UI 
- **Wallet Connection:** Allows users to connect their Starkey wallet.
- **Spin the Wheel Button**: Provides the game interface where users can spin the wheel.
- **Wheel Animation:** Displays the spinning wheel animation using the Supra circular logo.

### Role of Starkey Wallet 
The Starkey wallet plays a crucial role in this project by providing the following functionalities:

- **Authentication:** Verifies the user’s identity and ensures authorized access.
- **Transaction Signing:** Signs and sends transactions to Supra.
- **Account Management:** Users can manage their accounts and view spin results.

## Getting Started
This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/pages/api-reference/create-next-app).

- Install Dependencies:
```
npm install
```

- Start the Development Server::

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

- Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

- Connecting Starkey Wallet: 
Open the Application and Click the "Connect Wallet" button following the instructions to connect your Starkey wallet.

## Contribution
Feel free to contribute to this project by submitting pull requests or opening issues, all contributions that enhance the functionality or user experience of this project are welcome.
