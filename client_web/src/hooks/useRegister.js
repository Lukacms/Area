const useRegister = () => {
  const initialValues = {
    name: '',
    surname: '',
    password: '',
    passwordCheck: '',
    username: '',
    email: '',
  };

  const validate = (values) => {
    const errors = {};
    console.log('oui');
    if (values.password !== values.passwordCheck) {
      errors.password = 'Password must be identical on both inputs.';
      errors.passwordCheck = 'Password must be identical on both inputs.';
    }
    console.log(errors);
    return errors;
  };

  const register = (values) => {
    console.log(values);
  };

  return {
    initialValues,
    validate,
    register
  };
};

export default useRegister;
