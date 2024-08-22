const CryptoJS = require('crypto-js');
const jwt = require('jsonwebtoken');
const tokenModel = require("../models/tokenModel");
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

const getTokenApi = (req, res) => {
  const key = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_KEY);
  const iv = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_IV);

  tokenModel.getAllTables((err, responseTableToken) => {
    if (err) {
      // Status code 500 internal server error
      console.error('Error fetching token:', err);
      return res.status(500).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 0,
        message: "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!"
      });
    }

    if (!responseTableToken || responseTableToken.length === 0) {
      // Status code 404 not found
      return res.status(404).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 0,
        message: "Error Table database kosong !!!",
      });
    }

    const tokenString = responseTableToken[0].token_value;

    if (!tokenString) {
      // Status code 500 internal server error
      return res.status(500).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 0,
        message: "Token value tidak terdefinisikan atau kosong !!!"
      });
    }

    // Hashing token
    const hash = CryptoJS.SHA256(tokenString).toString(CryptoJS.enc.Hex);

    // Encrypt the hash
    const encrypted = CryptoJS.AES.encrypt(hash, key, { iv: iv }).toString();

    try {
      // Create JWT with the encrypted hash as payload
      const jwtToken = jwt.sign({ data: encrypted }, process.env.gettokenapi, { expiresIn: '1d' });

      res.status(200).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 1,
        message: "SUCCESS",
        token: jwtToken
      });
    } catch (error) {
      console.error('Error signing JWT:', error);
      res.status(500).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 0,
        message: "SERVER MENGALAMI GANGGUAN SAAT MEMBUAT TOKEN, SILAHKAN COBA LAGI NANTI !!!"
      });
    }
  });
};

module.exports = { getTokenApi };
