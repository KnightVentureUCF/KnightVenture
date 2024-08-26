const express = require('express');
const router = express.Router();
const { verifyAccessToken } = require('../../utils/cognito-utils');
const admin = require('firebase-admin');
const db = admin.firestore();

router.post('/', async (req, res) => {
  const { accessToken } = req.body;
  if (!accessToken) {
    return res.status(400).send({ message: 'Invalid request.' });
  }

  try {
    const userData = await verifyAccessToken(accessToken);
    if (!userData) {
      return res.status(403).send({ message: 'Session token unrecognized.' });
    }

    // Query Firestore for the top 10 users ranked by caches found
    const querySnapshot = await db
      .collection('users')
      .orderBy('cachesFound', 'desc')
      .limit(3) //TODO: Change to 10 later
      .get();

    const users = querySnapshot.docs.map((doc) => ({
      userid: doc.id,
      username: doc.data().username,
      cachesFound: doc.data().cachesFound,
    }));

    res.status(200).send({
      message: 'Rankings Read Successfully.',
      users: users,
    });
  } catch (error) {
    console.error('Error fetching rankings:', error);
    res.status(500).send({
      message: 'An error occurred on the server. Please try again later.',
    });
  }
});

module.exports = router;
