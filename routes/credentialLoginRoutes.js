const express = require("express");
const rateLimit = require("express-rate-limit");
const router = express.Router();
const credentialController = require("../controllers/credentialLoginController");
const checkUserAgent = require("../middlewares/checkUserAgent");
const { checkHeaders2 } = require("../middlewares/checkHeaders");

router.use(checkUserAgent);
router.use(checkHeaders2);

const loginLimiter = rateLimit({
  windowMs: 24 * 60 * 60 * 1000,
  max: 10,
  message: "Terlalu banyak request, coba lagi besok!!!",
});

router.post(
  "/api/mobile/personal/session",
  loginLimiter,
  credentialController.login
);

module.exports = router;
