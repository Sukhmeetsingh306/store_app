import express from 'express';
import dotenv from 'dotenv';
import mongoose from 'mongoose';
import { homeRoute } from './routes/home.js';

dotenv.config(); // Load .env variables

const app = express();

const port = process.env.PORT || 3000;
const uri = process.env.MONGODB_URI;

if (!uri) {
  console.error('MongoDB URI is not defined. Please check your .env file.');
  process.exit(1);
}

// MongoDB connection function
const connectDB = async () => {
  try {
    await mongoose.connect(uri);
    console.log('Connected to MongoDB');
  } catch (err) {
    console.error('Error connecting to MongoDB:', err);
    process.exit(1);
  }
};

app.use(homeRoute);

const main = async () => {
  await connectDB();
  app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
  });
};

main();
