/* eslint-disable react/jsx-no-target-blank */
import React, { useState, useEffect } from 'react';
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

const ShortenForm = () => {
  const [url, setUrl] = useState('');
  const [shortenedLink, setShortenedLink] = useState('');
  const [analyticsLink, setAnalyticsLink] = useState('');

  const urlFormSubmitHandler = (event) => {
    event.preventDefault();
    api.shortenLink({ url })
      .then((r) => {
        setShortenedLink(r.data.data.url.shortened_link);
        setAnalyticsLink(r.data.data.url.analytics_link);
      });
    setUrl('');
  };

  const urlInputChangeHandler = (event) => {
    setUrl(event.target.value);
  };

  return (
    <>
      <form className="row url-holder" onSubmit={urlFormSubmitHandler}>
        <input
          type="text"
          className="col-sm-8 col-md-8 col-lg-8"
          id="url"
          placeholder="Enter URL"
          value={url}
          onChange={urlInputChangeHandler}
        />
        <button className="col-sm-3 col-md-3 col-lg-3" type="submit">Shorten URL</button>
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

export default () => {
  const [mostRecent, setMostRecent] = useState([]);
  const [mostVisited, setMostVisited] = useState([]);

  useEffect(() => {
    api.mostRecent()
      .then((r) => {
        setMostRecent(r.data.data.recent);
      });

    api.mostVisited()
      .then((r) => {
        setMostVisited(r.data.data.visited);
      });
  }, []);

  return (
    <div className="home-page-container">
      <div className="row home-page-top-section">
        <div className="left-div col-sm-6 col-md-6 col-lg-6">
          <div className="left-container">
            <h1>Simplify Your Links</h1>
            <p>Shorten your links and see real-time analytics to improve your marketing efforts.</p>
            <ShortenForm />
          </div>
        </div>
        <div className="right-div col-sm-6 col-md-6 col-lg-6" />
      </div>
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
    </div>
  );
};
