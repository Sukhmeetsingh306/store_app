import express from "express";
import { SubCategory } from "../models/subCategory_models.js";

const subCategoryRouter = express.Router();

subCategoryRouter
  .route("/api/subCategory")
  .post(async (req, res) => {
    try {
      const { categoryId, categoryName, subCategoryImage, subCategoryName } =
        req.body;
      const newSubCategory = new SubCategory({
        categoryId,
        categoryName,
        subCategoryImage,
        subCategoryName,
      });
      await newSubCategory.save();
      console.log("SubCategory", newSubCategory, "saved successfully");
      return res.status(201).json(newSubCategory);
    } catch (e) {
      console.log("Error in creating SubCategory", e);
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

// Create a this get request here as this is working on the same category as the adding the category
subCategoryRouter
  .route("/api/category/:categoryName/subCategories")
  .get(async (req, res) => {
    const { categoryName } = req.params;
    try {
      const subCategories = await SubCategory.find({ categoryName });

      if (!subCategories || subCategories.length == 0) {
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
