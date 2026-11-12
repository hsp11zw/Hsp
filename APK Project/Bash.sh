npm init -y
npm install @capacitor/core @capacitor/cli @capacitor/android
npx cap add android
npx cap copy
cd android && ./gradlew assembleDebug