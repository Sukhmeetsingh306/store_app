import express from "express";
import { SubCategory } from "../models/subCategory_models.js";
import Category from "../models/category_models.js"; // Ensure this is imported

const subCategoryRouter = express.Router();

subCategoryRouter
  .route("/api/subCategory")
  .post(async (req, res) => {
    try {
      const { categoryId, categoryName, subCategoryImage, subCategoryName } =
        req.body;

      console.log("Request Body:", req.body);

      if (!categoryName || !subCategoryName) {
        return res.status(400).json({
          error: "Missing required fields: categoryName or subCategoryName",
        });
      }

      let resolvedCategoryId = categoryId;

      // Lookup categoryId if not provided
      if (!categoryId) {
        const category = await Category.findOne({ categoryName });
        if (!category) {
          return res.status(404).json({
            error: `Category with name "${categoryName}" not found`,
          });
        }
        resolvedCategoryId = category._id;
      }

      const newSubCategory = new SubCategory({
        categoryId: resolvedCategoryId,
        categoryName,
        subCategoryImage,
        subCategoryName,
      });

      console.log("Creating SubCategory...");
      await newSubCategory.save();
      console.log("SubCategory saved successfully:", newSubCategory);

      return res.status(201).json(newSubCategory);
    } catch (e) {
      console.error("Error in creating SubCategory:", e.errors || e.message);
      return res.status(400).json({ error: e.message });
    }
  })

  .get(async (req, res) => {
    try {
      const subCategories = await SubCategory.find();
      console.log("Subcategories", subCategories, "success in get");
      return res.status(200).json(subCategories);
    } catch (e) {
      console.log("Error in getting subcategories", e);
      return res.status(400).json({ error: e.message });
    }
  });

subCategoryRouter
  .route("/api/category/:categoryName/subCategories")
  .get(async (req, res) => {
    const { categoryName } = req.params;
    try {
      const subCategories = await SubCategory.find({ categoryName });

      if (!subCategories || subCategories.length === 0) {
        return res.status(404).json({
          message: `No subcategories found for category ${categoryName}`,
        });
      } else {
        console.log("Subcategories of", categoryName, "are", subCategories);
        return res.status(200).json(subCategories);
      }
    } catch (e) {
      console.log(
        "Error in getting subcategories for category",
        categoryName,
        e
      );
      return res.status(400).json({ error: e.message });
    }
  });

export { subCategoryRouter };
