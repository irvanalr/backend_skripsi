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
        p.kode_perusahaan,
        p.perusahaan,
        c.cabang,
        iu.kode_akun,
        iu.nama,
        iu.email AS iu_email,
        iu.no_hp,
        iu.jenis_kelamin,
        iu.tanggal_lahir,
        iu.registrasi,
        iu.kode_akun,
        au.alamat,
        au.kota,
        au.kode_pos
    FROM
        perusahaan p
    JOIN
        cabang c ON p.kode_perusahaan = c.kode_perusahaan
    JOIN
        informasi_user iu ON p.email = iu.email
    JOIN
        alamat_user au ON iu.email = au.email
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
  getAllTables,
};
