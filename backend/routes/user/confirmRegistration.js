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

// Confirm User Registration endpoint
router.post('/', (req, res) => {
  const { username, confirmationCode } = req.body;
  console.log('username:', username, 'confirmationCode:', confirmationCode);
  const params = {
    ClientId: process.env.CLIENT_ID,
    Username: username,
    ConfirmationCode: confirmationCode,
  };

  client.confirmSignUp(params, (err, data) => {
    if (err) {
      res.status(500).send(err.message);
    } else {
      res.send({ message: 'User registration confirmed.' });
    }
  });
});

module.exports = router;
