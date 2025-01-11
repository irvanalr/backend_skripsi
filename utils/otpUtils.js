const CryptoJS = require("crypto-js");

const secretKey = process.env.OTP_SECRET_KEY || "this_is_a_secret_key";

function generateSecureOTP(length = 6) {
  const now = new Date();

  const year = now.getFullYear();
  const month = now.getMonth() + 1;
  const day = now.getDate();
  const hours = now.getHours();
  const minutes = now.getMinutes();
  const seconds = now.getSeconds();
  const milliseconds = now.getMilliseconds();

  const timeString = `${year}${month.toString().padStart(2, "0")}${day
    .toString()
    .padStart(2, "0")}${hours.toString().padStart(2, "0")}${minutes
    .toString()
    .padStart(2, "0")}${seconds.toString().padStart(2, "0")}${milliseconds
    .toString()
    .padStart(3, "0")}`;

  const data = timeString + secretKey;

  const hash = CryptoJS.HmacSHA256(data, secretKey).toString(CryptoJS.enc.Hex);

  const charset =
    "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  let otp = "";

  for (let i = 0; i < length; i++) {
    const charCode = hash.charCodeAt(i % hash.length);
    otp += charset[charCode % charset.length];
  }

  return otp;
}

module.exports = {
  generateSecureOTP,
};
