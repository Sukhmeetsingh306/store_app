import express from "express";
import { ProductRatingReview } from "../models/rating_review_models.js";

const productRatingReviewRouter = express.Router();

productRatingReviewRouter
  .route("/api/product-rating-review")
  .post(async (req, res) => {
    const {
      buyerId,
      buyerEmail,
      buyerFullName,
      productId,
      productRating,
      productReview,
    } = req.body;

    try {
      const productRatingReview = new ProductRatingReview({
        buyerId,
        buyerEmail,
        buyerFullName,
        productId,
        productRating,
        productReview,
      });
      await productRatingReview.save();
      console.log(
        "Product rating review",
        productRatingReview,
        " saved successfully"
      );
      return res.status(201).json(productRatingReview);
    } catch (e) {
      console.log("Error in saving product rating review", e);
      return res.status(400).json({ error: e.message });
    }
  })

  // Get all product rating reviews that are present in the db
  .get(async (req, res) => {
     try{
          const productRatingReview = await ProductRatingReview.find();
          console.log("Product rating review", productRatingReview, "fetched successfully");
          return res.status(200).json(productRatingReview);
     }catch(e){
          console.log("Error in getting product rating review", e);
          return res.status(400).json({ error: e.message });
     }
  });

export { productRatingReviewRouter };
