import _ from 'lodash';

import posthog from 'posthog-js';

let intialized = false;

function init() {
  posthog.init('phc_GUokAn1TkZuQYirR8lYJRmNcu24or0SB7ZjWGfziSwR', {
    api_host: 'https://app.posthog.com',
  });
  intialized = true;
}

interface Properties {
  [key: string]: string | number | boolean | undefined | null;
}

function event(name: string, properties?: Properties) {
  if (intialized) {
    posthog.capture(name, properties);
  }
}

function pageView(path: string) {
  if (intialized) {
    posthog.capture('$pageview', { path });
  }
}

function identify(userId: string | number, properties?: Properties) {
  if (intialized) {
    posthog.identify(_.toString(userId), properties);
  }
}

function reset() {
  if (intialized) {
    posthog.reset(true);
  }
}

const analytics = {
  init,
  event,
  reset,
  pageView,
  identify,
};

export default analytics;
