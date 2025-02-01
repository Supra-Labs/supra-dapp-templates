// src/tokenService.js
const { SupraClient, SupraAccount, HexString } = require('supra-l1-sdk'); // Ensure you have the Supra SDK installed

const client = new SupraClient('https://rpc-testnet.supra.com/'); // Replace with your Supra node URL

async function accountExists(accountAddress) {
  try {
    const accountInfo = await client.getAccountInfo(HexString.ensure(accountAddress));
    return accountInfo ? true : false;
  } catch (error) {
    return false;
  }
}

async function mintToken(senderPrivateKey, receiverAccountAddr, amount) {
  try {
    // Convert the senderPrivateKey to Uint8Array using Buffer
    const senderPrivateKeyArray = Uint8Array.from(Buffer.from(senderPrivateKey, 'hex'));
    const senderAccount = new SupraAccount(senderPrivateKeyArray); // Create sender account from private key
    const receiverAddress = HexString.ensure(receiverAccountAddr); // Ensure the receiver address is a HexString

    // Verify sender and receiver accounts exist
    const senderExists = await accountExists(senderAccount.address());
    const receiverExists = await accountExists(receiverAccountAddr);

    if (!senderExists) {
      throw new Error('Sender account does not exist or is invalid');
    }
    if (!receiverExists) {
      throw new Error('Receiver account does not exist or is invalid');
    }

    // Mint the token
    const tx = await client.transferSupraCoin(senderAccount, receiverAddress, BigInt(amount));
    console.log(`Minting ${amount} tokens for account ${receiverAccountAddr}...`);
    return tx;
  } catch (error) {
    console.error('Error minting token:', error);
    throw error;
  }
}

async function getTokenDetails(account) {
  try {
    const balance = await client.getAccountSupraCoinBalance(HexString.ensure(account));
    return { balance };
  } catch (error) {
    console.error('Error getting token details:', error);
    throw error;
  }
}

module.exports = {
  mintToken,
  getTokenDetails
};
