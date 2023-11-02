import { useEffect, useRef } from 'react';
import { useLocation } from 'react-router-dom';

/**
 * Give error message to Error page which show it in a prettier way
 * @returns {{error_msgs: MutableRefObject<null>}}
 */
const useError = () => {
  const { state } = useLocation();
  const error_msgs = useRef(null);

  useEffect(() => {
    if (error_msgs.current) {
      error_msgs.current.clear();
    }
    error_msgs.current.show([
      {
        sticky: true,
        severity: 'error',
        summary: 'Error',
        detail: state.message ? state.message : 'An error has occured',
        closable: false,
      },
    ]);
  }, [state.message]);

  return { error_msgs };
};

export default useError;
