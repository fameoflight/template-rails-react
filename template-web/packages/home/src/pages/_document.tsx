import React from 'react';

import { Head, Html, Main, NextScript } from 'next/document';

import tags from 'src/lib/tags';

interface DocumentProps {
  html: string;
  head: React.ReactElement[];
}

function Document(props: DocumentProps) {
  const name = 'Picasso';
  const description = `Picasso is the technology partner for auditors.`;

  const website = 'https://usepicasso.com';

  const coverImage = `${website}/shared/cover.png`;

  return (
    <Html lang="en">
      <Head>
        <meta charSet="utf-8" />
        <link rel="icon" href="/shared/favicon/favicon.ico" />
        <link rel="manifest" href="/shared/manifest.json" />
        <meta name="theme-color" content="#1677ff" />
        <meta name="description" content={description} />
        <meta name="image" content={coverImage} />

        {tags.openGraph({
          name,
          title: name,
          description,
          url: website,
          image: coverImage,
        })}

        {tags.twitterCard({
          title: name,
          url: website,
          description,
          handle: '@usepicasso',
          image: coverImage,
        })}
      </Head>
      <body className="flex h-full flex-col">
        <Main />
        <NextScript />
      </body>
    </Html>
  );
}

export default Document;
