// const express = require('express');
// const router = express.Router();
// const dotenv = require('dotenv');
// const path = require('path');
// const AWS = require('aws-sdk');

// // Configure AWS using environment variables
// AWS.config.update({
//   region: process.env.REGION,
// });

// // Create Cognito Client
// const client = new AWS.CognitoIdentityServiceProvider({
//   apiVersion: '2024-05-06',
//   region: process.env.REGION,
// });

// router.post('/', (req, res) => {
//   const { username, email, password } = req.body;
//   const params = {
//     ClientId: process.env.CLIENT_ID,
//     Password: password,
//     Username: username,
//     UserAttributes: [
//       {
//         Name: 'email',
//         Value: email,
//       },
//     ],
//   };

//   client.signUp(params, (err, data) => {
//     if (err) res.status(500).send(err);
//     else res.send(data);
//   });
// });

// module.exports = router;

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

router.post('/', (req, res) => {
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
    if (err) {
      // Handle only UsernameExistsException and InvalidParameterException
      if (err.code === 'UsernameExistsException') {
        res.status(409).json({ error: 'Username already exists.' });
      } else if (err.code === 'InvalidParameterException') {
        res.status(400).json({
          error:
            'Invalid input parameters. Please check username, email, and password.',
        });
      } else {
        res.status(500).json({
          error: 'An error occurred during sign-up.',
          details: err.message,
        });
      }
    } else {
      res.send(data);
    }
  });
});

module.exports = router;