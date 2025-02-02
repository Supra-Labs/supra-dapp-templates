const TelegramBot = require('node-telegram-bot-api');
const { mintToken, getTokenDetails } = require('./tokenService'); // Ensure this path is correct

const token = 'PUT YOUR TELEGRAM BOT API HERE'; // Replace with your Telegram Bot API
const bot = new TelegramBot(token, { polling: true });

const senderPrivateKey = 'fa28...'; // Ensure the sender private key is in hex format without 0x prefix

bot.onText(/\/mint (\d+)/, async (msg, match) => {
  const chatId = msg.chat.id;
  const amount = match[1]; // Extract the amount from the command
  const receiverAccountAddr = '1c5...'; // Replace with the actual receiver account address

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
