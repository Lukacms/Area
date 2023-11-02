import '../styles/login.css';

/**
 * display the background css in a component to not be redundant at each page
 * @returns {HTML}
 * @param children elements to place after background
 */
const Background = ({ children }) => {
  return (
    <div className='box'>
      <div className='overflow: hidden'>
        <div className='CircleBlu' />
        <div className='CircleBlu2' />
        <div className='CircleHollow' />
        <div className='CircleHollow2' />
        <div className='CirclePink' />
        <div className='CirclePink2' />
        {children}
      </div>
    </div>
  );
};

export default Background;
