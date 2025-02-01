// src/index.ts
// this is the backend file of our server, where we will initialize the SupraClient and create the routes for our server also which we made to store the tasks in the to-do list we will make in frontend of ours and MAKE SURE YOU RUN THE BACKEND BEFORE FRONTEND.
import { SupraClient } from "supra-l1-sdk";
import express from 'express';
import cors from 'cors';

const app = express();
const port = 3000;

app.use(cors()); // Enable CORS, CORS can be a pain, but it's a necessary evil/
app.use(express.json());

let supraClient: SupraClient;

const initializeSupraClient = async () => {
  supraClient = await SupraClient.init("https://rpc-testnet.supra.com/");
};

// Test route to verify server is working and reachable, lets hope it always is fellas.
app.get('/', (req, res) => {
  res.send('Server is running and reachable.');
});

app.post('/add-task', async (req, res) => {
  const { account, task } = req.body;
  if (!supraClient) {
    await initializeSupraClient();
  }
  // Log the received task for debugging purposes only.
  console.log(`Received task from account ${account}: ${task.text}`);
  // Respond with a success message to the client, fingers crossed it works.
  res.send("Task added successfully");
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});

initializeSupraClient();
