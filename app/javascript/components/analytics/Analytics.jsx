/* eslint-disable react/jsx-no-target-blank */
import React, { useState, useEffect } from 'react';
import * as timeago from 'timeago.js';
import { createConsumer } from '@rails/actioncable';
import api from '../util/linkhiveApi';

const consumer = createConsumer();

const Analytics = () => {
  const [urlData, setUrlData] = useState({});
  const [urlStats, setUrlStats] = useState([]);
  const [urlVisitCount, setUrlVisitCount] = useState(0);

  useEffect(() => {
    const slug = (window.location.pathname).substring(3);

    api.getUrlData(slug)
      .then((r) => {
        setUrlData(r.data.data.url);
        setUrlStats(r.data.data.url.statistics);
        setUrlVisitCount(r.data.data.url.visit_count);
      });

    consumer.subscriptions.create({ channel: 'UrlVisitChannel', room: `url_visit:${slug}` }, {
      received(data) {
        const stats = JSON.parse(data);
        setUrlStats((_urlStats) => [stats, ..._urlStats]);
        setUrlVisitCount(stats.count);
      },
    });
  }, []);

  return (
    <div className="analytics-container">
      <div className="analytics-metadata-section white-background padded-container">
        <p className="bigger-font">
          Analytics data for&nbsp;
          <a href={urlData.shortened_link}>{urlData.slug}</a>
        </p>
        <p>
          Created&nbsp;
          {timeago.format(urlData.created_at)}
        </p>
        <p>
          Destination URL:&nbsp;
          <a href={urlData.url} target="_blank">{urlData.url}</a>
        </p>
        <div className="col-lg-6 col-md-6 col-sm-6 left-div">
          <b className="bigger-font">
            {urlVisitCount}
            &nbsp;
          </b>
          Clicks
        </div>
      </div>
      <div className="analytics-statistics-section white-background padded-container">
        <table className="table table-hover analytics-table">
          <thead>
            <tr>
              <th>Referrer</th>
              <th>Browser</th>
              <th>Country</th>
              <th>Date/Time</th>
            </tr>
          </thead>
          <tbody>
            {
              urlStats && urlStats.map((e) => (
                <tr key={e.id}>
                  <td>{e.referrer}</td>
                  <td>{e.user_agent}</td>
                  <td>{e.country}</td>
                  <td>{new Date(e.created_at).toString()}</td>
                </tr>
              ))
            }
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Analytics;
