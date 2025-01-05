const CryptoJS = require("crypto-js");
const jwt = require("jsonwebtoken");
const credentialChangePasswordModel = require("../models/credentialChangePasswordModel");
require("dotenv").config();
const {
  formatDateToJakarta,
  getFormattedDateToDatabase,
} = require("../utils/dateUtils");

const changePassword = (req, res) => {
  const { passwordOld, passwordNew, confirmPaswordNew } = req.body;
  const authHeader = req.get("Authorization");
  const mobileCredentialHeader = req.get("mobile-credential");
  const name = req.get("name");
  const key = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_KEY);
  const iv = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_IV);
  const formattedDate = getFormattedDateToDatabase();
  const forbiddenChars = /[`$]/;

  try {
    const decoded = jwt.verify(authHeader, process.env.gettokenapi);
    const bytes = CryptoJS.AES.decrypt(decoded.data, key, { iv: iv });
    const decryptedHash = bytes.toString(CryptoJS.enc.Utf8);

    credentialChangePasswordModel.getTableTokenAndOtentikasi(
      (err, responseGetTableTokenAndOtentikasi) => {
        const originalTokenHash = CryptoJS.SHA256(
          responseGetTableTokenAndOtentikasi[0].o_token_value
        ).toString(CryptoJS.enc.Hex);

        const user = responseGetTableTokenAndOtentikasi.find(
          (user) => user.o_nama_pengguna === name
        );

        if (err) {
          console.error("Error verifying token:", err);
          return res.status(500).json({
            timestamp: formatDateToJakarta(new Date()),
            status: 7,
            message: "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
          });
        } else if (decryptedHash !== originalTokenHash) {
          return res.status(401).json({
            timestamp: formatDateToJakarta(new Date()),
            status: 2,
            message: "Token tidak valid !!!",
          });
        } else if (!user) {
          return res.status(404).json({
            timestamp: formatDateToJakarta(new Date()),
            status: 4,
            message: "USERNAME NOT FOUND !!!",
          });
        } else if (user.t_status === "revoked") {
          return res.status(401).json({
            timestamp: formatDateToJakarta(new Date()),
            status: 2,
            message: "SESSION EXPIRED !!!",
          });
        } else if (user.o_account_status === "revoked") {
          return res.status(403).json({
            timestamp: formatDateToJakarta(new Date()),
            status: 3,
            message: "Akun Anda diblokir, silakan hubungi administrator !!!",
          });
        } else {
          console.log(user);
        }
      }
    );
  } catch (error) {
    if (error.name === "TokenExpiredError") {
      return res.status(401).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 2,
        message: "SESSION EXPIRED !!!",
      });
    } else if (error.name === "JsonWebTokenError") {
      return res.status(403).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 3,
        message: "Token tidak valid !!!",
      });
    } else {
      console.error("Error verifying token:", error);
      return res.status(500).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 7,
        message: "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
      });
    }
  }
};

module.exports = {
  changePassword,
};
