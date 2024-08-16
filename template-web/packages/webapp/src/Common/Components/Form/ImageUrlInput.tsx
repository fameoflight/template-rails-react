import React, { useEffect, useState } from 'react';

import _ from 'lodash';

import { Input, InputProps } from 'antd';

function ImageUrlInput(props: InputProps) {
  const { value, onChange, ...inputProps } = props;

  const [changedValue, setChangedValue] = useState<any>(value);

  useEffect(() => {
    setChangedValue(value);
  }, [value]);

  const [imageError, setImageError] = useState(false);

  const onValueChange = (newValue) => {
    setImageError(false);

    if (_.isEmpty(newValue)) {
      setChangedValue(null);
      onChange?.(null as any);
    } else {
      setChangedValue(newValue);
    }
  };

  const onImageError = (e) => {
    setImageError(true);
    console.error('Image Error', e.target.src);
  };

  const onImageLoaded = (e) => {
    setImageError(false);
    onChange?.(e.target.src);
  };

  return (
    <span className="w-full">
      <Input
        value={changedValue}
        onChange={(e) => onValueChange(_.trim(_.toString(e.target.value)))}
        {...inputProps}
      />

      {imageError ? (
        <div className="text-red-700 mt-1">Invalid icon url</div>
      ) : null}

      {changedValue && !imageError ? (
        <img
          className="h-12 mt-4 object-fit"
          src={changedValue}
          onError={onImageError}
          onLoad={onImageLoaded}
          alt="input image url"
        />
      ) : null}
    </span>
  );
}

export default ImageUrlInput;
