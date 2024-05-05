import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { CommentView_comment$key } from '@picasso/fragments/src/CommentView_comment.graphql';

import _ from 'lodash';

import { Rate, Tag } from 'antd';
import RichTextEditor from '@picasso/shared/src/RichTextEditor';

const fragmentSpec = graphql`
  fragment CommentView_comment on Comment {
    id
    tags
    rating
    richTextContent {
      content
      contentHtml
      format
    }
    createdAt
  }
`;

interface ICommentViewProps {
  comment: CommentView_comment$key;
  showTags: boolean;
  showRating: boolean;
}

const CommentView = (props: ICommentViewProps) => {
  const comment = useFragment(fragmentSpec, props.comment);

  const showTags = props.showTags && !_.isEmpty(comment.tags);

  const showRating = props.showRating && _.toNumber(comment.rating) > 0;

  return (
    <div className="flex flex-col space-y-2">
      {showRating && (
        <Rate disabled allowHalf value={_.toNumber(comment.rating)} />
      )}

      <div key={comment.id}>
        <RichTextEditor
          initialContent={comment.richTextContent.content}
          readOnly
        />
      </div>

      {showTags && (
        <div className="space-x">
          {_.map(comment.tags, (tag) => (
            <Tag key={tag} color="blue">
              {tag}
            </Tag>
          ))}
        </div>
      )}
    </div>
  );
};

export default CommentView;
