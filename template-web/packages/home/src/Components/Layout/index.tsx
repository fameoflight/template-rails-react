import React from 'react';

import Head from 'next/head';

import motion from '@picasso/shared/src/Components/motion';

import _ from 'lodash';

import Footer from './Footer';
import Navigation from './Navigation';

function getTitle(originalTitle: string): string {
  let title = _.trim(originalTitle);

  if (title) {
    title = `${title} | Picasso`;
  } else {
    title = 'Picasso';
  }

  return title;
}

interface ILayoutProps {
  title: string;
  description?: string | null;
  children: React.ReactNode;
  image?: string;
}

function Layout(props: ILayoutProps) {
  const title = getTitle(props.title);

  const description =
    props.description || 'Picasso is the technology partner for auditors.';

  const image = props.image || '/shared/cover.png';

  return (
    <>
      <Head>
        <title>{title}</title>
        <meta name="twitter:title" content={title} />
        <meta name="twitter:description" content={description} />
        <meta property="og:title" content={title} />
        <meta property="og:description" content={description} />

        <meta name="description" content={description} />

        <meta name="twitter:image" content={image} />
        <meta property="og:image" content={image} />

        <meta name="twitter:image:alt" content={title} />
        <meta property="og:image:alt" content={title} />
      </Head>

      <div className="flex flex-col min-h-screen">
        <Navigation />

        <div className="grow min-h-[90vh]">
          {React.Children.map(props.children, (child) => (
            <motion.shift values={{ x: 0, y: 20 }}>{child}</motion.shift>
          ))}
        </div>
        <Footer />
      </div>
    </>
  );
}

export default Layout;
