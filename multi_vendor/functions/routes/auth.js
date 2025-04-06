import express from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import User from "../models/authUserInfo.js";

dotenv.config();

const appAuthSignAndSignUp = express();

// Signup Route
appAuthSignAndSignUp.post("/signup", async (req, res) => {
  try {
    const { name, email, password, phone, age, image, isSeller } = req.body;

    // Validate required fields
    if (!name || !email || !password || !phone || !age) {
      return res.status(400).json({
        message: "All fields are required: name, email, password, phone, age.",
      });
    }

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists." });
    }

    // Hash password
    const salt = await bcrypt.genSalt(12);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create new user
    const newUser = new User({
      name,
      email,
      password: hashedPassword,
      phone,
      age,
      image: image, // Default avatar
      isSeller: isSeller || false,
    });

    await newUser.save();

    res.status(201).json({
      message: "User registered successfully.",
      user: {
        id: newUser._id,
        name: newUser.name,
        email: newUser.email,
        phone: newUser.phone,
        age: newUser.age,
        image: newUser.image,
        isSeller: newUser.isSeller,
      },
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Signin Route
appAuthSignAndSignUp.post("/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user by email
    const findUser = await User.findOne({ email });
    if (!findUser) {
      return res.status(400).json({ message: "Invalid email or password." });
    }

    // Compare passwords
    const isMatch = await bcrypt.compare(password, findUser.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid email or password." });
    }

    // Generate JWT token
    const token = jwt.sign(
      { id: findUser._id, isSeller: findUser.isSeller },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );

    const { password: _, ...userWithoutPassword } = findUser._doc;

    res.status(200).json({
      message: "Login successful.",
      token,
      user: userWithoutPassword,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

export { appAuthSignAndSignUp };
