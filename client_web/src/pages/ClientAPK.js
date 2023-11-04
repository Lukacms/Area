import { Background } from '../components';
import '../styles/components.css';
import { Button } from 'primereact/button';

/**
 * Allow an user to download mobile apk to then build the app on their phone
 * @returns {HTMLElement}
 */
function ClientAPK() {
  const fetchData = () => {
    fetch('/FastR-1.0.0.apk').then((response) => {
      console.log(response);
      response.blob().then((blob) => {
        const fileUrl = window.URL.createObjectURL(blob);
        let alink = document.createElement("a");
        alink.href = fileUrl;
        alink.download = 'FastR-1.0.0.apk';
        alink.click();
      });
    });
  };

  return (
    <Background>
      <div className='app'>
        <div style={{ marginLeft: '3vw', paddingTop: '5vh' }}>
          <Button label='Click here to download mobile apk' link onClick={() => fetchData()} />
        </div>
      </div>
    </Background>
  );
}

export default ClientAPK;
