import { BrowserRouter, Route, Routes } from 'react-router-dom';
import { Login, Register } from './pages';
import 'primereact/resources/themes/mdc-dark-indigo/theme.css';
import 'primeicons/primeicons.css';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path='/' element={<Login />} />
        <Route path='/register' element={<Register />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
