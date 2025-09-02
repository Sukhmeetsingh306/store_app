import mongoose from "mongoose";
import { type } from "os";

const productSchema = mongoose.Schema({
  productName: {
    type: String,
    required: true,
    trim: true,
  },

  productPrice: {
    type: Number,
    required: true,
  },

  productQuantity: {
    type: Number,
    required: true,
  },

  productDescription: {
    type: String,
    required: true,
    trim: true,
  },

  sellerId: {
    type: String,
    required: true,
  },

  sellerName: {
    type: String,
    required: true,
  },

  productCategory: {
    type: String,
    required: true,
  },

  productSubCategory: {
    type: String,
    required: false,
    default: null,
  },

  productImage: [
    {
      type: String,
      required: true,
    },
  ],

  productPopularity: {
    type: Boolean,
    default: false,
  },

  productRecommended: {
    type: Boolean,
    default: false,
  },
});

const Product = mongoose.model("Product", productSchema);
export { Product };
