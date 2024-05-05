import React, { Fragment } from 'react';
import { Link } from 'react-router-dom';

import _ from 'lodash';

import { UserOutlined } from '@ant-design/icons';
import { Menu, Transition } from '@headlessui/react';
import { Avatar } from 'antd';

interface ProfileMenuProps {
  user?: {
    readonly avatar?: {
      readonly id: string;
      readonly url?: string | null;
    } | null;
    readonly id: string;
    readonly name?: string | null;
    readonly spoof: boolean;
  } | null;
}

export default function ProfileMenu(props: ProfileMenuProps) {
  const user = props.user;

  if (user == null) {
    return null;
  }

  const name = user.name || 'User';

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
          <div className="px-2 py-2">
            <p className="text-xs">Signed in as</p>
            <Link to="/auth/update">
              <p className="mt-2 text-sm font-medium text-gray-900 truncate">
                {user.name}
              </p>
            </Link>
          </div>
          <div className="mt-4">
            <Menu.Item>
              <Link
                to="/auth/signout"
                className="text-gray-600 block w-full text-left px-2 text-sm remove-underline"
              >
                Sign out
              </Link>
            </Menu.Item>
          </div>

          {user.spoof && (
            <div className="mt-4">
              <Menu.Item>
                <Link
                  to="/auth/end-spoof"
                  className="text-red-700 block w-full text-left px-2 text-sm"
                >
                  End Spoof
                </Link>
              </Menu.Item>
            </div>
          )}
        </Menu.Items>
      </Transition>
    </Menu>
  );
}
