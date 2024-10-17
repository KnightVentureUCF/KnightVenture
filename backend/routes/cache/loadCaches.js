const express = require('express');
const admin = require('firebase-admin');
const router = express.Router();
const db = admin.firestore();
const usersCollectionRef = db.collection('users');
const cachesCollectionRef = db.collection('caches');
const { verifyAccessTokenMiddleware } = require("../../utils/verifyAccessTokenMiddleware.js");

// Route for loading all UCF caches for the venture screen.
router.post('/', verifyAccessTokenMiddleware, async (req, res) => {
  try {
    const { username } = req.body;

    // Validate that username is present in the request body
    if (!username) {
      return res.status(400).send({ message: "Username is required." });
    }

    // Get user data
    const userSnapshot = await usersCollectionRef.doc(username).get();
    if (!userSnapshot.exists) {
      return res.status(404).send({ message: 'User not found.' });
    }

    const userData = userSnapshot.data() || {}; // Handle potential null data
    const foundCaches = userData.foundCaches || []; // If no foundCaches, initialize as empty array

    // Get cache data
    const cachesSnapshot = await cachesCollectionRef.get();

    // Handle case where no caches exist
    if (cachesSnapshot.empty) {
      return res.status(200).send({
        foundCaches: foundCaches,
        allCaches: [],
        message: "No caches available at this time."
      });
    }

    // Map cache data from Firestore, including the document ID (cache ID)
    const cacheData = cachesSnapshot.docs.map(doc => ({
      id: doc.id,      // This will add the cache ID to each cache data object
      ...doc.data()    // Spread the rest of the cache data
    }));

    // Return the caches and user's found caches
    res.status(200).send({
      foundCaches: foundCaches,
      allCaches: cacheData,
      message: "Loaded Caches Successfully."
    });
  } catch (error) {
    console.error("Error loading caches:", error);
    res.status(500).send({
      message: "An error occurred on the server. Please try again later."
    });
  }
});

module.exports = router;
