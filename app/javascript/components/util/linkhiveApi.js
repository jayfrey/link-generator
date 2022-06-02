import axios from 'axios';
import qs from 'qs';

const routes = {
  whoami: (sessionId) => `/api/users/whoami?session_id=${sessionId}`,
  showUrl: (slug) => `/api/urls/${slug}`,
  createUrl: () => '/api/urls',
  logout: () => '/auth/logout',
  mostRecent: () => '/api/top/recent',
  mostVisited: () => '/api/top/visited',
};

const linkmanApi = {
  whoami(sessionId) {
    return axios.get(routes.whoami(sessionId));
  },

  getUrlData(slug) {
    return axios.get(routes.showUrl(slug));
  },

  shortenLink(url) {
    return axios.post(routes.createUrl(), qs.stringify(url));
  },

  logout() {
    return axios.delete(routes.logout());
  },

  mostRecent() {
    return axios.get(routes.mostRecent());
  },

  mostVisited() {
    return axios.get(routes.mostVisited());
  },
};

export default linkmanApi;
