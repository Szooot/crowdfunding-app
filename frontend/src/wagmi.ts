import { getDefaultConfig } from '@rainbow-me/rainbowkit';
import { sepolia } from 'wagmi/chains';

export const config = getDefaultConfig({
  appName: 'RainbowKit demo',
  projectId: '${process.env.NEXT_PUBLIC_RAINBOWKIT_PROJECT_ID}',
  chains: [
    sepolia,
    ...(process.env.NEXT_PUBLIC_ALCHEMY_API === 'true' ? [sepolia] : []),
  ],
  ssr: true,
});
