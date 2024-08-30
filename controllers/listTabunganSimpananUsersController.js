const CryptoJS = require('crypto-js');
const jwt = require("jsonwebtoken");
const listTabunganSimpananUsersModel = require("../models/listTabunganSimpananUsersModel");
require('dotenv').config();

const formatDateToJakarta = (date) => {
  // Mengonversi UTC ke waktu Jakarta
  const jakartaDateTime = new Date(date).toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' });
  
  // Mengambil hanya bagian tanggal dari string
  const [datePart, timePart] = jakartaDateTime.split(',');
  
  // Mengubah format dari 'd/M/yyyy' ke 'yyyy-MM-dd'
  const [day, month, year] = datePart.split('/');
  const formattedDate = `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
  
  return `${formattedDate} ${timePart}`;
};

const listTabunganSimpananUsers = (req, res) => {
    // Mengambil headers
    const authHeader = req.get('Authorization');
    const loginToken = req.get('mobile-credential');

    // Mengambil params
    const namaPengguna = req.params.namaPengguna;
  
    // cek header
    if (!authHeader || authHeader === null) {
      return res.status(403).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 0,
        message: "Token tidak ditemukan dalam header Authorization atau mobile-credential",
      });
    }
    if(!loginToken || loginToken === null) {
        return res.status(403).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 0,
        message: "Token tidak ditemukan dalam header Authorization atau mobile-credential",
      });
    }

    // Cek isi dari params namaPengguna
    if(!namaPengguna) {
      return res.status(403).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 0,
        message: "Token tidak ditemukan atau tidak valid !!!",
      });
    }

    try {
      // Verify and decode JWT
      const decoded = jwt.verify(authHeader, process.env.gettokenapi);
      const encryptedHash = decoded.data;
  
      const key = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_KEY);
      const iv = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_IV);
  
      // Decrypt the hash
      const bytes = CryptoJS.AES.decrypt(encryptedHash, key, { iv: iv });
      const decryptedHash = bytes.toString(CryptoJS.enc.Utf8);
  
       // Fetch the original token from the database and hash it
       listTabunganSimpananUsersModel.getTableToken((err, responseTableToken) => {
        if (err) {
          console.error('Error verifying token:', err);
          // Status code 500 Internal server error
          return res.status(500).json({
            timestamp: formatDateToJakarta(new Date()),
            status: 0,
            message: "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!"
          });
        }
  
        const originalTokenHash = CryptoJS.SHA256(responseTableToken[0].token_value).toString(CryptoJS.enc.Hex);
  
        // Verify if the decrypted hash matches the original token hash
        if (decryptedHash === originalTokenHash) {
  
          try {
            // Verify and decode JWT
            const decoded = jwt.verify(loginToken, process.env.login);
            const encryptedHash = decoded.data;
  
            // Decrypt the hash
            const bytes = CryptoJS.AES.decrypt(encryptedHash, key, { iv: iv });
            const decryptedHash = bytes.toString(CryptoJS.enc.Utf8);
  
            listTabunganSimpananUsersModel.getTableOtentikasi(namaPengguna, (err, responseTableOtentikasi) => {
              if (err) {
                console.error('Error verifying token:', err);
                // Status code 500 Internal server error
                return res.status(500).json({
                  timestamp: formatDateToJakarta(new Date()),
                  status: 0,
                  message: "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!"
                });
              }
  
              const user = responseTableOtentikasi.find((user) => user.nama_pengguna === namaPengguna);
  
              // Jika nama pengguna tidak di temukan
              if(!user) {
                // status code 404 not found
                return res.status(404).json({
                  timestamp: formatDateToJakarta(new Date()),
                  status: 0,
                  message: "Nama pengguna tidak di temukan !!!",
                });
              }
  
              // Jika aktivasi tidak sama dengan active
              if(user.aktivasi !== 'active') {
                // status code 401 unautorized
                return res.status(401).json({
                  timestamp: formatDateToJakarta(new Date()),
                  status: 0,
                  message: "Akun dinonaktifkan, Hubungi Operator kami untuk tindak selanjutnya !!!",
                });
              }
  
              const originalTokenHash = CryptoJS.SHA256(user.nama_pengguna).toString(CryptoJS.enc.Hex);
  
              if(originalTokenHash === decryptedHash) {

                listTabunganSimpananUsersModel.getAllTables(user.kode_cabang, (err, responseAllTable) => {
                  if (err) {
                    console.error('Error verifying token:', err);
                    // Status code 500 Internal server error
                    return res.status(500).json({
                      timestamp: formatDateToJakarta(new Date()),
                      status: 0,
                      message: "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!"
                    });
                  }

                  // status 200 success
                  return res.status(200).json({
                    timestamp: formatDateToJakarta(new Date()),
                    status: 1,
                    message: "Success",
                    savings: responseAllTable
                  });   
                });
              } else {
                // Status code 401 unautorized
                res.status(401).json({
                  timestamp: formatDateToJakarta(new Date()),
                  status: 0,
                  message: "Token tidak valid",
                });
              }
  
            });
          } catch (error) {
            // statusCode 401 unautorized
            if (error.name === 'TokenExpiredError') {
              res.status(401).json({
                timestamp: formatDateToJakarta(new Date()),
                status: 0,
                message: "Token sudah kadaluarsa !!!",
              });
            // statusCode 403 forbidden
            } else if (error.name === 'JsonWebTokenError') {
              res.status(403).json({
                timestamp: formatDateToJakarta(new Date()),
                status: 0,
                message: "Token tidak valid !!!",
              });
            // statusCode 500 internal server errror
            } else {
              console.error('Error verifying token:', error);
              res.status(500).json({
                timestamp: formatDateToJakarta(new Date()),
                status: 0,
                message: "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!"
              });
            }
          }
        } else {
          // Status code 401 unautorized
          res.status(401).json({
            timestamp: formatDateToJakarta(new Date()),
            status: 0,
            message: "Token tidak valid",
          });
        }
      });
    } catch (error) {
      // statusCode 401 unautorized
      if (error.name === 'TokenExpiredError') {
        res.status(401).json({
          timestamp: formatDateToJakarta(new Date()),
          status: 0,
          message: "Token sudah kadaluarsa !!!",
        });
      // statusCode 403 forbidden
      } else if (error.name === 'JsonWebTokenError') {
        res.status(403).json({
          timestamp: formatDateToJakarta(new Date()),
          status: 0,
          message: "Token tidak valid !!!",
        });
      // statusCode 500 internal server errror
      } else {
        console.error('Error verifying token:', error);
        res.status(500).json({
          timestamp: formatDateToJakarta(new Date()),
          status: 0,
          message: "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!"
        });
      }
    }
}

module.exports = {
    listTabunganSimpananUsers
};