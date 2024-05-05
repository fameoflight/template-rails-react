import React from 'react';

import SimpleTable, { ISimpleTableProps } from './SimpleTable';

type IModelTableProps<T extends RelayNode> = Omit<
  ISimpleTableProps<T>,
  'rowId'
>;

function ModelTable<T extends RelayNode>(props: IModelTableProps<T>) {
  return <SimpleTable rowKey="id" {...props} />;
}

export default ModelTable;
