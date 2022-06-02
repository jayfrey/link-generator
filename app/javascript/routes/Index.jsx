import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import Header from "../components/Header";
import Footer from "../components/Footer";
import Home from '../components/Home';
import Analytics from '../components/analytics/Analytics';

export default (
  <Router>
    <Header />
    <Switch>
      <Route path="/" exact component={Home} />
      <Route path="/a/:id" exact component={Analytics} />
    </Switch>
    <Footer />
  </Router>
);
