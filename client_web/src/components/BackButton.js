import { Button } from 'primereact/button';
import { useNavigate } from 'react-router-dom';
import '../styles/register.css';

/**
 * Back button to redirect either on precised path or previous page
 * @returns {Button}
 * @type Component
 * @param label str
 * @param path str
 */
const BackButton = ({ label, path }) => {
  const navigate = useNavigate();
  const onBackClick = () => {
    navigate(path ? path : -1);
  };

  return (
    <Button
      label={label}
      className='backButton'
      icon='pi pi-chevron-left'
      size='large'
      link
      rounded
      onClick={onBackClick}
    />
  );
};

export default BackButton;
