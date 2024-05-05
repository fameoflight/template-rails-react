import ModelTable from './ModelTable';
import SimpleTable from './SimpleTable';

import { ActionItemType, ITableWithActions } from './actions';
import comparators from './comparators';
import tableUtils from './tableUtils';

export type { ActionItemType, ITableWithActions };

export default {
  utils: tableUtils,
  Model: ModelTable,
  Simple: SimpleTable,
  comparators,
};
