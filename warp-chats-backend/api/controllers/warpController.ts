import { Request, Response } from "express";
import { STATUS } from "../enums/status_enum";
import { firestore } from "..";
import { getThread } from "../utils/firestoreHelpers";
import { nanoid } from "nanoid";

export const createWarp = async (req: Request, res: Response) => {
  const { threadId } = req.body;

  if (!threadId) {
    return res.status(400).send({
      status: STATUS.ERROR,
      error: { code: 400, message: "Thread ID was not provided." },
      data: null,
      message: "Thread ID was not provided.",
    });
  }

  try {
    // check if the thread exists
    const thread = await getThread(threadId);

    if (!thread.exists) {
      console.error(`Thread ID:${threadId} doesn't exist!`);
      res.status(500).send({
        status: STATUS.ERROR,
        error: {
          code: 500,
          message: `Thread ID:${threadId} doesn't exist!`,
        },
        data: null,
        message: `Thread ID:${threadId} doesn't exist!`,
      });
    }

    console.log(`Creating warp for Thread ID: ${threadId}`)

    // // Check if there's already a warp for this threadId
    // const existingWarps = await firestore
    //   .collection("warp")
    //   .where("threadId", "==", threadId)
    //   .get();

    // const existingWarp = existingWarps.docs[0];

    // // if there is, return an error
    // if (!existingWarps.empty) {
    //   const errorMsg = `Error: There is a Warp ID: ${existingWarp.get(
    //     "warpId"
    //   )} for Thread ID: ${threadId}`;
    //   return res.status(409).send({
    //     status: STATUS.ERROR,
    //     error: {
    //       code: 409,
    //       warpId: existingWarp.get("warpId"),
    //       message: errorMsg,
    //     },
    //     data: null,
    //     message: errorMsg,
    //   });
    // }

    // generate a fresh warp using nanoid
    const warpId = nanoid(8);
    const warpRef = firestore.collection("warp").doc(warpId);
    const warpData = {
      warpId: warpId,
      threadId: thread.id,
    };
    await warpRef.set(warpData);

    const successMsg = `Warp ID: ${warpId} has been created for Thread ID: ${threadId}`;
    res.status(201).send({
      status: STATUS.SUCCESS,
      error: null,
      data: {
        warpId: warpId,
      },
      message: successMsg,
    });

    console.log(successMsg);
  } catch (error) {
    console.error(error);
    res.status(500).send({
      status: STATUS.ERROR,
      error: {
        code: 500,
        message: `Error: ${error}`,
      },
      data: null,
      message: `Error: ${error}`,
    });
  }
};
