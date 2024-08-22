const express = require('express');
const rateLimit = require('express-rate-limit');
const router = express.Router();
const credentialController = require('../controllers/credentialController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders2 } = require('../middlewares/checkHeaders');

// Middleware khusus untuk user routes
router.use(checkUserAgent);
router.use(checkHeaders2);

// Rate limiter konfigurasi khusus untuk rute login
const loginLimiter = rateLimit({
  windowMs: 30 * 1000, 
  max: 3, 
  message: "Terlalu banyak request silahkan coba lagi nanti !!!"
});

// Endpoint untuk login dengan rate limiter
router.post('/auth/login', loginLimiter, credentialController.login);

module.exports = router;
