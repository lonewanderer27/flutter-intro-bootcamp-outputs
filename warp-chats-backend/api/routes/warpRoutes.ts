import { Router } from "express";
import { createWarp } from "../controllers/warpController";

const router = Router();

router.post("/new", createWarp);

export { router as warpRoutes };
