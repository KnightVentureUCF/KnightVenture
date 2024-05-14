const express = require('express');
const admin = require('firebase-admin');
const router = express.Router();
const db = admin.firestore();
const collectionRef = db.collection('Caches');
const {verifyAccessTokenMiddleware} = require("../../utils/verifyAccessTokenMiddleware.js");

// Route for loading all UCF caches for the venture screen.
router.post('/load_caches', verifyAccessTokenMiddleware, async (req, res) => {
  try {
    const snapshot = await collectionRef.get();
    const data = snapshot.docs.map(doc => doc.data());
    res.status(200).send({
      caches: data,
      message: "Loaded Caches Successfully."
    });
  } catch (error) {
    res.status(500).send({
      message: "An error occurred on the server. Please try again later."
    });
  }
});

module.exports = router;
