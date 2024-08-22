const express = require('express');
const router = express.Router();
const informationUsersController = require('../controllers/informationUsersController');
const checkUserAgent = require('../middlewares/checkUserAgent');
const { checkHeaders3 } = require('../middlewares/checkHeaders');

// Middleware
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk user informations
router.get('/user/informations/:namaPengguna', informationUsersController.InformationUsers);

module.exports = router;
