'use client';
import Link from 'next/link';
import Image from 'next/image';
import { useAccount } from 'wagmi';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import vercel from '../../../public/vercel.svg';

const Navbar = () => {
  const { address, isConnected } = useAccount();

  return (
    <nav className="bg-slate-100 border-b-2 border-b-slate-300">
      <div className="mx-auto max-w-7xl px-2 sm:px-6 lg:px-8">
        <div className="relative flex h-16 items-center justify-between">
          <div className="flex flex-1 items-center justify-center sm:items-stretch sm:justify-start">
            <div className="flex flex-shrink-0 items-center">
              <Image
                src={vercel}
                alt="Logo"
                width={32}
                height={32}
                style={{
                  filter: 'drop-shadow(0px 0px 24px #a726a9a8)',
                }}
              />
            </div>
            <div className="hidden sm:ml-6 sm:block">
              <div className="flex space-x-4">
                <Link href="/">
                  <p className="rounded-md px-3 py-2 text-sm font-medium text-slate-700">Campaigns</p>
                </Link>
                {isConnected && (
                  <Link href={`/dashboard/${address}`}>
                    <p className="rounded-md px-3 py-2 text-sm font-medium text-slate-700">Dashboard</p>
                  </Link>
                )}
              </div>
            </div>
          </div>
          <div className="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0">
            <ConnectButton />
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;