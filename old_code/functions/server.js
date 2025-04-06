import express from "express";
import dotenv from "dotenv";
import mongoose from "mongoose";
import cors from "cors";
import { appAuthSign } from "./routes/auth.js";
import { bannerRouter } from "./routes/banner_routes.js";
import { categoryRouter } from "./routes/category_router.js";
import { subCategoryRouter } from "./routes/subCategory_routes.js";
import { productRouter } from "./routes/product_routes.js";
import { productRatingReviewRouter } from "./routes/rating_review_routes.js";

dotenv.config(); // Load .env variables

const app = express();

const port = process.env.PORT || 3400;
const uri = process.env.MONGODB_URI;

app.use(express.json());
app.use(cors()); // enable CORS for all routes
app.use(appAuthSign);
app.use(bannerRouter);
app.use(categoryRouter);
app.use(subCategoryRouter);
app.use(productRouter);
app.use(productRatingReviewRouter);

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
