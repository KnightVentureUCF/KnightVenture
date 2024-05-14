//TODO: check this API with IBM Watson
const express = require('express');
const router = express.Router();
const { verifyAccessToken } = require('../../utils/cognito-utils');
const admin = require('firebase-admin');
const db = admin.firestore();

router.post('/create_comment', async (req, res) => {
  const { accessToken, text } = req.body;
  if (!accessToken || !text) {
    return res.status(400).send({ message: 'Invalid request.' });
  }

  try {
    const userData = await verifyAccessToken(accessToken);
    if (!userData) {
      return res.status(403).send({ message: 'Session token unrecognized.' });
    }

    const userId = userData.Username;

    // Additional content checks
    if (text.includes('spoiler')) {
      return res
        .status(400)
        .send({ message: 'Your comment contains a spoiler, please rewrite.' });
    }
    if (text.includes('harass')) {
      return res.status(400).send({
        message: 'Your comment contains harassing language, please rewrite.',
      });
    }

    // Add comment to Firestore
    const commentRef = db.collection('comments').doc();
    await commentRef.set({
      userId: userId,
      text: text,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });
    res.status(200).send({ message: 'Comment added successfully' });
  } catch (error) {
    console.error('Error posting comment:', error);
    res.status(500).send({
      message: 'An error occurred on the server. Please try again later.',
    });
  }
});

module.exports = router;
