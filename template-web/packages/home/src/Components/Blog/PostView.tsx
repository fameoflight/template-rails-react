import React from 'react';
import { graphql, useFragment } from 'react-relay/hooks';

import { PostView_record$key } from '@picasso/fragments/src/PostView_record.graphql';

import { POST_DEFAULT_CLASSNAME } from '@picasso/shared/src/Components/PostRichTextWrapper';
import { classNames } from '@picasso/shared/src/utils';

import _ from 'lodash';

import { motion, useScroll, useSpring } from 'framer-motion';
import RichTextJsonView from '@picasso/shared/src/RichTextEditor/RichTextJsonView';

const fragmentSpec = graphql`
  fragment PostView_record on BlogPost {
    id
    title
    publishedAt
    richTextContent {
      content
      contentHtml
      format
    }
  }
`;

interface IPostViewProps {
  record: PostView_record$key;
}

interface IContentViewProps {
  children: React.ReactNode;
}

function ContentView(props: IContentViewProps) {
  return (
    <div className="relative overflow-hidden bg-white py-16">
      <div className="relative px-4 sm:px-6 lg:px-8">{props.children}</div>
    </div>
  );
}

function PostView(props: IPostViewProps) {
  const record = useFragment(fragmentSpec, props.record);
  const { scrollYProgress } = useScroll();
  const scaleX = useSpring(scrollYProgress, {
    stiffness: 100,
    damping: 30,
    restDelta: 0.001,
  });

  return (
    <div>
      <div className="items-start fixed top-0 left-0 right-0 z-10 w-screen">
        <motion.div
          className="h-[8px] bg-picasso-primary-500"
          style={{ scaleX: scaleX }}
        />
      </div>

      <ContentView>
        <div className="mx-auto max-w-5xl text-lg">
          <h1>
            {/* <span className="block text-center text-lg font-semibold text-picasso-primary-800">
              {record.category.name}
            </span> */}
            <span className="mt-2 block text-center text-3xl font-bold leading-8 tracking-tight text-gray-900 sm:text-4xl">
              {record.title}
            </span>
          </h1>
          {/* <p className="mt-8 text-xl leading-8 text-gray-500">
            {record.summary}
          </p> */}

          <RichTextJsonView
            className={classNames(
              POST_DEFAULT_CLASSNAME,
              'max-w-7xl mx-auto mt-16'
            )}
            value={record.richTextContent}
          />
        </div>
      </ContentView>
    </div>
  );
}

export default PostView;
