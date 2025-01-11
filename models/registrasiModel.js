const connection = require("../config/database");

const getTableToken = (callback) => {
  const query = `SELECT * FROM token`;

  connection.query(query, (error, results) => {
    if (error) {
      return callback(error, null);
    }
    callback(null, results);
  });
};

const getTableInformasiUser = (callback) => {
  const query = `SELECT * FROM informasi_user`;

  connection.query(query, (error, results) => {
    if (error) {
      return callback(error, null);
    }
    callback(null, results);
  });
};

const insertTableInformasi = (
  email,
  nama,
  noHp,
  jenisKelamin,
  tanggalLahir,
  registrasi,
  nik,
  namaIbuKandung,
  callback
) => {
  const query = `
    INSERT INTO informasi_user
    (email, nama, no_hp, jenis_kelamin, tanggal_lahir, registrasi, nik, nama_ibu_kandung)
    VALUES
    (?, ?, ?, ?, ?, ?, ?, ?)
  `;

  connection.query(
    query,
    [
      email,
      nama,
      noHp,
      jenisKelamin,
      tanggalLahir,
      registrasi,
      nik,
      namaIbuKandung,
    ],
    (error, results) => {
      if (error) {
        return callback(error, null);
      }
      callback(null, results);
    }
  );
};

const insertTableAlamatUser = (email, alamat, kodePos, kota, callback) => {
  const query = `
    INSERT INTO alamat_user
    (email, alamat, kode_pos, kota)
    VALUES
    (?, ?, ?, ?)
  `;

  connection.query(query, [email, alamat, kodePos, kota], (error, results) => {
    if (error) {
      return callback(error, null);
    }
    callback(null, results);
  });
};

module.exports = {
  getTableToken,
  getTableInformasiUser,
  insertTableInformasi,
  insertTableAlamatUser,
};
