import React from 'react';
import logo from './stelligent.jpg';
import './App.css';

function App() {
  const bgColor = process.env.REACT_APP_BG_COLOR || 'white'
  return (
    <div className="App">
      <header className="App-header">
        Stelligent
      </header>
      <div style={{'background-color': bgColor, 'height': '100vh'}}>
        <img src={logo} className="App-logo" alt="logo" />
        <br></br>
        <div style={{'background-color': 'white'}} >We're here to chew bubble gum and kick butt...and we're all out of bubble gum...</div>
      </div>
    </div>
  );
}

export default App;
