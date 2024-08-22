const express = require('express');
const router = express.Router();
const rekeningUtamaUsersController = require('../controllers/rekeningUtamaUsersController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk rekening utama
router.get('/user/rekening-utama/:namaPengguna', rekeningUtamaUsersController.rekeningUtamaUsers);

module.exports = router;