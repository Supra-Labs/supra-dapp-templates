// src/wallet.ts
interface StarkeyProvider {
  connect: () => Promise<string[]>;
  account: () => Promise<string[]>;
  sendTransaction: (transaction: object) => Promise<string>;
  disconnect: () => Promise<void>;
  on: (event: string, handler: (accounts: string[]) => void) => void;
}

interface StarkeyWindow extends Window {
  starkey?: {
    supra: StarkeyProvider;
  };
}

declare let window: StarkeyWindow;

export const getProvider = () => {
  if (window.starkey) {
    const provider = window.starkey.supra;
    if (provider) {
      return provider;
    }
  }
  window.open('https://starkey.app/', '_blank');
};

export const connectWallet = async () => {
  const provider = getProvider();
  if (provider) {
    try {
      const accounts = await provider.connect();
      console.log(`Connected account: ${accounts[0]}`);
      return accounts[0];
    } catch (err) {
      console.error("User rejected the request:", err);
      return null;
    }
  }
};
