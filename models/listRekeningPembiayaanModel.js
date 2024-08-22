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
        pp.kode_pembiayaan AS code,
        iu.nama AS name,
        pb.kontrak AS contract,
        pb.pokok_pembiayaan AS principal,
        pb.margin_pembiayaan AS margin,
        pb.bunga_pembiayaan AS rate,
        pb.jangka_waktu_pembiayaan AS tenor,
        pb.tanggal_kontrak_pembiayaan AS contractDate,
        pp.nama_produk_pembiayaan AS productName,
        pb.tipe_jangka_waktu_pembiayaan AS tenorType,
        pb.nama_jangka_waktu_pembiayaan AS tenorName
    FROM
        perusahaan p
    JOIN 
        cabang c ON p.kode_perusahaan = c.kode_perusahaan
    JOIN
        informasi_user iu ON p.email = iu.email
    JOIN
        produk_pembiayaan pp ON c.kode_cabang = pp.kode_cabang
    JOIN
        pembiayaan pb ON pp.kode_pembiayaan = pb.kode_pembiayaan
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