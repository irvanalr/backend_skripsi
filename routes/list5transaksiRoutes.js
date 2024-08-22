const express = require('express');
const router = express.Router();
const list5transaksiController = require('../controllers/list5transaksiController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk rekening utama
router.get('/user/transaksi/last5date/:code/:namaPengguna', list5transaksiController.list5transaksi);

module.exports = router;