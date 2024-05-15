/** @type {import('vite').UserConfig} */
import basicSsl from '@vitejs/plugin-basic-ssl';
import react from '@vitejs/plugin-react';

import path from 'path';
import { defineConfig } from 'vite';
import relay from 'vite-plugin-relay';

const https = process.env.HTTPS === 'true';

export default defineConfig({
  clearScreen: false,
  define: {
    'process.env': {
      NODE_ENV: JSON.stringify(process.env.NODE_ENV),
    },
  },
  server: {
    port: 3000,
    strictPort: true,
    open: false,
    https: https,
  },
  resolve: {
    alias: {
      src: path.resolve(__dirname, 'src'),
    },
  },
  build: {
    sourcemap: false,
    rollupOptions: {
      output: {
        manualChunks: {
          shared: ['@picasso/shared'],
          framer: ['framer-motion'],
          fragments: ['@picasso/fragments'],
          antdicons: ['@ant-design/icons'],
          antd: ['antd', 'rc-select'],
          editor: ['lexical'],
          password: ['antd-password-input-strength'],
          sortable: ['react-sortable-hoc', 'array-move'],
          signature: ['react-signature-canvas'],
          pdf: ['html2pdf.js'],
          moment: ['moment'],
          misc: [
            'antd-colorpicker',
            'react-copy-to-clipboard',
            'react-plaid-link',
            'react-qr-code',
          ],
        },
      },
    },
  },
  plugins: [react(), relay, https && basicSsl()],
});
