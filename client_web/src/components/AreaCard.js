import ItemCard from './ItemCard';
import '../styles/AreaCard.css';

const AreaCard = ({ area }) => {
  let value = [];

  if (area.name !== '') {
    value.push(<ItemCard key='si' value={'Si'} />);
    value.push(<ItemCard key='action' value={area.action} />);
    const tabOfReaction = area.reaction?.split(',');
    for (let i = 0; i < tabOfReaction?.length; i++) {
      value.push(<ItemCard key={`alors-${i}`} value={'Alors'} />);
      value.push(<ItemCard key={`reaction-${i}`} value={tabOfReaction[i]} />);
    }
  }

  return <div className='areaCardMainDiv'>{value}</div>;
};

export default AreaCard;
