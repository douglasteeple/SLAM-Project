# SLAM-Project

SLAM in robotics comprises Localization - determining a good approximation of the current position of a robot given uncertainties due to noisy sensors and imperfect actuators moving the robot while simultaneously Mapping the unknown environment with no prior given map.
This project consists of creating a ROS (Robot Operating System) catkin workspace that includes a launch script, launch files for gazebo and RVIZ, a robot definition includ- ing integration of a Kinect RGBD camera with an associated depth image to laser scanner node, teleop and interactive markers to move the robot in the environment and RTAB-Map (an implementation of fast GraphSLAM). The project software generates maps and shows loop detection in two worlds. 
