const AWS = require('aws-sdk');
const cognitoIdentityServiceProvider = new AWS.CognitoIdentityServiceProvider({
  region: process.env.REGION, // Make sure to set the region
  apiVersion: '2024-05-06',
});

async function verifyAccessToken(accessToken) {
  const params = {
    AccessToken: accessToken,
  };
  try {
    const response = await cognitoIdentityServiceProvider
      .getUser(params)
      .promise();
    return response; // This response includes the username and other user attributes
  } catch (error) {
    console.error('Error verifying access token:', error);
    return null;
  }
}

module.exports = { verifyAccessToken };
