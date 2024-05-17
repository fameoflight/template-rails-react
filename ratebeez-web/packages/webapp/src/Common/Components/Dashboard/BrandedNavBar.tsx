import React, { ReactElement } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { graphql } from 'relay-runtime';

import { BrandedNavBarQuery } from '@picasso/fragments/src/BrandedNavBarQuery.graphql';

import logoPath from '@picasso/shared/assets/logo/web/svg/nobackground.svg';
import Suspense from '@picasso/shared/src/Components/Suspense';
import motion from '@picasso/shared/src/Components/motion';
import { useNetworkLazyLoadQuery } from '@picasso/shared/src/relay/hooks';
import { classNames } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { UserOutlined } from '@ant-design/icons';
import { Disclosure } from '@headlessui/react';
import { Bars4Icon, XMarkIcon } from '@heroicons/react/24/outline';
import { Avatar } from 'antd';

import ProfileMenu from './MobileUserMenu';

const brandedNavBarQuery = graphql`
  query BrandedNavBarQuery {
    currentUser {
      id
      name
      spoof
      avatar {
        id
        url
      }
    }
  }
`;



type NavigationItem = {
  name: string;
  link: string;
};

interface IBrandedNavBarProps {
  children: React.ReactNode;
  navigationItems: (NavigationItem | null)[];
  overlayTitle?: React.ReactNode;
  className?: string;
  disableAnimation?: boolean;
  suspeneFallback?: ReactElement;
}

function BrandedNavBar(props: IBrandedNavBarProps) {
  const location = useLocation();
  const navigationItems = _.compact(props.navigationItems);
  const data = useNetworkLazyLoadQuery<BrandedNavBarQuery>(brandedNavBarQuery);

  const user = data.currentUser;

  const name = _.get(user, 'name', 'User') || 'User';

  const isCurrent = (_item) => false;

  const isOverlay = !!props.overlayTitle;

  let children = props.children;
  if (!props.disableAnimation) {
    children = (
      <motion.shift motionKey={location.pathname} values={{ x: 0, y: 10 }}>
        {children}
      </motion.shift>
    );
  }

  // Note(hemantv): important to wrap after the animation
  if (isOverlay) {
    children = (
      <div className="-mt-24 bg-slate-100 p-6 overflow-auto grow">
        <Suspense paragraph={50} fallback={props.suspeneFallback}>
          {children}
        </Suspense>
      </div>
    );
  }

  const className = props.className || (isOverlay ? 'pb-32' : 'pb-1');

  const userNavigation = [
    {
      name: 'Your Profile',
      href: '/auth/update',
      colorClass: 'text-gray-600',
    },
    {
      name: 'Sign out',
      href: '/auth/signout',
      colorClass: 'text-gray-600',
    },
  ];

  if (user?.spoof) {
    userNavigation.push({
      name: 'End Spoof',
      href: '/auth/end-spoof',
      colorClass: 'text-red-700',
    });
  }

  return (
    <>
      <div className={`bg-picasso-primary-900 ${className}`}>
        <Disclosure as="nav" className="px-8 flex-shrink">
          {({ open }) => (
            <>
              <div className="flex items-center justify-between h-16">
                <div className="flex items-center">
                  <div className="flex-shrink-0">
                    <Link to="/">
                      <img
                        className="h-8 w-auto"
                        src={logoPath as any}
                        alt="Ratebeez"
                      />
                    </Link>
                  </div>
                  <div className="hidden md:block">
                    <div className="ml-10 flex items-baseline space-x-4">
                      {navigationItems.map((item) => (
                        <Link
                          key={item.name}
                          to={item.link}
                          className={classNames(
                            isCurrent(item)
                              ? 'bg-picasso-primary-900 text-white'
                              : 'text-white hover:bg-picasso-primary-800 hover:text-white',
                            'rounded-md py-2 px-3 text-sm font-medium remove-underline'
                          )}
                          aria-current={isCurrent(item) ? 'page' : undefined}
                        >
                          {item.name}
                        </Link>
                      ))}
                    </div>
                  </div>
                </div>
                <div className="hidden md:block">
                  <div className="ml-4 flex items-center md:ml-6">
                    {/* Profile dropdown */}
                    <ProfileMenu user={user} navigationItems={userNavigation} />
                  </div>
                </div>
                <div className="-mr-2 flex md:hidden">
                  {/* Mobile menu button */}
                  <Disclosure.Button className="bg-picasso-primary-900 inline-flex items-center justify-center p-2 rounded-md text-picasso-primary-200 hover:text-white hover:bg-picasso-primary-700 hover:bg-opacity-75 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-picasso-primary-900 focus:ring-white">
                    <span className="sr-only">Open main menu</span>
                    {open ? (
                      <XMarkIcon className="block h-6 w-6" aria-hidden="true" />
                    ) : (
                      <Bars4Icon className="block h-6 w-6" aria-hidden="true" />
                    )}
                  </Disclosure.Button>
                </div>
              </div>

              <Disclosure.Panel className="md:hidden">
                <div className="px-2 pb-3 space-y-1 sm:px-4">
                  {navigationItems.map((item) => (
                    <Link
                      key={item.name}
                      to={item.link}
                      className={classNames(
                        isCurrent(item)
                          ? 'bg-picasso-primary-900 text-white'
                          : 'text-white hover:bg-picasso-primary-800 hover:text-white',
                        'block rounded-md py-2 px-3 text-base font-medium remove-underline'
                      )}
                      aria-current={isCurrent(item) ? 'page' : undefined}
                    >
                      {item.name}
                    </Link>
                  ))}
                </div>
                <div className="pt-4 pb-3">
                  <div className="flex items-center px-5">
                    <div className="flex-shrink-0">
                      <Avatar
                        icon={<UserOutlined />}
                        className="h-8 w-8 rounded-full"
                        src={user?.avatar?.url}
                      >
                        {name[0]}
                      </Avatar>
                    </div>
                    <div className="ml-3">
                      <div className="text-base font-medium text-white">
                        {name}
                      </div>
                    </div>
                  </div>
                  <div className="mt-3 px-2 space-y-1">
                    {userNavigation.map((item) => (
                      <Disclosure.Button
                        key={item.name}
                        as="a"
                        href={item.href}
                        className="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-picasso-primary-700 hover:bg-opacity-75"
                      >
                        {item.name}
                      </Disclosure.Button>
                    ))}

                    {user?.spoof && (
                      <Disclosure.Button
                        key="spoof"
                        as="a"
                        href="/auth/end-spoof"
                        className="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-picasso-primary-700 hover:bg-opacity-75"
                      >
                        End Spoof
                      </Disclosure.Button>
                    )}
                  </div>
                </div>
              </Disclosure.Panel>
            </>
          )}
        </Disclosure>

        {isOverlay && (
          <header className="pt-12">
            <div className="mx-auto px-4 sm:px-6 lg:px-8">
              <h1 className="text-3xl font-bold text-white ml-4">
                {props.overlayTitle}
              </h1>
            </div>
          </header>
        )}
      </div>

      <div className="p-4 flex-grow flex flex-col bg-slate-100">
        <Suspense paragraph={50} fallback={props.suspeneFallback}>
          {children}
        </Suspense>
      </div>
    </>
  );
}

export default BrandedNavBar;
