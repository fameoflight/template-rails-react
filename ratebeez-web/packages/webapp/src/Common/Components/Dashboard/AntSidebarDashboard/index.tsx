import React from 'react';
import { useLocation } from 'react-router-dom';

import { matchingKeys } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { Layout, Menu, MenuProps } from 'antd';

interface IAntSidebarDashboardProps {
  children: JSX.Element;
  navigationItems: MenuProps['items'];
  onClick: MenuProps['onClick'];
}

function AntSidebarDashboard(props: IAntSidebarDashboardProps) {
  const location = useLocation();

  const items = _.compact(
    _.map(props.navigationItems, (item) => {
      if (item?.key) {
        return {
          key: item.key,
        };
      }
      return null;
    })
  );
  let defaultSelectedKeys = _.map(
    matchingKeys(items, location.pathname),
    (key) => _.toString(key)
  );

  // Note(hemantv): if there are more than one default keys
  // than we safely remove index route key
  if (_.size(defaultSelectedKeys) > 1) {
    defaultSelectedKeys = _.compact(defaultSelectedKeys);
  }

  return (
    <Layout className="p-4 min-h-full">
      <div className="hidden md:flex md:w-64 md:flex-col md:fixed md:inset-y-0">
        <Menu
          mode="inline"
          onClick={props.onClick}
          items={props.navigationItems}
          defaultSelectedKeys={defaultSelectedKeys}
        />
      </div>

      <Layout.Content className="ml-4 min-h-full">
        {props.children}
      </Layout.Content>
    </Layout>
  );
}

export default AntSidebarDashboard;
