import { Button } from 'primereact/button';
import { useNavigate } from 'react-router-dom';
import '../styles/register.css';

const BackButton = ({ label }) => {
  const navigate = useNavigate();
  const onBackClick = () => {
    navigate(-1);
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
