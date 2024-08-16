import React from 'react';
import ReactDOM from 'react-dom/client';

import AppRoot from './App/AppRoot';

const reactRoot = document.getElementById('react-root');

if (reactRoot) {
  ReactDOM.createRoot(reactRoot).render(<AppRoot />);
} else {
  alert('React root element not found');
}
