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

const getAllTables = (callback) => {
    const query = `
      SELECT
          p.kode_perusahaan AS companyCode,
          p.perusahaan AS company,
          c.kode_cabang AS branchCode,
          c.cabang AS branch,
          ps.kode_simpanan AS code,
          s.tanggal_di_buat AS registration,
          ps.nama_produk_simpanan AS productName,
          s.skema_produk AS productScheme,
          iu.nama AS name
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
    `;
      
    connection.query(query, (error, results) => {
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
};
