const CryptoJS = require("crypto-js");
const jwt = require("jsonwebtoken");
const tokenModel = require("../models/tokenModel");
const { response } = require("express");
require("dotenv").config();
const { formatDateToJakarta } = require("../utils/dateUtils");

const getTokenApi = (req, res) => {
  const key = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_KEY);
  const iv = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_IV);
  const currentDate = new Date().toLocaleString();

  tokenModel.getAllTables((err, responseTableToken) => {
    const tokenString = responseTableToken[0].token_value;
    console.log(responseTableToken);
    if (err) {
      // Status code 500 internal server error
      console.error("Error fetching token:", err);
      return res.status(500).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 7,
        message: "INTERNAL SERVER ERROR",
      });
    } else if (!responseTableToken || responseTableToken.length === 0) {
      // Status code 404 not found
      return res.status(404).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 4,
        message: "Table database tidak di temukan !!!",
      });
    } else if (
      responseTableToken[0].tanggal_kadaluarsa.toLocaleString() === currentDate
    ) {
      return tokenModel.updateStatus((err, responseUpdateStatus) => {
        if (err) {
          // Status code 500 internal server error
          console.error("Error fetching token:", err);
          return res.status(500).json({
            timestamp: formatDateToJakarta(new Date()),
            status: 7,
            message: "INTERNAL SERVER ERROR",
          });
        }
        // status code 401 unautorize
        return res.status(401).json({
          timestamp: formatDateToJakarta(new Date()),
          status: 2,
          message: "SESSION EXPIRED !!!",
        });
      });
    } else if (responseTableToken[0].status === "revoked") {
      // status code 401 unautorize
      return res.status(401).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 2,
        message: "SESSION EXPIRED !!!",
      });
    } else if (!tokenString || tokenString.length === 0) {
      // Status code 404 internal server error
      return res.status(404).json({
        timestamp: formatDateToJakarta(new Date()),
        status: 4,
        message: "Token value tidak terdefinisikan atau kosong !!!",
      });
    } else {
      try {
        // Hashing token
        const hash = CryptoJS.SHA256(tokenString).toString(CryptoJS.enc.Hex);

        // Encrypt the hash
        const encrypted = CryptoJS.AES.encrypt(hash, key, {
          iv: iv,
        }).toString();
        // Create JWT with the encrypted hash as payload
        const jwtToken = jwt.sign(
          { data: encrypted },
          process.env.gettokenapi,
          {
            expiresIn: "1d",
          }
        );

        res.status(200).json({
          timestamp: formatDateToJakarta(new Date()),
          status: 0,
          message: "SUCCESS",
          token: jwtToken,
        });
      } catch (error) {
        console.error("Error signing JWT:", error);
        res.status(500).json({
          timestamp: formatDateToJakarta(new Date()),
          status: 7,
          message: "SERVER MENGALAMI GANGGUAN SAAT MEMBUAT TOKEN !!!",
        });
      }
    }
  });
};

module.exports = { getTokenApi };
