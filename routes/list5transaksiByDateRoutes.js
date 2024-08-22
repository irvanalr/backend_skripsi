const express = require('express');
const router = express.Router();
const list5transaksiByDateController = require('../controllers/list5transaksiByDateController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk rekening utama
router.get('/user/transaksi/last5date/:code/:date/:namaPengguna', list5transaksiByDateController.list5transaksiByDate);

module.exports = router;