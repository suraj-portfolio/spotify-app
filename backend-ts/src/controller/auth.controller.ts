import { NextFunction, Request, Response } from "express";
import { User } from "../models/user.model.js";
import * as core from "express-serve-static-core";

export const authCallback = async (
  req: Request<core.ParamsDictionary, any, any, any>,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id, firstName, lastName, imageUrl } = req.body;

    // check if user already exists
    const user = await User.findOne({ clerkId: id });

    if (!user) {
      // signup
      await User.create({
        clerkId: id,
        fullName: `${firstName || ""} ${lastName || ""}`.trim(),
        imageUrl,
      });
    }

    res.status(200).json({ success: true });
  } catch (error) {
    console.log("Error in auth callback", error);
    next(error);
  }
};
