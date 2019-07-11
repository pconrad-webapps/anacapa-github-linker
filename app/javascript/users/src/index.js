import React from 'react';
import {Provider} from 'mobx-react';
import ReactDOM from 'react-dom';
import App from './App';
import './index.css';
import * as stores from './stores'

ReactDOM.render(
  <Provider {...stores}>
    <App />
  </Provider>,
  document.getElementById('root')
);
