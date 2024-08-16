import React from 'react';

import _ from 'lodash';

import { DownloadOutlined } from '@ant-design/icons';
import { Button } from 'antd';

import { iconClassFromContentType } from '../utils/files/view';

export type AttachmentType = {
  url?: string | null;
  contentType?: string | null;
};

interface IAttachmentViewProps {
  name: string;
  attachment?: null | AttachmentType;
  className?: string;
}

function AttachmentView({ name, attachment, className }: IAttachmentViewProps) {
  if (!attachment?.url) {
    return null;
  }

  const isImage = attachment?.contentType?.startsWith('image/');

  if (isImage) {
    return <img className={className} src={attachment.url} alt={name} />;
  }

  const IconClass = iconClassFromContentType(attachment?.contentType);

  if (attachment) {
    return (
      <a
        href={attachment.url}
        target="_blank"
        rel="noreferrer"
        className={className}
      >
        <Button>
          <IconClass /> Download {name} <DownloadOutlined />
        </Button>
      </a>
    );
  }

  return null;
}

export default AttachmentView;
