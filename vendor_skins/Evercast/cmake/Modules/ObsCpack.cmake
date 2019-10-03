
if(APPLE AND NOT CPACK_GENERATOR)
	set(CPACK_GENERATOR "Bundle")
elseif(WIN32 AND NOT CPACK_GENERATOR)
	set(CPACK_GENERATOR "NSIS")
endif()

set(CPACK_PACKAGE_NAME "EBS")
set(CPACK_PACKAGE_VENDOR "evercast.us")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "EBS - Live video and audio streaming and recording software")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/UI/data/license/gplv2.txt")

set(CPACK_PACKAGE_VERSION_MAJOR "1")
set(CPACK_PACKAGE_VERSION_MINOR "0")
set(CPACK_PACKAGE_VERSION_PATCH "0")
set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

if(NOT DEFINED OBS_VERSION_OVERRIDE)
	if(EXISTS "${CMAKE_SOURCE_DIR}/.git")
		execute_process(COMMAND git describe --always --tags --dirty=-modified
			OUTPUT_VARIABLE EBS_VERSION
			WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
			OUTPUT_STRIP_TRAILING_WHITESPACE)
	else()
		set(EBS_VERSION "${CPACK_PACKAGE_VERSION}")
	endif()
else()
	set(EBS_VERSION "${OBS_VERSION_OVERRIDE}")
endif()

MESSAGE(STATUS "EBS_VERSION: ${EBS_VERSION}")

if(INSTALLER_RUN)
	set(CPACK_PACKAGE_EXECUTABLES
		"ebs32" "EBS (32bit)"
		"ebs64" "EBS (64bit)")
	set(CPACK_CREATE_DESKTOP_LINKS
		"ebs32"
		"ebs64")
else()
	if(WIN32)
		if(CMAKE_SIZEOF_VOID_P EQUAL 8)
			set(_output_suffix "64")
		else()
			set(_output_suffix "32")
		endif()
	else()
		set(_output_suffix "")
	endif()

	set(CPACK_PACKAGE_EXECUTABLES "ebs${_output_suffix}" "EBS")
	set(CPACK_CREATE_DESKTOP_LINKS "ebs${_output_suffix}")
endif()

set(CPACK_BUNDLE_NAME "EBS")
set(CPACK_BUNDLE_PLIST "${CMAKE_SOURCE_DIR}/cmake/osxbundle/Info.plist")
set(CPACK_BUNDLE_ICON "${CMAKE_SOURCE_DIR}/cmake/osxbundle/obs.icns")
set(CPACK_BUNDLE_STARTUP_COMMAND "${CMAKE_SOURCE_DIR}/cmake/osxbundle/obslaunch.sh")

set(CPACK_WIX_TEMPLATE "${CMAKE_SOURCE_DIR}/cmake/Modules/WIX.template.in")

if(INSTALLER_RUN)
	set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "EBS")
	set(CPACK_WIX_UPGRADE_GUID "1f59ff79-2a3c-43c1-b2b2-033a5e6342eb")
	set(CPACK_WIX_PRODUCT_GUID "0c7bec2a-4f07-41b2-9dff-d64b09c9c384")
	set(CPACK_PACKAGE_FILE_NAME "ebs-${EBS_VERSION}")
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
	if(WIN32)
		set(CPACK_PACKAGE_NAME "EBS (64bit)")
	endif()
	set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "EBS64")
	set(CPACK_WIX_UPGRADE_GUID "44c72510-2e8e-489c-8bc0-2011a9631b0b")
	set(CPACK_WIX_PRODUCT_GUID "ca5bf4fe-7b38-4003-9455-de249d03caac")
	set(CPACK_PACKAGE_FILE_NAME "ebs-x64-${EBS_VERSION}")
else()
	if(WIN32)
		set(CPACK_PACKAGE_NAME "EBS (32bit)")
	endif()
	set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "EBS32")
	set(CPACK_WIX_UPGRADE_GUID "a26acea4-6190-4470-9fb9-f6d32f3ba030")
	set(CPACK_WIX_PRODUCT_GUID "8e24982d-b0ab-4f66-9c90-f726f3b64682")
	set(CPACK_PACKAGE_FILE_NAME "ebs-x86-${EBS_VERSION}")
endif()

set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGE_NAME}")

if(UNIX_STRUCTURE)
	set(CPACK_SET_DESTDIR TRUE)
endif()

include(CPack)
