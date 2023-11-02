import { ProgressSpinner } from 'primereact/progressspinner';
import { Background } from '../components';
import { useAbout } from '../hooks';
import '../styles/components.css';

/**
 * About page. Is from a mismatch (should be in backend).
 * Show ip adress of client, as well as time, and services with actions and reactions available
 * @returns {HTMLElement}
 */
function About() {
  const { about, loaded, services } = useAbout();

  return (
    <Background>
      <div className='app'>
        {loaded ? (
          <pre
            style={{
              paddingLeft: '4vw',
              paddingTop: '4vh',
              overflowY: 'scroll',
              maxHeight: '95%',
              maxWidth: '50%',
                fontSize: '15px'
            }}>
            {JSON.stringify({ ...about, server: { ...about.server, services: services } }, null, 2)}
          </pre>
        ) : (
          <ProgressSpinner />
        )}
      </div>
    </Background>
  );
}

export default About;
