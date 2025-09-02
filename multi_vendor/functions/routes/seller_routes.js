import express from "express";
import Seller from "../models/seller.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

const sellerRouter = express.Router();

// Seller signup
sellerRouter.post("/seller/signup", async (req, res) => {
  try {
    const { name, email, password, phone, age, image } = req.body;
    if (!name || !email || !password || !phone || !age) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const existingSeller = await Seller.findOne({ email });
    if (existingSeller)
      return res.status(400).json({ message: "Seller already exists." });

    const hashedPassword = await bcrypt.hash(password, 12);

    const newSeller = new Seller({
      name,
      email,
      password: hashedPassword,
      phone,
      age,
      image: image ?? null,
      roles: ["seller", "consumer"],
    });

    await newSeller.save();

    return res.status(201).json({
      message: "Seller registered successfully.",
      seller: {
        id: newSeller._id,
        name: newSeller.name,
        email: newSeller.email,
        phone: newSeller.phone,
        age: newSeller.age,
        image: newSeller.image,
        roles: newSeller.roles,
      },
    });
  } catch (err) {
    console.error("Error in /seller/signup:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// Seller signin
sellerRouter.post("/seller/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password)
      return res
        .status(400)
        .json({ message: "Both email and password are required." });

    const findSeller = await Seller.findOne({ email });
    if (!findSeller)
      return res.status(400).json({ message: "Invalid email or password." });

    const isMatch = await bcrypt.compare(password, findSeller.password);
    if (!isMatch)
      return res.status(400).json({ message: "Invalid email or password." });

    // 🔹 Include name, roles in JWT
    const token = jwt.sign(
      {
        id: findSeller._id,
        name: findSeller.name,
        roles: findSeller.roles,
        isSeller: true,
      },
      process.env.JWT_SECRET || "default_jwt_secret",
      { expiresIn: "1h" }
    );

    const { password: _, ...sellerWithoutPassword } = findSeller._doc;

    return res.status(200).json({
      message: "Login successful.",
      token,
      seller: sellerWithoutPassword,
    });
  } catch (err) {
    console.error("Error in /seller/signin:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
});

export { sellerRouter };
