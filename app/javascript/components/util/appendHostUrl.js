const appendHostUrl = (shortenedLink) => {
  const { protocol } = window.location;
  const slashes = protocol.concat('//');
  const host = slashes.concat(window.location.host);
  return host + shortenedLink;
};

export default appendHostUrl;
