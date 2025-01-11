const connection = require("../config/database");

const getTableInformasiUser = (callback) => {
  const query = `SELECT * FROM informasi_user`;

  connection.query(query, (error, results) => {
    if (error) {
      return callback(error, null);
    }
    callback(null, results);
  });
};

module.exports = {
  getTableInformasiUser,
};
