# PayPass Backend - MySQL Version

Backend API for car washing service built with Node.js, Express, and MySQL.

## 🚀 Features

- **User Management**: Registration, login, profile management
- **Car Management**: Add, edit, delete cars with size classification
- **Package System**: Different wash packages with pricing
- **QR Code System**: Generate and scan QR codes for washes
- **Payment Processing**: Handle payments and tips
- **Feedback System**: Rate washes and provide feedback
- **Firebase Authentication**: Phone-based authentication
- **Referral System**: User referral tracking
- **Notifications**: SMS and push notifications

## 🛠️ Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js v5.1.0
- **Database**: MySQL with Sequelize ORM
- **Authentication**: JWT + Firebase Auth
- **External Services**: 
  - Firebase Admin SDK
  - Twilio (SMS)
  - Google Auth
  - Apple Sign-in

## 📋 Prerequisites

- Node.js (v14 or higher)
- MySQL (v8.0 or higher)
- npm or yarn

## 🔧 Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd paypass-backend-main
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   Create a `.env` file in the root directory:
   ```env
   # Database Configuration
   DB_HOST=localhost
   DB_PORT=3306
   DB_NAME=paypass_db
   DB_USER=root
   DB_PASSWORD=your_password

   # JWT Secret
   JWT_SECRET=your_jwt_secret_key_here

   # Firebase Configuration
   FIREBASE_PROJECT_ID=paypass-5c24f

   # Twilio Configuration
   TWILIO_ACCOUNT_SID=your_twilio_account_sid
   TWILIO_AUTH_TOKEN=your_twilio_auth_token
   TWILIO_PHONE=your_twilio_phone_number

   # App Configuration
   PORT=5000
   NODE_ENV=development
   APP_URL=http://localhost:3000
   ```

4. **Create MySQL database**
   ```sql
   CREATE DATABASE paypass_db;
   ```

5. **Run the application**
   ```bash
   # Development mode
   npm run dev

   # Production mode
   npm start
   ```

## 🗄️ Database Schema

The application automatically creates the following tables:

- **users**: User accounts and profiles
- **cars**: User's cars with size classification
- **packages**: Available wash packages
- **user_packages**: User's purchased packages
- **washing_places**: Car wash locations
- **washes**: Wash history and records
- **payments**: Payment transactions
- **feedbacks**: User feedback and ratings
- **notifications**: System notifications
- **referrals**: User referral tracking

## 📡 API Endpoints

### Authentication
- `POST /api/users/register` - User registration
- `POST /api/users/login` - User login
- `POST /api/users/phone-login-initiate` - Initiate phone login
- `POST /api/users/phone-login-verify` - Verify phone login
- `POST /api/users/phone-signup-initiate` - Initiate phone signup
- `POST /api/users/phone-signup-verify` - Verify phone signup

### User Management
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile
- `DELETE /api/users/profile` - Delete user account

### Cars
- `GET /api/cars` - Get user's cars
- `POST /api/cars` - Add new car
- `PUT /api/cars/:id` - Update car
- `DELETE /api/cars/:id` - Delete car

### Packages
- `GET /api/packages` - Get available packages
- `POST /api/packages` - Create new package (admin)
- `PUT /api/packages/:id` - Update package (admin)
- `DELETE /api/packages/:id` - Delete package (admin)

### User Packages
- `GET /api/user-packages` - Get user's packages
- `POST /api/user-packages` - Purchase package
- `POST /api/user-packages/scan` - Scan QR code

### Washing Places
- `GET /api/washing-places` - Get washing places
- `POST /api/washing-places` - Add washing place (admin)

### Washes
- `GET /api/washes` - Get wash history
- `POST /api/washes` - Create wash record

### Payments
- `GET /api/payments` - Get payment history
- `POST /api/payments` - Process payment

### Feedback
- `GET /api/feedbacks` - Get feedback
- `POST /api/feedbacks` - Submit feedback

## 🔐 Authentication

The API uses JWT tokens for authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your_jwt_token>
```

## 📱 Firebase Integration

The application integrates with Firebase for:
- Phone number authentication
- Push notifications
- User management

## 🚀 Deployment

### Vercel Deployment
The project is configured for Vercel deployment with `vercel.json`.

### Environment Variables
Make sure to set all required environment variables in your deployment platform.

## 📝 License

This project is licensed under the ISC License.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 Support

For support, email support@paypass.com or create an issue in the repository. 