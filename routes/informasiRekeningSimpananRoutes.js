const express = require('express');
const router = express.Router();
const informasiRekeningSimpananController = require('../controllers/informasiRekeningSimpananController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk rekening utama
router.get('/user/informasi-rekening-simpanan/:code/:namaPengguna', informasiRekeningSimpananController.informasiRekeningSimpanan);

module.exports = router;