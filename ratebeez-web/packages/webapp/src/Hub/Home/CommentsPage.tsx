import React from 'react';
import { graphql } from 'react-relay/hooks';
import { Empty, Spin } from 'antd';

import { CommentsPageQuery } from '@picasso/fragments/src/CommentsPageQuery.graphql';

import {
  useCompatMutation,
  useNetworkLazyReloadQuery,
} from '@picasso/shared/src/relay/hooks';

import { useParams } from 'react-router-dom';

import _ from 'lodash';
import CommentList from 'src/Hub/Home/Comment/CommentList';
import CommentForm from 'src/Hub/Home/Comment/CommentForm';
import { CommentsPageMutation } from '@picasso/fragments/src/CommentsPageMutation.graphql';

const pageQuery = graphql`
  query CommentsPageQuery($commentableId: ID!) {
    node(id: $commentableId) {
      __typename
      ... on CommentInterface {
        comments {
          ...CommentList_comments
        }
      }
    }
    currentUser {
      id
      name
      ...CommentForm_user
    }
  }
`;

interface ICommentsPageProps {
  parentId: string;
}

function CommentsPage(props: ICommentsPageProps) {
  const [data, updateData] = useNetworkLazyReloadQuery<CommentsPageQuery>(
    pageQuery,
    {
      commentableId: props.parentId,
    }
  );

  if (!data.currentUser) {
    return null;
  }

  const node = data.node;

  if (!node || !node.comments) {
    return <Empty description="No comments available" />;
  }

  const comments = node.comments;

  const [commitComment, commitCommentIsInFlight] =
    useCompatMutation<CommentsPageMutation>(graphql`
      mutation CommentsPageMutation($input: CommentCreateUpdateInput!) {
        commentCreateUpdate(input: $input) {
          comment {
            id
            tags
            ...CommentList_comments
          }
          errors
        }
      }
    `);

  const onCommentSubmit = (values) => {
    console.log('Submitting comment', values);
    commitComment({
      variables: {
        input: {
          commentableId: props.parentId,
          tags: values.tags,
          rating: values.rating,
          richTextContent: values.richTextContent,
        },
      },
      onCompleted: (response) => {
        console.log('Comment created', response);
        updateData();
      },
      onError: (error) => {
        console.error('Error creating comment', error);
      },
    });
  };

  return (
    <div>
      <Spin spinning={commitCommentIsInFlight}>
        <CommentForm
          user={data.currentUser}
          record={null}
          showRating
          onSubmit={onCommentSubmit}
        />
      </Spin>

      <div className="mt-16">
        <CommentList comments={comments} showTags showRating />
      </div>
    </div>
  );
}

export default CommentsPage;
