const express = require('express');
const router = express.Router();
const list20transaksiByDateController = require('../controllers/list20transaksiByDateController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk rekening utama
router.get('/user/transaksi/last20date/:code/:date/:namaPengguna', list20transaksiByDateController.list20transaksiByDate);

module.exports = router;