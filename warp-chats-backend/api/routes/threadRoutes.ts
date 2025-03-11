import { Router } from "express";
import { checkUserId } from "../middlewares/checkUserId";
import { createThread, joinThread } from "../controllers/threadController";

const router = Router();

router.post("/join", checkUserId, joinThread);
router.post("/new", checkUserId, createThread);

export { router as threadRoutes };
