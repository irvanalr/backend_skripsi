const connection = require('../config/database');

const getTableToken = (callback) => {
  const query = `SELECT * FROM token`;

  connection.query(query, (error, results) => {
    if (error) {
      return callback(error, null);
    }
    callback(null, results);
  });
}

const getTableOtentikasi = (callback) => {
  const query = `SELECT * FROM otentikasi`;

  connection.query(query, (error, results) => {
    if (error) {
      return callback(error, null);
    }
    callback(null, results);
  });
}

const updatePassword = (passwordBaru, namaPengguna,  callback) => {
  connection.query('UPDATE otentikasi SET kata_sandi = ? WHERE nama_pengguna = ?', [passwordBaru, namaPengguna], (error, results) => {
    if (error) {
      return callback(error, null);
    }
    callback(null, results[0]);
  });
}

module.exports = { 
  getTableToken,
  getTableOtentikasi,
  updatePassword
};