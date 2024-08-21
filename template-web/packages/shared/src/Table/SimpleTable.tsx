import React from 'react';

import _ from 'lodash';

import { Table, TableProps } from 'antd';
import { ColumnsType, TablePaginationConfig } from 'antd/lib/table';

import actions, { ITableWithActions } from './actions';

export interface ISimpleTableProps<T> extends Omit<TableProps<T>, 'columns'> {
  actionProps?: ITableWithActions<T> | null;
  columns: (ColumnsType<T>[0] | null)[];
  pagination?: false | TablePaginationConfig;
}

function SimpleTable<T extends RelayNode>(props: ISimpleTableProps<T>) {
  const { columns, actionProps, ...restProps } = props;

  return (
    <Table
      scroll={{ x: true }}
      columns={_.compact([...columns, actions.actionColumn(actionProps)])}
      pagination={props.pagination == undefined ? false : props.pagination}
      {...restProps}
    />
  );
}

export default SimpleTable;
