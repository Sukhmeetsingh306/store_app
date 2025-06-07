import express from "express";
import Vendor from "../models/vendor.js";
import bcrypt from "bcrypt";

const vendorRouter = express.Router();

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
      image: image,
    });

    await newVendor.save();

    res.status(201).json({
      message: "Vendor registered successfully.",
      Vendor: {
        id: newVendor._id,
        name: newVendor.name,
        email: newVendor.email,
        phone: newVendor.phone,
        age: newVendor.age,
        image: newVendor.image,
      },
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

export { vendorRouter };
