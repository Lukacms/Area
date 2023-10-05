import { useState } from 'react';
import * as Yup from 'yup';
import { register } from '../config/request';
import { useNavigate } from 'react-router-dom';

const useRegister = () => {
  const [dialogue, setDialogue] = useState(false);
  const [successDialog, setSuccessDialog] = useState(false);
  const navigate = useNavigate();
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
      await register(newUser);
      setSuccessDialog(true);
    } catch (error) {
      console.log('Failure', error);
      setDialogue(true);
    }
  };

  return { initialValues, validate, registerUser, dialogue, setDialogue, successDialog, navigate };
};

export default useRegister;
