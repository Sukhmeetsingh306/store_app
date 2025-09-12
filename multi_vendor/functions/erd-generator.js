// erd-generator.js
import mongoose from "mongoose";
import jsonSchema from "mongoose-schema-jsonschema";

// ✅ Patch mongoose with jsonSchema
jsonSchema(mongoose);

// Import your models
import Banner from "./models/banner_models.js";
import Category from "./models/category_models.js";
import { Product } from "./models/product_models.js";
import { ProductRatingReview } from "./models/rating_review_models.js";
import Seller from "./models/seller.js";
import { SubCategory } from "./models/subCategory_models.js";
import User from "./models/userInf.js";

// Convert schemas to JSON Schema
const schemas = {
  Banner: Banner.schema.jsonSchema(),
  Category: Category.schema.jsonSchema(),
  Product: Product.schema.jsonSchema(),
  ProductRatingReview: ProductRatingReview.schema.jsonSchema(),
  Seller: Seller.schema.jsonSchema(),
  SubCategory: SubCategory.schema.jsonSchema(),
  User: User.schema.jsonSchema(),
};

// Save to file or print
console.log(JSON.stringify(schemas, null, 2));
