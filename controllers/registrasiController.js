const jwt = require("jsonwebtoken");
const registrasiModel = require("../models/registrasiModel");
const { encryptAES } = require("../utils/encUtils");
const { decryptAES } = require("../utils/decUtils");
require("dotenv").config();
const {
  formatDateToJakarta,
  getFormattedDateToDatabase,
} = require("../utils/dateUtils");

const registrasi = (req, res) => {
  const {
    email,
    nama,
    noHp,
    jenisKelamin,
    tanggalLahir,
    nik,
    alamat,
    kodePos,
    kota,
    namaIbuKandung,
  } = req.body;
  const authHeader = req.get("Authorization");
  const formattedDate = getFormattedDateToDatabase();
  const forbiddenChars = /[`$]/;
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  if (
    forbiddenChars.test(email) ||
    forbiddenChars.test(nama) ||
    forbiddenChars.test(noHp) ||
    forbiddenChars.test(jenisKelamin) ||
    forbiddenChars.test(tanggalLahir) ||
    forbiddenChars.test(nik) ||
    forbiddenChars.test(alamat) ||
    forbiddenChars.test(kodePos) ||
    forbiddenChars.test(kota) ||
    forbiddenChars.test(namaIbuKandung)
  ) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message: "Input mengandung karakter yang tidak diperbolehkan !!!",
    });
  } else if (!email) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message: "Email kosong, silahkan isikan email anda !!!",
    });
  } else if (!emailRegex.test(email)) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message:
        "Format email tidak sesuai, silahkan isikan kembali email anda !!!",
    });
  } else if (!nama) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message: "Nama kosong, silahkan isikan nama anda !!!",
    });
  } else if (!noHp) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message: "No hp kosong, silahkan isikan no hp anda !!!",
    });
  } else if (!jenisKelamin) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message: "Jenis kelamin kosong, silahkan isikan jenis kelamin anda !!!",
    });
  } else if (!tanggalLahir) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message: "Tanggal lahir kosong, silahkan isikan tangal lahir anda !!!",
    });
  } else if (!nik) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message: "Nik kosong, silahkan isikan nik anda !!!",
    });
  } else if (!alamat) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message: "Alamat kosong, silahkan isikan alamat anda !!!",
    });
  } else if (!kodePos) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message: "Kode pos kosong, silahkan isikan kode pos anda !!!",
    });
  } else if (!kota) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message: "Kota kosong, silahkan isikan kota anda !!!",
    });
  } else if (!namaIbuKandung) {
    return res.status(400).json({
      timestamp: formatDateToJakarta(new Date()),
      status: 1,
      message:
        "Nama ibu kandung kosong, silahkan isikan nama ibu kandung anda !!!",
    });
  } else {
    registrasiModel.getTableToken((err, responseGetTableToken) => {
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
          const originalTokenHash = responseGetTableToken[0].token_value;

          if (decrypted !== originalTokenHash) {
            return res.status(401).json({
              timestamp: formatDateToJakarta(new Date()),
              status: 2,
              message: "Token tidak valid !!!",
            });
          } else {
            registrasiModel.getTableInformasiUser(
              (err, responseGetTableInformasiUser) => {
                if (err) {
                  console.error("Error verifying token:", err);
                  return res.status(500).json({
                    timestamp: formatDateToJakarta(new Date()),
                    status: 7,
                    message:
                      "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                  });
                } else {
                  const namaAes = encryptAES(nama);
                  const noHpAes = encryptAES(noHp);
                  const nikAes = encryptAES(nik);
                  const namaIbuKandungAes = encryptAES(namaIbuKandung);
                  const user = responseGetTableInformasiUser.find(
                    (user) => user.email === email
                  );

                  if (user === undefined) {
                    registrasiModel.insertTableInformasi(
                      email,
                      namaAes,
                      noHpAes,
                      jenisKelamin,
                      tanggalLahir,
                      formattedDate,
                      nikAes,
                      namaIbuKandungAes,
                      (err, responseInsertTableInformasi) => {
                        if (err) {
                          console.error("Error verifying token:", err);
                          return res.status(500).json({
                            timestamp: formatDateToJakarta(new Date()),
                            status: 7,
                            message:
                              "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                          });
                        } else {
                          const alamatAes = encryptAES(alamat);
                          const kotaAes = encryptAES(kota);
                          registrasiModel.insertTableAlamatUser(
                            email,
                            alamatAes,
                            kodePos,
                            kotaAes,
                            (err, responseInsertTableAlamatUser) => {
                              if (err) {
                                console.error("Error verifying token:", err);
                                return res.status(500).json({
                                  timestamp: formatDateToJakarta(new Date()),
                                  status: 7,
                                  message:
                                    "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                                });
                              } else {
                                const encrypted = encryptAES(email);
                                const jwtToken = jwt.sign(
                                  { data: encrypted },
                                  process.env.registrasi,
                                  {
                                    expiresIn: "1d",
                                  }
                                );
                                return res.status(200).json({
                                  timestamp: formatDateToJakarta(new Date()),
                                  status: 0,
                                  message:
                                    "Pendaftaran sedang diproses. Hubungi petugas CS di cabang terdekat.",
                                  processStatus: 3,
                                  token: jwtToken,
                                });
                              }
                            }
                          );
                        }
                      }
                    );
                  } else if (
                    user !== undefined &&
                    user.email === email &&
                    (user.registrasi_status === "pending" ||
                      user.registrasi_status === "verified" ||
                      user.registrasi_status === "registered")
                  ) {
                    return res.status(409).json({
                      timestamp: formatDateToJakarta(new Date()),
                      status: 9,
                      message:
                        "Email sudah di gunakan, silakan gunakan email lain",
                    });
                  } else if (
                    user !== undefined &&
                    user.email === email &&
                    user.registrasi_status === "expired"
                  ) {
                    registrasiModel.insertTableInformasi(
                      namaAes,
                      noHpAes,
                      jenisKelamin,
                      tanggalLahir,
                      formattedDate,
                      nikAes,
                      namaIbuKandungAes,
                      (err, responseInsertTableInformasi) => {
                        if (err) {
                          console.error("Error verifying token:", err);
                          return res.status(500).json({
                            timestamp: formatDateToJakarta(new Date()),
                            status: 7,
                            message:
                              "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                          });
                        } else {
                          const alamatAes = encryptAES(alamat);
                          const kotaAes = encryptAES(kota);
                          registrasiModel.insertTableAlamatUser(
                            email,
                            alamatAes,
                            kodePos,
                            kotaAes,
                            (err, responseInsertTableAlamatUser) => {
                              if (err) {
                                console.error("Error verifying token:", err);
                                return res.status(500).json({
                                  timestamp: formatDateToJakarta(new Date()),
                                  status: 7,
                                  message:
                                    "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
                                });
                              } else {
                                const encrypted = encryptAES(email);
                                const jwtToken = jwt.sign(
                                  { data: encrypted },
                                  process.env.registrasi,
                                  {
                                    expiresIn: "1d",
                                  }
                                );
                                return res.status(200).json({
                                  timestamp: formatDateToJakarta(new Date()),
                                  status: 0,
                                  message:
                                    "Pendaftaran sedang diproses. Hubungi petugas CS di cabang terdekat.",
                                  processStatus: 3,
                                  token: jwtToken,
                                });
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
              message:
                "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!",
            });
          }
        }
      }
    });
  }
};

module.exports = {
  registrasi,
};
