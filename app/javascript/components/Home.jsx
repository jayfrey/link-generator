/* eslint-disable react/jsx-no-target-blank */
import React, { useState, useEffect } from 'react';
import { ChartBar, Trash } from 'phosphor-react';
import Moment from 'moment';
import { Link } from 'react-router-dom';
import coleHaanLogo from '../../assets/images/Framecolehaan.svg';
import mediumLogo from '../../assets/images/Framemedium.svg';
import expediaLogo from '../../assets/images/Frameexpedia.svg';
import netflixLogo from '../../assets/images/Framenetflix.svg';
import timeLogo from '../../assets/images/Frametime.svg';
import AELogo from '../../assets/images/Frameae.svg';
import shopifyLogo from '../../assets/images/Frameshopify.svg';
import autodeskLogo from '../../assets/images/Frameautodesk.svg';
import api from './util/linkhiveApi';
import getSessId from './util/getSessId';
import appendHostUrl from './util/appendHostUrl';

const ShortenForm = ({ isUserLoggedIn, fetchUserLinks, fetchMostLinks }) => {
  const [url, setUrl] = useState('');
  const [shortenedLink, setShortenedLink] = useState('');
  const [analyticsLink, setAnalyticsLink] = useState('');
  const [customUrl, setCustomUrl] = useState('');
  const [isCreateCustomUrl, setIsCreateCustomUrl] = useState(false);

  const urlFormSubmitHandler = async (event) => {
    event.preventDefault();
    let userId;
    const sessId = getSessId();

    if (sessId != null) {
      await api.whoami(sessId)
        .then((r) => {
          const currentUser = r.data.data.current_user;
          userId = currentUser.id;
        });
    }

    api.shortenLink({ url, customUrl, userId })
      .then((r) => {
        setShortenedLink(r.data.data.url.shortened_link);
        setAnalyticsLink(r.data.data.url.analytics_link);
      }).finally(() => {
        if (isUserLoggedIn) {
          fetchUserLinks();
        } else {
          fetchMostLinks();
        }
      });
    setUrl('');
    setCustomUrl('');
  };

  const urlInputChangeHandler = (event) => {
    setUrl(event.target.value);
  };

  const customUrlInputChangeHandler = (event) => {
    setCustomUrl(event.target.value);
  };

  const onToggleChange = (event) => {
    // setCustomUrl(event.target.checked);
    setIsCreateCustomUrl(event.target.checked);
  };

  return (
    <>
      <div className="toggle-form-group">
        <span>Create custom URL?</span>
        <label className="switch" htmlFor="toggle">
          <input type="checkbox" id="toggle" onChange={onToggleChange} value={isCreateCustomUrl} />
          <span className="slider round" />
        </label>
      </div>

      <form className="url-holder " onSubmit={urlFormSubmitHandler}>
        <div className="flex-row-container">
          <input
            type="text"
            id="url"
            placeholder="Enter an URL to shorten"
            value={url}
            onChange={urlInputChangeHandler}
          />
          <button
            type="submit"
          >
            Shorten URL
          </button>
        </div>
        {
          isUserLoggedIn && isCreateCustomUrl
            ? (
              <div className={`flex-row-container ${isCreateCustomUrl ? 'fadeIn' : 'fadeOut'}`}>
                <input
                  type="text"
                  id="custom-url"
                  placeholder="Enter a custom path"
                  value={customUrl}
                  onChange={customUrlInputChangeHandler}
                />
              </div>
            ) : <></>
        }
      </form>
      {shortenedLink && analyticsLink && (
      <span>
        link: &nbsp;
        <a href={shortenedLink} target="_blank">{shortenedLink}</a>
        <br />
        manage: &nbsp;
        <Link to={analyticsLink}>{analyticsLink}</Link>
      </span>
      )}
    </>
  );
};

const ColumnItem = ({ headline, description, logo }) => (
  <div className="col-lg-4 col-md-4 col-sm-4 sub-section">
    <div className="shorten row">
      <div className="col-sm-4 col-md-4 col-lg-4">
        <div className={`${logo}-logo logo`} />
      </div>
      <h3 className="col-sm-8 col-md-8 col-lg-8">{headline}</h3>
    </div>
    <p>{description}</p>
  </div>
);

const MostRecent = ({ items }) => (
  <>
    <h4>Most Recent Links</h4>
    <ul>
      {items.map((i) => (
        <Link to={i.analytics_link} key={i.slug}><li>{i.url}</li></Link>
      ))}
    </ul>
  </>
);

const MostVisited = ({ items }) => (
  <>
    <h4>Most Visited Links</h4>
    <ul>
      {items.map((i) => (
        <Link to={i.analytics_link} key={i.slug}><li>{i.url}</li></Link>
      ))}
    </ul>
  </>
);

const PublicContent = ({ mostRecent, mostVisited }) => (
  <>
    <div className="home-page-middle-section text-center">
      <p><b>Trusted by the best teams in the world</b></p>
      <div className="row image-container">
        <img className="col-sm col-md col-lg" src={coleHaanLogo} width="20" height="20" alt="COLE HAAN" />
        <img className="col-sm col-md col-lg" src={mediumLogo} width="23" height="23" alt="MEDIUM" />
        <img className="col-sm col-md col-lg" src={expediaLogo} width="30" height="30" alt="EXPEDIA" />
        <img className="col-sm col-md col-lg" src={netflixLogo} width="25" height="25" alt="NETFLIX" />
        <img className="col-sm col-md col-lg" src={timeLogo} width="20" height="20" alt="TIME" />
        <img className="col-sm col-md col-lg" src={AELogo} width="25" height="25" alt="A+E" />
        <img className="col-sm col-md col-lg" src={shopifyLogo} width="30" height="30" alt="SHOPIFY" />
        <img className="col-sm col-md col-lg" src={autodeskLogo} width="30" height="30" alt="AUTODESK" />
      </div>
    </div>
    <div className="home-page-bottom-section row">
      <ColumnItem
        headline="Shorten"
        description="Shorten your links so it&apos;s ready to be shared everywhere"
        logo="link"
      />
      <ColumnItem
        headline="Track"
        description="Analytics help you know where your clicks are coming from"
        logo="track"
      />
      <ColumnItem
        headline="Learn"
        description="Understand and visualize your audience"
        logo="people"
      />
    </div>
    <div className="home-page-most-section row">
      <div className="col-lg-5 col-md-5 col-sm-5 sub-section">
        <MostRecent items={mostRecent} />
      </div>
      <div className="col-lg-1 col-md-1 col-sm-1" />
      <div className="col-lg-5 col-md-5 col-sm-5 sub-section">
        <MostVisited items={mostVisited} />
      </div>
    </div>
  </>
);

const PrivateContent = ({ links, fetchUserLinks }) => {
  const removeLink = (event, linkId) => {
    event.preventDefault();
    api.unbindLink(linkId).finally(() => {
      fetchUserLinks();
    });
  };

  return (
    <>
      <div className="home-page-my-link-section">
        <div className="my-link-section white-background padded-container">
          <p><b>My Links</b></p>
          <table className="table my-link-table">
            <thead>
              <tr>
                <th>Short Link</th>
                <th>Destination URL</th>
                <th>Created</th>
                <th>Clicks</th>
              </tr>
            </thead>
            <tbody>
              {
                links.map((link) => <TableRow key={link.id} link={link} removeLink={removeLink} />)
              }
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
};

const TableRow = ({ link, removeLink }) => (
  <>
    <tr>
      <td>{appendHostUrl(link.shortened_link)}</td>
      <td>{link.url}</td>
      <td>{Moment(link.created_at).format('MMM DD, yyyy')}</td>
      <td className="text-center">{link.visit_count}</td>
      <td>
        <a href={link.analytics_link} target="_blank" className="action-btn">
          <ChartBar size={18} />
        </a>
        <button type="button" className="action-btn" onClick={() => removeLink(link.id)}>
          <Trash size={18} />
        </button>
      </td>
    </tr>
  </>
);

export default () => {
  const [mostRecent, setMostRecent] = useState([]);
  const [mostVisited, setMostVisited] = useState([]);
  const [isUserLoggedIn, setIsUserLoggedIn] = useState(false);
  const [userLinks, setUserLinks] = useState([]);

  const fetchUserLinks = () => {
    api.userLinks()
      .then((r) => {
        setUserLinks(r.data.data.urls);
      });
  };

  const fetchMostLinks = () => {
    api.mostRecent()
      .then((r) => {
        setMostRecent(r.data.data.recent);
      });

    api.mostVisited()
      .then((r) => {
        setMostVisited(r.data.data.visited);
      });
  };

  useEffect(() => {
    const sessId = getSessId();

    if (sessId != null) {
      setIsUserLoggedIn(true);
      fetchUserLinks();
    } else {
      fetchMostLinks();
    }
  }, []);

  return (
    <div className="home-page-container">
      <div className="row home-page-top-section">
        <div className="left-div col-sm-6 col-md-6 col-lg-6">
          <div className="left-container">
            <h1>Simplify Your Links</h1>
            <p>Shorten your links and see real-time analytics to improve your marketing efforts.</p>
            <ShortenForm
              isUserLoggedIn={isUserLoggedIn}
              fetchUserLinks={fetchUserLinks}
              fetchMostLinks={fetchMostLinks}
            />
          </div>
        </div>
        <div className="right-div col-sm-6 col-md-6 col-lg-6" />
      </div>
      {isUserLoggedIn ? (
        <PrivateContent
          links={userLinks}
          fetchUserLinks={fetchUserLinks}
        />
      ) : (
        <PublicContent mostRecent={mostRecent} mostVisited={mostVisited} />
      )}
    </div>
  );
};
