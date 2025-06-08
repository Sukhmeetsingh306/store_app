import express from "express";
import Seller from "../models/seller.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

const sellerRouter = express.Router();

// Route: POST /seller/signup
sellerRouter.post("/seller/signup", async (req, res) => {
  try {
    const { name, email, password, phone, age, image } = req.body;

    // Validate required fields
    if (!name || !email || !password || !phone || !age) {
      return res.status(400).json({
        message: "All fields are required: name, email, password, phone, age.",
      });
    }

    // Check if seller already exists
    const existingSeller = await Seller.findOne({ email });
    if (existingSeller) {
      return res.status(400).json({ message: "Seller already exists." });
    }

    // Hash password
    const salt = await bcrypt.genSalt(12);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create new Seller
    const newSeller = new Seller({
      name,
      email,
      password: hashedPassword,
      phone,
      age,
      image: image ?? null, // Optional image
    });

    await newSeller.save();

    return res.status(201).json({
      message: "Seller registered successfully.",
      Seller: {
        id: newSeller._id,
        name: newSeller.name,
        email: newSeller.email,
        phone: newSeller.phone,
        age: newSeller.age,
        image: newSeller.image,
      },
    });
  } catch (err) {
    console.error("Error in /Seller/signup:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// Signin Route
sellerRouter.post("/seller/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validate input
    if (!email || !password) {
      return res
        .status(400)
        .json({ message: "Both email and password are required." });
    }

    // Find seller by email
    const findSeller = await Seller.findOne({ email });
    if (!findSeller) {
      return res.status(400).json({ message: "Invalid email or password." });
    }

    // Compare passwords
    const isMatch = await bcrypt.compare(password, findSeller.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid email or password." });
    }

    // Generate JWT token
    const token = jwt.sign(
      {
        id: findSeller._id,
        isSeller: findSeller.isSeller || false, // in case not set
      },
      process.env.JWT_SECRET || "default_jwt_secret", // fallback for dev
      {
        expiresIn: "1h",
      }
    );

    // Remove password before sending response
    const { password: _, ...sellerWithoutPassword } = findSeller._doc;

    return res.status(200).json({
      message: "Login successful.",
      token,
      user: sellerWithoutPassword, // renamed to "user" for consistency
    });
  } catch (err) {
    console.error("Error in /seller/signin:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
});

export { sellerRouter };
