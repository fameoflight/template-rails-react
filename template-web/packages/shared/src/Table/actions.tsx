import React from 'react';

import _ from 'lodash';

import { DownOutlined } from '@ant-design/icons';
import { Button, Dropdown, Menu } from 'antd';
import { SizeType } from 'antd/lib/config-provider/SizeContext';
import { ColumnProps, ColumnType } from 'antd/lib/table';

export type ActionItemType = {
  key: string;
  label: string;
  danger?: boolean;
  icon?: React.ReactNode;
  className?: string;
};

export interface ITableWithActions<T> {
  size?: SizeType;
  dropdown?: boolean;
  actions: ActionItemType[];
  rowActions?: (row: T) => ActionItemType[];
  onAction: (actionKey: string, row: T) => void;
  columnProps?: ColumnProps<T>;
}

function actionColumn<T>(
  actionProps: ITableWithActions<T> | null | undefined
): ColumnType<T> | null {
  if (!actionProps) {
    return null;
  }

  const { size, columnProps, onAction } = actionProps;

  return {
    ...columnProps,
    dataIndex: 'id',
    key: 'actions',
    render: (_text: string, record: T) => {
      let { actions } = actionProps;

      if (actionProps.rowActions) {
        actions = actions.concat(actionProps.rowActions(record));
      }

      const onClick = (key: any) => {
        onAction(key, record);
      };

      // If there are less than two action it doesn't make sense to show dropdown
      const dropdown = _.isUndefined(actionProps.dropdown)
        ? _.size(actions) > 2
        : actionProps.dropdown;

      if (!dropdown) {
        return (
          <div className="space-x-2 space-y-2">
            {_.map(actions, (action: any) => (
              <Button
                size={size || 'small'}
                key={action.key}
                danger={action.danger}
                onClick={() => onClick(action.key)}
                className={action.className}
                type={action.type}
                icon={action.icon}
                disabled={action.disabled}
              >
                {action.label}
              </Button>
            ))}
          </div>
        );
      }

      const menu = (
        <Menu onClick={(info) => onClick(info.key)} items={actions} />
      );

      return (
        <Dropdown overlay={menu} trigger={['click']}>
          <Button size={size}>
            Actions
            <DownOutlined />
          </Button>
        </Dropdown>
      );
    },
  };
}

const actions = {
  actionColumn,
};

export default actions;
