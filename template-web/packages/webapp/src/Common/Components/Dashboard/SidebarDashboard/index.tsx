import React, { Fragment, ReactElement, useEffect, useState } from 'react';
import { Link, useLocation } from 'react-router-dom';

import Suspense from '@picasso/shared/src/Components/Suspense';
import motion from '@picasso/shared/src/Components/motion';
import { classNames } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { Dialog, Transition } from '@headlessui/react';
import { Bars4Icon, XMarkIcon } from '@heroicons/react/24/outline';

type NavigationItem = {
  name: string;
  link: string;
  icon: ReactElement;
};

interface ISidebarDashboardProps {
  children: ReactElement;
  navigationItems: NavigationItem[];
  disableAnimation?: boolean;
}

function SidebarDashboard(props: ISidebarDashboardProps) {
  const location = useLocation();
  const [sidebarOpen, setSidebarOpen] = useState(false);

  useEffect(() => {
    setSidebarOpen(false);
  }, [location.pathname]);

  const isCurrent = (item: NavigationItem) => false;

  const children = props.disableAnimation ? (
    props.children
  ) : (
    <motion.shift motionKey={location.pathname} values={{ x: 0, y: 10 }}>
      {props.children}
    </motion.shift>
  );

  return (
    <div className="flex flex-row min-h-[90vh] -m-8">
      <Transition.Root show={sidebarOpen} as={Fragment}>
        <Dialog
          as="div"
          className={`fixed inset-0 flex z-40 ${
            sidebarOpen ? 'block' : 'hidden'
          }`}
          onClose={setSidebarOpen}
        >
          <Transition.Child
            as={Fragment}
            enter="transition-opacity ease-linear duration-300"
            enterFrom="opacity-0"
            enterTo="opacity-100"
            leave="transition-opacity ease-linear duration-300"
            leaveFrom="opacity-100"
            leaveTo="opacity-0"
          >
            <Dialog.Overlay className="fixed inset-0 bg-gray-600 bg-opacity-75" />
          </Transition.Child>
          <Transition.Child
            as={Fragment}
            enter="transition ease-in-out duration-300 transform"
            enterFrom="-translate-x-full"
            enterTo="translate-x-0"
            leave="transition ease-in-out duration-300 transform"
            leaveFrom="translate-x-0"
            leaveTo="-translate-x-full"
          >
            <div className="relative flex-1 flex flex-col max-w-xs w-full bg-picasso-primary-900">
              <Transition.Child
                as={Fragment}
                enter="ease-in-out duration-300"
                enterFrom="opacity-0"
                enterTo="opacity-100"
                leave="ease-in-out duration-300"
                leaveFrom="opacity-100"
                leaveTo="opacity-0"
              >
                <div className="absolute top-0 right-0 -mr-12 pt-2">
                  <button
                    type="button"
                    className="border-none ml-1 flex items-center justify-center h-10 w-10 rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
                    onClick={() => setSidebarOpen(false)}
                  >
                    <span className="sr-only">Close sidebar</span>
                    <XMarkIcon
                      className="h-6 w-6 text-picasso-primary-900"
                      aria-hidden="true"
                    />
                  </button>
                </div>
              </Transition.Child>
              <div className="flex-1 h-0 pt-5 pb-4 overflow-y-auto">
                <nav className="mt-4 px-2 space-y-1">
                  {props.navigationItems.map((item) => (
                    <Link
                      key={item.name}
                      to={item.link}
                      className={classNames(
                        isCurrent(item)
                          ? 'bg-picasso-primary-800 text-white'
                          : 'text-white hover:bg-picasso-primary-800 hover:bg-opacity-75',
                        'group flex items-center px-2 py-2 text-base font-medium rounded-md remove-underline'
                      )}
                    >
                      {item.icon && (
                        <span
                          className="mr-4 flex-shrink-0 h-6 w-6 text-picasso-primary-500"
                          aria-hidden="true"
                        >
                          {item.icon}
                        </span>
                      )}
                      {item.name}
                    </Link>
                  ))}
                </nav>
              </div>
            </div>
          </Transition.Child>
        </Dialog>
      </Transition.Root>

      {/* Static sidebar for desktop */}
      <div className="hidden md:flex md:flex-col  md:inset-y-0">
        {/* Sidebar component, swap this element with another sidebar if you like */}
        <div className="flex-1 flex flex-col min-h-0 bg-picasso-primary-900">
          <div className="flex-1 flex flex-col overflow-y-auto">
            <nav className="mt-1 flex-1 pl-4 pr-6 space-y-4">
              {props.navigationItems.map((item) => (
                <Link
                  key={item.name}
                  to={item.link}
                  className={classNames(
                    isCurrent(item)
                      ? 'bg-picasso-primary-800 text-white'
                      : 'text-white hover:bg-opacity-75',
                    'group flex items-center text-sm font-medium rounded-md pr-2'
                  )}
                >
                  {item.icon && (
                    <span
                      className="mr-4 flex-shrink-0 h-6 w-6 text-white"
                      aria-hidden="true"
                    >
                      {item.icon}
                    </span>
                  )}
                  {item.name}
                </Link>
              ))}
            </nav>
          </div>
        </div>
      </div>
      <div className="flex flex-col flex-1">
        <div className="sticky top-0 z-10 md:hidden pl-1 pt-1 sm:pl-3 sm:pt-3 bg-gray-100">
          <button
            type="button"
            className="border-none bg-white -ml-0.5 -mt-0.5 h-12 w-12 inline-flex items-center justify-center rounded-md text-gray-500 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-picasso-primary-700"
            onClick={() => setSidebarOpen(true)}
          >
            <span className="sr-only">Open sidebar</span>
            <Bars4Icon className="h-6 w-6" aria-hidden="true" />
          </button>
        </div>
        <main className="flex-1 bg-gray-100">
          <div className="py-6">
            <div className="mx-auto px-4 sm:px-6 md:px-8">
              <Suspense paragraph={50}>{children}</Suspense>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}

export default SidebarDashboard;
