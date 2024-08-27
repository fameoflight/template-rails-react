import { graphql } from 'react-relay';

import { utilsRichTextJson_value$data } from '@picasso/fragments/src/utilsRichTextJson_value.graphql';

const fragment = graphql`
  fragment utilsRichTextJson_value on RichTextJson {
    format
    content
    contentHtml
    contentMarkdown
  }
`;

export type RichTextJsonValue = Omit<
  utilsRichTextJson_value$data,
  ' $fragmentType'
>;
