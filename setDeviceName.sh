#!/bin/bash

# https://github.com/ethanr-io/jamf-scripts
# Tested on macOS 15.1

loggedInUser=$(ls -l /dev/console | awk '{ print $3 }')
# Alt: loggedInUser=$(stat -f%Su /dev/console)

userFullName=$(dscl . -read /Users/$loggedInUser RealName | cut -d: -f2 | sed -e 's/^[ \t]*//' | grep -v "^$")
userFullNameHost=(${userFullName// /-})

# Get the system information
systemInfo=$(system_profiler SPHardwareDataType)

# Extract the model name from the output
modelName=$(echo "$systemInfo" | grep -i "Model Name" | awk '{print $3,$4}')

#  Need to define the non MacBooks options
if [[ "$modelName" == "MacBook Air" ]]; then
    hostSuffix='MBA'
  elif [[ "$modelName" == "MacBook Pro" ]]; then
    hostSuffix='MBP'
  elif [[ "$modelName" == "Mac Mini" ]]; then
    hostSuffix='Mac Mini'
  elif [[ "$modelName" == "iMac" ]]; then
    hostSuffix='iMac'
else
    exit
fi

computerName="$userFullName's $hostSuffix"
hostName="${userFullNameHost}s-$hostSuffix"

echo $computerName
echo $hostName

# Set the ComputerName and LocalHostName
/usr/sbin/scutil --set ComputerName "$computerName"
/usr/sbin/scutil --set LocalHostName "$hostName"

exit 0