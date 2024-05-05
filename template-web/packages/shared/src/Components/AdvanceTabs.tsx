import React from 'react';

import _ from 'lodash';

import motion from './motion';
import { LayoutGroup } from 'framer-motion';

import TailwindTabs, { ITailwindTab } from './TailwindTabs';

export interface IAdvanceTabProps<T> extends ITailwindTab<T> {
  render: () => JSX.Element;
}

interface IAdvanceTabsProps<T> {
  mode?: 'simple' | 'tabs';
  tabs: IAdvanceTabProps<T>[];
  selectedKey?: T;
  onChange?: (key: T) => void;
}

function AdvanceTabs<T extends string>(props: IAdvanceTabsProps<T>) {
  const tabs = props.tabs;

  const mode = props.mode || 'tabs';

  const [shift, setShift] = React.useState({
    x: 0,
    y: 0,
  });

  if (mode == 'simple') {
    if (tabs.length === 1) {
      return tabs[0].render();
    }
  }

  const [currentKey, setCurrentKey] = React.useState(
    props.selectedKey || _.first(tabs)?.key
  );

  const onChange = (newKey: T) => {
    const previousIndex = _.findIndex(tabs, (tab) => tab.key === currentKey);

    const nextIndex = _.findIndex(tabs, (tab) => tab.key === newKey);

    setShift({
      x: 100 * (nextIndex - previousIndex),
      y: 0,
    });

    setCurrentKey(newKey);
    props.onChange?.(newKey);
  };

  const current = tabs.find((tab) => tab.key === currentKey);

  return (
    <LayoutGroup>
      <TailwindTabs
        tabs={props.tabs}
        onChange={onChange}
        selectedKey={current?.key}
        className="mb-4 border-b border-dashed bg-white p-4"
      />

      <motion.shift
        motionKey={currentKey}
        values={shift}
        transition={{ duration: 0.3 }}
      >
        {current?.render()}
      </motion.shift>
    </LayoutGroup>
  );
}

export default AdvanceTabs;
