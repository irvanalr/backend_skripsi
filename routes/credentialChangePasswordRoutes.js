const express = require('express');
const router = express.Router();
const credentialController = require('../controllers/credentialController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware khusus untuk user routes
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk changePassword
router.put('/users/password/:namaPengguna', credentialController.changePassword);

module.exports = router;