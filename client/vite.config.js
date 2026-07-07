import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [react()],
    server: {
        hmr: {
            clientPort: 80,
        },
        proxy: {
            '/api': 'http://backend:3000',
        },
    },
});
