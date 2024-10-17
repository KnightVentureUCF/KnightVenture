const express = require('express');
const router = express.Router();
const AWS = require('aws-sdk');
const admin = require('firebase-admin');

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

// Update Profile endpoint
router.post('/', async (req, res) => {
  const { username, accessToken, fullName } = req.body;

  const params = {
    AccessToken: accessToken,
  };

  cognitoIdentityServiceProvider.getUser(params, async (err, data) => {
    if (err) {
      console.error(err);
      return res.status(403).send({ message: 'Session token unrecognized.' });
    } else {
      try {
        const userId = data.Username; 
        const userRef = db.collection('users').doc(userId);

        const updates = {};
        
        updates.fullName = fullName;
        
        await userRef.update(updates);
        res.status(200).send({ message: 'Profile updated successfully.' });
      } catch (firebaseError) {
        console.error('Firestore Error:', firebaseError);
        res.status(500).send({
          message: 'An error occurred on the server. Please try again later.',
        });
      }
    }
  });
});

module.exports = router;
