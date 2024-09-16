const express = require('express');
const router = express.Router();
const AWS = require('aws-sdk');
const admin = require('firebase-admin'); // Firebase admin for Firestore

// Create Cognito Client (already configured in server.js)
const client = new AWS.CognitoIdentityServiceProvider({
  apiVersion: '2024-05-06',
  region: process.env.REGION,
});

// Confirm Email and Add User Data to Firebase
router.post('/', async (req, res) => {
  const { username, confirmationCode, email } = req.body;
  const confirmParams = {
    ClientId: process.env.CLIENT_ID,
    Username: username,
    ConfirmationCode: confirmationCode,
  };

  console.log(email);

  client.confirmSignUp(confirmParams, async (err, data) => {
    if (err) {
      res.status(500).send({ message: err.message });
    } else {
      try {
        // After confirming the user in Cognito, store user information in Firebase Firestore
        const db = admin.firestore();
        await db.collection('users').doc(username).set({
          email: email,
          fullName: username,
          profilePicture: '🐶',
          cachesFound: 0,
          distanceVentured: 0,
        });

        res.status(200).send({
          message: 'User confirmed and data added to Firebase successfully.',
          username: username,
        });
      } catch (firebaseErr) {
        res
          .status(500)
          .send({ message: `Firebase error: ${firebaseErr.message}` });
      }
    }
  });
});

module.exports = router;
