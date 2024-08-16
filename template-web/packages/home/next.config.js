/* eslint-disable @typescript-eslint/no-var-requires */
/** @type {import('next').NextConfig} */

const withPlugins = require('next-compose-plugins');
const withTM = require('next-transpile-modules')([
  '@picasso/shared',
  '@picasso/fragments',
]);

const relayConfig = require('../../relay.config');

const nextConfig = {
  experimental: { images: { allowFutureImage: true } },
  compiler: {
    relay: {
      ...relayConfig,
      src: './',
    },
  },
  images: {
    domains: [
      'localhost',
      'res.cloudinary.com',
      'upload.wikimedia.org',
      'cdns.iconmonstr.com',
      'seeklogo.com',
      'cdn.worldvectorlogo.com',
      'usepicasso.s3.us-west-004.backblazeb2.com',
      'www.vectorlogo.zone',
      'cdn-icons-png.flaticon.com',
      'assets-global.website-files.com',
      'd23fqex5axu15s.cloudfront.net',
    ],
  },
  reactStrictMode: true,
  concurrentFeatures: true,
  pageExtensions: ['tsx'],
};

module.exports = withPlugins([withTM], nextConfig);
