import { Request, Response } from "express";
import { STATUS } from "../enums/status_enum";
import {
  getThread,
  getThreadUser,
  getUser,
  getUserThread,
  getWarp,
} from "../utils/firestoreHelpers";
import { firestore } from "..";

export const joinThread = async (req: Request, res: Response) => {
  /*
    Errors:
    - 400: Warp, user id not provided
    - 404: Warp ID not found
    - 404: No valid thread under warp code
    - 404: Thread does not exist
    - 409: User already joined the thread
    - 500: Internal Server Error
  */
  const { userId, warpId } = req.body;

  if (!userId) {
    return res.status(400).send({
      status: STATUS.ERROR,
      error: { code: 400, message: "User ID was not provided." },
      data: null,
      message: "User ID was not provided.",
    });
  }

  if (!warpId) {
    return res.status(400).send({
      status: STATUS.ERROR,
      error: { code: 400, message: "Warp ID was not provided." },
      data: null,
      message: "Warp ID was not provided.",
    });
  }

  try {
    // Fetch the warp tunnel based on the code
    // so we can get hold of the threadId it is linked to
    const [warp, user] = await Promise.all([getWarp(warpId), getUser(userId)]);

    if (!warp.exists) {
      return res.status(404).send({
        status: STATUS.ERROR,
        error: { code: 404, message: "Warp ID not found or invalid." },
        data: null,
        message: "Warp ID not found or invalid.",
      });
    }

    const threadId = warp.get("threadId");

    if (!threadId) {
      return res.status(404).send({
        status: STATUS.ERROR,
        error: { code: 404, message: "No thread associated with this warp." },
        data: null,
        message: "No thread associated with this warp.",
      });
    }

    // Check if the thread exists
    const thread = await getThread(threadId);

    if (!thread.exists) {
      return res.status(404).send({
        status: STATUS.ERROR,
        error: { code: 404, message: "Thread does not exist." },
        data: null,
        message: "Thread does not exist.",
      });
    }

    // Check if the user is already joined in this thread
    // We can do this in two ways for consistency:

    // 1. Check in the /threads/:threadId/users collection
    //    to see if the userId exists in that collection.

    // OR

    // 2. Check in the /user_threads/:userId/threads collection
    //    to see if the threadId exists in that collection.

    // Using Promise.all to speed up execution
    const [threadUser, userThread] = await Promise.all([
      getThreadUser(userId, threadId),
      getUserThread(userId, threadId),
    ]);

    if (threadUser.exists || userThread.exists) {
      return res.status(409).send({
        status: STATUS.ERROR,
        error: {
          code: 409,
          message: `User ID ${userId} is already a member of Thread ID ${threadId}.`,
        },
        data: null,
        message: `User ID ${userId} is already a member of Thread ID ${threadId}.`,
      });
    }

    // Add the thread to user_threads
    const userThreadData = { name: thread.get("name"), threadId: thread.id };
    await firestore
      .collection("user_threads")
      .doc(userId)
      .collection("threads")
      .doc(threadId)
      .set(userThreadData);

    // Add the user to thread/users collection
    const threadUserData = {
      username: user.get("username"),
      avatarBase64: user.get("avatarBase64"),
    };
    await firestore
      .collection("threads")
      .doc(thread.id)
      .collection("users")
      .doc(userId)
      .set(threadUserData);

    res.status(200).send({
      status: STATUS.SUCCESS,
      error: null,
      data: { threadId },
      message: `User ID ${userId} successfully joined Thread ID ${threadId}.`,
    });
  } catch (error) {
    console.error(error);
    res.status(500).send({
      status: STATUS.ERROR,
      error: { code: 500, message: `Internal Server Error: ${error}` },
      data: null,
      message: "An error occurred while processing your request.",
    });
  }
};

export const createThread = async (req: Request, res: Response) => {
  /*
    Errors:
    - 400: Thread name not provided
    - 500: Internal Server Error
  */
  const { name, userId } = req.body;

  if (!name) {
    return res.status(400).send({
      status: STATUS.ERROR,
      error: { code: 400, message: "Thread name was not provided." },
      data: null,
      message: "Thread name was not provided.",
    });
  }

  try {
    // Get the user data which includes:
    // - username
    // - avatarBase64
    const userRef = firestore.collection("users").doc(userId);
    const userRefData = await userRef.get();

    // Create the thread
    const threadRef = firestore.collection("threads").doc();
    await threadRef.set({ name });

    // Add the user to the thread
    const threadUserData = {
      username: userRefData.get("username"),
      avatarBase64: userRefData.get("avatarBase64"),
    };
    await firestore
      .collection("threads")
      .doc(threadRef.id)
      .collection("users")
      .doc(userId)
      .set(threadUserData);

    // Add the newly created thread to user_threads
    const userThreadData = { name, threadId: threadRef.id };
    await firestore
      .collection("user_threads")
      .doc(userId)
      .collection("threads")
      .doc(threadRef.id)
      .set(userThreadData);

    res.status(201).send({
      status: STATUS.SUCCESS,
      error: null,
      data: { threadId: threadRef.id },
      message: `Thread created successfully: ${threadRef.id}.`,
    });
  } catch (error) {
    console.error(error);
    res.status(500).send({
      status: STATUS.ERROR,
      error: { code: 500, message: `Internal Server Error: ${error}` },
      data: null,
      message: "An error occurred while creating the thread.",
    });
  }
};
