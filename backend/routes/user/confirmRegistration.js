const express = require('express');
const router = express.Router();
const AWS = require('aws-sdk');

// Use the existing Firebase instance from the main server file
const admin = require('firebase-admin');

// Create Cognito Client (already configured in server.js)
const client = new AWS.CognitoIdentityServiceProvider({
  apiVersion: '2024-05-06',
  region: process.env.REGION,
});

// Confirm Email and Add User to Firebase
router.post('/', (req, res) => {
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
        // After confirmation, add the user to Firebase Authentication
        const userRecord = await admin.auth().createUser({
          email: email,
          emailVerified: true,
          password: 'Knight-3101.', // TODO: change this to real password, apply hashing
        });

        // Store additional user information in Firestore
        const db = admin.firestore();
        await db.collection('users').doc(userRecord.uid).set({
          fullName: username,
          profilePicture: '🐶',
          cachesFound: 0,
          distanceVentured: 0,
        });

        res.status(200).send({
          message: 'User confirmed and added to Firebase successfully.',
          userId: userRecord.uid,
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
