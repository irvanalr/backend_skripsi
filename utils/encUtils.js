const CryptoJS = require("crypto-js");

const key = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_KEY);
const iv = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_IV);

function encryptSHA256(text) {
  return CryptoJS.SHA256(text).toString(CryptoJS.enc.Hex);
}

function generateSalt(length = 16) {
  return CryptoJS.lib.WordArray.random(length).toString(CryptoJS.enc.Hex);
}

function encryptAES(text) {
  const salt = generateSalt();
  const textWithSalt = `${salt}:${text}`;
  const encrypted = CryptoJS.AES.encrypt(textWithSalt, key, {
    iv: iv,
    mode: CryptoJS.mode.CBC,
    padding: CryptoJS.pad.Pkcs7,
  }).toString();

  return `${salt}:${encrypted}`;
}

module.exports = {
  encryptSHA256,
  encryptAES,
};
