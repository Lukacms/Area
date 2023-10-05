import '../styles/ItemCard.css'

const ItemCard = ({value}) => {
    return (
        <div className='ItemCardDiv'>
        <p> {value} </p>
        </div>

    );
}

export default ItemCard;
