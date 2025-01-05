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

module.exports = {
  getTableTokenAndOtentikasi,
};
