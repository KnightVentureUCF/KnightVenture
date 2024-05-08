const express = require('express');
const admin = require('firebase-admin');
const serviceAccount = require('./firestore private key.json');
const app = express();

// Initialize Firebase Admin SDK with your service account credentials
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://your-firebase-project-id.firebaseio.com'
});

const loadCaches = require('./routes/cache/loadCaches.js');

// Mount the API routes from api.js
app.use('/caches', loadCaches);

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
