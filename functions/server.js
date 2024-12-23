import express from 'express';
import {homeRoute} from './routes/home.js';

const app = express();

const port = process.env.PORT || 3000;


app.use(homeRoute);

app.listen(port,()=>{
     console.log(`Server is running on port ${port}`);
})