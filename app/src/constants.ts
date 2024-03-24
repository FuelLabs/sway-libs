export const FUEL_GREEN = '#00f58c';

export const LOCAL_SERVER_URI = 'http://0.0.0.0:8080';
export const SERVER_URI = process.env.REACT_APP_LOCAL_SERVER
  ? LOCAL_SERVER_URI
  : 'https://api.sway-playground.org';
