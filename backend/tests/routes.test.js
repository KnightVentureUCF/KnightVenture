const supertest = require('supertest');
const { app, server } = require('../../server.js');
require('dotenv').config();
const describeIfTest = process.env.ENVIRONMENT === 'test' ? describe : describe.skip;

describeIfTest('API Tests', () => {
    beforeEach(() => {
        // Ensure that the server is not running before starting a new test
        if (server.listening) {
            server.close();
        }
    });

    afterEach(() => {
        // Close the server after each test
        if (server.listening) {
            server.close();
        }
    });

    describe('Cache API Tests', () => {
    it('should connect to the server on /api/load_caches', async () => {
        expect.assertions(1);
        const response = await supertest(app).post("/api/load_caches").send();
        expect([200, 500]).toContain(response.statusCode);
    });

    it('should connect to the server on /api/read_cache', async () => {
        expect.assertions(1);
        const response = await supertest(app).post("/api/read_cache").send({
            cacheID: "test"
        });
        expect([200, 404, 500]).toContain(response.statusCode);
    });
});
});
