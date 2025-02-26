cmake_minimum_required(VERSION 3.16)
project(KrystaliumAdmin VERSION 2024.0.0)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)
qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

include(FeatureSummary)
find_package(Zax COMPONENTS Core JsonApi Identity)
set_package_properties(Zax PROPERTIES TYPE REQUIRED DESCRIPTION "Zax Application Framework" URL "https://gitlab.com/multiversechronicles/zax/zax-qt")
feature_summary(WHAT REQUIRED_PACKAGES_NOT_FOUND FATAL_ON_MISSING_REQUIRED_PACKAGES)
set(CMAKE_MODULE_PATH ${ZAX_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(GNUInstallDirs)
include(ZaxCompilerSettings NO_POLICY_SCOPE)
include(ZaxCMakeSettings NO_POLICY_SCOPE)

set(BUILD_ANDROID FALSE)
if (CMAKE_SYSTEM_NAME STREQUAL "Android")
    set(BUILD_ANDROID TRUE)
endif()

add_executable(KrystaliumAdmin)
qt_add_qml_module(KrystaliumAdmin URI "Krystal.Admin")

target_sources(KrystaliumAdmin PRIVATE
    main.cpp
    AttributeTypes.cpp
    AttributeTypes.h
    Builder.cpp
    Builder.h
    Effects.cpp
    Effects.h
)

qt_target_qml_sources(KrystaliumAdmin QML_FILES
    Main.qml
    controls/SubtitleDelegate.qml
    controls/GridContentDelegate.qml
    pages/ConnectPage.qml
    pages/OverviewPage.qml
    pages/JsonApiListPage.qml
    pages/RawSamplesPage.qml
    pages/RefinedSamplesPage.qml
    pages/BloodSamplesPage.qml
)

target_link_libraries(KrystaliumAdmin PUBLIC Qt6::Core Qt6::Gui Qt6::Quick Qt6::QuickControls2 Zax::Core Zax::JsonApi)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
