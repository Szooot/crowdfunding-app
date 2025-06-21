'use client';

import { useAccount } from 'wagmi';
import { ConnectButton } from '@rainbow-me/rainbowkit';

export default function Home() {
  const { address, isConnected } = useAccount();

  return (
    <main className="p-8">
      <h1 className="text-3xl font-bold mb-4">Crowdfunding DApp</h1>

      <ConnectButton />

      {isConnected ? (
        <p className="mt-4 text-green-700">Connected as: {address}</p>
      ) : (
        <p className="mt-4 text-gray-500">Connect your wallet to begin.</p>
      )}

    </main>
  );
}