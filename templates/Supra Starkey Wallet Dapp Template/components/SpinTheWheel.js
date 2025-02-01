import React, { useState } from 'react';
import Wheel from './Wheel';

const SpinTheWheel = ({ provider }) => {
  const [result, setResult] = useState(null);

  const spinWheel = () => {
    const outcomes = ["Win", "Lose", "Try Again"];
    const randomIndex = Math.floor(Math.random() * outcomes.length);
    const outcome = outcomes[randomIndex];
    setResult(outcome);

    const wheel = document.getElementById('wheel');
    wheel.classList.add('spin');
    setTimeout(() => {
      wheel.classList.remove('spin');
      alert(`You ${outcome}!`);
    }, 4000);
  };

  return (
    <div className="spin-the-wheel-container">
      <Wheel />
      <button onClick={spinWheel} className="spin-button">Spin the Wheel!</button>
    </div>
  );
};

export default SpinTheWheel;
