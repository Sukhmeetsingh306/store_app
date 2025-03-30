import express from "express";
import dotenv from "dotenv";
import mongoose from "mongoose";
import cors from "cors";

dotenv.config(); // Load .env variables

const app = express();

const port = process.env.PORT || 3000;
const uri = process.env.MONGODB_URI;

app.use(express.json());
app.use(cors()); // enable CORS for all routes

if (!uri) {
  console.error("MongoDB URI is not defined. Please check your .env file.");
  process.exit(1);
}

// MongoDB connection function
const connectDB = async () => {
  try {
    await mongoose.connect(uri);
    console.log("Connected to MongoDB");
  } catch (err) {
    console.error("Error connecting to MongoDB:", err);
    process.exit(1);
  }
};

app.route("/").get((req, res) => {
  res.send("Welcome to my page!");
});

const main = async () => {
  await connectDB();
  app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
  });
};

main();
