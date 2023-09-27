import {Password} from 'primereact/password';
import '../styles/components.css';

const FormikPassword = ({ field, form, label, id, error, ...props }) => {
  return (
    <div className=''>
      {label ? <label htmlFor={id}>{label}</label> : null}
      <Password id={id} {...props} promptLabel='Choose a password' weakLabel='too weak' mediumLabel='average' strongLabel='Complex password'/>
      {error ? <small className='p-error'>{error}</small>: null}
    </div>
  );
};

export default FormikPassword;
