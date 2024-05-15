import React, { useEffect, useState } from 'react';

import _ from 'lodash';

import { store } from './utils';

export const jsonStore = {
  get: (key: string) => {
    const value = store.get(key);
    if (!value) {
      return null;
    }

    return JSON.parse(value);
  },
  set: (key: string, value: any) => {
    store.set(key, JSON.stringify(value));
  },
};

interface JSONStore {
  [key: string]: string | number | boolean | null | symbol;
  version: number;
}

function useJsonStore<T extends JSONStore>(
  persistId: string,
  defaultValues: T
): [T, (settings: Partial<T>) => T] {
  const [values, setValues] = useState<T>(defaultValues);

  const updateValues = (updates: Partial<T>): T => {
    console.log('updateValues', updates);
    const newValues = _.merge({}, values, updates);

    if (!_.isEqual(values, newValues)) {
      setValues({
        ...newValues,
        version: values.version + 1,
      });

      jsonStore.set(persistId, newValues);
    }

    return newValues;
  };

  useEffect(() => {
    const storedValues = jsonStore.get(persistId) || {};

    updateValues(storedValues);
  }, []);
  return [values, updateValues];
}

export default useJsonStore;
