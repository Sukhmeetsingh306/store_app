import express from "express";
import { Product } from "../models/product_models.js";

const productRouter = express.Router();

productRouter.post("/api/add-product", async (req, res) => {
  try {
    const {
      productName,
      productPrice,
      productQuantity,
      productDescription,
      productCategory,
      productSubCategory,
      productImage,
    } = req.body;
    const newProduct = new Product({
      productName,
      productPrice,
      productQuantity,
      productDescription,
      productCategory,
      productSubCategory,
      productImage,
    });
    await newProduct.save();
    console.log("Product", newProduct, "saved successfully");
    return res.status(201).json(newProduct);
  } catch (e) {
    console.log("Error in creating product", e);
    return res.status(400).json({ error: e.message });
  }
});

export { productRouter };
