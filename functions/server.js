import express from 'express';

const app = express();

const port = process.env.PORT || 3000;

console.log('hello')

app.listen(port,()=>{
     console.log(`Server is running on port ${port}`);
})