import express from "express";

const homeRoute = express.Router();

homeRoute.route('/')
    .get((req, res) => {
        res.send("Welcome to my home page!");
    });

export { homeRoute }; // Use ES Modules export
