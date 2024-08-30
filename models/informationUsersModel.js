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

const getAllTables = (namaPengguna, callback) => {
  // const query = `
  //   SELECT
  //       p.kode_perusahaan,
  //       p.perusahaan,
  //       c.cabang,
  //       iu.kode_akun,
  //       iu.nama,
  //       iu.email AS iu_email,
  //       iu.no_hp,
  //       iu.jenis_kelamin,
  //       iu.tanggal_lahir,
  //       iu.registrasi,
  //       iu.kode_akun,
  //       au.alamat,
  //       au.kota,
  //       au.kode_pos
  //   FROM
  //       perusahaan p
  //   JOIN
  //       cabang c ON p.kode_perusahaan = c.kode_perusahaan
  //   JOIN
  //       informasi_user iu ON p.email = iu.email
  //   JOIN
  //       alamat_user au ON iu.email = au.email
  // `;

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
      informasi_user iu
  Join
      alamat_user au ON iu.email = au.email 
  JOIN 
      perusahaan p ON iu.email = p.email
  JOIN 
      cabang c ON p.kode_perusahaan = c.kode_perusahaan
  WHERE 
      iu.nama_pengguna = ?
`;
    
  connection.query(query, [namaPengguna], (error, results) => {
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
