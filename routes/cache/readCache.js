const express = require('express');
const admin = require('firebase-admin');
const router = express.Router();
const db = admin.firestore();
const collectionRef = db.collection('Caches');
const { verifyAccessTokenMiddleware } = require("../../utils/verifyAccessTokenMiddleware.js");

// TODO: This API has not been tested on a real database yet.
router.post('/read_cache', verifyAccessTokenMiddleware, async (req, res) => {
    const { cacheID } = req.body;

    if (!cacheID) {
        res.status(400).send({
            message: "Invalid Request."
        });
    }
    
    try {
        const docRef = collectionRef.doc(cacheID);
        const docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
            // Send back the data of the specific entry
            res.status(200).send({
                cache: docSnapshot.data(),
                message: "Cache read successfully."
            });
        } else {
            // Handle the case where the document does not exist
            res.status(404).send({
                message: "Cache not found."
            });
        }
    } catch (error) {
        res.status(500).send({
            message: "An error occurred on the server. Please try again later."
        });
    }
});

module.exports = router;
