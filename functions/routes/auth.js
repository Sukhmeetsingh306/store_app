import express from "express";
import User from "../models/signup.js"

const appAuthSignInAuthSignIn = express();

appAuthSignIn.route('/api/signup')
     .post(async(req, res)=>{
          try{
               const {name, email, password} = req.body;
               const existingUser = await User.findOne({email}); // that finding that there is already an existing user

               if(existingUser){
                    return res.status(400).json({message: 'User already exists'});
               }else{
                    const newUser = new User({name, email, password});
                    await newUser.save();
                    res.status(201).json({newUser: newUser});
               }
          }catch(err){
               res.status(500).json({message: err.message});
          }
     });

export {appAuthSignInAuthSignIn};
