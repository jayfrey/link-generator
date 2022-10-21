import axios from 'axios';
import qs from 'qs';
import getSessId from './getSessId';

const routes = {
  whoami: (sessionId) => `/api/users/whoami?session_id=${sessionId}`,
  showUrl: (slug) => `/api/urls/${slug}`,
  createUrl: () => '/api/urls',
  logout: () => '/auth/logout',
  mostRecent: () => '/api/top/recent',
  mostVisited: () => '/api/top/visited',
  userLinks: (sessionId) => `/api/users/links?session_id=${sessionId}`,
  unbindLink: (sessionId, urlId) => `/api/urls/${urlId}/unbind?session_id=${sessionId}`,
};

const linkmanApi = {
  whoami(sessionId) {
    return axios.get(routes.whoami(sessionId));
  },

  getUrlData(slug) {
    return axios.get(routes.showUrl(slug));
  },

  shortenLink(url, customUrl = '', userId = null) {
    return axios.post(routes.createUrl(), qs.stringify(url), customUrl, userId);
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

  userLinks() {
    return axios.get(routes.userLinks(getSessId()));
  },

  unbindLink(urlId) {
    return axios.patch(routes.unbindLink(getSessId(), urlId));
  },
};

export default linkmanApi;
