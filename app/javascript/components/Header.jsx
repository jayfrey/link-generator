import React from 'react';
import { Link } from 'react-router-dom';

import Login from './Login';

const Header = () => (
  <header className="header row">
    <Link to="/" className="col-lg col-md col-sm logo">
      <b>Link</b>
      Man
    </Link>
    <Login />
  </header>
);

export default Header;
