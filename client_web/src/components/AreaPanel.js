import { Accordion, AccordionTab } from 'primereact/accordion';
import { Button } from 'primereact/button';
import { Card } from 'primereact/card';
import '../styles/panelArea.css';

const AreaPanelBuild = ({ name, action, reactions, status, onHide }) => {
  const footer = <Button label='Hide' onClick={() => onHide(null)} />;

  return (
    <div className='card'>
      <Card title={name} style={{ minWidth: '50vw' }} footer={status === 'Default' ? footer : null}>
        <Accordion multiple>
          <AccordionTab header={action?.label} key={0}>
            <p>timer: {action?.timer}</p>
            {action?.configuration ? (
              Object.entries(action.configuration).map((item, key) => (
                <p key={key}>
                  {item[0]}: {item[1]}
                </p>
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
                    <p key={pKey}>
                      {item[0]}: {item[1]}
                    </p>
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
            <p>timer: {action?.timer}</p>
            {actionConfig ? (
              Object.entries(actionConfig).map((item, key) => (
                <p key={key}>
                  {item[0]}: {item[1]}
                </p>
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
                    <p key={pKey}>
                      {item[0]}: {item[1]}
                    </p>
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
