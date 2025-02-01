const TelegramBot = require('node-telegram-bot-api');
const { mintToken, getTokenDetails } = require('./tokenService'); // Ensure this path is correct

const token = '7940970496:AAFOnhpVNNN-5rZMdGMMQ9Izp0XESs9wSU4';
const bot = new TelegramBot(token, { polling: true });

const senderPrivateKey = 'fa28ca085f8a5302e62b6dd9088b3192174460589450e73511f6d8f454580ed6'; // Ensure the sender private key is in hex format without 0x prefix

bot.onText(/\/mint (\d+)/, async (msg, match) => {
  const chatId = msg.chat.id;
  const amount = match[1]; // Extract the amount from the command
  const receiverAccountAddr = '1c5acf62be507c27a7788a661b546224d806246765ff2695efece60194c6df05'; // Replace with the actual receiver account address

  try {
    // Mint the token
    const tx = await mintToken(senderPrivateKey, receiverAccountAddr, amount);

    // Get the token details
    const tokenDetails = await getTokenDetails(receiverAccountAddr);

    // Format transaction details
    const formattedTx = JSON.stringify(tx, null, 2);

    // Send a success message with details
    bot.sendMessage(chatId, `Token minted successfully!\n\nDetails:\nBalance: ${tokenDetails.balance}\nTransaction: ${formattedTx}`);
  } catch (error) {
    console.error('Error minting token:', error);
    bot.sendMessage(chatId, 'Failed to mint token. Please try again.');
  }
});
