import { useState } from 'react';
import * as Yup from 'yup';
import { register } from '../config/request';

const useRegister = () => {
  const [dialogue, setDialogue] = useState(false);
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

  const registerUser = async (values) => {
    const newUser = {
      name: values.name,
      surname: values.surname,
      password: values.password,
      username: values.username,
      email: values.email,
    };

    try {
      const datas = await register(newUser);
      console.log('Success', datas);
    } catch (error) {
      console.log('Failure', error);
      setDialogue(true);
    }
  };

  return { initialValues, validate, registerUser, dialogue, setDialogue };
};

export default useRegister;
