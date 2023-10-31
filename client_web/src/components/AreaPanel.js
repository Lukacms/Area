import { Accordion, AccordionTab } from 'primereact/accordion';
import { Button } from 'primereact/button';
import { Card } from 'primereact/card';
import { InputText } from 'primereact/inputtext';
import '../styles/panelArea.css';

const AreaConfig = ({ label, value, id }) => {
  return (
    <div className='p-inputgroup flex-1' key={id} style={{margin: '1vh 0vw 1vh 0vw'}}>
      <Button label={label} disabled />
      <InputText value={value} disabled />
    </div>
  );
};

const AreaPanelBuild = ({ name, action, reactions, status, onHide }) => {
  const footer = <Button label='Hide' onClick={() => onHide(null)} />;

  return (
    <div className='card'>
      <Card title={name} style={{ minWidth: '50vw' }} footer={status === 'Default' ? footer : null}>
        <Accordion multiple>
          <AccordionTab header={action?.label} key={0}>
            <AreaConfig label='timer' value={action?.timer} />
            {action?.configuration ? (
              Object.entries(action.configuration).map((item, key) => (
                <AreaConfig label={item[0]} value={item[1]} id={key} />
              ))
            ) : (
              <p>No configuration available</p>
            )}
          </AccordionTab>
          {reactions?.map((reaction, key) => {
            return (
              <AccordionTab header={reaction?.label} key={key + 1}>
                {reaction?.configuration ? (
                  Object.entries(reaction.configuration).map((item, pKey) => (
                    <AreaConfig label={item[0]} value={item[1]} id={pKey} />
                  ))
                ) : (
                  <p>No configuration available</p>
                )}
              </AccordionTab>
            );
          })}
        </Accordion>
      </Card>
    </div>
  );
};

const AreaPanel = ({ name, action, reactions, status, onHide }) => {
  const footer = <Button label='Hide' onClick={() => onHide(null)} />;
  const actionConfig = action?.configuration ? JSON.parse(action.configuration) : '';

  return (
    <div className='card'>
      <Card title={name} style={{ minWidth: '50vw' }} footer={status === 'Default' ? footer : null}>
        <Accordion multiple>
          <AccordionTab header={action.action?.name} key={0}>
            <AreaConfig label='timer' value={action?.timer} />
            {actionConfig ? (
              Object.entries(actionConfig).map((item, key) => (
                <AreaConfig label={item[0]} value={item[1]} id={key} />
              ))
            ) : (
              <p>No configuration available</p>
            )}
          </AccordionTab>
          {reactions?.map((reaction, key) => {
            const reactionConfig = reaction?.configuration
              ? JSON.parse(reaction.configuration)
              : '';
            return (
              <AccordionTab header={reaction.reaction?.name} key={key + 1}>
                {reactionConfig && reactionConfig !== '' ? (
                  Object.entries(reactionConfig).map((item, pKey) => (
                    <AreaConfig label={item[0]} value={item[1]} id={pKey} />
                  ))
                ) : (
                  <p>No configuration available</p>
                )}
              </AccordionTab>
            );
          })}
        </Accordion>
      </Card>
    </div>
  );
};

export { AreaPanel, AreaPanelBuild };
