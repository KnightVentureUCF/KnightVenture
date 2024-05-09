require('dotenv').config();
const express = require('express');
const AWS = require('aws-sdk');
const admin = require('firebase-admin');
const serviceAccount = require('./firestorePrivateKey.json');

// Initialize Express
const app = express();

// Configure AWS using environment variables
AWS.config.update({
  region: process.env.REGION,
});

// Create Cognito Client
const client = new AWS.CognitoIdentityServiceProvider({
  apiVersion: '2024-05-06',
  region: process.env.REGION,
});

// Initialize Firebase Admin SDK with your service account credentials
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://your-firebase-project-id.firebaseio.com'
});

// Middleware to parse JSON bodies
const bodyParser = require('body-parser');
app.use(bodyParser.json());

const register = require('./backend/routes/user/register.js');
app.use('/api/register', register);

const confirmRegistration = require('./backend/routes/user/confirmRegistration.js');
app.use('/api/confirm_registration', confirmRegistration);

const login = require('./backend/routes/user/login.js');
app.use('/api/login', login);

const forgotPassword = require('./backend/routes/user/forgotPassword.js');
app.use('/api/forgot_password', forgotPassword);

const confirmPasswordReset = require('./backend/routes/user/confirmPasswordReset.js');
app.use('/api/confirm_password_reset', confirmPasswordReset);

const getProfile = require('./backend/routes/profile/getProfile');
app.use('/api/get_profile', getProfile);

const updateProfile = require('./backend/routes/profile/updateProfile');
app.use('/api/update_profile', updateProfile);

const createComment = require('./backend/routes/comment/createComment');
app.use('/api/create_comment', createComment);

const readRanking = require('./backend/routes/ranking/readRanking');
app.use('/api/read_ranking', readRanking);

const loadCaches = require('./backend/routes/cache/loadCaches.js');
app.use('/api/caches', loadCaches);

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


