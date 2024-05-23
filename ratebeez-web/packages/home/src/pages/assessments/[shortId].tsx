import React, { useState } from 'react';
import { graphql } from 'react-relay/hooks';

import { event } from 'nextjs-google-analytics';

import assessmentQueryRequest, {
  ShortIdAssessmentQuery,
} from '@picasso/fragments/src/ShortIdAssessmentQuery.graphql';

import ErrorPage from '@picasso/shared/src/Components/ErrorPage';

import _ from 'lodash';

import {
  RelayNextPage,
  getPreloadedQuery,
  usePreloadedQueryCompat,
} from 'src/lib/relay';

import AssessmentTemplateForm from 'src/Components/Assessments/AssessmentTemplateForm';
import Layout from 'src/Components/Layout';
import { getStaticProps as getAssessments } from 'src/pages/assessments';

const assessmentPageQuery = graphql`
  query ShortIdAssessmentQuery($shortId: String!) {
    home {
      assessmentTemplate(shortId: $shortId) {
        id
        name
        description
        ...AssessmentTemplateForm_record
      }
    }
  }
`;

type assessmentNextPage = RelayNextPage<ShortIdAssessmentQuery>;

function assessmentPage(props: assessmentNextPage['props']) {
  const data = usePreloadedQueryCompat(assessmentPageQuery, props, 'query');
  const template = data.home.assessmentTemplate;

  if (!template) {
    return <ErrorPage errors={['Something went wrong']} />;
  }

  return (
    <Layout title={template.name} description={template.description}>
      <div className="max-w-7xl mx-auto p-4">
        <div className="flex-1">
          <h1 className="text-picasso-primary-800 text-2xl">{template.name}</h1>

          <p className="text-picasso-primary-900 mb-8">
            {template.description}
          </p>

          <AssessmentTemplateForm record={template} />
        </div>
      </div>
    </Layout>
  );
}

export async function getStaticPaths() {
  const query = await (
    await getAssessments({} as any)
  ).props.preloadedQueries.query;

  const templates = query.data.home.assessmentTemplates;

  const paths = templates.map((template) => ({
    params: { shortId: template.shortId },
  }));

  return {
    paths: paths,
    fallback: 'blocking',
  };
}

export async function getStaticProps(
  ctx: any
): Promise<assessmentNextPage['getStaticProps']> {
  const shortId = ctx.params.shortId as string;

  return {
    props: {
      preloadedQueries: {
        query: await getPreloadedQuery<ShortIdAssessmentQuery>(
          assessmentQueryRequest,
          {
            shortId,
          }
        ),
      },
    },
  };
}

export default assessmentPage;
