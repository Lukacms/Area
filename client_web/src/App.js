import { Navigate, Route, Routes } from 'react-router-dom';
import {
  CallBackAppleMusic,
  CallBackDeezer,
  CallBackDiscord,
  CallBackFacebook,
  CallBackGoogle,
  CallBackInstagram,
  CallBackLetterBoxd,
  CallBackLinkedin,
  CallBackOutlook,
  CallBackPhilipsHue,
  CallBackSpotify,
  CallBackSteam,
  CallBackTrello,
  CallBackYoutube,
  Error,
  Home,
  Login,
  MailVerif,
  NotFound,
  Register,
  SettingServices,
  SettingsUser,
  SpecificService,
} from './pages';
import 'primeicons/primeicons.css';
import 'primereact/resources/themes/mdc-dark-deeppurple/theme.css';

function App() {
  return (
    <Routes>
      <Route path='/' element={<Login />} />
      <Route path='/register'>
        <Route index element={<Register />} />
        <Route path='verify' element={<MailVerif />} />
      </Route>
      <Route path='/home' element={<Home />} />
      <Route path='/settings'>
        <Route index element={<SettingsUser />} />
        <Route path='services'>
          <Route index element={<SettingServices />} />
          <Route path=':id' element={<SpecificService />} />
          <Route path='applemusic' element={<CallBackAppleMusic />} />
          <Route path='deezer' element={<CallBackDeezer />} />
          <Route path='discord' element={<CallBackDiscord />} />
          <Route path='facebook' element={<CallBackFacebook />} />
          <Route path='github' element={<CallBackGithub />} />
          <Route path='google' element={<CallBackGoogle />} />
          <Route path='instagram' element={<CallBackInstagram />} />
          <Route path='letterboxd' element={<CallBackLetterBoxd />} />
          <Route path='linkedin' element={<CallBackLinkedin />} />
          <Route path='outlook' element={<CallBackOutlook />} />
          <Route path='philipshue' element={<CallBackPhilipsHue />} />
          <Route path='spotify' element={<CallBackSpotify />} />
          <Route path='steam' element={<CallBackSteam />} />
          <Route path='trello' element={<CallBackTrello />} />
          <Route path='youtube' element={<CallBackYoutube />} />
        </Route>
      </Route>
      <Route path='/error' element={<Error />} />
      <Route path='/notfound' element={<NotFound />} />
      <Route path='*' element={<Navigate to='/notfound' />} />
    </Routes>
  );
  // <Route index element={<SettingUser />} /> // TODO
}

export default App;
