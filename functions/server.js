import express from 'express';

const app = express();

const port = process.env.PORT || 3000;


app.route('/')
     .get((req, res)=>{
          res.send('Hello Working');
     })

app.listen(port,()=>{
     console.log(`Server is running on port ${port}`);
})