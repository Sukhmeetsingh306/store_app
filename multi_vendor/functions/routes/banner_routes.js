import express from "express";
import Banner from "../models/banner_models.js";

const bannerRouter = express.Router();

bannerRouter
  .route("/api/banner")
  .post(async (req, res) => {
    try {
      const { bannerImage } = req.body;
      const banner = new Banner({ bannerImage });
      await banner.save();
      console.log("banner ", banner, "success");
      return res.status(201).json(banner);
    } catch (e) {
      console.log("error in banner");
      return res.status(400).json({ error: e.message });
    }
  })

  .get(async (req, res) => {
    try {
      const banner = await Banner.find();
      console.log("banner ", banner, "success in get");
      return res.status(200).json(banner);
    } catch (e) {
      console.log("error in banner in get request");
      return res.status(400).json({ error: e.message });
    }
  });

export { bannerRouter };
