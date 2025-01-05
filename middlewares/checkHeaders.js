// Middleware untuk getTokenApi
const checkHeaders1 = (req, res, next) => {
  const mobileAppHeader = req.get("mobile-app");
  const contentTypeHeader = req.get("Content-Type");
  const acceptHeader = req.get("accept");

  // Periksa keberadaan headers yang diperlukan
  if (
    !mobileAppHeader ||
    !contentTypeHeader ||
    acceptHeader !== "application/json"
  ) {
    return res.status(404).send("404 NOT FOUND !!!");
  }

  // Jika semua headers valid, lanjutkan ke handler berikutnya
  next();
};

// Middleware untuk user login
const checkHeaders2 = (req, res, next) => {
  const mobileAppHeader = req.get("mobile-app");
  const contentTypeHeader = req.get("Content-Type");
  const acceptHeader = req.get("accept");
  const authorizationHeader = req.get("Authorization");

  // Periksa keberadaan headers yang diperlukan
  if (
    !mobileAppHeader ||
    !contentTypeHeader ||
    acceptHeader !== "application/json" ||
    !authorizationHeader
  ) {
    return res.status(404).send("404 NOT FOUND !!!");
  }

  // Jika semua headers valid, lanjutkan ke handler berikutnya
  next();
};

const checkHeaders3 = (req, res, next) => {
  const mobileAppHeader = req.get("mobile-app");
  const contentTypeHeader = req.get("Content-Type");
  const acceptHeader = req.get("accept");
  const authorizationHeader = req.get("Authorization");
  const mobileCredentialHeader = req.get("mobile-credential");
  const name = req.get("name");

  // Periksa keberadaan headers yang diperlukan
  if (
    !mobileAppHeader ||
    !contentTypeHeader ||
    !acceptHeader ||
    !authorizationHeader ||
    !mobileCredentialHeader ||
    !name ||
    acceptHeader !== "application/json"
  ) {
    return res.status(404).send("404 NOT FOUND !!!");
  }

  // Jika semua headers valid, lanjutkan ke handler berikutnya
  next();
};

module.exports = { checkHeaders1, checkHeaders2, checkHeaders3 };
