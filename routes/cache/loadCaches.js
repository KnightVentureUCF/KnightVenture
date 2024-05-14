const express = require('express');
const admin = require('firebase-admin');
const router = express.Router();
const db = admin.firestore();
const collectionRef = db.collection('Caches');
const {verifyAccessTokenMiddleware} = require("../../utils/verifyAccessTokenMiddleware.js");

// Define a route to get data from the Firestore database
router.get('/load_caches', verifyAccessTokenMiddleware, async (req, res) => {
  try {
    // Now you can access req.userData here if you need to use it
    const snapshot = await collectionRef.get();
    const data = snapshot.docs.map(doc => doc.data());
    res.status(200).send({
      caches: data,
      message: "Loaded Caches Successfully"
    });
  } catch (error) {
    res.status(500).send({
      message: "An error occurred on the server. Please try again later."
    });
  }
});

module.exports = router;
