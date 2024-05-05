import _ from 'lodash';

import { AxiosResponse } from 'axios';

import JToker from 'j-toker';

import { isBrowser } from '../utils';

const getAuthHeaders = (): any => {
  const authHeaders = JToker.retrieveData('authHeaders');

  return authHeaders;
};

const setAuthHeaders = (authHeaders: any) =>
  JToker.persistData('authHeaders', authHeaders);

// const tokenKeys = ["access-token", "token-type", "client", "expiry", "uid"];

const buildAuthHeaders = (headers: any) => JToker.buildAuthHeaders(headers);

function updateAuthHeaders(response: AxiosResponse) {
  const accessToken = _.get(response.headers, 'access-token');

  if (!_.isEmpty(accessToken)) {
    const authHeaders = buildAuthHeaders(response.headers);

    setAuthHeaders(authHeaders);
  }
}

function setup(basePath: string) {
  if (!isBrowser()) {
    throw new Error('jTokerAuthProvider can only be used on browser');
  }

  JToker.configure({
    apiUrl: `${basePath}/api/internal`,
    storage: 'localStorage',
  });
}

const jTokerAuthProvider = {
  setup,
  getAuthHeaders,
  updateAuthHeaders,
};

export default jTokerAuthProvider;
