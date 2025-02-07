interface Auth {
  userId: string;
}

declare namespace Express {
  export interface Request {
    auth?: Auth;
    files?: {
      audioFile?: File & { tempFilePath: string };
      imageFile?: File & { tempFilePath: string };
    };
  }
}
