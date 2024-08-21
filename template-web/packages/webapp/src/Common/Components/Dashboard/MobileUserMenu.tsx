import React, { Fragment } from 'react';
import { Link } from 'react-router-dom';

import _ from 'lodash';

import { UserOutlined } from '@ant-design/icons';
import { Menu, Transition } from '@headlessui/react';
import { Avatar } from 'antd';

import { useFragment, graphql } from 'react-relay/hooks';

import { MobileUserMenu_user$key } from '@picasso/fragments/src/MobileUserMenu_user.graphql';

const fragmentSpec = graphql`
  fragment MobileUserMenu_user on User {
    id
    name
    avatar {
      url
    }
  }
`;

interface MobileUserMenuProps {
  user: MobileUserMenu_user$key | null;
  navigationItems: {
    name: string;
    href: string;
    colorClass?: string;
  }[];
}

function MobileUserMenu(props: MobileUserMenuProps) {
  const user = useFragment(fragmentSpec, props.user);

  if (user == null) {
    return null;
  }

  const name = user.name || 'User';

  const navigationItems = props.navigationItems;

  return (
    <Menu as="div" className="ml-3 relative">
      <div>
        <Menu.Button className="border-none max-w-xs bg-picasso-primary-900 rounded-full flex items-center text-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-picasso-primary-900 focus:ring-white">
          <span className="sr-only">Open user menu</span>
          <Avatar
            src={user.avatar?.url}
            icon={<UserOutlined />}
            className="h-8 w-8 rounded-full"
          >
            {name[0]}
          </Avatar>
        </Menu.Button>
      </div>
      <Transition
        as={Fragment}
        enter="transition ease-out duration-100"
        enterFrom="transform opacity-0 scale-95"
        enterTo="transform opacity-100 scale-100"
        leave="transition ease-in duration-75"
        leaveFrom="transform opacity-100 scale-100"
        leaveTo="transform opacity-0 scale-95"
      >
        <Menu.Items className="z-10 p-4 origin-top-right absolute right-0 mt-1 w-72 rounded-md shadow-lg bg-gray-50">
          <div className="px-2 pb-4 border-b border-gray-200">
            <p className="mt-2 text-sm font-medium text-gray-900 truncate">
              {user.name}
            </p>
          </div>
          {navigationItems.map((item) => (
            <div key={item.name} className="mt-4">
              <Menu.Item>
                <Link
                  to={item.href}
                  className={`block w-full text-left px-2 text-sm remove-underline hover:${item.colorClass} ${item.colorClass}`}
                >
                  {item.name}
                </Link>
              </Menu.Item>
            </div>
          ))}
        </Menu.Items>
      </Transition>
    </Menu>
  );
}

export default MobileUserMenu;
