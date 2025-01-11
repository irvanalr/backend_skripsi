const express = require("express");
const rateLimit = require("express-rate-limit");
const router = express.Router();
const registrasiGetController = require("../controllers/registrasiGetController");
const checkUserAgent = require("../middlewares/checkUserAgent");
const { checkHeaders2 } = require("../middlewares/checkHeaders");

router.use(checkUserAgent);
router.use(checkHeaders2);

const registrasiGetLimiter = rateLimit({
  windowMs: 24 * 60 * 60 * 1000,
  max: 10,
  message: "Terlalu banyak request, coba lagi besok!!!",
});

router.get(
  "/api/mobile/personal/user/register/:tokenRegistrasi",
  registrasiGetLimiter,
  registrasiGetController.registrasiGet
);

module.exports = router;
