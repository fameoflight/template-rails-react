import React, { useState } from 'react';

import _ from 'lodash';

import { RadioGroup } from '@headlessui/react';
import { CheckCircleIcon } from '@heroicons/react/24/solid';

import { classNames } from '../utils';

type RadioCardItem<T extends Recordable> = {
  label: React.ReactNode | string;
  value: T | null;
  descriptions?: string[];
};

interface IRadioCardProps<T extends Recordable> {
  label?: React.ReactNode | string;
  value?: T | null;
  className?: string;
  onChange?: (value: T) => void;
  options: RadioCardItem<T>[];
  itemClassName?: string;
}

function RadioCard<T extends Recordable>(props: IRadioCardProps<T>) {
  const onChange = (value) => {
    props.onChange?.(value);
  };

  return (
    <RadioGroup
      value={props.value}
      onChange={onChange}
      className={classNames(props.className, 'transition-all')}
    >
      {props.label && (
        <RadioGroup.Label className="text-base font-medium text-gray-900 mb-4">
          {props.label}
        </RadioGroup.Label>
      )}

      <div className="flex flex-col md:flex-row">
        {props.options.map((item) => (
          <RadioGroup.Option
            key={item.value}
            value={item.value}
            className={({ checked, active }) =>
              classNames(
                checked
                  ? 'border-picasso-primary-500 shadow'
                  : 'border-gray-200',
                `relative bg-white border shadow-sm p-4 flex cursor-pointer focus:outline-none flex-1`,
                props.itemClassName
              )
            }
          >
            {({ checked, active }) => (
              <>
                <span className="flex-1 flex">
                  <span className="flex flex-col">
                    <RadioGroup.Label
                      as="span"
                      className="block text-sm font-medium text-gray-900"
                    >
                      {item.label}
                    </RadioGroup.Label>
                    {_.map(item.descriptions, (description, idx) => (
                      <RadioGroup.Description
                        as="span"
                        key={idx}
                        className="mt-2 flex items-center text-sm text-gray-500"
                      >
                        {description}
                      </RadioGroup.Description>
                    ))}
                  </span>
                </span>
                <CheckCircleIcon
                  className={classNames(
                    !checked ? 'invisible' : 'visible',
                    'h-5 w-5 text-picasso-primary-800 ml-4'
                  )}
                  aria-hidden="true"
                />
              </>
            )}
          </RadioGroup.Option>
        ))}
      </div>
    </RadioGroup>
  );
}

export default RadioCard;
