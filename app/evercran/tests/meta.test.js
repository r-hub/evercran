import { jest, describe, beforeEach, it, expect, beforeAll } from '@jest/globals';
import { Readable } from 'stream';
import zlib from 'node:zlib';

// Mock fs before importing anything that uses it
const mockCreateReadStream = jest.fn();
await jest.unstable_mockModule('fs', () => ({
    default: {
        createReadStream: mockCreateReadStream,
    },
    createReadStream: mockCreateReadStream,
}));

// Now import the modules that use fs
const { default: request } = await import('supertest');
const { default: express } = await import('express');
const { default: metaRouter } = await import('../routes/meta.js');

describe('Meta Routes', () => {
    let app;

    beforeAll(() => {
        // Create Express app once
        app = express();
        app.use('/', metaRouter);
    });

    beforeEach(() => {
        // Reset all mocks before each test
        jest.clearAllMocks();
    });

    describe('GET /yesterday/src/contrib/PACKAGES.gz', () => {
        it('should serve the gzipped PACKAGES file from two days ago', async () => {
            // Calculate date from two days ago
            const twoDaysAgo = new Date();
            twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);

            const year = twoDaysAgo.getFullYear();
            const month = String(twoDaysAgo.getMonth() + 1).padStart(2, '0');
            const day = String(twoDaysAgo.getDate()).padStart(2, '0');

            const expectedPath = `/packages/${year}/${month}/${day}/src/contrib/PACKAGES.gz`;

            // Mock file content
            const mockContent = Buffer.from('Package: test\nVersion: 1.0.0\n');
            const mockStream = Readable.from([mockContent]);

            mockCreateReadStream.mockReturnValue(mockStream);

            await request(app)
                .get('/yesterday/src/contrib/PACKAGES.gz')
                .expect(200)
                .expect('Content-Type', /application\/gzip/);

            // Verify fs.createReadStream was called with the correct path
            expect(mockCreateReadStream).toHaveBeenCalledWith(expectedPath);
        });
    });

    describe('GET /yesterday/src/contrib/PACKAGES', () => {
        it('should serve the decompressed PACKAGES file from two days ago', async () => {
            // Calculate date from two days ago
            const twoDaysAgo = new Date();
            twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);

            const year = twoDaysAgo.getFullYear();
            const month = String(twoDaysAgo.getMonth() + 1).padStart(2, '0');
            const day = String(twoDaysAgo.getDate()).padStart(2, '0');

            const expectedPath = `/packages/${year}/${month}/${day}/src/contrib/PACKAGES.gz`;

            // Create mock gzipped content
            const originalContent = 'Package: test\nVersion: 1.0.0\n';
            const gzippedContent = zlib.gzipSync(originalContent);
            const mockStream = Readable.from([gzippedContent]);

            mockCreateReadStream.mockReturnValue(mockStream);

            const response = await request(app)
                .get('/yesterday/src/contrib/PACKAGES')
                .expect(200)
                .expect('Content-Type', /text\/plain/);

            // Verify fs.createReadStream was called with the correct path
            expect(mockCreateReadStream).toHaveBeenCalledWith(expectedPath);

            // Verify content was decompressed
            expect(response.text).toBe(originalContent);
        });
    });

    describe('GET /:year/:month/:day/src/contrib/PACKAGES', () => {
        it('should serve the decompressed PACKAGES file for a specific date', async () => {
            const year = '2024';
            const month = '02';
            const day = '15';

            const expectedPath = `/packages/${year}/${month}/${day}/src/contrib/PACKAGES.gz`;

            // Create mock gzipped content
            const originalContent = 'Package: example\nVersion: 2.0.0\n';
            const gzippedContent = zlib.gzipSync(originalContent);
            const mockStream = Readable.from([gzippedContent]);

            mockCreateReadStream.mockReturnValue(mockStream);

            const response = await request(app)
                .get(`/${year}/${month}/${day}/src/contrib/PACKAGES`)
                .expect(200)
                .expect('Content-Type', /text\/plain/);

            // Verify fs.createReadStream was called with the correct path
            expect(mockCreateReadStream).toHaveBeenCalledWith(expectedPath);

            // Verify content was decompressed
            expect(response.text).toBe(originalContent);
        });
    });
});
