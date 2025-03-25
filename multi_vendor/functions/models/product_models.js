import mongoose from "mongoose";

const productSchema = mongoose.Schema({
     productName:{
          type: String,
          required: true,
          trim: true,
     },

     productPrice:{
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

     productCategory: {
          type: String,
          required: true,
     },

     productSubCategory: {
          type: String,
          required: true,
     },

     productImage: [
          {
               type: String,
               required: true,
          }
     ],

     productPopularity:{
          type: Boolean,
          default: false,
     },

     productRecommended:{
          type: Boolean,
          default: false,
     }
});

const Product = mongoose.model('Product', productSchema);
export  { Product };