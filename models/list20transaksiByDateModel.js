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

const getTableTransaksi = (kodeSimpanan, tanggal, callback) => {
    const query = `SELECT * FROM transaksi WHERE kode_simpanan = ? AND tanggal_transaksi = ?`;
      
    connection.query(query, [kodeSimpanan, tanggal], (error, results) => {
        if (error) {
            return callback(error, null);
        }
        callback(null, results);
    });
};

module.exports = {
    getTableToken,
    getTableOtentikasi,
    getTableTransaksi
}