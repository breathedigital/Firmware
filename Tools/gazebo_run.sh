#!/bin/bash

set -e

if [ "$#" -lt 3 ]; then
	echo usage: gazebo_run.sh model world src_path
	exit 1
fi

model="$1"
world="$2"
src_path="$3"

if [ -z $PX4_SITL_WORLD ]; then
	#Spawn predefined world
	if [ "$world" == "none" ]; then
		if [ -f ${src_path}/Tools/sitl_gazebo/worlds/${model}.world ]; then
			echo "empty world, default world ${model}.world for model found"
			gzserver "${src_path}/Tools/sitl_gazebo/worlds/${model}.world" &
		else
			echo "empty world, setting empty.world as default"
			gzserver "${src_path}/Tools/sitl_gazebo/worlds/empty.world" &
		fi
	else
		#Spawn empty world if world with model name doesn't exist
		gzserver "${src_path}/Tools/sitl_gazebo/worlds/${world}.world" &
	fi
else

	if [ -f ${src_path}/Tools/sitl_gazebo/worlds/${PX4_SITL_WORLD}.world ]; then
		# Spawn world by name if exists in the worlds directory from environment variable
		gzserver "${src_path}/Tools/sitl_gazebo/worlds/${PX4_SITL_WORLD}.world" &
	else
		# Spawn world from environment variable with absolute path
		gzserver "$PX4_SITL_WORLD" &
	fi
fi

gz model --spawn-file="${src_path}/Tools/sitl_gazebo/models/${model}/${model}.sdf" --model-name=${model} -x 1.01 -y 0.98 -z 0.83
