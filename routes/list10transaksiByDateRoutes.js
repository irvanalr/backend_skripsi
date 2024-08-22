const express = require('express');
const router = express.Router();
const list10transaksiByDateController = require('../controllers/list10transaksiByDateController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk rekening utama
router.get('/user/transaksi/last10date/:code/:date/:namaPengguna', list10transaksiByDateController.list10transaksiByDate);

module.exports = router;