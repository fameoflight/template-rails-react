import _ from 'lodash';

import moment from 'moment';

function stringPathComparator<T>(a: T, b: T, path: string | string[]): number {
  const val1 = _.toString(_.get(a, path, ''));
  const val2 = _.toString(_.get(b, path, ''));

  return val1.localeCompare(val2);
}

function datePathComparator<T>(a: T, b: T, path: string | string[]): number {
  const val1 = moment(_.get(a, path)).utc().seconds();
  const val2 = moment(_.get(b, path)).utc().seconds();

  return val1 - val2;
}

const pathComparators = {
  string: stringPathComparator,
  date: datePathComparator,
};

export default {
  path: pathComparators,
};
