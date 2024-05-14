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

// Middleware to parse JSON bodies
const bodyParser = require('body-parser');
app.use(bodyParser.json());

const register = require('./routes/user/register.js');
app.use('/api', register);

const confirm_registration = require('./routes/user/confirmRegistration.js');
app.use('/api', confirm_registration);

const login = require('./routes/user/login.js');
app.use('/api', login);

const forgot_password = require('./routes/user/forgotPassword.js');
app.use('/api', forgot_password);

const confirm_password_reset = require('./routes/user/confirmPasswordReset.js');
app.use('/api', confirm_password_reset);

const get_profile = require('./routes/profile/getProfile');
app.use('/api', get_profile);

const update_profile = require('./routes/profile/updateProfile');
app.use('/api', update_profile);

const create_comment = require('./routes/comment/createComment');
app.use('/api', create_comment);

const read_ranking = require('./routes/ranking/readRanking');
app.use('/api', read_ranking);

const load_caches = require('./routes/cache/loadCaches.js');
app.use('/api', load_caches);

module.exports = app;

