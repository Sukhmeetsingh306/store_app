import express from "express";
import Banner from "../models/banner_models.js";

const bannerRouter = express.Router();

bannerRouter.route("/api/banner").post(async (req, res) => {
  try {
    const { image } = req.body;
    const banner = new Banner({ image });
    await banner.save();
    console.log("banner ", banner, "success");
    return res.status(201).json(banner);
  } catch (e) {
    console.log("error in banner");
    return res.status(400).json({ error: e.message });
  }
});

export { bannerRouter };
