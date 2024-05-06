require('dotenv').config();

const express = require('express');
const AWS = require('aws-sdk');
const bodyParser = require('body-parser');

// Initialize Express
const app = express();

// Configure AWS using environment variables
AWS.config.update({
    region: process.env.REGION,
});

// Create Cognito Client
const client = new AWS.CognitoIdentityServiceProvider({
    apiVersion: '2024-05-06',
    region: process.env.REGION
});

// Middleware to parse JSON bodies
app.use(bodyParser.json());

// Register endpoint
app.post('/register', (req, res) => {
    const { username, email, password } = req.body;
    const params = {
        ClientId: process.env.CLIENT_ID,
        Password: password,
        Username: username,
        UserAttributes: [
            {
                Name: 'email',
                Value: email
            },
        ],
    };

    client.signUp(params, (err, data) => {
        if (err) res.status(500).send(err);
        else res.send(data);
    });
});

// Confirm User Registration endpoint
app.post('/confirm-registration', (req, res) => {
    const { username, confirmationCode } = req.body;
    const params = {
        ClientId: process.env.CLIENT_ID,
        Username: username,
        ConfirmationCode: confirmationCode,
    };

    client.confirmSignUp(params, (err, data) => {
        if (err) {
            res.status(500).send(err.message);
        } else {
            res.send({ message: 'User registration confirmed.' });
        }
    });
});

// Login endpoint
app.post('/login', (req, res) => {
    const { username, password } = req.body;
    const params = {
        AuthFlow: 'USER_PASSWORD_AUTH',
        ClientId: process.env.CLIENT_ID,
        AuthParameters: {
            USERNAME: username,
            PASSWORD: password,
        },
    };

    client.initiateAuth(params, (err, authData) => {
        if (err) res.status(500).send(err);
        else res.send(authData);
    });
});

// Forgot Password endpoint
app.post('/forgot-password', (req, res) => {
    const { username } = req.body;
    const params = {
        ClientId: process.env.CLIENT_ID,
        Username: username,
    };

    client.forgotPassword(params, (err, data) => {
        if (err) {
            res.status(500).send(err.message);
        } else {
            res.send({ message: 'Password reset code sent to email.' });
        }
    });
});

// Confirm Password Reset endpoint
app.post('/confirm-password-reset', (req, res) => {
    const { username, code, newPassword } = req.body;
    const params = {
        ClientId: process.env.CLIENT_ID,
        ConfirmationCode: code,
        Password: newPassword,
        Username: username,
    };

    client.confirmForgotPassword(params, (err, data) => {
        if (err) {
            res.status(500).send(err.message);
        } else {
            res.send({ message: 'Password successfully reset.' });
        }
    });
});

// Listen on a port
app.listen(3000, () => {
    console.log('Server running on http://localhost:3000');
});
