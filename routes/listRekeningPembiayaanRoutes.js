const express = require('express');
const router = express.Router();
const listRekeningPembiayaanController = require('../controllers/listRekeningPembiayaanController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk rekening utama
router.get('/user/list-rekening-pembiayaan/:namaPengguna', listRekeningPembiayaanController.listRekeningPembiayaan);

module.exports = router;