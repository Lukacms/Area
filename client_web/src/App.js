import "./styles/App.css";
import { BrowserRouter, Route, Routes } from 'react-router-dom';
import Login from "./pages/Login";
import 'primeicons/primeicons.css';
import 'primereact/resources/primereact.css';
import './styles/theme.css';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
