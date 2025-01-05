const connection = require("../config/database");

const getTableTokenAndOtentikasi = (callback) => {
  const query = `
    SELECT 
        otentikasi.nama_pengguna as o_nama_pengguna,
        otentikasi.token_value as o_token_value,
        otentikasi.kata_sandi as o_kata_sandi,
        otentikasi.pin as o_pin,
        otentikasi.account_status as o_account_status,
        token.tanggal_di_buat as t_tanggal_di_buat,
        token.tanggal_kadaluarsa as t_tanggal_kadaluarsa,
        token.status as t_status
    FROM 
        otentikasi
    JOIN 
        token
    ON 
        otentikasi.token_value = token.token_value;
  `;

  connection.query(query, (error, results) => {
    if (error) {
      return callback(error, null);
    }
    callback(null, results);
  });
};

const cekUserActivityFailedLogin = (username, callback) => {
  connection.query(
    "SELECT * FROM user_activity_failed_login WHERE nama_pengguna = ?",
    [username],
    (error, results) => {
      if (error) {
        return callback(error, null);
      }
      callback(null, results);
    }
  );
};

const cekUserActivityLogin = (username, callback) => {
  connection.query(
    "SELECT * FROM user_activity_login WHERE nama_pengguna = ?",
    [username],
    (error, results) => {
      if (error) {
        return callback(error, null);
      }
      callback(null, results);
    }
  );
};

const insertFailedLoginAttempts = (
  username,
  failedLoginAttempts,
  lastFailedLogin,
  callback
) => {
  connection.query(
    "INSERT INTO user_activity_failed_login (nama_pengguna, total_failed_login, last_failed_login) VALUES (?, ?, ?)",
    [username, failedLoginAttempts, lastFailedLogin],
    (error, results) => {
      if (error) {
        return callback(error, null);
      }
      callback(null, results);
    }
  );
};

const insertLoginAttempts = (username, totalLogin, lastLogin, callback) => {
  connection.query(
    "INSERT INTO user_activity_login (nama_pengguna, total_login, last_login) VALUES (?, ?, ?)",
    [username, totalLogin, lastLogin],
    (error, results) => {
      if (error) {
        return callback(error, null);
      }
      callback(null, results);
    }
  );
};

const updateAccountStatus = (accountStatus, username, callback) => {
  connection.query(
    "UPDATE otentikasi SET account_status = ? WHERE nama_pengguna = ?",
    [accountStatus, username],
    (error, results) => {
      if (error) {
        return callback(error, null);
      }
      callback(null, results);
    }
  );
};

module.exports = {
  getTableTokenAndOtentikasi,
  cekUserActivityFailedLogin,
  cekUserActivityLogin,
  insertFailedLoginAttempts,
  insertLoginAttempts,
  updateAccountStatus,
};
