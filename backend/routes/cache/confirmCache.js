const express = require('express');
const admin = require('firebase-admin');
const router = express.Router();
const db = admin.firestore();
const usersCollectionRef = db.collection('users');
const cachesCollectionRef = db.collection('caches');

// Middleware to verify access token
const { verifyAccessTokenMiddleware } = require('../../utils/verifyAccessTokenMiddleware');

// Route to confirm the geocache find
router.post('/', verifyAccessTokenMiddleware, async (req, res) => {
  const { username, cacheId } = req.body;

  if (!username || !cacheId) {
    return res.status(400).send({ message: 'Username and cache ID are required.' });
  }

  try {
    // Get the user's data from Firestore
    const userSnapshot = await usersCollectionRef.doc(username).get();
    if (!userSnapshot.exists) {
      return res.status(404).send({ message: 'User not found.' });
    }

    const userData = userSnapshot.data();
    
    // Check if the cache has already been found by the user
    const foundCaches = userData.foundCaches || []; // If no foundCaches, initialize as empty array
    if (foundCaches.includes(cacheId)) {
      return res.status(400).send({ message: 'You have already found this cache.' });
    }

    // Get the cache data from Firestore using the numeric cacheId
    const cacheSnapshot = await cachesCollectionRef.doc(cacheId).get();
    if (!cacheSnapshot.exists) {
      return res.status(404).send({ message: 'Cache not found.' });
    }

    const cacheData = cacheSnapshot.data();

    // Increment the cachesFound count
    const updatedCachesFound = (userData.cachesFound || 0) + 1;

    // Update the user's data in Firestore - increment cachesFound and add cacheId to foundCaches
    await usersCollectionRef.doc(username).update({
      cachesFound: updatedCachesFound,
      foundCaches: admin.firestore.FieldValue.arrayUnion(cacheId) // Add cacheId to foundCaches array
    });

    // Respond with success message and updated user data
    res.status(200).send({
      message: `Congratulations ${userData.fullName}! You found the ${cacheData.Name} cache.`,
      cachesFound: updatedCachesFound,
      cacheId: cacheId,
      cacheName: cacheData.Name,
      description: cacheData.Description,
    });

  } catch (error) {
    console.error('Error confirming cache:', error);
    res.status(500).send({ message: 'Server error. Please try again later.' });
  }
});

module.exports = router;
