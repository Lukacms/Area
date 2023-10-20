import { Chips } from 'primereact/chips';
import '../styles/components.css';

const FormikChip = ({ field, form, label, id, error, touched, ...props }) => {
  return (
    <div className='flex flex-column gap-2'>
      <span className='p-float-label'>
        <Chips id={id} {...props} />
        {label ? <label htmlFor={id}>{label}</label> : null}
      </span>
      {error && touched && <small className='p-error'>{error}</small>}
    </div>
  );
};

export default FormikChip;
