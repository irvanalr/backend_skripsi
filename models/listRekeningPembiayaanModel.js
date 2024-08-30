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
        informasi_user iu
    JOIN 
        perusahaan p ON iu.email = p.email
    JOIN 
        cabang c ON p.kode_perusahaan = c.kode_perusahaan
    JOIN
        produk_pembiayaan pp ON c.kode_cabang = pp.kode_cabang
    JOIN
        pembiayaan pb ON pp.kode_pembiayaan = pb.kode_pembiayaan
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