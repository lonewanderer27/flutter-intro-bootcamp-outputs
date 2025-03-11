import express, { Request, Response } from "express";
import dotenv from "dotenv";
import { initializeFirebase } from "./config/firebase";
import { notificationRoutes } from "./routes/notificationRoutes";
import { userRoutes } from "./routes/userRoutes";
import { threadRoutes } from "./routes/threadRoutes";
import { warpRoutes } from "./routes/warpRoutes";

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

// Initialize Firebase
const { firestore, messaging, auth } = initializeFirebase();

app.use(express.json());
app.get("/", (req: Request, res: Response) => {
  res.send("Warp Chats Server");
});
app.use("/warp", warpRoutes);
app.use("/threads", threadRoutes);
app.use("/notifications", notificationRoutes);
app.use("/users", userRoutes);

app.listen(port, () => {
  console.log(`[server]: Server is running on port ${port}`);
});

export { firestore, messaging, auth };
