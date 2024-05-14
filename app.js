const express = require('express');
const AWS = require('aws-sdk');
const admin = require('firebase-admin');
// TODO: Switch this to use the knightventure firestore
const serviceAccount = require('./firestorePrivateKey.json');
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

const express = require('express');
const AWS = require('aws-sdk');
const admin = require('firebase-admin');
const serviceAccount = require('./firestorePrivateKey.json');

// Middleware to parse JSON bodies
const bodyParser = require('body-parser');
app.use(bodyParser.json());

const register = require('./routes/user/register.js');
app.use('/api/register', register);

const confirmRegistration = require('./routes/user/confirmRegistration.js');
app.use('/api/confirm_registration', confirmRegistration);

const login = require('./routes/user/login.js');
app.use('/api/login', login);

const forgotPassword = require('./routes/user/forgotPassword.js');
app.use('/api/forgot_password', forgotPassword);

const confirmPasswordReset = require('./routes/user/confirmPasswordReset.js');
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
app.use('/api/load_caches', loadCaches);

module.exports = app;

