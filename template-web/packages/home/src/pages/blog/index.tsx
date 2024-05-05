import React from 'react';
import { graphql } from 'react-relay/hooks';

import blogQueryRequest, {
  blogQuery,
} from '@picasso/fragments/src/blogQuery.graphql';

import _ from 'lodash';

import {
  RelayNextPage,
  getPreloadedQuery,
  usePreloadedQueryCompat,
} from 'src/lib/relay';

import PostSummary from 'src/Components/Blog/PostSummary';
import Layout from 'src/Components/Layout';

const blogPageQuery = graphql`
  query blogQuery {
    currentUser {
      id
    }
    blogPosts(status: published) {
      id
      shortId
      status
      ...PostSummary_record
    }
  }
`;

type blogNextPage = RelayNextPage<blogQuery>;

function blogPage(props: blogNextPage['props']) {
  const data = usePreloadedQueryCompat(blogPageQuery, props, 'query');

  const posts = _.filter(data.blogPosts, (post) => post.status === 'published');

  return (
    <Layout title="Blog">
      <div className="bg-white px-4 pt-16 pb-20 sm:px-6 lg:px-8 lg:pt-16 lg:pb-28">
        <div className="relative mx-auto max-w-lg divide-y-2 divide-gray-200 lg:max-w-7xl">
          <div>
            <h2 className="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
              Recent publications
            </h2>
            <p className="mt-3 text-xl text-gray-500 sm:mt-4">
              Security best practices, product updates, and more.
            </p>
          </div>

          <div className="mt-4 pt-4 grid gap-16 lg:grid-cols-3 lg:gap-x-5 lg:gap-y-12">
            {_.map(posts, (post) => (
              <PostSummary key={post.id} record={post} />
            ))}
          </div>
        </div>
      </div>
    </Layout>
  );
}

export async function getStaticProps(
  _context
): Promise<blogNextPage['getStaticProps']> {
  return {
    props: {
      preloadedQueries: {
        query: await getPreloadedQuery<blogQuery>(blogQueryRequest),
      },
    },
    revalidate: 60,
  };
}

export default blogPage;
