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

const getTablePerusahaanCabang = (email, callback) => {
  const query = `
    SELECT
        iu.registrasi,
        ps.kode_simpanan,
        ps.nama_produk_simpanan,
        s.saldo_simpanan,
        iu.nama
    FROM
        perusahaan p
    JOIN 
        cabang c ON p.kode_perusahaan = c.kode_perusahaan
    JOIN
        produk_simpanan ps ON c.kode_cabang = c.kode_cabang
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
}

module.exports = {
  getTableToken,
  getTableOtentikasi,
  getTablePerusahaanCabang
}