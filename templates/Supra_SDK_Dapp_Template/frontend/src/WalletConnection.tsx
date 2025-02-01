// src/WalletConnection.tsx
// This is the file that will be used to connect to the Starkey Wallet., the official wallet on Supra, you can check Starkey.app for docs.
import React, { useState, useEffect } from 'react';
import { connectWallet } from './wallet';

interface WalletConnectionProps {
  setAccount: React.Dispatch<React.SetStateAction<string | null>>;
}

const WalletConnection: React.FC<WalletConnectionProps> = ({ setAccount }) => {
  useEffect(() => {
    const connect = async () => {
      const account = await connectWallet();
      if (account !== null && account !== undefined) {
        setAccount(account);
      }
    };

    connect();
  }, [setAccount]);

  return (
    <div>
      <p>Connecting to StarKey wallet...</p>
    </div>
  );
};

export default WalletConnection;
