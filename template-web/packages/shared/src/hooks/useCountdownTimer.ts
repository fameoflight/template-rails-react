import { useCallback, useEffect, useReducer } from 'react';

type Actions =
  | { type: 'START' }
  | { type: 'RESET'; payload: number }
  | { type: 'PAUSE' }
  | { type: 'RUNNING' }
  | { type: 'TICK'; payload: number };

type State = {
  canStart: boolean;
  countdown: number;
  isRunning: boolean;
};

function reducer(state: State, action: Actions) {
  switch (action.type) {
    case 'START':
      return {
        ...state,
        canStart: state.countdown !== 0,
      };
    case 'RESET':
      return {
        ...state,
        countdown: action.payload,
        canStart: false,
        isRunning: false,
      };
    case 'PAUSE':
      return {
        ...state,
        canStart: false,
        isRunning: false,
      };
    case 'RUNNING':
      return {
        ...state,
        isRunning: true,
      };
    case 'TICK':
      return {
        ...state,
        countdown: state.countdown - action.payload,
      };
    /* istanbul ignore next */
    default:
      return state;
  }
}

interface ICountdownTimerParams {
  /**
   * Default: 1000.
   * Interval between ticks in milliseconds.
   */
  interval?: number;
  /**
   * Default: false.
   * Determines if the countdown will start ticking on mount. This value has no effect on
   * a timer after it has expired or been reset.
   */
  autostart?: boolean;
  /**
   * Default: false
   * Determines if the countdown will expire immediately when ticking to 0. If false,
   * the timer will first set countdown to 0 and then expire on the next interval tick.
   */
  expireImmediate?: boolean;
  /**
   * Default: true.
   * Reset the countdown to it's initial value after expiration. If false,
   * the countdown will remain at 0 in a non-running state until reset.
   */
  resetOnExpire?: boolean;
  /**
   * Callback fired on countdown expiration.
   */
  onExpire?: () => boolean; // return value indicate whether to restart the timer
  /**
   * Callback fired when countdown is reset, either by setting resetOnExpire to true
   * or explicitly calling the reset method.
   */
  onReset?: () => boolean; // return value indicate whether to restart the timer
}

type CountdownTimerResults = {
  /**
   * Current value of the countdown.
   */
  timerCountdown: number;
  /**
   * Is the countdown currently ticking.
   */
  isTimerRunning: boolean;
  /**
   * Start a non-running and non-expired timer. If countdown has expired and
   * resetOnExpire = false, reset must be called before starting again.
   */
  startTimer: () => void;
  /**
   * Reset a countdown to it's initial state.
   */
  resetTimer: () => void;
  /**
   * Pause a running countdown.
   */
  pauseTimer: () => void;
};

/**
 * Create a configurable countdown timer.
 */
function useCountdownTimer(
  initialTimerMs: number,
  {
    interval = 1000,
    autostart = false,
    expireImmediate = false,
    resetOnExpire = true,
    onExpire,
    onReset,
  }: ICountdownTimerParams
): CountdownTimerResults {
  const [state, dispatch] = useReducer(reducer, {
    canStart: autostart,
    countdown: initialTimerMs,
    isRunning: false,
  });

  function start() {
    dispatch({ type: 'START' });
  }

  function pause() {
    dispatch({ type: 'PAUSE' });
  }

  function initStopped(time: number) {
    dispatch({ type: 'RESET', payload: time });
  }

  const reset = useCallback(() => {
    initStopped(initialTimerMs);
    if (onReset && typeof onReset === 'function') {
      if (onReset()) {
        start();
      }
    }
  }, [initialTimerMs, onReset]);

  const expire = useCallback(() => {
    initStopped(resetOnExpire ? initialTimerMs : 0);
    if (onExpire && typeof onExpire === 'function') {
      if (onExpire()) {
        start();
      }
    }
  }, [initialTimerMs, onExpire, resetOnExpire]);

  useEffect(() => {
    function tick() {
      if (
        state.countdown / 1000 <= 0 ||
        (expireImmediate && (state.countdown - interval) / 1000 <= 0)
      ) {
        expire();
      } else {
        dispatch({ type: 'TICK', payload: interval });
      }
    }

    let id: NodeJS.Timeout;
    if (state.canStart) {
      id = setInterval(tick, interval);
      if (!state.isRunning) {
        dispatch({ type: 'RUNNING' });
      }
    }
    return () => clearInterval(id);
  }, [
    expire,
    expireImmediate,
    interval,
    state.canStart,
    state.countdown,
    state.isRunning,
  ]);

  return {
    timerCountdown: state.countdown,
    isTimerRunning: state.isRunning,
    startTimer: start,
    resetTimer: reset,
    pauseTimer: pause,
  };
}

export default useCountdownTimer;
