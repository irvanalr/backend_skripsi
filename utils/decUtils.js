const CryptoJS = require("crypto-js");

const key = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_KEY);
const iv = CryptoJS.enc.Hex.parse(process.env.ENCRYPTION_IV);

function generateSalt(length = 16) {
  return CryptoJS.lib.WordArray.random(length).toString(CryptoJS.enc.Hex);
}

function decryptAES(encryptedText) {
  const [salt, encrypted] = encryptedText.split(":");
  const decryptedBytes = CryptoJS.AES.decrypt(encrypted, key, {
    iv: iv,
    mode: CryptoJS.mode.CBC,
    padding: CryptoJS.pad.Pkcs7,
  });
  const decryptedTextWithSalt = decryptedBytes.toString(CryptoJS.enc.Utf8);

  if (!decryptedTextWithSalt.startsWith(salt)) {
    throw new Error("Invalid salt during decryption.");
  }

  return decryptedTextWithSalt.slice(salt.length + 1);
}

module.exports = {
  decryptAES,
};
