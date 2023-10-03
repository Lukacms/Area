import '../styles/AreaCard.css';
import ItemCard from './ItemCard';

const AreaCard = ({ area }) => {
  let value = [];

  if (area.name !== '') {
    value.push(<ItemCard value={'Si'} />);
    value.push(<ItemCard value={area.action} />);

    for (let i = 0; i < area.reaction.length; i++) {
      value.push(<ItemCard value={'Alors'} />);
      value.push(<ItemCard value={area.reaction[i]} />);
    }
  }

  return <div className='areaCardMainDiv'>{value}</div>;
};

export default AreaCard;
