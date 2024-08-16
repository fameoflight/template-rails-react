import { useCallback, useEffect, useRef, useState } from 'react';

import _ from 'lodash';

type Maybe<V> = V | null;
type SetStateCallbackResult<V> = (
  newState: V | ((prevState: V) => V),
  cb?: (value: V) => void
) => void;

function useStateCallback<V>(initialState: V): [V, SetStateCallbackResult<V>] {
  const [state, setState] = useState<V>(initialState);
  const cbRef = useRef<Maybe<(value: V) => void>>(null);

  const setStateCallback: SetStateCallbackResult<V> = useCallback(
    (newState, cb?) => {
      cbRef.current = cb ? cb : null;
      setState(newState);
    },
    []
  );

  useEffect(() => {
    if (cbRef.current) {
      cbRef.current?.(state);
      cbRef.current = null;
    }
  }, [state]);

  return [state, setStateCallback];
}

export default useStateCallback;
