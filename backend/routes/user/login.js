const express = require('express');
const router = express.Router();
const dotenv = require('dotenv');
const path = require('path');
const AWS = require('aws-sdk');

// Configure AWS using environment variables
AWS.config.update({
  region: process.env.REGION,
});

// Create Cognito Client
const client = new AWS.CognitoIdentityServiceProvider({
  apiVersion: '2024-05-06',
  region: process.env.REGION,
});

// Login endpoint
router.post('/', (req, res) => {
  const { username, password } = req.body;
  const params = {
    AuthFlow: 'USER_PASSWORD_AUTH',
    ClientId: process.env.CLIENT_ID,
    AuthParameters: {
      USERNAME: username,
      PASSWORD: password,
    },
  };

  client.initiateAuth(params, (err, authData) => {
    if (err) res.status(500).send(err);
    else res.send(authData);
  });
});

module.exports = router;
