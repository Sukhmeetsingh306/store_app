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

productRouter.get("/api/popular-product", async (req, res) => {
  try {
    const popularProducts = await Product.find({ productPopularity: true });
    if (!popularProducts || popularProducts.length == 0) {
      console.log("No popular products");
      return res.status(404).json({
        message: "No popular products found",
      });
    } else {
      console.log("Popular Products are", popularProducts);
      return res.status(200).json(popularProducts);
    }
  } catch (e) {
    console.log("Error in getting popular products", e);
    return res.status(400).json({ error: e.message });
  }
});

productRouter.get("/api/recommended-product", async (req, res) => {
  try {
    const recommendedProducts = await Product.find({
      productRecommended: true,
    });
    if (!recommendedProducts || recommendedProducts.length == 0) {
      console.log("No recommended products");
      return res.status(404).json({
        message: "No recommended products found",
      });
    } else {
      console.log("Recommended Products are", recommendedProducts);
      return res.status(200).json(recommendedProducts);
    }
  } catch (e) {
    console.log("Error in getting recommended products", e);
    return res.status(400).json({ error: e.message });
  }
});

export { productRouter };
