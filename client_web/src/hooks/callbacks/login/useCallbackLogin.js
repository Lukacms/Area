import { useEffect, useRef } from "react";

const useCallbackLogin = () => {
  const ref = useRef(null);

  useEffect(() => {
    if (ref.current) {
      ref.current.clear();
      ref.current.show({sticky: true, severity: 'info', summary: 'Loading', detail: 'Please wait, you will be redirected in an instant...', closable: false});
    }

    const connectGoogle = async () => {};
  }, []);

  return {ref};
};

export default useCallbackLogin;
