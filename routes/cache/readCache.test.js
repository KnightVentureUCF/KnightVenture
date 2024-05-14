const supertest = require('supertest');
const app = require('../../app.js');
require('dotenv').config();
const describeIfTest = process.env.ENVIRONMENT === 'test' ? describe : describe.skip;

describeIfTest('POST /api/read_cache', () => {
    it('should connect to the server', async () => {
        expect.assertions(1);
        const response = await supertest(app).post("/api/read_cache").send({
            cacheID: "test"
        });
        expect([200, 404, 500]).toContain(response.statusCode);
    });
})