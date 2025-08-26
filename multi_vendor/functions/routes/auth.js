import express from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import User from "../models/userInf.js";
import Seller from "../models/seller.js";

dotenv.config();

const appAuthSignAndSignUp = express();

// ---------------- Signup Route ----------------
appAuthSignAndSignUp.post("/signup", async (req, res) => {
  try {
    const { name, email, password, phone, age, image } = req.body;

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

    // Create user with default role 'consumer'
    const newUser = new User({
      name,
      email,
      password: hashedPassword,
      phone,
      age,
      image: image ?? null,
      roles: ["consumer"], // default role
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
        roles: newUser.roles,
      },
    });
  } catch (err) {
    console.error("Error in /signup:", err);
    res.status(500).json({ message: "Internal server error" });
  }
});

// ---------------- Signin Route ----------------
appAuthSignAndSignUp.post("/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    let findUser = await User.findOne({ email });
    let isSellerLogin = false;

    if (!findUser) {
      findUser = await Seller.findOne({ email });
      if (findUser) isSellerLogin = true;
    }

    if (!findUser) {
      return res.status(400).json({ message: "Invalid email or password." });
    }

    const isMatch = await bcrypt.compare(password, findUser.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid email or password." });
    }

    const roles = isSellerLogin ? ["seller"] : ["consumer"];

    const token = jwt.sign(
      { id: findUser._id, roles },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );

    const { password: _, ...userWithoutPassword } = findUser._doc;

    return res.status(200).json({
      message: "Login successful.",
      token,
      user: { ...userWithoutPassword, roles },
    });
  } catch (err) {
    console.error("Error in /signin:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
});

export { appAuthSignAndSignUp };
