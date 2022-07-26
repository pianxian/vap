#! /bin/sh

path=$(cd "$(dirname "$0")";pwd)
cd $path

files=$(ls $path)
metal_array=()
air_array=()
index=0

for filename in $files
do
    if [ ${filename##*.} == 'metal' ]
    then
        echo ${filename}
        prefix=${filename%%.*}
        air_array[index]=$prefix".air"
        metal_array[index]=$prefix".metal"
        let index++
        air_command="xcrun -sdk iphoneos metal -c -target air64-apple-ios12.0 "
        air_command+=$prefix".metal"
        air_command+=" -o "
        air_command+=$prefix".air"
        $air_command
    fi
done

bulid_command="xcrun -sdk iphoneos metal -std=ios-metal2.1 -mios-version-min=12.0 "
remove_command="rm "

for (( i = 0; i < index; i++ )); do
    bulid_command+=${air_array[i]}
    bulid_command+=" "
    remove_command+=${air_array[i]}
    remove_command+=" "
done

bulid_command+="-o QGHWDShaders.metallib"
$bulid_command
$remove_command

# xcrun -sdk iphoneos metal -c -target air64-apple-ios9.0 mix.metal -o mix.air
# xcrun -sdk iphoneos metal -c -target air64-apple-ios9.0 no_green.metal -o no_green.air
# xcrun -sdk iphoneos metal -std=ios-metal1.1 -mios-version-min=9.0 mix.air no_green.air -o alpha_video_renderer.metallib

# rm mix.air no_green.air
