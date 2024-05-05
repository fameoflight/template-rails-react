import _ from 'lodash';

import { ColumnType } from 'antd/lib/table';

import { titlize } from '../utils';

type IFilterReturn<T> = Pick<ColumnType<T>, 'filters' | 'onFilter'>;

type KeyType<T> = keyof T | string[];

function filterColumn<T extends object>(
  records: readonly T[],
  recordKey: KeyType<T>,
  keyLabel?: (sampleRecord: T) => string | undefined
): IFilterReturn<T> {
  const key = _.isArray(recordKey)
    ? _.join(recordKey, '.')
    : _.toString(recordKey);

  const values = _.compact(_.flatten(_.uniq(_.map(records, key))));

  const labelFunc = (value: any) => {
    const record = _.find(records, (r) => _.get(r, key) === value);

    if (!record) {
      return titlize(key);
    }

    if (keyLabel?.(record)) {
      return keyLabel(record);
    }

    return titlize(_.get(record, key));
  };

  if (_.size(values) < 2) {
    return {
      filters: undefined,
      onFilter: undefined,
    };
  }

  return {
    filters: _.map(values, (value) => ({
      text: labelFunc(value),
      value: _.toString(value),
    })),
    onFilter: (value, record) =>
      _.toString(_.get(record, key)) === _.toString(value),
  };
}

const tableUtils = {
  filterColumn,
};

export default tableUtils;
