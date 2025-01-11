const jwt = require("jsonwebtoken");
const registrasiGetModel = require("../models/registrasiGetModel");
const { encryptAES } = require("../utils/encUtils");
const { decryptAES } = require("../utils/decUtils");
require("dotenv").config();
const {
  formatDateToJakarta,
  getFormattedDateToDatabase,
} = require("../utils/dateUtils");

const registrasiGet = (req, res) => {
  const authHeader = req.get("Authorization");
  const tokenRegistrasi = req.params.tokenRegistrasi;

  registrasiGetModel.getTableInformasiUser((err, responseGetInformasiUser) => {
    if (err) {
      console.error("Error verifying token:", err);
      return res.status(500).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 7,
        message: "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
      });
    } else {
      try {
        const decoded = jwt.verify(authHeader, process.env.gettokenapi);
        const decrypted = decryptAES(decoded.data);
        const originalTokenHash = responseGetInformasiUser[0].token_value;

        if (decrypted !== originalTokenHash) {
          return res.status(401).json({
            timestamp: formatDateToJakarta(new Date()),
            status: 2,
            message: "Token tidak valid !!!",
          });
        } else {
          const decoded = jwt.verify(tokenRegistrasi, process.env.registrasi);
          const decrypted = decryptAES(decoded.data);
          const user = responseGetInformasiUser.find(
            (user) => user.email === decrypted
          );

          if (!user) {
            return res.status(401).json({
              timestamp: formatDateToJakarta(new Date()),
              status: 2,
              message: "Token tidak valid !!!",
            });
          } else if (user.registrasi_status === "pending") {
            return res.status(200).json({
              timestamp: formatDateToJakarta(new Date()),
              status: 0,
              message:
                "Pendaftaran sedang diproses. Hubungi petugas CS di cabang terdekat.",
              processStatus: 3,
            });
          } else if (user.registrasi_status === "verified") {
            return res.status(200).json({
              timestamp: formatDateToJakarta(new Date()),
              status: 0,
              message:
                "Jangan berikan OTP ke siapapun, berikan OTP kepada CS untuk tindak selanjutnya.",
              otp: "11223344",
              processStatus: 2,
            });
          } else if (user.registrasi_status === "registered") {
            return res.status(200).json({
              timestamp: formatDateToJakarta(new Date()),
              status: 0,
              message:
                "Akun sudah terdaftar, silahkan lakukan aktivitas anda pada aplikasi kami",
              processStatus: 1,
            });
          } else if (user.registrasi_status === "expired") {
            return res.status(401).json({
              timestamp: formatDateToJakarta(new Date()),
              status: 2,
              message: "SESSION EXPIRED !!!",
            });
          }
        }
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
    }
  });
};

module.exports = {
  registrasiGet,
};
