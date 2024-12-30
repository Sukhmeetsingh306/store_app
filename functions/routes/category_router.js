import express from "express";
import Category from "../models/category_models";

const categoryRouter = express.Router();

categoryRouter.route('/api/category').post(async (req, res) => {
     try{
          const { name, image, banner}  = req.body;
          const category = new Category({ name, image, banner });
          await category.save();
          console.log('category ', category,'success in post');
          return res.status(201).json(category);
     }catch(e){
          console.log('error in category in post request');
          return res.status(400).json({ error: e.message });
     }
})

export default categoryRouter;