const { verifyAccessToken } = require("../utils/cognito-utils");
// Middleware to verify the access token
async function verifyAccessTokenMiddleware(req, res, next) {
    if (process.env.ENVIRONMENT !== "test") {
      const { accessToken } = req.body;
      if (!accessToken) {
        return res.status(400).send({ message: 'Invalid request.' });
      }
  
      const userData = await verifyAccessToken(accessToken);
      if (!userData) {
        return res.status(403).send({ message: 'Session token unrecognized.' });
      }
  
      // Attach userData to the request object so it can be used in subsequent routes
      req.userData = userData;
    }
    next(); // Proceed to the next middleware or route handler
  }

module.exports = { verifyAccessTokenMiddleware };
