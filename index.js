const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

// Load env vars
dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// Simple test route
app.get('/', (req, res) => {
  res.json({ 
    message: 'PayPass Backend is running!',
    status: 'success',
    timestamp: new Date().toISOString()
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

// Routes (commented out until database is connected)
// app.use('/api', require('./routes/index'));

// Error handler
app.use((err, req, res, next) => {
  res.status(500).json({ error: err.message });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`🚀 PayPass Backend running on port ${PORT}`);
  console.log(`📱 Test the API: http://localhost:${PORT}/api/test`);
  console.log(`📦 Packages: http://localhost:${PORT}/api/packages`);
  console.log(`🏪 Washing Places: http://localhost:${PORT}/api/washing-places`);
  console.log(`⚠️  Running in TEST MODE without database`);
}); 