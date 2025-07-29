import _ from 'lodash';

import axios, { AxiosInstance } from 'axios';

import axiosRetry from 'axios-retry';

export interface IRequestGetProps {
  endpoint: string;
  params?: { [key: string]: string | number | boolean | undefined | null };
  responseType?: 'json' | 'text' | 'arraybuffer';
  headers?: { [key: string]: string };
}

export interface IRequestPostProps extends IRequestGetProps {
  data?: string | any;
}

type MethodType = 'get' | 'post' | 'put' | 'delete' | 'patch';

export interface IMakeRequestProps extends IRequestPostProps {
  method: MethodType;
}

interface IRequestsFactoryProps {
  baseURL: string | unknown;
  requestHeaders: any;
  retries?: number;
  callbacks?: {
    onStart?: () => void;
    onSuccess?: (response: any) => void;
    onError?: (response: any) => void;
  };
  cache?: {
    maxAge: number;
  };
}
const requestsFactory = (requestsFactoryOptions: IRequestsFactoryProps) => {
  const { callbacks, retries, baseURL, requestHeaders, cache } =
    requestsFactoryOptions;

  const cacheAdapter: any = null;

  // if (cache) {
  //   cacheAdapter = setupCache({
  //     maxAge: cache.maxAge,
  //   }).adapter;
  // }

  const client = axios.create({
    adapter: cacheAdapter,
  });

  if (retries) {
    axiosRetry(client as any, {
      retries,
      retryDelay: (retryCount) => retryCount * 1500,
    });
  }

  const dictToURI = (dict?: any) =>
    _.join(
      _.map(
        dict,
        (v, k) => `${encodeURIComponent(k)}=${encodeURIComponent(v)}`
      ),
      '&'
    );

  const axiosOptions = async (overrides: any) => {
    const resolvedHeaders = await Promise.resolve(requestHeaders);

    const resolvedBaseUrl = await Promise.resolve(baseURL);

    // Merge custom headers with default headers
    const customHeaders = overrides.headers || {};
    const headers = _.merge({}, resolvedHeaders, customHeaders);

    const defaults = {
      method: 'post',
      timeout: 30000,
      responseType: 'json',
      crossdomain: true,
      headers,
      baseURL: resolvedBaseUrl,
    };

    return _.merge(defaults, _.omit(overrides, 'headers'));
  };

  /**
   * Request Wrapper with default success/error actions
   */

  const axiosWrapper = (axiosClient: AxiosInstance, options: any) => {
    if (callbacks && callbacks.onStart) {
      callbacks.onStart();
    }

    const onSuccess = (response: any) => {
      if (callbacks && callbacks.onSuccess) {
        callbacks.onSuccess(response);
      }

      return response;
    };

    const onError = (response: any) => {
      if (callbacks && callbacks.onError) {
        callbacks.onError(response);
      }

      console.error('Request Failed:', response); // tslint:disable-line

      if (_.get(response, 'response')) {
        // Request was made but server responded with something
        // other than 2xx
        console.error('Status:', _.get(response, 'response.status')); // tslint:disable-line
        console.error('Data:', _.get(response, 'response.data')); // tslint:disable-line
        console.error('Headers:', _.get(response, 'response.headers')); // tslint:disable-line
      }

      return Promise.reject(response);
    };

    return axiosClient(options).then(onSuccess).catch(onError);
  };

  const doRequest = async (
    method: MethodType,
    options: IRequestGetProps | IRequestPostProps
  ) => {
    let url = options.endpoint;

    if (!_.isEmpty(options.params)) {
      url += `?${dictToURI(options.params)}`;
    }

    const data = _.get(options, 'data', null);
    const customHeaders = options.headers || {};

    const axiosWrapperOptions = await axiosOptions({
      method,
      url,
      data,
      responseType: options.responseType || 'json',
      headers: customHeaders,
    });

    return axiosWrapper(client, axiosWrapperOptions);
  };

  return {
    client,
    get: async (getOptions: IRequestGetProps) => {
      return doRequest('get', getOptions);
    },
    put: async (postOptions: IRequestPostProps) => {
      return doRequest('put', postOptions);
    },
    post: async (postOptions: IRequestPostProps) => {
      return doRequest('post', postOptions);
    },
    delete: async (postOptions: IRequestPostProps) => {
      return doRequest('delete', postOptions);
    },
    patch: async (postOptions: IRequestPostProps) => {
      return doRequest('patch', postOptions);
    },
  };
};

export default requestsFactory;
