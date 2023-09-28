import { Password } from 'primereact/password';
import '../styles/components.css';

const FormikPassword = ({ field, form, label, id, error, touched, ...props }) => {
  return (
    <div className='gap-10'>
      {label ? <label htmlFor={id}>{label}</label> : null}
      <Password
        id={id}
        {...props}
        promptLabel='Choose a password'
        weakLabel='too weak'
        mediumLabel='average'
        strongLabel='Complex password'
      />
      {error && touched && <small className='p-error'>{error}</small>}
    </div>
  );
};

export default FormikPassword;
