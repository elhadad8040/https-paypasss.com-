const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

// Load env vars
dotenv.config();

const app = express();

// CORS configuration
app.use(cors({
  origin: ['http://localhost:3000', 'http://localhost:8080', 'http://localhost:5000', 'https://paypass-app.vercel.app', 'https://paypass-app-git-main.vercel.app'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
}));

app.use(express.json());

// Simple test route
app.get('/', (req, res) => {
  res.json({ 
    message: 'PayPass Backend is running!',
    status: 'success',
    timestamp: '2025-07-28T04:22:21.148Z'
  });
});

// Test API route
app.get('/api/test', (req, res) => {
  res.json({ 
    message: 'API is working!',
    endpoints: {
      packages: '/api/packages',
      washingPlaces: '/api/washing-places',
      users: '/api/users'
    }
  });
});

// Mock data routes for testing
app.get('/api/packages', (req, res) => {
  res.json([
    {
      id: 1,
      name: 'Basic Wash - Small Car',
      basePrice: 25.00,
      originalPrice: 30.00,
      features: ['Exterior wash', 'Interior vacuum', 'Window cleaning'],
      popular: false,
      washes: 1,
      savings: 5.00,
      duration: 30,
      size: 'small'
    },
    {
      id: 2,
      name: 'Premium Package - Small Car',
      basePrice: 45.00,
      originalPrice: 55.00,
      features: ['Exterior wash', 'Interior deep clean', 'Waxing', 'Tire shine'],
      popular: true,
      washes: 1,
      savings: 10.00,
      duration: 30,
      size: 'small'
    }
  ]);
});

app.get('/api/washing-places', (req, res) => {
  res.json([
    {
      id: 1,
      name: 'Clean Car Center - Downtown',
      address: '123 Main Street, Downtown',
      phone: '+966501234567',
      hours: '8:00 AM - 10:00 PM',
      email: 'info@cleancar.com',
      city: 'Riyadh',
      rating: 4.5,
      customers: 150
    }
  ]);
});

// API Routes
app.use('/api', require('./routes/index'));

// Test API routes for development
app.get('/api/test', (req, res) => {
  res.json({ 
    message: 'API is working!',
    endpoints: {
      packages: '/api/packages',
      washingPlaces: '/api/washing-places',
      users: '/api/users',
      cars: '/api/cars',
      washes: '/api/washes'
    }
  });
});

// Error handler
app.use((err, req, res, next) => {
  res.status(500).json({ error: err.message });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`🚀 PayPass Backend running on port ${PORT}`);
  console.log(`📱 Test the API: https://https-paypasss-com.vercel.app/api/test`);
  console.log(`📦 Packages: https://https-paypasss-com.vercel.app/api/packages`);
  console.log(`🏪 Washing Places: https://https-paypasss-com.vercel.app/api/washing-places`);
  console.log(`⚠️  Running in TEST MODE without database`);
}); 