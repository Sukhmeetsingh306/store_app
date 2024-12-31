import express from "express";
import { SubCategory } from "../models/subCategory_models.js";

const subCategoryRouter = express.Router();

subCategoryRouter.route("/api/subCategory").post(async (req, res) => {
  try {
    const { categoryId, categoryName, image, subCategoryName } = req.body;
    const newSubCategory = new SubCategory({
      categoryId,
      categoryName,
      image,
      subCategoryName,
    });
    await newSubCategory.save();
    console.log("SubCategory", newSubCategory, "saved successfully");
    return res.status(201).json(newSubCategory);
  } catch (e) {
    console.log("Error in creating SubCategory", e);
    return res.status(400).json({ error: e.message });
  }
});

export { subCategoryRouter };
