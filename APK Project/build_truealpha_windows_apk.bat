@echo off
title TrueAlpha Studio - Windows EXE & Android APK Automated Builder
echo =====================================================================
echo   TrueAlpha Studio - Automated Windows .EXE & Android .APK Packager
echo =====================================================================
echo.
if not exist "index.html" (
  echo [!] Please place index.html in this same folder before running!
  pause
  exit /b 1
)
echo [1/4] Generating Electron main.js for Windows Desktop App...
(
echo const { app, BrowserWindow } = require("electron"^);
echo const path = require("path"^);
echo function createWindow(^) {
echo   const win = new BrowserWindow({
echo     width: 1440, height: 900, minWidth: 960, minHeight: 640,
echo     backgroundColor: "#090b10", autoHideMenuBar: true,
echo     webPreferences: { nodeIntegration: false, contextIsolation: true }
echo   }^);
echo   win.loadFile(path.join(__dirname, "index.html"^)^);
echo }
echo app.whenReady(^).then(createWindow^);
echo app.on("window-all-closed", (^) =^> { if (process.platform !== "darwin"^) app.quit(^); }^);
) > main.js

echo [2/4] Generating package.json for Electron Builder & Capacitor...
(
echo {
echo   "name": "truealpha-studio",
echo   "version": "1.0.0",
echo   "description": "TrueAlpha Studio - True Transparency Video & GIF Background Remover",
echo   "main": "main.js",
echo   "scripts": {
echo     "start": "electron .",
echo     "dist": "electron-builder --win --x64"
echo   },
echo   "build": {
echo     "appId": "com.truealpha.studio",
echo     "productName": "TrueAlpha Studio",
echo     "win": { "target": "nsis" },
echo     "nsis": { "oneClick": false, "allowToChangeInstallationDirectory": true, "createDesktopShortcut": true }
echo   },
echo   "devDependencies": {
echo     "electron": "^30.0.0",
echo     "electron-builder": "^24.13.3"
echo   }
echo }
) > package.json

echo [3/4] Generating PWA manifest.json and Capacitor config for Android APK...
(
echo {
echo   "name": "TrueAlpha Studio",
echo   "short_name": "TrueAlpha",
echo   "start_url": "./index.html",
echo   "display": "standalone",
echo   "background_color": "#090b10",
echo   "theme_color": "#6366f1"
echo }
) > manifest.json

if not exist "www" mkdir www
copy /Y "index.html" "www\index.html" >nul
copy /Y "manifest.json" "www\manifest.json" >nul
(
echo {
echo   "appId": "com.truealpha.studio",
echo   "appName": "TrueAlpha Studio",
echo   "webDir": "www",
echo   "bundledWebRuntime": false
echo }
) > capacitor.config.json

echo [4/4] Installing dependencies and compiling Windows .EXE Setup Installer...
call npm install
call npm run dist
echo.
echo =====================================================================
echo   DONE! Your Windows Setup .EXE is inside the "dist" folder.
echo   To also build the Android .APK, run:
echo     npm install @capacitor/core @capacitor/cli @capacitor/android
echo     npx cap add android ^&^& npx cap copy
echo     cd android ^&^& gradlew assembleDebug
echo =====================================================================
pause