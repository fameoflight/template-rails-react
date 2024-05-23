import React from 'react';
import { Fragment } from 'react';
import { graphql } from 'relay-runtime';

import Image from 'next/future/image';

import { NavigationQuery } from '@picasso/fragments/src/NavigationQuery.graphql';

import IconImg from '@picasso/shared/assets/logo/web/svg/color.svg';
import TailwindButton from '@picasso/shared/src/Components/TailwindButton';
import { useNetworkLazyLoadQuery } from '@picasso/shared/src/relay/hooks';

import { Popover, Transition } from '@headlessui/react';
import { Bars4Icon, XMarkIcon } from '@heroicons/react/24/outline';

import Link from 'src/Components/Link';

const navigationQuery = graphql`
  query NavigationQuery {
    currentUser {
      id
      name
    }
  }
`;

const navigation = [
  {
    name: 'Home',
    href: '/',
  },
  {
    name: 'Blog',
    href: '/blog',
  },
  { name: 'About', href: '/about' },
];

function Navigation() {
  const data = useNetworkLazyLoadQuery<NavigationQuery>(navigationQuery);

  const buttonText = data.currentUser ? 'Dashboard' : 'Login';

  const logoElement = (
    <Link to="/">
      <Image src={IconImg} alt="" className="w-24 h-auto cursor-pointer" />
    </Link>
  );
  return (
    <div className="py-8 bg-gray-50">
      <Popover>
        <div className="mx-auto max-w-7xl px-4 sm:px-6">
          <nav
            className="relative flex items-center justify-between sm:h-10 md:justify-center"
            aria-label="Global"
          >
            <div className="flex flex-1 items-center md:absolute md:inset-y-0 md:left-0">
              <div className="flex w-full items-center justify-between md:w-auto">
                {logoElement}
                <div className="-mr-2 flex items-center md:hidden">
                  <Popover.Button className="inline-flex items-center justify-center rounded-md bg-gray-50 p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-picasso-primary-700">
                    <span className="sr-only">Open main menu</span>
                    <Bars4Icon className="h-6 w-6" aria-hidden="true" />
                  </Popover.Button>
                </div>
              </div>
            </div>
            <div className="hidden md:flex md:space-x-10">
              {navigation.map((item) => (
                <Link
                  key={item.name}
                  to={item.href}
                  className="font-medium text-gray-400 hover:text-gray-900 cursor-pointer"
                >
                  {item.name}
                </Link>
              ))}
            </div>
            <div className="hidden md:absolute md:inset-y-0 md:right-0 md:flex md:items-center md:justify-end">
              <span className="inline-flex rounded-md shadow">
                <TailwindButton type="secondary" className="block w-full">
                  <a
                    href="https://app.usepicasso.com"
                    target="_blank"
                    rel="noreferrer"
                  >
                    {buttonText}
                  </a>
                </TailwindButton>
              </span>
            </div>
          </nav>
        </div>

        <Transition
          as={Fragment}
          enter="duration-150 ease-out"
          enterFrom="opacity-0 scale-95"
          enterTo="opacity-100 scale-100"
          leave="duration-100 ease-in"
          leaveFrom="opacity-100 scale-100"
          leaveTo="opacity-0 scale-95"
        >
          <Popover.Panel
            focus
            className="absolute inset-x-0 top-0 z-10 origin-top-right transform p-2 transition md:hidden"
          >
            <div className="overflow-hidden bg-white shadow-md ring-1 ring-black ring-opacity-5">
              <div className="flex items-center justify-between px-5 pt-4">
                {logoElement}
                <div className="-mr-2">
                  <Popover.Button className="inline-flex items-center justify-center rounded-md bg-white p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-picasso-primary-700">
                    <span className="sr-only">Close menu</span>
                    <XMarkIcon className="h-6 w-6" aria-hidden="true" />
                  </Popover.Button>
                </div>
              </div>
              <div className="px-2 pt-2 pb-3">
                {navigation.map((item) => (
                  <Link
                    key={item.name}
                    to={item.href}
                    className="block rounded-md px-3 py-2 text-base font-medium text-gray-700 hover:bg-gray-50 hover:text-gray-900 remove-underline"
                  >
                    {item.name}
                  </Link>
                ))}
              </div>
              <div className="w-full px-2 py-4">
                <a
                  href="https://app.usepicasso.com"
                  target="_blank"
                  rel="noreferrer"
                  className="block w-full"
                >
                  <TailwindButton className="w-full p-6">
                    {buttonText}
                  </TailwindButton>
                </a>
              </div>
            </div>
          </Popover.Panel>
        </Transition>
      </Popover>
    </div>
  );
}

export default Navigation;
