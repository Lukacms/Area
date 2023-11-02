import { Dialog } from 'primereact/dialog';
import { InputText } from 'primereact/inputtext';
import '../styles/home.css';

/**
 * Configure the reaction when creating an Area - used in Home
 * @returns {Dialog} display content in overlay window
 * @param reaction Object
 * @param status when the dialog should be visible
 * @param setStatus param of onHide function
 * @param onHide what happen when dialog is hidden
 * @param onChangeValue fucntion to call on change
 * @param error error message to display
 * @param footer HTML
 */
const ConfigureReaction = ({
  reactions,
  status,
  setStatus,
  onHide,
  onChangeValue,
  error,
  footer,
}) => {
  return (
    <Dialog
      header={reactions[reactions.length - 1]?.label}
      style={{ minWidth: '20vw' }}
      footer={footer}
      visible={status === 'ConfigureReaction'}
      onHide={() => onHide(setStatus)}>
      <div className='dialog'>
        {reactions[reactions.length - 1]?.configuration
          ? Object.entries(reactions[reactions.length - 1].configuration).map((item, key) => (
              <InputText
                placeholder={item[0]}
                value={item[1]}
                key={key}
                onChange={(e) => onChangeValue(e, item[0])}
              />
            ))
          : null}
        {error ? <small className='p-error'>{error}</small> : null}
      </div>
    </Dialog>
  );
};

export default ConfigureReaction;
