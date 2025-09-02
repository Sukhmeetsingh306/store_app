import express from "express";
import { Product } from "../models/product_models.js";
import Category from "../models/category_models.js";
import { sellerAuth } from "../middleware/auth.js";

const productRouter = express.Router();

productRouter.post("/seller/add-product", sellerAuth, async (req, res) => {
  try {
    console.log("🔹 Received add-product request:", req.body);

    const {
      productName,
      productPrice,
      productQuantity,
      productDescription,
      productCategory,
      productSubCategory,
      productImage,
    } = req.body;

    const sellerId = req.seller.id;
    const sellerName = req.seller.name;

    if (!sellerId || !sellerName) {
      console.log("❌ Seller info missing in request");
      return res.status(400).json({ error: "Seller info missing" });
    }

    const category = await Category.findOne({ categoryName: productCategory });
    if (!category) {
      console.log("❌ Invalid category:", productCategory);
      return res.status(400).json({ error: "Invalid category name" });
    }

    if (
      category.subCategories?.length > 0 &&
      (!productSubCategory || productSubCategory.trim() === "")
    ) {
      return res.status(400).json({ error: "Subcategory is required" });
    }

    const newProduct = new Product({
      productName,
      productPrice,
      productQuantity,
      productDescription,
      sellerId,
      sellerName,
      productCategory,
      productSubCategory: productSubCategory || null,
      productImage,
    });

    await newProduct.save();
    console.log("✅ Product saved successfully:", newProduct);

    return res.status(201).json(newProduct);
  } catch (e) {
    console.error("❌ Error creating product:", e);
    return res.status(400).json({ error: e.message });
  }
});

productRouter.get("/seller/popular-product", async (req, res) => {
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

productRouter.get("/seller/recommended-product", async (req, res) => {
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
