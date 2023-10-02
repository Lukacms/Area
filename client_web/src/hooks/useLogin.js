import { useNavigate } from "react-router-dom";

const useLogin = () => {
  const navigate = useNavigate();

  const login = () => {
    navigate('/home');
  };

  return { login, navigate };
}

export default useLogin;
