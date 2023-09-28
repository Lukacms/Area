import * as Yup from 'yup';

const useRegister = () => {
  const initialValues = {
    name: '',
    surname: '',
    password: '',
    passwordCheck: '',
    username: '',
    email: '',
  };

  const validate = Yup.object().shape({
    name: Yup.string().min(2, 'Too short').max(50, 'Too long').required('Required'),
    surname: Yup.string().min(2, 'Too short').max(50, 'Too long').required('Required'),
    password: Yup.string().min(8, 'Must be 8 characters minimum').required('Required'),
    passwordCheck: Yup.string()
      .equals([Yup.ref('password'), null], 'This field must be identical to the one above')
      .required('Required'),
    username: Yup.string().min(5, 'Too short').max(50, 'Too long').required('Required'),
    email: Yup.string().email('Invalid email').required('Required'),
  });

  const register = (values) => {
    console.log(values);
  };

  return {
    initialValues,
    validate,
    register,
  };
};

export default useRegister;
