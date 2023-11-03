const express = require("express");
const app = express();
const cors = require("cors")
const pool = require("./database")

//middleware
app.use(cors());
app.use(express.json());

//ROUTES//

//create todo object

//get todo object

// update todo object

//delete todo object




app.listen(5001, ()=> {
    console.log("server has started on port 5001");
});