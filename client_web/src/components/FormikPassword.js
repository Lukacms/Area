import { Password } from 'primereact/password';
import '../styles/components.css';

const FormikPassword = ({ field, form, label, id, error, touched, ...props }) => {
  return (
    <div className='flex flex-column gap-2'>
      <span className='p-float-label'>
        <Password id={id} {...props} />
        {label ? <label htmlFor={id}>{label}</label> : null}
      </span>
      {error && touched && <small className='p-error'>{error}</small>}
    </div>
  );
};

export default FormikPassword;
