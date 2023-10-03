import { BrowserRouter, Route, Routes } from 'react-router-dom';
import { Home, Login, MailVerif, Register, SettingServices, SpecificService } from './pages';
import 'primeicons/primeicons.css';
import 'primereact/resources/themes/mdc-dark-deeppurple/theme.css'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path='/' element={<Login />} />
        <Route path='/register'>
          <Route index element={<Register />} />
          <Route path='verify' element={<MailVerif />} />
        </Route>
        <Route path="/home" element={<Home />} />
        <Route path='/settings'>
          <Route path='services' element={<SettingServices />} />
          <Route path='services/:id' element={<SpecificService />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
  // <Route index element={<SettingUser />} />
}

export default App;
