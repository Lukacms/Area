import { useEffect, useState } from 'react';
import { useLocation, useParams } from 'react-router-dom';

const useMailVerif = () => {
  const [verified, setVerified] = useState(false);
  const { userId } = useParams();
  const tmp = useLocation().search;
  const [id, setId] = useState('');

  useEffect(() => {
    const getId = () => {
      setId(tmp.substring(tmp.search('=') + 1, tmp.length));
    };
    getId();
  }, []);

  return { verified, id };
};

export default useMailVerif;
