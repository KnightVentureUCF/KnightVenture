const AWS = require('aws-sdk');
const cognitoIdentityServiceProvider = new AWS.CognitoIdentityServiceProvider();
const admin = require('firebase-admin');
const db = admin.firestore();
const router = express.Router();


// Initialize Firebase Admin
const admin = require('firebase-admin');
const serviceAccount = require('./service-account-file.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.FIREBASE_DATABASE_URL,
});

// Get Profile endpoint
router('/', async (req, res) => {
  const { accessToken } = req.body;

  const params = {
    AccessToken: accessToken,
  };

  cognitoIdentityServiceProvider.getUser(params, async (err, data) => {
    if (err) {
      console.error(err);
      res.status(403).send({ message: 'Session token unrecognized.' });
    } else {
      try {
        const userId = data.Username;
        const userDoc = await db.collection('users').doc(userId).get();
        if (!userDoc.exists) {
          res.status(404).send({ message: 'Profile not found.' });
        } else {
          res.status(200).send({
            message: 'Profile data found successfully.',
            ...userDoc.data(),
          });
        }
      } catch (dbErr) {
        console.error(dbErr);
        res
          .status(500)
          .send({
            message: 'An error occurred on the server. Please try again later.',
          });
      }
    }
  });
});
