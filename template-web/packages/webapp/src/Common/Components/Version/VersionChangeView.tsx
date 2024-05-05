import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { VersionChangeView_records$key } from '@picasso/fragments/src/VersionChangeView_records.graphql';

import { titlize } from '@picasso/shared/src/utils';

import _ from 'lodash';

import AttributesView from 'src/Common/Components/Display/AttributesView';

const fragmentSpec = graphql`
  fragment VersionChangeView_records on VersionChange @relay(plural: true) {
    label
    previousValue
    newValue
  }
`;

interface IVersionChangeViewProps {
  records: VersionChangeView_records$key;
  skippedKeys?: string[];
}

function VersionChangeView(props: IVersionChangeViewProps) {
  const records = useFragment(fragmentSpec, props.records);

  const skippedKeys = props.skippedKeys || [];

  const attributes = _.compact(
    _.map(records, (change) => {
      if (skippedKeys.includes(change.label)) {
        return null;
      }
      return {
        key: change.label,
        label: titlize(change.label),
        value: (
          <div className="px-4">
            <span className="mx-2">Old: {change.previousValue}</span>
            <span className="mx-2">New: {change.newValue}</span>
          </div>
        ),
      };
    })
  );
  return (
    <div className="max-w-fit	overflow-x-auto px-4">
      <AttributesView attributes={attributes} />
    </div>
  );
}

export default VersionChangeView;
