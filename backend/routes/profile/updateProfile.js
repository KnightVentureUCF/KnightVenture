//TODO: implement update cachesFound, distanceVentured, picture later
const express = require('express');
const router = express.Router();
const AWS = require('aws-sdk');
const admin = require('firebase-admin');

// Assuming Firebase Admin SDK has been initialized elsewhere in your application
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

  // Validate accessToken with Cognito
  const params = {
    AccessToken: accessToken,
  };

  cognitoIdentityServiceProvider.getUser(params, async (err, data) => {
    if (err) {
      console.error(err);
      return res.status(403).send({ message: 'Session token unrecognized.' });
    } else {
      try {
        // User is authenticated, update Firestore data
        const userId = data.Username; // Assuming Username is the userId in your Firestore
        const userRef = db.collection('users').doc(userId);

        // Create an object for the fields to update
        const updates = {};
        // if (cachesFound !== undefined) updates.cachesFound = cachesFound;
        // if (distanceVentured !== undefined)
        //   updates.distanceVentured = distanceVentured;
        updates.fullName = fullName;
        // if (password !== undefined) updates.password = password; // Note: Storing passwords in Firestore is discouraged
        // if (profilePicture !== undefined)
        //   updates.profilePicture = profilePicture;

        // Update the document
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
