import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { ModelAttachmentView_attachment$key } from '@picasso/fragments/src/ModelAttachmentView_attachment.graphql';

import { iconClassFromContentType } from '@picasso/shared/src/utils/files/view';

import _ from 'lodash';

import moment from 'moment';

const fragmentSpec = graphql`
  fragment ModelAttachmentView_attachment on ModelAttachment {
    id
    name
    attachment {
      url
      contentType
    }
    createdAt
  }
`;

interface IModelAttachmentViewProps {
  attachment: ModelAttachmentView_attachment$key;
}

function ModelAttachmentView(props: IModelAttachmentViewProps) {
  const attachment = useFragment(fragmentSpec, props.attachment);

  if (!attachment.attachment?.url) {
    return null;
  }

  const IconClass = iconClassFromContentType(
    attachment.attachment?.contentType
  );

  return (
    <div className="shadow-sm p-4 text-center">
      <div className="p-2">
        <IconClass style={{ fontSize: '32px' }} />
      </div>

      <a href={attachment.attachment?.url} target="_blank" rel="noreferrer">
        {attachment.name}
      </a>

      <p className="text-xs text-gray-400">
        Created {moment(attachment.createdAt).fromNow()}
      </p>
    </div>
  );
}

export default ModelAttachmentView;
