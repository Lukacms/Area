import { InputText } from 'primereact/inputtext';
import '../styles/components.css';

const FormikInputtext = ({ field, form, label, id, error, touched, ...props }) => {
  return (
    <span className='gap-10'>
      {label ? <label htmlFor={id}>{label}</label> : null}
      <InputText id={id} {...props} />
      {error && touched && <small className='p-error'>{error}</small>}
    </span>
  );
};

export default FormikInputtext;
