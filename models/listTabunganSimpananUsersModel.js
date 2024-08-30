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

const getTableOtentikasi = (namaPengguna, callback) => {
  const query = `
  SELECT 
      o.nama_pengguna,
      o.token_value,
      o.kata_sandi,
      o.pin,
      o.aktivasi,
      iu.nama,
      p.kode_perusahaan,
      c.kode_cabang
  FROM 
      otentikasi o
  JOIN 
      informasi_user iu ON o.nama_pengguna = iu.nama_pengguna
  JOIN 
      perusahaan p ON iu.email = p.email
  JOIN 
      cabang c ON p.kode_perusahaan = c.kode_perusahaan
  WHERE o.nama_pengguna = ?
  `;

  connection.query(query, [namaPengguna], (error, results) => {
    if (error) {
      return callback(error, null);
    }
    callback(null, results);
  });
}

const getAllTables = (kodeCabang, callback) => {
  const query = `
    SELECT
        iu.nama AS name,
        ps.kode_simpanan AS code,
        ps.nama_produk_simpanan AS productName,
        s.saldo_simpanan AS balance
    FROM 
        informasi_user iu
    JOIN 
        perusahaan p ON iu.email = p.email
    JOIN 
        cabang c ON p.kode_perusahaan = c.kode_perusahaan
    JOIN 
        produk_simpanan ps ON c.kode_cabang = ps.kode_cabang
    JOIN 
        simpanan s ON ps.kode_simpanan = s.kode_simpanan
    WHERE 
        c.kode_cabang = ?
  `;
    
    connection.query(query, [kodeCabang], (error, results) => {
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