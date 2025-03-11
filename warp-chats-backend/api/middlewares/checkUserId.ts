import { Response, NextFunction, Request } from "express";
import { STATUS } from "../enums/status_enum";

export const checkUserId = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  console.log(`User ID param: ${req.params.userId}`)
  console.log(`User ID body: ${req.body.userId}`)
  const userId = req.params.userId || req.body.userId;

  if (!userId) {
    return res.status(400).send({
      status: STATUS.ERROR,
      error: {
        code: 400,
        message: "User ID was not provided.",
      },
      data: null,
      message: "User ID was not provided.",
    });
  }

  next();
};
