const CryptoJS = require("crypto-js");
const jwt = require("jsonwebtoken");
const credentialLoginModel = require("../models/credentialLoginModel");
require("dotenv").config();
const {
  formatDateToJakarta,
  getFormattedDateToDatabase,
} = require("../utils/dateUtils");

const login = (req, res) => {
  const { username, password } = req.body;
  const authHeader = req.get("Authorization");
  const key = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_KEY);
  const iv = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_IV);
  const formattedDate = getFormattedDateToDatabase();
  const forbiddenChars = /[`$]/;

  if (!username || !password) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message:
        "Username atau Password kosong, silahkan masukan username atau password !!!",
    });
  } else if (forbiddenChars.test(username) || forbiddenChars.test(password)) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message:
        "Username atau Password mengandung karakter tidak valid (` atau $), silakan perbaiki input Anda !!!",
    });
  } else {
    try {
      const decoded = jwt.verify(authHeader, process.env.gettokenapi);
      const bytes = CryptoJS.AES.decrypt(decoded.data, key, { iv: iv });
      const decryptedHash = bytes.toString(CryptoJS.enc.Utf8);

      credentialLoginModel.getTableTokenAndOtentikasi(
        (err, responseTableTokenAndOtentikasi) => {
          const originalTokenHash = CryptoJS.SHA256(
            responseTableTokenAndOtentikasi[0].o_token_value
          ).toString(CryptoJS.enc.Hex);

          const user = responseTableTokenAndOtentikasi.find(
            (user) => user.o_nama_pengguna === username
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
            return res.status(401).json({
              timestamp: formatDateToJakarta(new Date()),
              status: 2,
              message: "Username dan Password salah !!!",
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
          } else if (user.o_kata_sandi !== password) {
            credentialLoginModel.cekUserActivityFailedLogin(
              user.o_nama_pengguna,
              (err, responseCekUserActivityFailedLogin) => {
                // Jika error
                if (err) {
                  console.error("Error verifying token:", err);
                  return res.status(500).json({
                    timestamp: formatDateToJakarta(new Date()),
                    status: 7,
                    message:
                      "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                  });

                  // jika tidak ada isinya
                } else if (responseCekUserActivityFailedLogin.length === 0) {
                  credentialLoginModel.insertFailedLoginAttempts(
                    user.o_nama_pengguna,
                    1,
                    formattedDate,
                    (err, responseInsertFailedLoginAttempts) => {
                      if (err) {
                        console.error("Error verifying token:", err);
                        return res.status(500).json({
                          timestamp: formatDateToJakarta(new Date()),
                          status: 7,
                          message:
                            "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                        });
                      } else {
                        return res.status(401).json({
                          timestamp: formatDateToJakarta(new Date()),
                          status: 2,
                          message: "Username dan Password salah !!!",
                        });
                      }
                    }
                  );
                } else {
                  const lastFailedLogin =
                    responseCekUserActivityFailedLogin[
                      responseCekUserActivityFailedLogin.length - 1
                    ];
                  const totalFailedLogins = lastFailedLogin.total_failed_login;

                  // Jika total_failed_login adalah 0, 1, atau 2
                  if (totalFailedLogins === 0 || totalFailedLogins % 3 !== 0) {
                    credentialLoginModel.insertFailedLoginAttempts(
                      user.o_nama_pengguna,
                      totalFailedLogins + 1,
                      formattedDate,
                      (err, responseInsertFailedLoginAttempts) => {
                        if (err) {
                          console.error("Error updating login attempts:", err);
                          return res.status(500).json({
                            timestamp: formatDateToJakarta(new Date()),
                            status: 7,
                            message:
                              "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                          });
                        } else {
                          return res.status(401).json({
                            timestamp: formatDateToJakarta(new Date()),
                            status: 2,
                            message: "Username dan Password salah !!!",
                          });
                        }
                      }
                    );

                    // Jika total_failed_login adalah kelipatan 3 (3, 6, 9, dst.)
                  } else if (totalFailedLogins % 3 === 0) {
                    credentialLoginModel.updateAccountStatus(
                      "revoked",
                      user.o_nama_pengguna,
                      (err, responseUpdateAccountStatus) => {
                        if (err) {
                          console.error("Error updating account status:", err);
                          return res.status(500).json({
                            timestamp: formatDateToJakarta(new Date()),
                            status: 7,
                            message:
                              "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                          });
                        } else {
                          return res.status(403).json({
                            timestamp: formatDateToJakarta(new Date()),
                            status: 3,
                            message:
                              "Akun Anda diblokir, silakan hubungi administrator !!!",
                          });
                        }
                      }
                    );
                  }
                }
              }
            );
          } else {
            try {
              const hash = CryptoJS.SHA256(user.o_nama_pengguna).toString(
                CryptoJS.enc.Hex
              );
              const encrypted = CryptoJS.AES.encrypt(hash, key, {
                iv: iv,
              }).toString();
              const jwtToken = jwt.sign(
                { data: encrypted },
                process.env.login,
                {
                  expiresIn: "1d",
                }
              );

              credentialLoginModel.cekUserActivityFailedLogin(
                user.o_nama_pengguna,
                (err, responseCekUserActivityFailedLogin) => {
                  if (err) {
                    console.error("Error verifying token:", err);
                    return res.status(500).json({
                      timestamp: formatDateToJakarta(new Date()),
                      status: 7,
                      message:
                        "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                    });
                  } else {
                    if (
                      responseCekUserActivityFailedLogin.length !== 0 &&
                      responseCekUserActivityFailedLogin[
                        responseCekUserActivityFailedLogin.length - 1
                      ].total_failed_login === 0
                    ) {
                      credentialLoginModel.cekUserActivityLogin(
                        user.o_nama_pengguna,
                        (err, responseCekUserActivityLogin) => {
                          if (err) {
                            console.error("Error verifying token:", err);
                            return res.status(500).json({
                              timestamp: formatDateToJakarta(new Date()),
                              status: 7,
                              message:
                                "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                            });
                          } else {
                            if (responseCekUserActivityLogin.length === 0) {
                              credentialLoginModel.insertLoginAttempts(
                                user.o_nama_pengguna,
                                1,
                                formattedDate,
                                (err, responseInsertLoginAttempts) => {
                                  if (err) {
                                    console.error(
                                      "Error verifying token:",
                                      err
                                    );
                                    return res.status(500).json({
                                      timestamp: formatDateToJakarta(
                                        new Date()
                                      ),
                                      status: 7,
                                      message:
                                        "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                                    });
                                  } else {
                                    return res.status(200).json({
                                      timestamp: formatDateToJakarta(
                                        new Date()
                                      ),
                                      status: 0,
                                      message: "SUCCESS",
                                      token: jwtToken,
                                    });
                                  }
                                }
                              );
                            } else if (
                              responseCekUserActivityLogin.length !== 0
                            ) {
                              credentialLoginModel.insertLoginAttempts(
                                user.o_nama_pengguna,
                                responseCekUserActivityLogin[
                                  responseCekUserActivityLogin.length - 1
                                ].total_login + 1,
                                formattedDate,
                                (err, responseInsertLoginAttempts) => {
                                  if (err) {
                                    console.error(
                                      "Error verifying token:",
                                      err
                                    );
                                    return res.status(500).json({
                                      timestamp: formatDateToJakarta(
                                        new Date()
                                      ),
                                      status: 7,
                                      message:
                                        "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                                    });
                                  } else {
                                    return res.status(200).json({
                                      timestamp: formatDateToJakarta(
                                        new Date()
                                      ),
                                      status: 0,
                                      message: "SUCCESS",
                                      token: jwtToken,
                                    });
                                  }
                                }
                              );
                            }
                          }
                        }
                      );
                    } else {
                      credentialLoginModel.insertFailedLoginAttempts(
                        user.o_nama_pengguna,
                        0,
                        formattedDate,
                        (err, responseInsertFailedLoginAttempts) => {
                          if (err) {
                            console.error("Error verifying token:", err);
                            return res.status(500).json({
                              timestamp: formatDateToJakarta(new Date()),
                              status: 7,
                              message:
                                "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                            });
                          } else {
                            credentialLoginModel.cekUserActivityLogin(
                              user.o_nama_pengguna,
                              (err, responseCekUserActivityLogin) => {
                                if (err) {
                                  console.error("Error verifying token:", err);
                                  return res.status(500).json({
                                    timestamp: formatDateToJakarta(new Date()),
                                    status: 7,
                                    message:
                                      "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                                  });
                                } else {
                                  if (
                                    responseCekUserActivityLogin.length === 0
                                  ) {
                                    credentialLoginModel.insertLoginAttempts(
                                      user.o_nama_pengguna,
                                      1,
                                      formattedDate,
                                      (err, responseInsertLoginAttempts) => {
                                        if (err) {
                                          console.error(
                                            "Error verifying token:",
                                            err
                                          );
                                          return res.status(500).json({
                                            timestamp: formatDateToJakarta(
                                              new Date()
                                            ),
                                            status: 7,
                                            message:
                                              "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                                          });
                                        } else {
                                          return res.status(200).json({
                                            timestamp: formatDateToJakarta(
                                              new Date()
                                            ),
                                            status: 0,
                                            message: "SUCCESS",
                                            token: jwtToken,
                                          });
                                        }
                                      }
                                    );
                                  } else if (
                                    responseCekUserActivityLogin.length !== 0
                                  ) {
                                    credentialLoginModel.insertLoginAttempts(
                                      user.o_nama_pengguna,
                                      responseCekUserActivityLogin[
                                        responseCekUserActivityLogin.length - 1
                                      ].total_login + 1,
                                      formattedDate,
                                      (err, responseInsertLoginAttempts) => {
                                        if (err) {
                                          console.error(
                                            "Error verifying token:",
                                            err
                                          );
                                          return res.status(500).json({
                                            timestamp: formatDateToJakarta(
                                              new Date()
                                            ),
                                            status: 7,
                                            message:
                                              "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                                          });
                                        } else {
                                          return res.status(200).json({
                                            timestamp: formatDateToJakarta(
                                              new Date()
                                            ),
                                            status: 0,
                                            message: "SUCCESS",
                                            token: jwtToken,
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
                      );
                    }
                  }
                }
              );
            } catch (error) {
              console.error("Error signing JWT:", error);
              return res.status(500).json({
                timestamp: formatDateToJakarta(new Date()),
                status: 7,
                message:
                  "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
              });
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
          message: "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
        });
      }
    }
  }
};

module.exports = { login };
