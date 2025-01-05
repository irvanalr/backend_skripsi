const CryptoJS = require("crypto-js");
const jwt = require("jsonwebtoken");
const credentialLogoutModel = require("../models/credentialLogoutModel");
require("dotenv").config();
const {
  formatDateToJakarta,
  getFormattedDateToDatabase,
} = require("../utils/dateUtils");

const logout = (req, res) => {
  const authHeader = req.get("Authorization");
  const mobileCredentialHeader = req.get("mobile-credential");
  const name = req.get("name");
  const key = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_KEY);
  const iv = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_IV);
  const forbiddenChars = /[`$]/;

  if (forbiddenChars.test(name)) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message:
        "Nama header mengandung karakter tidak valid (` atau $), silakan perbaiki input Anda !!!",
    });
  } else {
    try {
      const decoded = jwt.verify(authHeader, process.env.gettokenapi);
      const bytes = CryptoJS.AES.decrypt(decoded.data, key, { iv: iv });
      const decryptedHash = bytes.toString(CryptoJS.enc.Utf8);
      const formattedDate = getFormattedDateToDatabase();

      credentialLogoutModel.getTableTokenAndOtentikasi(
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
              message:
                "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
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
            const decoded = jwt.verify(
              mobileCredentialHeader,
              process.env.login
            );
            const bytes = CryptoJS.AES.decrypt(decoded.data, key, { iv: iv });
            const decryptedHash = bytes.toString(CryptoJS.enc.Utf8);

            const originalTokenHash = CryptoJS.SHA256(
              user.o_nama_pengguna
            ).toString(CryptoJS.enc.Hex);

            if (decryptedHash !== originalTokenHash) {
              return res.status(401).json({
                timestamp: formatDateToJakarta(new Date()),
                status: 2,
                message: "Token tidak valid !!!",
              });
            } else {
              credentialLogoutModel.cekUserActivityLogout(
                (err, responseCekUserActivityLogout) => {
                  if (err) {
                    console.error("Error verifying token:", err);
                    return res.status(500).json({
                      timestamp: formatDateToJakarta(new Date()),
                      status: 7,
                      message:
                        "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                    });
                  } else {
                    // jika tidak ada isinya
                    if (responseCekUserActivityLogout.length === 0) {
                      credentialLogoutModel.insertLogoutAttempts(
                        user.o_nama_pengguna,
                        1,
                        formattedDate,
                        (err, responseInsertLogoutAttempts) => {
                          if (err) {
                            console.error("Error verifying token:", err);
                            return res.status(500).json({
                              timestamp: formatDateToJakarta(new Date()),
                              status: 7,
                              message:
                                "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                            });
                          } else {
                            return res.status(200).json({
                              timestamp: formatDateToJakarta(new Date()),
                              status: 0,
                              message: "SUCCESS",
                            });
                          }
                        }
                      );

                      // jika ada isinya
                    } else if (responseCekUserActivityLogout.length !== 0) {
                      credentialLogoutModel.insertLogoutAttempts(
                        user.o_nama_pengguna,
                        responseCekUserActivityLogout[
                          responseCekUserActivityLogout.length - 1
                        ].total_logout + 1,
                        formattedDate,
                        (err, responseInsertLogoutAttempts) => {
                          if (err) {
                            console.error("Error verifying token:", err);
                            return res.status(500).json({
                              timestamp: formatDateToJakarta(new Date()),
                              status: 7,
                              message:
                                "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                            });
                          } else {
                            return res.status(200).json({
                              timestamp: formatDateToJakarta(new Date()),
                              status: 0,
                              message: "SUCCESS",
                            });
                          }
                        }
                      );
                    }
                  }
                }
              );
            }
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
          message:
            "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTIaaaa !!!",
        });
      }
    }
  }
};

module.exports = { logout };
