import Head from 'next/head';
import Image from 'next/image';
import SpinTheWheel from '../components/SpinTheWheel';
import WalletConnection from '../components/WalletConnection';

export default function Home() {
  return (
    <div>
      <Head>
        <title>Spin the Wheel</title>
      </Head>
      <main>
        <div className="logo-container">
          <Image src="/supra.svg" alt="Company Logo" width={200} height={200} />
        </div>
        <h1>Welcome to Spin the Wheel!</h1>
        <WalletConnection />
        <SpinTheWheel />
        <div className="social-buttons">
          <a href="https://github.com/JatinSupra" target="_blank" rel="noopener noreferrer">
            <button className="social-button github">GitHub</button>
          </a>
          <a href="https://twitter.com/Jpandya26" target="_blank" rel="noopener noreferrer">
            <button className="social-button twitter">Twitter</button>
          </a>
          <a href="https://github.com/Entropy-Foundation/supra-dev-hub/" target="_blank" rel="noopener noreferrer">
            <button className="social-button supra-dev-hub">Supra Dev Hub</button>
          </a>
        </div>
      </main>
    </div>
  );
} 