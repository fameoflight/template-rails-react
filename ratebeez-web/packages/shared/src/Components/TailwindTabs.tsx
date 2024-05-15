import React from 'react';

import { Select } from 'antd';

import { Variants, motion } from 'framer-motion';

export interface ITailwindTab<T> {
  key: T;
  label: React.ReactNode;
  description?: React.ReactNode | null;
}

interface ITailwindTabsProps<T> {
  tabs: ITailwindTab<T>[];
  onChange: (key: T) => void;
  className?: string;
  selectedKey?: T;
  styles?: {
    active: Variants;
    inactive: Variants;
  };
}

function TailwindTabs<T extends string>(props: ITailwindTabsProps<T>) {
  const { tabs, onChange, selectedKey, className } = props;

  const current = tabs.find((tab) => tab.key === selectedKey);

  const description = current?.description;

  const active = props.styles?.active || {
    backgroundColor: 'var(--ant-primary-color-disabled)',
    color: 'var(--ant-primary-9)',
    fontWeight: 600,
  };

  const inactive = props.styles?.inactive || {
    backgroundColor: '#fff',
    color: '#9CA3AF',
    fontWeight: 400,
  };

  const tabVariant = {
    active: {
      transition: {
        type: 'tween',
        duration: 0.3,
      },
      ...active,
    },
    inactive: {
      transition: {
        type: 'tween',
        duration: 0.3,
      },
      ...inactive,
    },
  };

  return (
    <div className={className}>
      <div className="sm:hidden">
        <Select
          id="tabs"
          className="block w-full"
          value={current?.key}
          onChange={(value) => {
            onChange(value as T);
            // onChange(e.target.value as T);
          }}
        >
          {tabs.map((tab) => (
            <Select.Option key={tab.key} value={tab.key}>
              {tab.label}
            </Select.Option>
          ))}
        </Select>
      </div>
      <div className="hidden sm:block">
        <nav className="flex space-x-4" aria-label="Tabs">
          {tabs.map((tab) => (
            <motion.div
              key={tab.key}
              onClick={() => onChange(tab.key)}
              className="px-3 py-2 font-medium text-sm rounded-md cursor-pointer transition-all"
              variants={tabVariant}
              animate={tab.key === selectedKey ? 'active' : 'inactive'}
              initial={'inactive'}
            >
              {tab.label}
            </motion.div>
          ))}
        </nav>
      </div>
      {description && <div className="text-gray-500 mt-4">{description}</div>}
    </div>
  );
}

export default TailwindTabs;
