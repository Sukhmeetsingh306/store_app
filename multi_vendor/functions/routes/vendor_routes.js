import express from "express";
import Vendor from "../models/vendor.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

const vendorRouter = express.Router();

// Route: POST /vendor/signup
vendorRouter.post("/vendor/signup", async (req, res) => {
  try {
    const { name, email, password, phone, age, image } = req.body;

    // Validate required fields
    if (!name || !email || !password || !phone || !age) {
      return res.status(400).json({
        message: "All fields are required: name, email, password, phone, age.",
      });
    }

    // Check if vendor already exists
    const existingVendor = await Vendor.findOne({ email });
    if (existingVendor) {
      return res.status(400).json({ message: "Vendor already exists." });
    }

    // Hash password
    const salt = await bcrypt.genSalt(12);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create new vendor
    const newVendor = new Vendor({
      name,
      email,
      password: hashedPassword,
      phone,
      age,
      image: image ?? null, // Optional image
    });

    await newVendor.save();

    return res.status(201).json({
      message: "Vendor registered successfully.",
      vendor: {
        id: newVendor._id,
        name: newVendor.name,
        email: newVendor.email,
        phone: newVendor.phone,
        age: newVendor.age,
        image: newVendor.image,
      },
    });
  } catch (err) {
    console.error("Error in /vendor/signup:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// Signin Route
vendorRouter.post("/vendor/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validate input
    if (!email || !password) {
      return res
        .status(400)
        .json({ message: "Both email and password are required." });
    }

    // Find Vendor by email
    const findVendor = await Vendor.findOne({ email });
    if (!findVendor) {
      return res.status(400).json({ message: "Invalid email or password." });
    }

    // Compare passwords
    const isMatch = await bcrypt.compare(password, findVendor.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid email or password." });
    }

    // Generate JWT token
    const token = jwt.sign(
      {
        id: findVendor._id,
        isSeller: findVendor.isSeller || false, // in case not set
      },
      process.env.JWT_SECRET || "default_jwt_secret", // fallback for dev
      {
        expiresIn: "1h",
      }
    );

    // Remove password before sending response
    const { password: _, ...vendorWithoutPassword } = findVendor._doc;

    return res.status(200).json({
      message: "Login successful.",
      token,
      user: vendorWithoutPassword, // renamed to "user" for consistency
    });
  } catch (err) {
    console.error("Error in /vendor/signin:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
});

export { vendorRouter };
