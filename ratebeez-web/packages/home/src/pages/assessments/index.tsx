import React from 'react';
import { graphql } from 'react-relay/hooks';

import assessmentsQueryRequest, {
  assessmentsQuery,
} from '@picasso/fragments/src/assessmentsQuery.graphql';

import TailwindList from '@picasso/shared/src/Components/TailwindList';

import _ from 'lodash';

import { List } from 'antd';

import {
  RelayNextPage,
  getPreloadedQuery,
  usePreloadedQueryCompat,
} from 'src/lib/relay';

import Layout from 'src/Components/Layout';
import Link from 'src/Components/Link';

const assessmentsPageQuery = graphql`
  query assessmentsQuery {
    home {
      assessmentTemplates {
        id
        name
        shortId
        description
      }
    }
  }
`;

type assessmentsNextPage = RelayNextPage<assessmentsQuery>;

function assessmentsPage(props: assessmentsNextPage['props']) {
  const data = usePreloadedQueryCompat(assessmentsPageQuery, props, 'query');

  const listItems = data.home.assessmentTemplates.map((item) => ({
    link: `/assessments/${item.shortId}`,
    title: item.name,
    description: item.description || '',
  }));

  return (
    <Layout title="Assessments">
      <div className="p-4 max-w-7xl mx-auto mt-4">
        <List
          header="Assessments"
          dataSource={listItems}
          renderItem={(item) => (
            <List.Item>
              <List.Item.Meta
                title={
                  <a>
                    <Link to={item.link}>{item.title}</Link>
                  </a>
                }
                description={item.description}
              />
            </List.Item>
          )}
        />
      </div>
    </Layout>
  );
}

export async function getStaticProps(
  _context
): Promise<assessmentsNextPage['getStaticProps']> {
  return {
    props: {
      preloadedQueries: {
        query: await getPreloadedQuery<assessmentsQuery>(
          assessmentsQueryRequest
        ),
      },
    },
  };
}

export default assessmentsPage;
