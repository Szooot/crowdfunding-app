'use client';

import { WagmiProvider, createConfig, configureChains } from 'wagmi';
import { sepolia } from 'wagmi/chains';
import { publicProvider } from 'viem/providers/public';
import { alchemyProvider } from 'viem/providers/alchemy';
import {
  RainbowKitProvider,
  getDefaultWallets,
} from '@rainbow-me/rainbowkit';
import '@rainbow-me/rainbowkit/styles.css';

const { chains, publicClient } = configureChains(
  [sepolia],
  [
    alchemyProvider({ apiKey: 'O016kwiJVcm6CFTUz2rDWdDhNu7eLf16' }),
    publicProvider(),
  ]
);

const { connectors } = getDefaultWallets({
  appName: 'Crowdfunding App',
  projectId: '659306a0a48592d4ceea6de4bc11c3d2',
  chains,
});

const wagmiConfig = createConfig({
  autoConnect: true,
  connectors,
  publicClient,
});

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <WagmiProvider config={wagmiConfig}>
      <RainbowKitProvider >
        {children}
      </RainbowKitProvider>
    </WagmiProvider>
  );
}