const express = require('express');
const router = express.Router();
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

// Get User Info endpoint (POST with access token in the body)
router.post('/', (req, res) => {
  const { accessToken } = req.body; // Access token from the request body

  // Check if the token is missing
  if (!accessToken) {
    return res.status(400).send({ message: 'Access token is required' });
  }

  const params = {
    AccessToken: accessToken, // Pass the access token to fetch user data
  };

  client.getUser(params, (err, data) => {
    if (err) {
      console.error('Error fetching user data:', err);
      return res.status(500).send(err);
    }
    
    // Extracting username and email from the user attributes
    const username = data.Username;
    const email = data.UserAttributes.find(attr => attr.Name === 'email').Value;

    return res.status(200).json({
      username: username,
      email: email,
    });
  });
});

module.exports = router;
