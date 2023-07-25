const express = require('express');
const User = require('../models/user');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');

const authRouter = express.Router();

authRouter.post('/api/signup',async (req,res)=>{
    try{
        const {name, email, password} = req.body;
    const existingUser = await User.findOne({email});

    if(existingUser){
        return res.status(400).json({msg:'User Existed!'});
    }
    const hasdedPassword = await bcryptjs.hash(password, 8);


    let user = new User({
        email,
        password:hasdedPassword,
        name,
    });

    user = await user.save();
    res.json({user});
    }catch(e){
        res.status(500).json({error : e.message});
    }

    
});

// Sign In Route 
authRouter.post('/api/signin', async(req,res)=>{
    try{
        const {email, password} = req.body;

        const user = await User.findOne({email});

        if(!user){
            return res.status(400).json({msg : 'Not existed user!'});

        }

        // check password with hashes pass 
        const isMatch = bcryptjs.compare(password, user.password);
        if(!isMatch){
            return res.status(400).json({msg : 'Wrong Password!'});
        }
        const token = jwt.sign({id : user._id}, "passwordKey");
        /// Search more to understand
        
        res.json({token, ...user._doc});

    }catch(e){
        res.status(500).json({error:e.message});
    }
})
module.exports = authRouter;