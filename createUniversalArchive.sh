#!/bin/bash

set -e

abort() {
echo "[fatal] $1"
exit 1
}

test -n "${PROJECT_NAME}" || abort "This script should not be run from the command line, but is used by Xcode"

######################
# Options
######################

REVEAL_ARCHIVE_IN_FINDER=true

FRAMEWORK_NAME="${PROJECT_NAME}"

SIMULATOR_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}.framework"

DEVICE_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework"

UNIVERSAL_LIBRARY_DIR="${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal"

FRAMEWORK="${UNIVERSAL_LIBRARY_DIR}/${FRAMEWORK_NAME}.framework"


######################
# Build Frameworks
######################

xcodebuild -workspace "${FRAMEWORK_NAME}.xcworkspace" -scheme "${FRAMEWORK_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" || exit 1
xcodebuild -workspace "${FRAMEWORK_NAME}.xcworkspace" -scheme "${FRAMEWORK_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6,OS=latest' BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" || exit 1


######################
# Create directory for universal
######################

rm -rf "${UNIVERSAL_LIBRARY_DIR}"

mkdir "${UNIVERSAL_LIBRARY_DIR}"

mkdir "${FRAMEWORK}"


######################
# Copy files Framework
######################

cp -r "${DEVICE_LIBRARY_PATH}/." "${FRAMEWORK}"


######################
# Make an universal binary
######################

set -o pipefail
lipo "${SIMULATOR_LIBRARY_PATH}/${FRAMEWORK_NAME}" "${DEVICE_LIBRARY_PATH}/${FRAMEWORK_NAME}" -create -output "${FRAMEWORK}/${FRAMEWORK_NAME}" | echo  || exit 1

## For Swift framework, Swiftmodule needs to be copied in the universal framework
#if [ -d "${SIMULATOR_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/" ]; then
#cp -f ${SIMULATOR_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/* "${FRAMEWORK}/Modules/${FRAMEWORK_NAME}.swiftmodule/" | echo
#fi
#
#if [ -d "${DEVICE_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/" ]; then
#cp -f ${DEVICE_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/* "${FRAMEWORK}/Modules/${FRAMEWORK_NAME}.swiftmodule/" | echo
#fi

if [ -n "${WORKSPACE}" ]; then
cp -r "${FRAMEWORK}" "${WORKSPACE}"
elif [ ${REVEAL_ARCHIVE_IN_FINDER} = true ]; then
open "${UNIVERSAL_LIBRARY_DIR}/"
fi
