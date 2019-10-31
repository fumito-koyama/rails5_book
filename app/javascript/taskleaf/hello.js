import React from 'react'
import ReactDOM from 'react-dom'

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    React.createElement('dev', null, 'Hello World!'),
    document.body.appendChild(document.createElement('div')),
  );
});