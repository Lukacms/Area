import { BrowserRouter, Route, Routes } from 'react-router-dom';
import { Login, MailVerif, Register } from './pages';
import 'primereact/resources/themes/mdc-dark-indigo/theme.css';
import 'primeicons/primeicons.css';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path='/' element={<Login />} />
        <Route path='/register'>
          <Route index element={<Register />} />
          <Route path='verify' element={<MailVerif />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
