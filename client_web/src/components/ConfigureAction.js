import { Dialog } from 'primereact/dialog';
import { InputNumber } from 'primereact/inputnumber';
import { InputText } from 'primereact/inputtext';
import '../styles/home.css';

const ConfigureAction = ({
  action,
  onHide,
  status,
  footer,
  error,
  setStatus,
  changeValue,
  setAction,
}) => {
  return (
    <Dialog
      header={action.label}
      footer={footer}
      visible={status === 'ConfigureAction'}
      style={{ minWidth: '20vw' }}
      onHide={() => onHide(setStatus)}>
      <div className='dialog'>
        <InputNumber
          placeholder='Timer (in seconds)'
          value={action.timer}
          onChange={(e) => setAction((old) => [{ ...old, timer: e.value }][0])}
          locale='fr-FR'
          suffix=' sec'
          min={1}
        />
        {action.configuration
          ? Object.entries(action.configuration).map((item, key) => (
              <InputText
                key={key}
                placeholder={item[0]}
                value={item[1]}
                onChange={(e) => changeValue(e, item[0])}
              />
            ))
          : null}
        {error ? <small className='p-error'>{error}</small> : null}
      </div>
    </Dialog>
  );
};

export default ConfigureAction;
