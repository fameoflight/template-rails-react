/* eslint-disable */
// @ts-nocheck
import React, { useEffect } from 'react';

import { Spin } from 'antd';

const BoardToken = 'e4fb2834-d574-8e56-9499-6c089e5df582';

function loadCanny() {
  (function (w, d, i, s) {
    function l() {
      if (!d.getElementById(i)) {
        const f = d.getElementsByTagName(s)[0],
          e = d.createElement(s);
        (e.type = 'text/javascript'),
          (e.async = !0),
          (e.src = 'https://canny.io/sdk.js'),
          f.parentNode.insertBefore(e, f);
      }
    }
    if ('function' != typeof w.Canny) {
      var c = function () {
        c.q.push(arguments);
      };
      (c.q = []),
        (w.Canny = c),
        'complete' === d.readyState
          ? l()
          : w.attachEvent
            ? w.attachEvent('onload', l)
            : w.addEventListener('load', l, !1);
    }
  })(window, document, 'canny-jssdk', 'script');
}

interface IFeedbackProps {
  className?: string;
  ssoToken?: string | null;
}

function Feedback(props: IFeedbackProps) {
  const [loaded, setLoaded] = React.useState(false);
  useEffect(() => {
    loadCanny();

    Canny('render', {
      boardToken: BoardToken,
      basePath: null,
      ssoToken: props.ssoToken,
      onLoadCallback: () => {
        setLoaded(true);
      },
    });
  }, []);

  return (
    <Spin spinning={!loaded}>
      <div data-canny className={props.className} />
    </Spin>
  );
}

export default Feedback;
