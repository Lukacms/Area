import { useEffect, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { getByValue } from '../config/commons';
import { verifyMail } from '../config/request';

const useMailVerif = () => {
  const [searchParams /* , setSearchParams */] = useSearchParams();
  const [verified, setVerified] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchVerifMail = async () => {
      const data = {
        email: getByValue(searchParams, 'email'),
        hashId: getByValue(searchParams, 'id')
      };

      try {
        await verifyMail(data);
      } catch (e) {
        setError(e.message);
      }
      setVerified(true);
    };
    fetchVerifMail();
  }, [searchParams]);

  return { verified, error };
};

export default useMailVerif;
