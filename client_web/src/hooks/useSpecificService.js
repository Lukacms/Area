import { useLocation, useNavigate } from 'react-router-dom';

const useSpecificService = () => {
  const navigate = useNavigate();
  const { item } = useLocation().state;

  return { navigate, item };
};

export default useSpecificService;
