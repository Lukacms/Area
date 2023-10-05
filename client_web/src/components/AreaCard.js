import '../styles/AreaCard.css';
import ItemCard from './ItemCard';

const AreaCard = ({ area }) => {
  let value = [];

  if (area.name !== '') {
    value.push(<ItemCard key='si' value={'Si'} />);
    value.push(<ItemCard key='action' value={area.action} />);

    const tabOfReaction = area.reaction.split(',');

    for (let i = 0; i < tabOfReaction.length; i++) {
      value.push(<ItemCard key={`alors-${i}`} value={'Alors'} />);
      value.push(<ItemCard key={`reaction-${i}`} value={tabOfReaction[i]} />);
    }

/*    if (typeof area.reaction !== 'string') {
      for (let i = 0; i < area.reaction.length; i++) {
        value.push(<ItemCard key={`alors-${i}`} value={'Alors'} />);
        value.push(<ItemCard key={`reaction-${i}`} value={area.reaction[i]} />);
      }
    } else {
      value.push(<ItemCard key='alors' value={'Alors'} />);
      value.push(<ItemCard key='reaction' value={area.reaction} />);
    }
  */
  }

  return <div className='areaCardMainDiv'>{value}</div>;
};

export default AreaCard;
