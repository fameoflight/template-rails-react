/* eslint-disable @typescript-eslint/no-var-requires */
/** @type {import('tailwindcss').Config} */

const baseConfig = require('../../tailwind.config.js');

module.exports = {
  content: ['./src/**/*.{js,jsx,ts,tsx}', '../shared/src/**/*.{js,jsx,ts,tsx}'],
  plugins: baseConfig.plugins,
  theme: baseConfig.theme,
};
