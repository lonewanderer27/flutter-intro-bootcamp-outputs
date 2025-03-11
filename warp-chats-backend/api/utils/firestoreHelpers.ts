import { firestore } from "..";

const getUser = (userId: string) => {
  return firestore.collection("users").doc(userId).get();
};

const getThread = (threadId: string) => {
  return firestore.collection("threads").doc(threadId).get();
};

const getThreadChat = (chatId: string, threadId: string) => {
  return firestore
    .collection("threads")
    .doc(threadId)
    .collection("chats")
    .doc(chatId)
    .get();
};

const getThreadUser = (userId: string, threadId: string) => {
  return firestore
    .collection("threads")
    .doc(threadId)
    .collection("users")
    .doc(userId)
    .get();
};

const getUserThread = (userId: string, threadId: string) => {
  return firestore
    .collection("user_threads")
    .doc(userId)
    .collection("chats")
    .doc(threadId)
    .get();
};

const getWarp = (warpId: string) => {
  return firestore.collection("warp").doc(warpId).get();
};

const getUserFromUsername = (username: String) => {
  return firestore
    .collection("users")
    .where("username", "==", username)
    .limit(1)
    .get();
};



export {
  getUser,
  getThread,
  getThreadChat,
  getThreadUser,
  getUserThread,
  getWarp,
  getUserFromUsername,
};
