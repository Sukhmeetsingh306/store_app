import { MongoDBCollectionNamespace } from 'mongodb';
import mongoose, { mongo } from 'mongoose';

const ratingReviewSchema = mongoose.Schema({
     buyerId: {
          type: String,
          required: true,
          unique: true // self added if any error get known
     },

     buyerEmail: {
          type: String,
          required: true,
          unique: true,
          lowercase: true,
     },

     buyerFullName: {
          type: String,
          required: true,
          trim: true,
     },

     productId: { // as each product will have there own id and this will match form the product table
          type: String,
          required: true,
          unique: true,
     },

     productRating:{
          type: Number,
          default: 0,
     },

     productReview:{
          type: String,
          trim: true,
     }
});

const ProductRatingReview = mongoose.model('ProductRatingReview', ratingReviewSchema);
export { ProductRatingReview };