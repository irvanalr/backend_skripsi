const express = require('express');
const router = express.Router();
const list20transaksiController = require('../controllers/list20transaksiController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk rekening utama
router.get('/user/transaksi/last20date/:code/:namaPengguna', list20transaksiController.list20transaksi);

module.exports = router;