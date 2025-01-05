const express = require("express");
const router = express.Router();
const rateLimit = require("express-rate-limit");
const credentialChangePasswordController = require("../controllers/credentialChangePasswordController");
const checkUserAgent = require("../middlewares/checkUserAgent");
const { checkHeaders3 } = require("../middlewares/checkHeaders");

// Middleware khusus untuk user routes
router.use(checkUserAgent);
router.use(checkHeaders3);

// Rate limiter
const ChangePasswordLimiter = rateLimit({
  windowMs: 24 * 60 * 60 * 1000,
  max: 10,
  message: "Terlalu banyak request, coba lagi besok!!!",
});

// Endpoint untuk changePassword
router.put(
  "/api/mobile/personal/user/password",
  ChangePasswordLimiter,
  credentialChangePasswordController.changePassword
);

module.exports = router;
