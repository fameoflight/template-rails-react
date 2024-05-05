import _ from 'lodash';

import jTokerAuthProvider from './jTokerAuthProvider';
import requestsFactory from './requestFactory';

import { isBrowser } from '../utils';

const PRODUCTION_BASE_PATH = 'https://api.usepicasso.com';

const DEVELOPMENT_BASE_PATH = 'http://localhost:5001';

const isProduction = process.env.NODE_ENV === 'production';

let ENV_BASE_PATH = process.env.BASE_PATH;

const setBasePath = (path: string) => {
  // verify that the path is a valid URL
  try {
    new URL(path);
  } catch (e) {
    throw new Error(`Invalid BASE_PATH: ${path}`);
  }

  ENV_BASE_PATH = path;
};

const { getAuthHeaders, updateAuthHeaders } = jTokerAuthProvider;

const basePath = () => {
  if (ENV_BASE_PATH) {
    return ENV_BASE_PATH;
  }

  const defaultPath = isProduction
    ? PRODUCTION_BASE_PATH
    : DEVELOPMENT_BASE_PATH;

  if (isBrowser()) {
    if (window.location.hostname === 'localhost') {
      return DEVELOPMENT_BASE_PATH;
    }
    return PRODUCTION_BASE_PATH;
  } else {
    // we are on server

    return defaultPath;
  }
};

export type RequestFactoryInstance = ReturnType<typeof requestsFactory>;

function browserRequestClient(): RequestFactoryInstance {
  function authHeaders() {
    const authHeaders = _.merge(getAuthHeaders(), {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    });

    return authHeaders;
  }

  return requestsFactory({
    baseURL: basePath(),
    requestHeaders: authHeaders(),
    retries: 0,
    cache: {
      maxAge: 0,
    },
    callbacks: {
      onSuccess: (response) => {
        updateAuthHeaders(response);
      },
    },
  });
}

function serverRequestClient(): RequestFactoryInstance {
  return requestsFactory({
    baseURL: basePath(),
    requestHeaders: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
    retries: 0,
    cache: {
      maxAge: 0,
    },
  });
}

function apiInstance(kind: 'server' | 'browser') {
  if (kind === 'server') {
    return serverRequestClient();
  }

  return browserRequestClient();
}

export default {
  basePath,
  setBasePath,
  apiInstance,
  browserRequestClient,
  serverRequestClient,
  updateAuthHeaders,
};
