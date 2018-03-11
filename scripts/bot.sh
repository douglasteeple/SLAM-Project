#!/bin/bash
##################################################################
#
# Udacity Term 2 SLAM Project launch script
#          Douglas Teeple March 2018
#
##################################################################

RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
YELLOW='\e[0;33m'
CYAN='\e[0;36m'
MAGENTA='\e[0;35m'
BRIGHTRED='\e[1;31m'
BRIGHTGREEN='\e[1;32m'
BRIGHTBLUE='\e[1;34m'
BRIGHTYELLOW='\e[1;93m'
BRIGHTCYAN='\e[1;96m'
BRIGHTMAGENTA='\e[1;95m'
NC='\e[0m' # No Color

function launch() {
	if [[ "$2" != "" ]]
	then
		sleep $2
	fi
	echo -e ${BLUE}"$1"${NC}
	xterm -e $1 &
}

function help() {
	echo -e ${GREEN}"$(basename $0): [-k] [-w<worldfile>] [-s<mapfile>] [--rviz] [--gazebo]	[--localization] [--killall]"${NC};
	echo -e ${GREEN}"launch SLAM Project, -k keeps the old map, -w names a world file -s saves a mapfile"${NC};
	echo -e ${GREEN}"--rviz launches rviz only"${NC};
	echo -e ${GREEN}"--gazebo launches gazebo only"${NC};
	echo -e ${GREEN}"--localization performs localization only"${NC};
	echo -e ${GREEN}"--killall kills a previous run"${NC};
}

echo -e ${BLUE}"Starting Slam Project"${NC}
source devel/setup.bash

worlds=$HOME/catkin_ws/src/slam_project/worlds
world=kitchen_dining.world

keep=0
RVIZONLY=0
GAZEBOONLY=0
LOCALIZATIONONLY=0
KILLALL=0
mapfile=""

for arg in $*
do
	case $arg in
	-h|--help)
		help;
		exit;;
	-k|--keep)
		keep=1;;
	-s*)
		mapfile=${arg#-s};
		keep=1;;
	--rviz)
		RVIZONLY=1;
		keep=1;;
	--gazebo)
		GAZEBOONLY=1;;
	--loc*)
		LOCALIZATIONONLY=1;;
	--kill*)
		KILLALL=1;
		keep=1;;
	-w*)
		if [ -e ${worlds}/${arg#-w} ]
		then
			world=${arg#-w};
		else
			echo -e ${YELLOW}"World ${arg#-w} can't be found, defaulting to ${world}"${NC};
		fi;;
	*)
		echo -e ${RED}"Invalid parameter: $arg"${NC};
		help;
		exit;;
	esac
done
if (( keep == 0 ))
then
	echo -e ${BLUE}"Deleting map in ~/.ros/rtabmap.db"${NC};
	rm -f ~/.ros/rtabmap.db;
fi

if (( RVIZONLY == 1 ))
then
	launch 'roslaunch slam_project rviz.launch'
elif (( GAZEBOONLY == 1 ))
then
	launch "roslaunch slam_project slam_project_world.launch world_file:=${worlds}/${world}" 
elif (( KILLALL == 1 ))
then
	killall xterm roslaunch rtabmap
elif [[ "${mapfile}" != "" ]]
then
	rosrun map_server map_saver -f ${mapfile}
else
	launch "roslaunch slam_project slam_project_world.launch world_file:=${worlds}/${world}" 

	launch 'roslaunch slam_project rviz.launch' 5

	launch 'roslaunch slam_project teleop.launch' 5
	if (( LOCALIZATIONONLY == 1 ))
	then
		launch 'roslaunch slam_project localization.launch localization:=true' 5
	else
		launch 'roslaunch slam_project mapping.launch simulation:=true' 5
	fi

	launch "roslaunch turtlebot_interactive_markers interactive_markers.launch"
fi

