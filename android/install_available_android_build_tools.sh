#!/usr/bin/env bash
########################################################
# This script will install all build-tools of android 
########################################################

sdkmanager="${ANDROID_HOME}/tools/bin/sdkmanager"
if [ -x "${sdkmanager}" ]; then
    "${sdkmanager}" --update > /dev/null
    if [ $? -ne 0 ]; then
        echo "sdkmanager fails. This server is not for android"
        exit
    fi
else
    echo "sdkmanager doesn't exist. This server is not for android"
    exit
fi

lines=`${ANDROID_HOME}/tools/bin/sdkmanager --list`
start=`echo "$lines"|grep -n "Available Packages:"|awk -F ":" '{print $1}'`
end=`echo "$lines"|wc -l`
num_of_available_packages=`expr ${end} - ${start}`
available_packages=`echo "$lines"|tail -n ${num_of_available_packages}`
# exclude rc version
buildtools=`echo "${available_packages}"| grep 'build-tools;'| grep -v "\-rc"| awk '{print $1}'`
for tool in `echo "${buildtools}"`; do
    echo ${sdkmanager} --install ${tool}
    ${sdkmanager} --install ${tool}
done
