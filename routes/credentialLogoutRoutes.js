const express = require('express');
const router = express.Router();
const credentialController = require('../controllers/credentialController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware 
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk logout
router.delete('/logout/:namaPengguna', credentialController.logout);

module.exports = router;
