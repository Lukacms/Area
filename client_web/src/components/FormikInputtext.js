import { InputText } from 'primereact/inputtext';
import '../styles/components.css';

const FormikInputtext = ({ field, form, label, id, error, touched, icon, ...props }) => {
  return (
    <div className='flex flex-column gap-2'>
      <span className={'p-float-label' + (icon ? ' p-input-icon-right' : '')}>
        {icon ? <i className={icon} /> : null}
        <InputText id={id} {...props} />
        {label ? <label htmlFor={id}>{label}</label> : null}
      </span>
      {error && touched && <small className='p-error'>{error}</small>}
    </div>
  );
};

export default FormikInputtext;
