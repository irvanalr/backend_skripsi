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
        pd.kode_deposito AS code,
        pd.nama_produk_deposito AS productName,
        iu.nama AS name,
        d.kode_bilyet_deposito AS bilyet,
        d.tanggal_mulai_deposito AS begin,
        d.tanggal_akhir_deposito AS end,
        d.saldo_deposito AS value,
        d.aro_deposito AS aro
    FROM
        perusahaan p
    JOIN 
        cabang c ON p.kode_perusahaan = c.kode_perusahaan
    JOIN
        informasi_user iu ON p.email = iu.email
    JOIN
        produk_deposito pd ON c.kode_cabang = c.kode_cabang
    JOIN
        deposito d ON pd.kode_deposito = d.kode_deposito
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
  getAllTables
}