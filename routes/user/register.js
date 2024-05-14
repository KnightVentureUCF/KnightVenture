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

router.post('/register', (req, res) => {
  const { username, email, password } = req.body;
  const params = {
    ClientId: process.env.CLIENT_ID,
    Password: password,
    Username: username,
    UserAttributes: [
      {
        Name: 'email',
        Value: email,
      },
    ],
  };

  client.signUp(params, (err, data) => {
    if (err) res.status(500).send(err);
    else res.send(data);
  });
});

module.exports = router;
