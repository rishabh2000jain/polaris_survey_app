echo "Select one of the following option to execute appropriate tasks"
echo "1 - Clean Build"
echo "2 - Clean Build for ios also"
echo "3 - Run build runner"
echo "4 - Run build watcher"
echo "5 - Run build runner with clean build"
echo "6 - Build fresh android apk - Debug"
echo "7 - Build fresh android apk - Profile"
echo "8 - Build fresh android apk - Release"
echo "9 - Build fresh android aab - Release [For playstore]"
echo "10 - Build fresh iOS IPA - Release [For App Store]"
read "choice"

cleanBuild() {
  fvm flutter clean
  fvm flutter pub get
}

cleanAndUpdateIos() {
  cleanBuild
  cd ios && pod install && cd ..
}

runBuildRunnerModeWatch() {
  cleanBuild
  fvm flutter pub run build_runner watch --delete-conflicting-outputs
}

runBuildRunnerModeBuild() {
  fvm flutter pub run build_runner build --delete-conflicting-outputs
}
createIpaBuild() {
  cleanBuild
  fvm flutter build ios --release
}

runBuildRunnerWithClean() {
  cleanBuild
  runBuildRunnerModeBuild
}

cleanAndBuildAndroid() {
  cleanAndUpdate
  fvm flutter build apk
  fvm flutter build appbundle
}

if [ -z "$choice" ];then
    echo "choice cannot be null"
    exit 1
fi
if [ "$choice" == 1 ];then
    cleanBuild
elif [ "$choice" == 2 ];then
    cleanAndUpdateIos
elif [ "$choice" == 3 ];then
    runBuildRunnerModeBuild
elif [ "$choice" == 4 ];then
    runBuildRunnerModeWatch
elif [ "$choice" == 5 ];then
    runBuildRunnerWithClean
elif [ "$choice" == 10 ];then
    createIpaBuild
elif [ "$choice" == 6 ] || [ "$choice" == 7 ] || [ "$choice" == 8 ] || [ "$choice" == 9 ];then
    cleanBuild
    if [ "$choice" == 6 ]; then
        fvm flutter build apk --debug
    elif [ "$choice" == 7 ]; then
        fvm flutter build apk --profile
    elif [ "$choice" == 8 ]; then
        fvm flutter build apk
    else
        fvm flutter build appbundle
    fi
else
    echo "Invalid choice"
    exit 1
fi