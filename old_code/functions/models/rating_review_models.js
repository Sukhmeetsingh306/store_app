import mongoose from "mongoose";

const ratingReviewSchema = mongoose.Schema({
  buyerId: {
    type: String,
    required: true,
    unique: true, // self added if any error get known
  },

  buyerEmail: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    validate: {
      validator: (value) => {
        const result =
          /^[-!#$%&'*+\/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+\/0-9=?A-Z^_a-z`{|}~])*@[a-zA-Z0-9](-*\.?[a-zA-Z0-9])*\.[a-zA-Z](-?[a-zA-Z0-9])+$/;
        return result.test(value);
      },
      message: "Please enter a valid email address.",
    },
  },

  buyerFullName: {
    type: String,
    required: true,
    trim: true,
  },

  productId: {
    // as each product will have there own id and this will match form the product table
    type: String,
    required: true,
    unique: true,
  },

  productRating: {
    type: Number,
  },

  productReview: {
    type: String,
    trim: true,
  },
});

const ProductRatingReview = mongoose.model(
  "ProductRatingReview",
  ratingReviewSchema
);
export { ProductRatingReview };
