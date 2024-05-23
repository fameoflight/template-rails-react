import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { PostSummary_record$key } from '@picasso/fragments/src/PostSummary_record.graphql';

import _ from 'lodash';

import { Tag } from 'antd';

import Link from 'src/Components/Link';

const fragmentSpec = graphql`
  fragment PostSummary_record on BlogPost {
    id
    title
    shortId
    summary
    publishedAt
    category {
      id
      name
      color
    }
  }
`;

interface IPostSummaryProps {
  record: PostSummary_record$key;
}

function PostSummary(props: IPostSummaryProps) {
  const post = useFragment(fragmentSpec, props.record);

  const postLink = `/blog/posts/${post.shortId}`;

  return (
    <div
      key={post.id}
      className="flex flex-col overflow-hidden shadow p-6 bg-white"
    >
      <div className="flex-1">
        <Tag className="text-sm font-medium" color={post.category.color}>
          {post.category.name}
        </Tag>

        <Link to={postLink} className="mt-2 block">
          <p className="text-xl font-semibold text-gray-900">{post.title}</p>
          <p className="mt-3 text-base text-gray-500 text-ellipse overflow-hidden">
            {post.summary}
          </p>
        </Link>
      </div>

      <div className="mt-3">
        <Link
          to={postLink}
          className="text-base font-semibold text-picasso-primary-800 hover:text-picasso-primary-700"
        >
          Read full story
        </Link>
      </div>
    </div>
  );
}

export default PostSummary;
