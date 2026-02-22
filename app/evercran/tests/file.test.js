import { jest, describe, beforeEach, it, expect, beforeAll } from '@jest/globals';

// Mock pool before importing anything that uses it
const mockQuery = jest.fn();
await jest.unstable_mockModule('../lib/pool.js', () => ({
    default: {
        query: mockQuery,
    },
}));

// Now import the modules that use pool
const { default: request } = await import('supertest');
const { default: express } = await import('express');
const { default: fileRouter } = await import('../routes/file.js');

describe('File Routes', () => {
    let app;

    beforeAll(() => {
        // Create Express app once
        app = express();
        app.use('/', fileRouter);
    });

    beforeEach(() => {
        // Reset all mocks before each test
        jest.clearAllMocks();
    });

    describe('GET /:year/:month/:day/src/contrib/Archive/:package/:filename', () => {
        it('should redirect to CRAN archive for valid package file', async () => {
            const response = await request(app)
                .get('/2024/02/15/src/contrib/Archive/dplyr/dplyr_1.0.0.tar.gz')
                .expect(302);

            expect(response.headers.location).toBe(
                'http://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_1.0.0.tar.gz'
            );
        });

        it('should redirect to HTTPS mirror when x-forwarded-proto is https', async () => {
            const response = await request(app)
                .get('/2024/02/15/src/contrib/Archive/dplyr/dplyr_1.0.0.tar.gz')
                .set('x-forwarded-proto', 'https')
                .expect(302);

            expect(response.headers.location).toBe(
                'https://cran.rstudio.com/src/contrib/Archive/dplyr/dplyr_1.0.0.tar.gz'
            );
        });

        it('should not match invalid filename format', async () => {
            await request(app)
                .get('/2024/02/15/src/contrib/Archive/dplyr/invalid-file.txt')
                .expect(404);
        });

        it('should not match when package name differs from path', async () => {
            await request(app)
                .get('/2024/02/15/src/contrib/Archive/dplyr/ggplot2_1.0.0.tar.gz')
                .expect(404);
        });
    });

    describe('GET /:year/:month/:day/src/contrib/:filename', () => {
        it('should redirect to current package path when package is current', async () => {
            mockQuery.mockResolvedValue({
                rowCount: 1,
                rows: [{ package: 'dplyr', version: '1.0.0', current: true }]
            });

            const response = await request(app)
                .get('/2024/02/15/src/contrib/dplyr_1.0.0.tar.gz')
                .expect(302);

            expect(response.headers.location).toBe(
                'http://cran.r-project.org/src/contrib//dplyr_1.0.0.tar.gz'
            );

            // Verify database query
            expect(mockQuery).toHaveBeenCalledWith(
                expect.stringContaining('SELECT package, version, current'),
                ['dplyr', '1.0.0']
            );
        });

        it('should redirect to archive path when package is not current', async () => {
            mockQuery.mockResolvedValue({
                rowCount: 1,
                rows: [{ package: 'dplyr', version: '0.8.0', current: false }]
            });

            const response = await request(app)
                .get('/2024/02/15/src/contrib/dplyr_0.8.0.tar.gz')
                .expect(302);

            expect(response.headers.location).toBe(
                'http://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_0.8.0.tar.gz'
            );
        });

        it('should redirect to root path when package not in database', async () => {
            mockQuery.mockResolvedValue({
                rowCount: 0,
                rows: []
            });

            const response = await request(app)
                .get('/2024/02/15/src/contrib/newpackage_1.0.0.tar.gz')
                .expect(302);

            expect(response.headers.location).toBe(
                'http://cran.r-project.org/src/contrib//newpackage_1.0.0.tar.gz'
            );
        });

        it('should use HTTPS mirror when x-forwarded-proto is https', async () => {
            mockQuery.mockResolvedValue({
                rowCount: 1,
                rows: [{ package: 'dplyr', version: '1.0.0', current: true }]
            });

            const response = await request(app)
                .get('/2024/02/15/src/contrib/dplyr_1.0.0.tar.gz')
                .set('x-forwarded-proto', 'https')
                .expect(302);

            expect(response.headers.location).toBe(
                'https://cran.rstudio.com/src/contrib//dplyr_1.0.0.tar.gz'
            );
        });

        it('should not match invalid filename format', async () => {
            await request(app)
                .get('/2024/02/15/src/contrib/invalid-file.txt')
                .expect(404);

            // Database should not be queried for invalid filename
            expect(mockQuery).not.toHaveBeenCalled();
        });

        it('should handle package names with numbers', async () => {
            mockQuery.mockResolvedValue({
                rowCount: 1,
                rows: [{ package: 'R6', version: '2.5.0', current: true }]
            });

            const response = await request(app)
                .get('/2024/02/15/src/contrib/R6_2.5.0.tar.gz')
                .expect(302);

            expect(response.headers.location).toBe(
                'http://cran.r-project.org/src/contrib//R6_2.5.0.tar.gz'
            );
        });

        it('should handle version strings with multiple dots and hyphens', async () => {
            mockQuery.mockResolvedValue({
                rowCount: 1,
                rows: [{ package: 'dplyr', version: '1.0.0-1', current: false }]
            });

            const response = await request(app)
                .get('/2024/02/15/src/contrib/dplyr_1.0.0-1.tar.gz')
                .expect(302);

            expect(response.headers.location).toBe(
                'http://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_1.0.0-1.tar.gz'
            );
        });
    });
});
