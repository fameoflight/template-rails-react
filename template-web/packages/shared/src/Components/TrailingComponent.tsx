import React, { useState } from 'react';
import { Button } from 'antd';
interface ITrailingComponentProps {
  children: React.ReactNode;
  className?: string;
  disabled?: boolean;
}

function TrailingComponent(props: ITrailingComponentProps) {
  const [showMore, setShowMore] = useState(false);

  return (
    <div className={props.className}>
      <div
        className={`${props.disabled ? '' : showMore ? '' : 'line-clamp-4'}`}
      >
        {props.children}
      </div>

      {!props.disabled && (
        <Button
          onClick={() => setShowMore(!showMore)}
          type="link"
          className="p-0 mt-2"
        >
          {showMore ? 'Show Less' : 'Show More'}
        </Button>
      )}
    </div>
  );
}

export default TrailingComponent;
