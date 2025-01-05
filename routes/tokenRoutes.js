const express = require("express");
const router = express.Router();
const tokenController = require("../controllers/tokenController");
const checkUserAgent = require("../middlewares/checkUserAgent");
const { checkHeaders1 } = require("../middlewares/checkHeaders");

// Middleware khusus untuk auth routes
router.use(checkUserAgent);
router.use(checkHeaders1);

router.get("/api/mobile/personal/session", tokenController.getTokenApi);

module.exports = router;
