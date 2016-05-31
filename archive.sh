#!/usr/bin/env bash

PRJ_NAME='MyProject'
WORK_PATH='~/Workspace/ClientDemo/ios'
BUILD_PATH="~/Desktop/build/"
ARCHIVE_PATH="${BUILD_PATH}${PRJ_NAME}.xcarchive"
IPA_PATH="${BUILD_PATH}${PRJ_NAME}.ipa"
PROVISION_PROFILE="adhoc"

echo "PRJ_NAME:$PRJ_NAME"
echo "WORK_PATH:$WORK_PATH"
echo "ARCHIVE_PATH:$ARCHIVE_PATH"
echo "IPA_PATH:$IPA_PATH"

echo "========Clean Olds====>"
rm  $IPA_PATH
rm  -rf $ARCHIVE_PATH

mkdir -p $BUILD_PATH

echo "Start AUTOBUILD======>"
echo "========Move To Workspace path====>"
cd $WORK_PATH && pwd

echo "========Git pull====>"
git stash
git pull --rebase
git stash pop

echo "======== Available provisioning profiles"
security find-identity -p codesigning -v

echo "======== Available SDKs"
xcodebuild -showsdks

echo "======== Available schemes"
xcodebuild -list -project $PRJ_NAME.xcodeproj

#git checkout release
#git pull
echo "========run xcodebuild====>"
echo "xcodebuild  -workspace $PRJ_NAME.xcworkspace -scheme $PRJ_NAME\
  archive -archivePath $ARCHIVE_PATH "
xcodebuild -workspace $PRJ_NAME.xcworkspace -scheme $PRJ_NAME\
 	archive -archivePath $ARCHIVE_PATH 

echo "======== export archive====>"
xcodebuild -exportArchive -exportFormat ipa\
	-archivePath $ARCHIVE_PATH\
	-exportPath $IPA_PATH\
	-exportProvisioningProfile $PROVISION_PROFILE\

cd $BUILD_PATH && pwd
#archivePath=`ls -df ($PRJ_NAME)* | tail -1`
#echo $archivePath

echo "== Start Upload=======>"
#cd $archivePath
#ipa distribute:pgyer -u [User_Key] -a [API_Key]