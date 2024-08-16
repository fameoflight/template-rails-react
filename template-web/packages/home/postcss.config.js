module.exports = {
  plugins: {
    'tailwindcss/nesting': {},
    tailwindcss: {},
    autoprefixer: {},
    'postcss-focus-visible': {
      replaceWith: '[data-focus-visible-added]',
    },
  },
};
