import Cookies from 'js-cookie';

const getSessId = () => {
  let sessId = new URLSearchParams(window.location.search).getAll('session_id').pop();

  if (sessId == null) {
    sessId = Cookies.get('linkhive_session_id');
  }
  return sessId;
};

export default getSessId;
