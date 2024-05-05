/** @type {import('tailwindcss').Config} */

const picassoPrimary = {
  DEFAULT: 'var(--ant-primary-color)',
  50: 'var(--ant-primary-1)',
  100: 'var(--ant-primary-1)',
  200: 'var(--ant-primary-2)',
  300: 'var(--ant-primary-3)',
  400: 'var(--ant-primary-3)',
  500: 'var(--ant-primary-4)',
  600: 'var(--ant-primary-5)',
  700: 'var(--ant-primary-5)',
  800: 'var(--ant-primary-6)',
  900: 'var(--ant-primary-7)',
};

function typographyCss(theme, name) {
  const prefix = 'colors.' + name;

  return {
    '--tw-prose-invert-pre-bg': 'rgb(0 0 0 / 50%)',
    '--tw-prose-invert-headings': theme('colors.white'),
    '--tw-prose-invert-links': theme('colors.white'),
    '--tw-prose-invert-bold': theme('colors.white'),
    '--tw-prose-invert-code': theme('colors.white'),
    '--tw-prose-body': theme(`${prefix}[900]`),
    '--tw-prose-headings': theme(`${prefix}[800]`),
    '--tw-prose-lead': theme(`${prefix}[600]`),
    '--tw-prose-links': theme(`${prefix}[700]`),
    '--tw-prose-bold': theme(`${prefix}[700]`),
    '--tw-prose-counters': theme(`${prefix}[500]`),
    '--tw-prose-bullets': theme(`${prefix}[400]`),
    '--tw-prose-hr': theme(`${prefix}[200]`),
    '--tw-prose-quotes': theme(`${prefix}[700]`),
    '--tw-prose-quote-borders': theme(`${prefix}[200]`),
    '--tw-prose-captions': theme(`${prefix}[600]`),
    '--tw-prose-code': theme(`${prefix}[700]`),
    '--tw-prose-pre-code': theme(`${prefix}[100]`),
    '--tw-prose-pre-bg': theme(`${prefix}[700]`),
    '--tw-prose-th-borders': theme(`${prefix}[200]`),
    '--tw-prose-td-borders': theme(`${prefix}[200]`),
    '--tw-prose-invert-body': theme(`${prefix}[200]`),
    '--tw-prose-invert-lead': theme(`${prefix}[200]`),
    '--tw-prose-invert-counters': theme(`${prefix}[400]`),
    '--tw-prose-invert-bullets': theme(`${prefix}[500]`),
    '--tw-prose-invert-hr': theme(`${prefix}[600]`),
    '--tw-prose-invert-quotes': theme(`${prefix}[100]`),
    '--tw-prose-invert-quote-borders': theme(`${prefix}[600]`),
    '--tw-prose-invert-captions': theme(`${prefix}[400]`),
    '--tw-prose-invert-pre-code': theme(`${prefix}[200]`),
    '--tw-prose-invert-th-borders': theme(`${prefix}[500]`),
    '--tw-prose-invert-td-borders': theme(`${prefix}[600]`),
  };
}

module.exports = {
  plugins: [require('@tailwindcss/forms'), require('@tailwindcss/typography')],
  theme: {
    listStyleType: {
      square: 'square',
      disc: 'disc',
      decimal: 'decimal',
      roman: 'upper-roman',
    },
    extend: {
      colors: {
        'picasso-primary': picassoPrimary,
      },
      typography: ({ theme }) => ({
        'picasso-primary': {
          css: typographyCss(theme, 'picasso-primary'),
        },
      }),
    },
  },
};
