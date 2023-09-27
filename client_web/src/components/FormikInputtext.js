import { InputText } from 'primereact/inputtext';
import '../styles/components.css';

const FormikInputtext = ({ field, form, label, id, ...props }) => {
  return (
    <span className='gap-10'>
      {label ? <label htmlFor={id}>{label}</label> : null}
      <InputText id={id} {...props} />
    </span>
  );
};

export default FormikInputtext;
