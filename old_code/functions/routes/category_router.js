import express from "express";
import Category from "../models/category_models.js";

const categoryRouter = express.Router();

categoryRouter
  .route("/api/category")
  .post(async (req, res) => {
    try {
      const { categoryName, categoryImage, categoryBanner } = req.body;
      const category = new Category({
        categoryName,
        categoryImage,
        categoryBanner,
      });
      await category.save();
      console.log("category ", category, "success in post");
      return res.status(201).json(category);
    } catch (e) {
      console.log("error in category in post request" + e.message);
      return res.status(400).json({ error: e.message });
    }
  })

  .get(async (req, res) => {
    try {
      const category = await Category.find();
      console.log("category ", category, "success in get");
      return res.status(200).json(category);
    } catch (e) {
      console.log("error in category in get request");
      return res.status(400).json({ error: e.message });
    }
  });

export { categoryRouter };
