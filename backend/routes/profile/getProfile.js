const express = require('express');
const router = express.Router();
const AWS = require('aws-sdk');
const admin = require('firebase-admin');

// Ensure Firebase Admin is initialized outside of this file, typically in server.js
const db = admin.firestore();

// Configure AWS using environment variables
AWS.config.update({
  region: process.env.REGION,
});

// Create Cognito Client
const cognitoIdentityServiceProvider = new AWS.CognitoIdentityServiceProvider({
  apiVersion: '2024-05-06',
  region: process.env.REGION,
});

// Setup the endpoint to use POST to receive the accessToken
router.post('/', async (req, res) => {
  const { accessToken } = req.body;

  const params = {
    AccessToken: accessToken,
  };

  cognitoIdentityServiceProvider.getUser(params, async (err, data) => {
    if (err) {
      console.error(err);
      res.status(403).send({ message: 'Session token unrecognized.' });
    } else {
      try {
        const userId = data.Username;
        const userDoc = await db.collection('users').doc(userId).get();
        if (!userDoc.exists) {
          res.status(404).send({ message: 'Profile not found.' });
        } else {
          res.status(200).send({
            message: 'Profile data found successfully.',
            profileData: userDoc.data(),
          });
        }
      } catch (dbErr) {
        console.error(dbErr);
        res
          .status(500)
          .send({
            message: 'An error occurred on the server. Please try again later.',
          });
      }
    }
  });
});

module.exports = router;
