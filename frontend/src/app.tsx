import { Route, Routes } from "react-router-dom";
import HomePage from "./pages/home/home-page";
import AuthCallbackPage from "./pages/auth-callback/auth-callback-page";
import { AuthenticateWithRedirectCallback } from "@clerk/clerk-react";
import MainLayout from "./layout/main-layout";
import ChatPage from "./pages/chat/chat-page";
import AlbumPage from "./pages/album/album-page";
import AdminPage from "./pages/admin/admin-page";

import { Toaster } from "react-hot-toast";
import NotFoundPage from "./pages/404/not-found-page";

function App() {
  return (
    <>
      <Routes>
        <Route
          path="/sso-callback"
          element={
            <AuthenticateWithRedirectCallback
              signUpForceRedirectUrl={"/auth-callback"}
            />
          }
        />
        <Route path="/auth-callback" element={<AuthCallbackPage />} />
        <Route path="/admin" element={<AdminPage />} />

        <Route element={<MainLayout />}>
          <Route path="/" element={<HomePage />} />
          <Route path="/chat" element={<ChatPage />} />
          <Route path="/albums/:albumId" element={<AlbumPage />} />
          <Route path="*" element={<NotFoundPage />} />
        </Route>
      </Routes>
      <Toaster />
    </>
  );
}

export default App;
