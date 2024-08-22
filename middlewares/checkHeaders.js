// Middleware untuk getTokenApi
const checkHeaders1 = (req, res, next) => {
  const mobileAppHeader = req.get('mobile-app');
  const contentTypeHeader = req.get('Content-Type');
  const acceptHeader = req.get('accept');

  // Periksa keberadaan headers yang diperlukan
  if ((!mobileAppHeader || !contentTypeHeader) || acceptHeader !== 'application/json') {
    return res.status(400).json({
      message: 'Masukkan headers yang diperlukan !!!'
    });
  }

  // Jika semua headers valid, lanjutkan ke handler berikutnya
  next();
};

// Middleware untuk user login
const checkHeaders2 = (req, res, next) => {
  const mobileAppHeader = req.get('mobile-app');
  const contentTypeHeader = req.get('Content-Type');
  const acceptHeader = req.get('accept');
  const authorizationHeader = req.get('Authorization');

  // Periksa keberadaan headers yang diperlukan
  if ( (!mobileAppHeader || !contentTypeHeader) || (acceptHeader !== 'application/json' || !authorizationHeader) ) {
    return res.status(400).json({
      message: 'Masukkan headers yang diperlukan !!!'
    });
  }

  // Jika semua headers valid, lanjutkan ke handler berikutnya
  next();
};

const checkHeaders3 = (req, res, next) => {
  const mobileAppHeader = req.get('mobile-app');
  const contentTypeHeader = req.get('Content-Type');
  const acceptHeader = req.get('accept');
  const authorizationHeader = req.get('Authorization');
  const mobileCredentialHeader = req.get('mobile-credential');

  // Periksa keberadaan headers yang diperlukan
  if ( ( (!mobileAppHeader || !contentTypeHeader) || (!acceptHeader || !authorizationHeader) ) || (!mobileCredentialHeader || acceptHeader !== 'application/json')) {
    return res.status(400).json({
      message: 'Masukkan headers yang diperlukan !!!'
    });
  }

  // Jika semua headers valid, lanjutkan ke handler berikutnya
  next();
};

module.exports = { checkHeaders1, checkHeaders2, checkHeaders3 };
