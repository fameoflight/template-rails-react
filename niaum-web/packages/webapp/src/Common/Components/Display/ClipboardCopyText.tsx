import React, { useState } from 'react';
import CopyToClipboard from 'react-copy-to-clipboard';

import { classNames } from '@picasso/shared/src/utils';

import { CheckSquareTwoTone, CopyTwoTone } from '@ant-design/icons';
import { Tooltip, notification } from 'antd';

interface IClipboardCopyTextProps {
  text: string;
  className?: string;
  textClassName?: string;
}

function ClipboardCopyText(props: IClipboardCopyTextProps) {
  const [copied, setCopied] = useState(false);

  const onCopyClick = () => {
    setCopied(true);

    notification.success({
      message: 'Copied to clipboard',
      onClose: () => {
        setCopied(false);
      },
    });
  };

  const copyIcon = copied ? (
    <CheckSquareTwoTone twoToneColor="#52c41a" />
  ) : (
    <CopyTwoTone />
  );

  return (
    <div className={classNames('flex', props.className)}>
      <span className={classNames('mr-2 flex-1', props.textClassName)}>
        {props.text}
      </span>
      <CopyToClipboard text={props.text} onCopy={onCopyClick}>
        <Tooltip title="Copy to clipboard" color="blue">
          {copyIcon}
        </Tooltip>
      </CopyToClipboard>
    </div>
  );
}

export default ClipboardCopyText;
