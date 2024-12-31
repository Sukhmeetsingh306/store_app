import mongoose from "mongoose";

const subCategoryModel = mongoose.Schema({
     categoryId: {
          'type': String,
          required: true
     },

     categoryName: {
          'type': String,
          required: true
     },

     image: {
          'type': String,
          required: true
     },

     subCategoryName:{
          'type': String,
          required: true
     }
});

const SubCategory = mongoose.model('SubCategory', subCategoryModel);
export { SubCategory };