require('dotenv').config();
const express = require('express');
const AWS = require('aws-sdk');

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

// Confiure Firebase
const admin = require('firebase-admin');
const serviceAccount = require('./firebasePrivateKey.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.FIREBASE_DATABASE_URL,
});
// const dtb = admin.firestore();

// Middleware to parse JSON bodies
const bodyParser = require('body-parser');
app.use(bodyParser.json());

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

// Listen on a port
app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
