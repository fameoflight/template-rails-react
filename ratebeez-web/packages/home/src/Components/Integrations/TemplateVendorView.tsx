import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import Image from 'next/future/image';

import { TemplateVendorView_record$key } from '@picasso/fragments/src/TemplateVendorView_record.graphql';

import { classNames } from '@picasso/shared/src/utils';

import _ from 'lodash';

const fragmentSpec = graphql`
  fragment TemplateVendorView_record on TemplatesVendor {
    id
    name
    shortId
    iconUrl
  }
`;

interface ITemplateVendorViewProps {
  record: TemplateVendorView_record$key;
  className?: string;
}

export function isValid(record: TemplateVendorView_record$key) {
  const template = useFragment(fragmentSpec, record);

  if (_.isEmpty(template.iconUrl) || _.isEmpty(template.shortId)) {
    return false;
  }

  return true;
}

function TemplateVendorView(props: ITemplateVendorViewProps) {
  const template = useFragment(fragmentSpec, props.record);

  if (!isValid(props.record)) {
    return null;
  }

  return (
    <div
      key={template.id}
      className={classNames(
        'col-span-1 flex justify-center py-8 px-8 ',
        props.className
      )}
    >
      <div className="flex flex-col items-center">
        <Image
          src={template.iconUrl || ''}
          alt={template.name}
          className="w-14 h-14 object-contain"
        />
        <div className="text-center mt-4">
          <h3 className="text-sm text-gray-700">{template.name}</h3>
        </div>
      </div>
    </div>
  );
}

export default TemplateVendorView;
