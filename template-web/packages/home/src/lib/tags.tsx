import React from 'react';

interface ITwitterCardProps {
  title: string;
  url: string;
  description: string;
  handle: string;
  image?: string;
}

function twitterCard(props: ITwitterCardProps) {
  const imageTags = props.image
    ? [
        <meta key="twitter:image" name="twitter:image" content={props.image} />,
        <meta
          key="twitter:image:alt"
          name="twitter:image:alt"
          content={props.title}
        />,
      ]
    : [];

  return [
    <meta key="twitter:card" name="twitter:card" content="summary" />,
    <meta key="twitter:url" property="twitter:url" content={props.url} />,
    <meta key="twitter:title" name="twitter:title" content={props.title} />,
    <meta
      key="twitter:description"
      name="twitter:description"
      content={props.description}
    />,
    <meta key="twitter:site" name="twitter:site" content={props.handle} />,
    <meta
      key="twitter:creator"
      name="twitter:creator"
      content={props.handle}
    />,
    ...imageTags,
  ];
}

interface IOpenGraphProps {
  name: string;
  title: string;
  description: string;
  url: string;
  image?: string;
}

function openGraph(props: IOpenGraphProps) {
  const imageTags = props.image
    ? [
        <meta key="og:image" property="og:image" content={props.image} />,

        <meta
          key="og:image:alt"
          property="og:image:alt"
          content={props.title}
        />,
      ]
    : [];

  return [
    <meta key="og:locale" property="og:locale" content="en_US" />,
    <meta key="og:type" property="og:type" content="website" />,
    <meta key="og:site_name" property="og:site_name" content={props.name} />,
    <meta key="og:title" property="og:title" content={props.title} />,
    <meta
      key="og:description"
      property="og:description"
      content={props.description}
    />,
    <meta key="og:url" property="og:url" content={props.url} />,
    ...imageTags,
  ];
}

export default {
  openGraph,
  twitterCard,
};
