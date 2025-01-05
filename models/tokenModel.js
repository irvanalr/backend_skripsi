const connection = require("../config/database");

const getAllTables = (callback) => {
  const query = `SELECT * FROM token`;

  connection.query(query, (error, results) => {
    if (error) {
      return callback(error, null);
    }
    callback(null, results);
  });
};

const updateStatus = (callback) => {
  connection.query('UPDATE tokens SET status = "revoked"', (error, results) => {
    if (error) {
      return callback(error, null);
    }
    callback(null, results);
  });
};

module.exports = {
  getAllTables,
  updateStatus,
};
