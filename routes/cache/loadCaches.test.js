const supertest = require('supertest');
const app = require('../../app.js');
require('dotenv').config();
const describeIfTest = process.env.ENVIRONMENT === 'test' ? describe : describe.skip;

describeIfTest('GET /api/load_caches', () => {
    it('should connect to the server', async () => {
        expect.assertions(1);
        const response = await supertest(app).get("/api/load_caches").send();
        expect([200, 500]).toContain(response.statusCode);
    });
})