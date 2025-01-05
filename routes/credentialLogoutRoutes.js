const express = require("express");
const router = express.Router();
const credentialLogoutController = require("../controllers/credentialLogoutController");
const checkUserAgent = require("../middlewares/checkUserAgent");
const { checkHeaders3 } = require("../middlewares/checkHeaders");

// Middleware
router.use(checkUserAgent);
router.use(checkHeaders3);

// Endpoint untuk logout
router.delete(
  "/api/mobile/personal/session",
  credentialLogoutController.logout
);

module.exports = router;
