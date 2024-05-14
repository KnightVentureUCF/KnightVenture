const express = require('express');
const admin = require('firebase-admin');
const router = express.Router();
const db = admin.firestore();

const collectionRef = db.collection('Caches');

// Define a route to get data from the Firestore database
router.get('/', async (req, res) => {
  try {
    const snapshot = await collectionRef.get();
    const data = snapshot.docs.map(doc => doc.data());
    res.json({ 'caches': data });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
