import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    lowercase: true,
    validate:{validator:(value)=>{
        const result = /^[-!#$%&'*+\/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+\/0-9=?A-Z^_a-z`{|}~])*@[a-zA-Z0-9](-*\.?[a-zA-Z0-9])*\.[a-zA-Z](-?[a-zA-Z0-9])+$/;
        return result.test(value);
        },
        message: 'Please enter a valid email address.'
      }
    },

    state: {
      type: String,
      default: '',
    },

    city: {
      type: String,
      default: '',
    },

    locality: {
      type: String,
      default: '',
    },

  password: {
    type: String,
    required: true,
    validate:{
      validator:(value)=>{
        const passwordRegex = /^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
        if(value.length <=8){
          message: 'Password must be at least 8 characters long.'
        }else if(value.contain(passwordRegex)){
          message: 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.'
        }
        
      },
    }
  },
}, { timestamps: true });

const User = mongoose.model('User', userSchema);

export default User;
