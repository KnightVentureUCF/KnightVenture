require('dotenv').config();
const express = require('express');
const AWS = require('aws-sdk');
const admin = require('firebase-admin');
const path = require('path');
const bodyParser = require('body-parser');

const PORT = process.env.PORT || 3000;

// Initialize Express
const app = express();

// Configure AWS SDK
AWS.config.update({
  region: process.env.REGION,
});

const s3 = new AWS.S3();

// Function to load Firebase credentials from S3
async function loadFirebaseCredentials() {
  const params = {
    Bucket: process.env.S3_BUCKET_NAME, // S3 bucket name where the JSON file is stored
    Key: process.env.S3_CREDENTIALS_KEY, // Key (file path) for the JSON file
  };

  return new Promise((resolve, reject) => {
    s3.getObject(params, (err, data) => {
      if (err) {
        console.error('Error fetching Firebase credentials from S3:', err);
        reject(err);
      } else {
        try {
          const credentials = JSON.parse(data.Body.toString('utf-8'));
          resolve(credentials);
        } catch (parseError) {
          console.error('Error parsing Firebase credentials:', parseError);
          reject(parseError);
        }
      }
    });
  });
}

// Initialize Firebase with credentials from S3
async function initializeFirebase() {
  try {
    const serviceAccount = await loadFirebaseCredentials();
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      databaseURL: process.env.FIREBASE_DATABASE_URL,
    });
    console.log('Firebase initialized successfully.');
  } catch (error) {
    console.error('Failed to initialize Firebase:', error);
    process.exit(1); // Exit the application if Firebase initialization fails
  }
}

// Initialize Firebase asynchronously
initializeFirebase();

// Middleware to parse JSON bodies
app.use(bodyParser.json());

// Register routes
const register = require('./backend/routes/user/register');
app.use('/api/register', register);

const confirmRegistration = require('./backend/routes/user/confirmRegistration');
app.use('/api/confirm_registration', confirmRegistration);

const login = require('./backend/routes/user/login');
app.use('/api/login', login);

const forgotPassword = require('./backend/routes/user/forgotPassword');
app.use('/api/forgot_password', forgotPassword);

const confirmPasswordReset = require('./backend/routes/user/confirmPasswordReset');
app.use('/api/confirm_password_reset', confirmPasswordReset);

const getProfile = require('./backend/routes/profile/getProfile');
app.use('/api/get_profile', getProfile);

const updateProfile = require('./backend/routes/profile/updateProfile');
app.use('/api/update_profile', updateProfile);

const createComment = require('./backend/routes/comment/createComment');
app.use('/api/create_comment', createComment);

const readRanking = require('./backend/routes/ranking/readRanking');
app.use('/api/read_ranking', readRanking);

const loadCaches = require('./backend/routes/cache/loadCaches');
app.use('/api/load_caches', loadCaches);

const readCache = require('./backend/routes/cache/readCache');
app.use('/api/read_cache', readCache);

// Listen on a port
const server = app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = { app, server };
