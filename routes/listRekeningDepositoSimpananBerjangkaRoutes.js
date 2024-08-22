const express = require('express');
const router = express.Router();
const  listRekeningDepositoSimpananBerjangkaController = require('../controllers/listRekeningDepositoSimpananBerjangkaController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk user informations
router.get('/user/rekening-deposito/:namaPengguna', listRekeningDepositoSimpananBerjangkaController.listRekeningDeposito);

module.exports = router;
