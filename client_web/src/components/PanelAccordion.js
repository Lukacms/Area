import { Accordion, AccordionTab } from 'primereact/accordion';
import { Button } from 'primereact/button';
import '../styles/components.css';

/**
 * Reproduction of primereact PanelMenu component without the inconvenients
 * @returns {Accordion}
 */
const PanelAccordion = ({ baseList, onClick, status, setStatus }) => {
  const renderItem = (item) => {
    return (
      <div className='panelAccordionButton' key={item.id}>
        <Button
          label={item.label}
          key={item.id}
          text
          tooltip={item.desc ? item.desc : ''}
          onClick={() => onClick(status, setStatus, item)}
        />
      </div>
    );
  };

  return (
    <Accordion>
      {baseList.map((item) => (
        <AccordionTab header={item.label} key={item.id}>
          {item.items?.map((subItem) => renderItem(subItem))}
        </AccordionTab>
      ))}
    </Accordion>
  );
};

export default PanelAccordion;
