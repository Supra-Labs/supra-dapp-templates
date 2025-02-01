// src/App.tsx
// use the App/.tsx file to render the WalletConnection and TodoList components for our frontend of to-do list dapp.
import React, { useState } from 'react';
import './App.css';
import WalletConnection from './WalletConnection';
import TodoList from './TodoList';
import logo from './assets/supra.png';  // Add the logo import statement for the Supra logo on top

const App: React.FC = () => {
  const [account, setAccount] = useState<string | null>(null);

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="Supra Logo" />   
        <h1>Supra To-Do List</h1>
        <p>A simple to-do list dapp built using the Supra TypeScript SDK</p>   
        <WalletConnection setAccount={setAccount} />
        {account && <TodoList account={account} />}
      </header>
    </div>
  );
};

export default App;
