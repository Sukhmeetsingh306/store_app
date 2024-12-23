import express from "express";
import User from "../models/userInf.js"

const appAuthSignIn= express();

appAuthSignIn.route('/api/signup')
     .post(async (req, res) => {
          try {
          const { name, email, password } = req.body;

          if (!name || !email || !password) {
               return res.status(400).json({ message: `All fields are required: ${name}, ${email}, ${password}` });
          }
          const existingUser = await User.findOne({ email });
               if (existingUser) {
                    return res.status(400).json({ message: 'User already exists' });
               }else{
                    const newUser = new User({ name, email, password });
                    await newUser.save();
                    res.status(201).json({ newUser });
               }
          } catch (err) {
          //console.error('Error in saving user:', err);
          res.status(500).json({ message: err.message });
          }
     });

export {appAuthSignIn};
