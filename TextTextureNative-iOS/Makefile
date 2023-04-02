BUILD_DIR=Build
TARGET_NAME=TextTextureNative

framework:
	rm -rf ${BUILD_DIR}
	swift package generate-xcodeproj --skip-extra-files
	xcodebuild \
		-project ${TARGET_NAME}.xcodeproj \
		-scheme ${TARGET_NAME}-Package \
		-configuration Release \
		-sdk iphoneos \
		ENABLE_BITCODE=YES \
		BITCODE_GENERATION_MODE=bitcode \
		OTHER_CFLAGS=-fembed-bitcode \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		CONFIGURATION_BUILD_DIR=${BUILD_DIR}
	rm -r ${TARGET_NAME}.xcodeproj

bundle:
	xcodebuild \
		-project ${TARGET_NAME}-iOS.xcodeproj \
		-scheme ${TARGET_NAME}-macOS \
		-configuration Release \
		-sdk macosx \
		CONFIGURATION_BUILD_DIR=$(CURDIR)/${BUILD_DIR}
