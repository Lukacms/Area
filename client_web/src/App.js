import { Navigate, Route, Routes } from 'react-router-dom';
import {
  Error,
  Home,
  Login,
  MailVerif,
  NotFound,
  Register,
  SettingServices,
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
        <Route path='services' element={<SettingServices />} />
        <Route path='services/:id' element={<SpecificService />} />
      </Route>
      <Route path='/error' element={<Error />} />
      <Route path='/notfound' element={<NotFound />} />
      <Route path='*' element={<Navigate to='/notfound' />} />
    </Routes>
  );
  // <Route index element={<SettingUser />} /> // TODO
}

export default App;
