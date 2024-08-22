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

const getAllTables = (email, callback) => {
  const query = `
    SELECT
        ps.kode_simpanan AS code,
        iu.nama AS name,
        s.saldo_simpanan AS balance,
        ps.nama_produk_simpanan AS productName
    FROM
        perusahaan p
    JOIN 
        cabang c ON p.kode_perusahaan = c.kode_perusahaan
    JOIN
        produk_simpanan ps ON c.kode_cabang = ps.kode_cabang
    JOIN 
        simpanan s ON ps.kode_simpanan = s.kode_simpanan
    JOIN
        informasi_user iu ON p.email = iu.email
    WHERE
        p.email = ?
  `;
    
    connection.query(query, [email], (error, results) => {
      if (error) {
        return callback(error, null);
      }
      callback(null, results);
    });
  };

module.exports = {
  getTableToken,
  getTableOtentikasi,
  getAllTables,
}