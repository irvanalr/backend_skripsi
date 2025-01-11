const jwt = require("jsonwebtoken");
const { encryptAES } = require("./encUtils");
const { decryptAES } = require("./decUtils");

function generateEncryptedJwt(value) {
  const encrypted = encryptAES(value);
  const jwtToken = jwt.sign({ data: encrypted }, process.env.gettokenapi, {
    expiresIn: "1d",
  });

  return jwtToken;
}

function generateDecryptedJwt(value) {
  try {
    const decoded = jwt.verify(value, process.env.gettokenapi);
    if (decoded && decoded.data) {
      return decryptAES(decoded.data);
    }

    return null;
  } catch (err) {
    console.error("Error verifying or decrypting JWT:", err.message);
    return null;
  }
}

module.exports = {
  generateEncryptedJwt,
  generateDecryptedJwt,
};
