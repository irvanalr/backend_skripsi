const express = require('express');
const router = express.Router();
const list10transaksiController = require('../controllers/list10transaksiController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk rekening utama
router.get('/user/transaksi/last10date/:code/:namaPengguna', list10transaksiController.list10transaksi);

module.exports = router;