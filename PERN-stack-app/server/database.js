const Pool = require("pg").Pool;

const pool = new Pool({
  user: "tuvx2000",
  password: "admin123",
  // host: "postgre-db.c8cpygvyvsb5.ap-southeast-1.rds.amazonaws.com",14.169.180.191\
  host: "postgre-db.c8cpygvyvsb5.ap-southeast-1.rds.amazonaws.com",
  port: 5432,
  database: "perntodo",
  ssl: {
    rejectUnauthorized: false
}
});

module.exports = pool;
