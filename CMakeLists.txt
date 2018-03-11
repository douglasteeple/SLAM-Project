cmake_minimum_required(VERSION 1.0.0)
project(slam_project)
find_package(catkin REQUIRED)
catkin_package()

catkin_add_env_hooks(slam_project SHELLS sh DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/env-hooks)

install(DIRECTORY launch
        DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})

install(DIRECTORY maps
        DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})

install(DIRECTORY worlds
        DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})

install(PROGRAMS scripts/teleop 
	DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})
