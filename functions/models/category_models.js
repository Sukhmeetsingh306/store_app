import mongoose from "mongoose";

const categorySchema = mongoose.Schema({
     name:{
          type: String,
          required: true,
     },

     image: {
          type: String,
          required: true,
     },

     banner :{
          type: String,
     }
});

export default categorySchema;