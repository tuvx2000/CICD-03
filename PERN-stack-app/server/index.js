const express = require("express");
const app = express();
const cors = require("cors")
const pool = require("./database")
var datetime = new Date();

// const customFormat  = format.combine(format.timestamp(), format.printf((info) => {
//   return `${info.timestamp} - [${info.level.toUpperCase().padEnd(7)}] -- ${info.message}`
// }))

// const customFormat = format.combine(
//   format.timestamp(),
//   format.printf((info) => {
//     return `${info.timestamp} - [${info.level.toUpperCase().padEnd(7)}] - ${info.message}`;
//   })
// );


const { createLogger, transports, format, info } = require('winston');
const logger = createLogger({ 
  // format: customFormat ,
  level: 'debug',
  transports: [
    new transports.Console({ level : 'silly'}),
    new transports.File({ filename: '/data-dir1/app.log', level: 'info',handleExceptions: true  })

  ]
});
// module.exports logger;


// 👇️ handle uncaught exceptions
process.on('uncaughtException', function (err) {
  console.log(err);
});



//middleware
app.use(cors());
app.use(express.json());
 

//ROUTES//

//create todo object
app.post("/todos", async (req, res) => {
    try {
    //   console.log(req.body);
      const { description } = req.body;
    //   console.log(description);

      const newTodo = await pool.query( 
        "INSERT INTO todo (description) VALUES($1) RETURNING *",
        [description]
      );
      logger.info("put command " + datetime)
      // logger.silly(allTodos.rows);
      logger.info("--- end put!")
      res.json(newTodo);
    } catch (err) {
      console.error(err.message);
    }
  });
//get todo all object

app.get("/todos", async (req, res) => {
    try {
      const allTodos = await pool.query("SELECT * FROM todo");
      logger.info("list command "+ datetime)
      // logger.silly(allTodos.rows);
      logger.info("--- end list!")

      res.json(allTodos.rows);

    } catch (err) {
      console.error(err.message);
    }
  });

//get a todo object
  
  app.get("/todos/:id", async (req, res) => {
    try {
      const { id } = req.params; 
      const todo = await pool.query("SELECT * FROM todo WHERE todo_id = $1", [
        id
      ]);

      res.json(todo.rows[0]);
    } catch (err) {
      console.error(err.message);
    }
  });
  
// update todo object
app.put("/todos/:id", async (req, res) => {
    try {
      const { id } = req.params;
      const { description } = req.body;
      const updateTodo = await pool.query(
        "UPDATE todo SET description = $1 WHERE todo_id = $2",
        [description, id]
      );
  
      res.json("Todo was updated!");
    } catch (err) {
      console.error(err.message);
    }
  });
//delete todo object 

app.delete("/todos/:id", async (req, res) => {
    try {
      const { id } = req.params;
      const deleteTodo = await pool.query("DELETE FROM todo WHERE todo_id = $1", [
        id
      ]);
      res.json("Todo was deleted!");
    } catch (err) {
      console.log(err.message);
    }
  });
  

  // logger.error("error")
  // logger.warn("warn")
  // logger.info("info")
  // logger.debug("debug")
  // logger.silly("sully")

app.listen(80, ()=> {
    // console.log("server has started on port 80");
    logger.info("this is log tuvo of logger -> running app" )
});