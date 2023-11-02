import { Navigate, Route, Routes } from 'react-router-dom';
import {
  CallBackGithub,
  CallBackGoogle,
  CallBackSpotify,
  CallbackLogin,
  Error,
  Home,
  Login,
  MailVerif,
  NotFound,
  Register,
  SettingServices,
  SettingsAdmin,
  SettingsUser,
  SpecificService,
  CallBackMicrosoft,
  About,
} from './pages';
import 'primeicons/primeicons.css';
import 'primereact/resources/themes/mdc-dark-deeppurple/theme.css';

/**
 * Main function of the application;
 * Launch the visuals in single-page react app
 */
function App() {
  return (
    <Routes>
      <Route path='/' element={<Login />} />
      <Route path='/about.json' element={<About />}/>
      <Route path='/googleOauth' element={<CallbackLogin />} />
      <Route path='/register'>
        <Route index element={<Register />} />
        <Route path='verify' element={<MailVerif />} />
      </Route>
      <Route path='/home' element={<Home publicPath='' />} />
      <Route path='/settings'>
        <Route index element={<SettingsUser />} />
        <Route path='admin' element={<SettingsAdmin />} />
        <Route path='services'>
          <Route index element={<SettingServices />} />
          <Route path=':id' element={<SpecificService />} />
          <Route path='github' element={<CallBackGithub />} />
          <Route path='google' element={<CallBackGoogle />} />
          <Route path='microsoft' element={<CallBackMicrosoft />} />
          <Route path='spotify' element={<CallBackSpotify />} />
        </Route>
      </Route>
      <Route path='/error' element={<Error />} />
      <Route path='/notfound' element={<NotFound />} />
      <Route path='*' element={<Navigate to='/notfound' />} />
    </Routes>
  );
}

export default App;
