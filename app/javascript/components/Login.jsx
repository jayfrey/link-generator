import React, { useState, useEffect } from 'react';
import Cookies from 'js-cookie';
import api from './util/linkhiveApi';
import avatarLogo from '../../assets/images/avatar.svg';

const Login = () => {
  const [user, setUser] = useState({});
  const [sessionId, setSessionId] = useState(null);

  useEffect(() => {
    let sessId = new URLSearchParams(window.location.search).getAll('session_id').pop();

    if (sessId == null) {
      // maybe the session id is in the cookie?
      sessId = Cookies.get('linkhive_session_id');
    }

    if (sessId != null) {
      Cookies.set('linkhive_session_id', sessId);
      setSessionId(sessId);
      api.whoami(sessId)
        .then((r) => {
          const currentUser = r.data.data.current_user;
          setUser(currentUser);
        })
        .catch((r) => {
          // eslint-disable-next-line no-console
          console.error(r);
          Cookies.remove('linkhive_session_id');
          setSessionId(null);
        });
    } else {
      Cookies.remove('linkhive_session_id');
    }
  }, []);

  const logout = () => {
    api.logout()
      .then(() => {
        setUser({});
        setSessionId(null);
        Cookies.remove('linkhive_session_id');
        window.location = '/';
      });
  };

  return (
    <>
      {(sessionId && user) ? (
        <div className="col-lg col-md col-sm avatar-container">
          <div className="dropdown">
            <img src={avatarLogo} width="20" height="20" alt="AVATAR" />
            <div className="dropdown-content">
              <p className="name">{user.name}</p>
              <p className="email">{user.email}</p>
              <button className="logout" onClick={logout} type="button">Logout</button>
            </div>
          </div>
        </div>
      )
        : (
          <div className="col-lg col-md col-sm login-signup">
            <a className="login button" href="/auth/developer">Login</a>
          </div>
        )}
    </>
  );
};

export default Login;
