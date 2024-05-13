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
const client = new AWS.CognitoIdentityServiceProvider({
  apiVersion: '2024-05-06',
  region: process.env.REGION,
});

// Confirm registration and login endpoint
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

  client.initiateAuth(params, async (err, authData) => {
    if (err) {
      res.status(500).send(err);
    } else {
      try {
        // Check if the user already exists in Firestore
        const userRef = db.collection('users').doc(username);
        const doc = await userRef.get();
        if (!doc.exists) {
          // User does not exist, add them
          await userRef.set({
            username: username,
            fullName: '', // Empty string as default
            password: password, // Note: Storing passwords in plaintext is not recommended
            profilePicture: null,
            cachesFound: 0,
            distanceVentured: 0,
          });
          res.send({
            message: 'User registered and authenticated successfully.',
            authData,
          });
        } else {
          // User already exists, just return success
          res.send({ message: 'User authenticated successfully.', authData });
        }
      } catch (firebaseError) {
        console.error(firebaseError);
        res.status(500).send({
          message: 'Failed to check or write user details in Firebase.',
          firebaseError,
        });
      }
    }
  });
});

module.exports = router;
