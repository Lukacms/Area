import '../styles/login.css';

const Background = ({ children }) => {
  return (
    <div className="box">
      <div className="overflow: hidden">
        <div className="CircleBlu" />
        <div className="CircleBlu2" />
        <div className="CircleHollow" />
        <div className="CircleHollow2" />
        <div className="CirclePink" />
        <div className="CirclePink2" />
        {children}
      </div>
    </div>
  );
};

export default Background;
