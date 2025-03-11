import { Router } from "express";
import {
  sendNotification,
  sendNotificationToThread,
} from "../controllers/notificationController";

const router = Router();

router.post("/threads/:threadId/chats/:chatId", sendNotificationToThread);
router.post("/chats/:chatId", sendNotification);

export { router as notificationRoutes };
