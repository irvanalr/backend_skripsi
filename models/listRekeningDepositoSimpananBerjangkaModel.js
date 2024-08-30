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
        pd.kode_deposito AS code,
        pd.nama_produk_deposito AS productName,
        iu.nama AS name,
        d.kode_bilyet_deposito AS bilyet,
        d.tanggal_mulai_deposito AS begin,
        d.tanggal_akhir_deposito AS end,
        d.saldo_deposito AS value,
        d.aro_deposito AS aro
    FROM 
        informasi_user iu
    JOIN 
        perusahaan p ON iu.email = p.email
    JOIN 
        cabang c ON p.kode_perusahaan = c.kode_perusahaan
    JOIN 
        produk_deposito pd ON c.kode_cabang = pd.kode_cabang
    JOIN
        deposito d ON pd.kode_deposito = d.kode_deposito
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
  getAllTables
}