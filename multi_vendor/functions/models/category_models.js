import mongoose from "mongoose";

const categorySchema = mongoose.Schema({
  categoryName: {
    type: String,
    required: true,
  },

  categoryImage: {
    type: String,
    required: true,
  },

  categoryBanner: {
    type: String,
  },
});

const Category = mongoose.model("Category", categorySchema);
export default Category;
