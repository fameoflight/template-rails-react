import React from 'react';
import { graphql } from 'react-relay/hooks';

import postQueryRequest, {
  ShortIdPostQuery,
} from '@picasso/fragments/src/ShortIdPostQuery.graphql';

import ContentLayout from '@picasso/shared/src/Components/ContentLayout';
import JSONViewer from '@picasso/shared/src/Components/JSONViewer';

import _ from 'lodash';

import {
  RelayNextPage,
  getPreloadedQuery,
  usePreloadedQueryCompat,
} from 'src/lib/relay';

import PostView from 'src/Components/Blog/PostView';
import Layout from 'src/Components/Layout';
import { getStaticProps as getPosts } from 'src/pages/blog';

const postPageQuery = graphql`
  query ShortIdPostQuery($shortId: String!) {
    blogPost(shortId: $shortId) {
      id
      title
      tags
      publishedAt
      richTextContent {
        contentHtml
      }
      ...PostView_record
    }
  }
`;

type postNextPage = RelayNextPage<ShortIdPostQuery>;

function postPage(props: postNextPage['props']) {
  const data = usePreloadedQueryCompat(postPageQuery, props, 'query');

  const post = data.home.blogPost;

  if (!post) {
    return <div>Post not found</div>;
  }

  return (
    <Layout title={post.title}>
      <PostView record={post} />
    </Layout>
  );
}

export async function getStaticPaths() {
  const query = await (await getPosts({} as any)).props.preloadedQueries.query;

  const posts = query.data.home.blogPosts;

  const paths = posts.map((post) => ({
    params: { shortId: post.shortId },
  }));

  return {
    paths: paths,
    fallback: true,
  };
}

export async function getStaticProps(
  ctx
): Promise<postNextPage['getStaticProps']> {
  const shortId = ctx.params.shortId as string;
  return {
    props: {
      preloadedQueries: {
        query: await getPreloadedQuery<ShortIdPostQuery>(postQueryRequest, {
          shortId,
        }),
      },
    },
    revalidate: 60,
  };
}

export default postPage;
