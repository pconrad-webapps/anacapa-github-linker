import React, { Component } from 'react';
import './App.css';
import Header from './components/Header.js';
import UsersTable from "./components/UsersTable";

class App extends Component {
  render() {
    return (
      <div className="App">
        <Header />
        <UsersTable />
      </div>
    );
  }
}

export default App;
