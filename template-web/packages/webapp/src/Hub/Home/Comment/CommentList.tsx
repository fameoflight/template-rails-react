import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import {
  CommentList_comments$data,
  CommentList_comments$key,
} from '@picasso/fragments/src/CommentList_comments.graphql';

import _ from 'lodash';

import { Avatar, Timeline } from 'antd';

import DateView from 'src/Common/Components/Display/DateView';
import VersionItemView, {
  getActionVerb,
} from 'src/Common/Components/Version/VersionItemView';

import CommentView from './CommentView';

type CommentType = CommentList_comments$data[0];

const commentFragmentSpec = graphql`
  fragment CommentList_comments on Comment @relay(plural: true) {
    __typename
    id
    user {
      name
      avatar {
        url
      }
    }
    createdAt
    ...CommentView_comment
  }
`;

interface ICommentListProps {
  comments: CommentList_comments$key;
  className?: string;
  showTags: boolean;
  showRating: boolean;
}

function TimeLineItem(props: {
  item: CommentType;
  showTags: boolean;
  showRating: boolean;
}) {
  const item = props.item;

  if (!item.user) {
    return null;
  }

  const dot = item.user ? (
    <Avatar
      src={item.user.avatar?.url}
      size={18}
      style={{ color: '#1677ff', backgroundColor: '#D0E8FF' }}
    >
      {item.user.name?.[0]}
    </Avatar>
  ) : null;

  const userName = item.user?.name || 'Unknown User';

  let verb = 'Unknown';

  if (item.__typename === 'Comment') {
    verb = 'Commented';
  }

  return (
    <Timeline.Item className="bg-none" dot={dot}>
      <div className="ml-2">
        <div className="text-sm text-gray-500 mb-2">
          {`${userName} ${verb} at `} <DateView value={item.createdAt} />
        </div>

        {item.__typename === 'Comment' && (
          <CommentView
            comment={item}
            showTags={props.showTags}
            showRating={props.showRating}
          />
        )}
      </div>
    </Timeline.Item>
  );
}

const CommentList = (props: ICommentListProps) => {
  const comments = useFragment(commentFragmentSpec, props.comments);

  const items: Array<CommentType> = React.useMemo(() => {
    return _.sortBy([...comments], 'createdAt');
  }, [comments]);

  return (
    <Timeline className={`mx-4 ${props.className}`}>
      {_.map(items, (item) => {
        return (
          <TimeLineItem
            key={item.id}
            item={item}
            showTags={props.showTags}
            showRating={props.showRating}
          />
        );
      })}
    </Timeline>
  );
};

export default CommentList;
