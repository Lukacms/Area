import { Dropdown } from 'primereact/dropdown';
import '../styles/components.css';

/**
 * Dropdown primereact component adapted to formik
 * @returns {HTML}
 */
const FormikDropdown = ({ field, form, label, id, error, touched, ...props }) => {
  return (
    <div className='flex flex-column gap-2'>
      <span className='p-float-label'>
        <Dropdown id={id} {...props} />
        {label ? <label htmlFor={id}>{label}</label> : null}
      </span>
      {error && touched && <small className='p-error'>{error}</small>}
    </div>
  );
};

export default FormikDropdown;
