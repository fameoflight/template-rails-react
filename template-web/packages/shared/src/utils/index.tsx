import _ from 'lodash';

export const DATE_FORMAT = 'MM/DD/YYYY';
export const DATE_TIME_FORMAT = `${DATE_FORMAT} HH:mm ZZ`;

export const US_DATE_FORMAT = 'MM/DD/YYYY';
export const US_DATE_TIME_FORMAT = `${US_DATE_FORMAT} LT`;

export const DEFAULT_DATE = '2019-01-01';

export const ISO8601_DATE_FORMAT = 'YYYY-MM-DD';

export const ISO8601_DATE_TIME_FORMAT = 'YYYY-MM-DDThh:mm:ssTZD';

export const tagColors = [
  'magenta',
  'red',
  'volcano',
  'orange',
  'gold',
  'lime',
  'green',
  'cyan',
  'blue',
  'geekblue',
  'purple',
];

export function getComponentClass(
  prefix: string,
  size?: any,
  className?: string
) {
  const sizeClassNameMap = {
    small: `${prefix}-sm`,
    default: null,
    large: `${prefix}-lg`,
  };

  const componentSize = size || 'default';

  const classes = _.compact([
    prefix,
    sizeClassNameMap[componentSize],
    className,
  ]);

  return _.join(classes, ' ');
}

export const downloadFile = (fileName: string, content: string) => {
  const link = document.createElement('a');
  link.setAttribute('href', encodeURI(content));
  link.setAttribute('style', 'visibility:hidden');
  link.setAttribute('download', fileName);

  // this part will append the anchor tag and remove it after automatic click
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};

interface IConnectionData<T> {
  edges: {
    node: T;
  }[];
}

export function extractNodes<T>(data: IConnectionData<T>): T[] {
  return _.map(_.get(data, 'edges'), (edge) => edge.node);
}

export function titlize(value: string): string {
  return _.startCase(_.camelCase(_.toString(value)));
}

export function classNames(...classes) {
  return classes.filter(Boolean).join(' ');
}

export function invariant(cond: any, message: string): asserts cond {
  if (!cond) throw new Error(message);
}

export const findAllByKey = (object: object, searchKey: string): any[] => {
  const result: any[] = [];

  _.map(object, (value, key) => {
    if (key === searchKey) {
      result.push(value);
    } else if (_.isObjectLike(value)) {
      _.each(findAllByKey(value, searchKey), (r) => result.push(r));
    }
  });

  return _.flatten(result);
};

export function getFileBase64(file: File): Promise<string | ArrayBuffer> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result as any);
    reader.onerror = (error) => reject(error);
  });
}

export function trimSuffix(toTrim: string, trim: string): string {
  if (!toTrim || !trim) {
    return toTrim;
  }
  const index = toTrim.lastIndexOf(trim);
  if (index === -1 || index + trim.length !== toTrim.length) {
    return toTrim;
  }
  return toTrim.substring(0, index);
}

// trimPrefix('abc', 'ab') -> 'c'
export function trimPrefix(toTrim: string, trim: string): string {
  if (!toTrim || !trim) {
    return toTrim;
  }
  const index = toTrim.indexOf(trim);
  if (index !== 0) {
    return toTrim;
  }
  return toTrim.substring(trim.length);
}

type MenuItem<T> = {
  key: T;
};
function matchingMenuItems<T>(items: MenuItem<T>[], path: string) {
  return _.filter(items, (item) => _.endsWith(path, _.toString(item?.key)));
}

export function matchingKeys<T>(items: MenuItem<T>[], path: string): T[] {
  return _.map(matchingMenuItems(items, path), 'key');
}

type Mutable<T> = {
  -readonly [P in keyof T]: T[P];
};

export type DeepMutable<T> = {
  -readonly [key in keyof T]: DeepMutable<T[key]>;
};

export function writeable<T>(value: T): DeepMutable<T> {
  return _.cloneDeep(value);
}

type UnionType = {
  __typename: string;
};

export function simplifyUnion<T extends UnionType | null>(value: T) {
  /* eslint-disable no-underscore-dangle */
  if (value?.__typename === '%other') {
    return null;
  }

  return value;
}

export function searchParams() {
  return new URLSearchParams(window.location.search);
}

export const SELECT_MULTIPLE_OPTION_SEPARATOR = ',';

export function split(value: string): string[] {
  return _.filter(
    _.split(value, SELECT_MULTIPLE_OPTION_SEPARATOR),
    (value) => !_.isEmpty(value)
  );
}

export function join(value: string[]): string {
  return _.join(value, SELECT_MULTIPLE_OPTION_SEPARATOR);
}

export const store = {
  get: (key: string) => {
    if (!isBrowser()) {
      console.warn('Cannot get store value in server side');
      return null;
    }

    return window.localStorage.getItem(key);
  },
  set: (key: string, value: string) => {
    if (!isBrowser()) {
      console.warn('Cannot set store value in server side');
      return;
    }

    window.localStorage.setItem(key, value);
  },
};

export function tailwindColorClass(color: TailwindColor, inverse?: boolean) {
  if (inverse) {
    return `bg-${color}-500 text-white`;
  }

  return `bg-white text-${color}-500`;
}

export function randomString(
  length: number,
  characters?: string,
  wordLength?: number
) {
  const DEFAULT_WORD_LENGTH = 5;
  const chars =
    characters ||
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  let result = '';

  while (result.length < length) {
    const randomWord = _.times(wordLength || DEFAULT_WORD_LENGTH, () => {
      return chars.charAt(Math.floor(Math.random() * chars.length));
    }).join('');

    result += `${randomWord} `;
  }

  return result;
}

export function randomShortId(length: number) {
  return Math.random()
    .toString(36)
    .substring(2, length + 2);
}

export function printHostNames(urls: (string | null)[]) {
  const hostnames = _.uniq(
    _.compact(
      _.map(urls, (url) => {
        if (url) {
          const { hostname } = new URL(url);
          return hostname;
        }

        return null;
      })
    )
  );

  const printableHostnames = _.join(
    _.map(hostnames, (hostname) => `"${hostname}"`),
    ', '
  );

  return printableHostnames;
}

export function isBrowser() {
  return typeof window !== 'undefined';
}

export function downloadBlob(blob: Blob, fileName: string) {
  const url = URL.createObjectURL(blob);

  const link = document.createElement('a');
  link.href = url;
  link.download = fileName;

  document.body.appendChild(link);

  link.click();

  document.body.removeChild(link);
}

export function fileToLines(file: File) {
  return new Promise<string[]>((resolve, reject) => {
    const reader = new FileReader();

    reader.onload = (e) => {
      const content = e.target?.result?.toString() || '';

      const lines = _.filter(
        content.split('\n'),
        (line) => !_.isEmpty(_.trim(line))
      );

      const firstLine = _.first(lines);

      // csv file sometime has a BOM at the beginning
      if (firstLine?.startsWith('\ufeff')) {
        lines[0] = firstLine.substring(1);
      }

      resolve(lines);
    };

    reader.onerror = (e) => {
      reject(e);
    };

    reader.readAsText(file);
  });
}

export const SHORT_ID_REGEX = /^[-a-z0-9_.]*$/;
