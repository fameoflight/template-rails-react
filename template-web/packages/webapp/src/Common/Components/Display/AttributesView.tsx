import React from 'react';

import _ from 'lodash';

type ValueType = string | number | boolean | null | React.ReactNode;

interface AttributeValueType {
  key: string | number;
  label: string;
  value: ValueType;
}

interface AttributeValuesType {
  key: string | number;
  label: string;
  values: ValueType[];
}

interface IAttributesViewProps {
  attributes: (AttributeValueType | AttributeValuesType)[];
  strip?: boolean;
}

const attributeValues = (
  attribute: AttributeValueType | AttributeValuesType
) => {
  if ('values' in attribute) {
    return attribute.values;
  }
  if (attribute.value) {
    return [attribute.value];
  }
  return null;
};

function AttributeView(props: {
  attribute: AttributeValueType | AttributeValuesType;
}) {
  const values = _.compact(attributeValues(props.attribute));

  const size = values ? values.length : 0;

  return (
    <div className="py-4 flex flex-col sm:flex-row space-x-2 items-center align-middle">
      <dt className="text-sm font-medium text-gray-500 flex-1">
        {props.attribute.label}
      </dt>
      {_.range(size).map((idx) => (
        <dd className="flex-1" key={idx}>
          {values?.[idx]}
        </dd>
      ))}
    </div>
  );
}

function AttributesView(props: IAttributesViewProps) {
  return (
    <dl className="sm:divide-y sm:divide-gray-200 px-4">
      {_.map(props.attributes, (attribute, idx) => {
        if (props.strip) {
          if (!attributeValues(attribute)) {
            return null;
          }
        }

        return <AttributeView key={idx} attribute={attribute} />;
      })}
    </dl>
  );
}

export default AttributesView;
