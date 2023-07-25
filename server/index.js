const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
const authRouter = require('./routes/auth');
const PORT = 3000; 
const DB = 'mongodb+srv://admin:admin@cluster0.nlf37up.mongodb.net/?retryWrites=true&w=majority'

// middleware 
app.use(cors());
app.use(express.json()); // return json payload
app.use(authRouter);

mongoose.connect(DB).then(()=>{
    console.log('Connected!');
}

).catch((e)=>{
    console.log(e);
})


// 0.0.0.0 can use to any IP address outside server 
app.listen(PORT, "0.0.0.0",() =>{
    console.log(`Listen ${PORT}`);
})