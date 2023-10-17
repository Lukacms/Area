import '../styles/ItemCard.css';

const ItemCard = ({ value }) => {
  return (
    <div className='itemCardDiv'>
      <div> {value} </div>
    </div>
  );
};

export default ItemCard;
