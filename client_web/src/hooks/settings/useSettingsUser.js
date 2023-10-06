import { useNavigate } from "react-router-dom";
import * as Yup from 'yup';

const useSettingsUser = () => {
  const navigate = useNavigate();
  const passwordValues = {
    password: '',
    passwordCheck: ''
  };

  const validation = Yup.object().shape({
    password: Yup.string().min(8, 'Must be 8 characters minimum').required('Required'),
    passwordCheck: Yup.string()
      .equals([Yup.ref('password'), null], 'This field must be identical to the one above')
      .required('Required')
  });

  const changePassword = async (values) => {};

  return { navigate, passwordValues, validation, changePassword };
};

export default useSettingsUser;
