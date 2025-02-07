import { NextFunction, Request, Response } from "express";
import { Album } from "../models/album.model.js";

export const getAllAlbums = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const albums = await Album.find();
    res.status(200).json(albums);
  } catch (error) {
    next(error);
  }
};

export const getAlbumById = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { albumId } = req.params;

    const album = await Album.findById(albumId).populate("songs");

    if (!album) {
      res.status(404).json({ message: "Album not found" });
      next();
    }

    res.status(200).json(album);
  } catch (error) {
    next(error);
  }
};
