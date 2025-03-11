import { Router } from "express";
import { createYourselfThread } from "../controllers/userController";
import { checkUserId } from "../middlewares/checkUserId";

const router = Router();

router.post(
  "/:userId/create-yourself-thread",
  checkUserId,
  createYourselfThread
);

export { router as userRoutes };
