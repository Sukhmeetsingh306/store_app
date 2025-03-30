import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
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
      validate: {
        validator: (value) => {
          const result =
            /^[-!#$%&'*+\/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+\/0-9=?A-Z^_a-z`{|}~])*@[a-zA-Z0-9](-*\.?[a-zA-Z0-9])*\.[a-zA-Z](-?[a-zA-Z0-9])+$/;
          return result.test(value);
        },
        message: "Please enter a valid email address.",
      },
    },

    state: {
      type: String,
      default: "",
    },

    city: {
      type: String,
      default: "",
    },

    locality: {
      type: String,
      default: "",
    },

    password: {
      type: String,
      required: [true, "Password is required."],
      validate: {
        validator: (value) => {
          // Check minimum length
          if (value.length < 8) {
            throw new Error("Password must be at least 8 characters long.");
          }

          // Regular expression to check for required complexity
          // const passwordRegex = /r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'/;
          // if (!passwordRegex.test(value)) {
          //   throw new Error('Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.');
          // }

          return true; // If all checks pass, the validation succeeds
        },
        message: "Invalid password.",
      },
    },

    isSellers: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);

export default User;
