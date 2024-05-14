const supertest = require('supertest');
const app = require('../../app.js');

describe('GET /api/load_caches', () => {
    it('should have status 200', async () => {
        expect.assertions(2);
        const response = await supertest(app).get("/api/load_caches").send();
        expect(response.statusCode).toBe(200);
        expect(response.body.caches).toEqual([]);
    });
})