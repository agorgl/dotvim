#!/bin/bash

# Eclipse jdt.ls location
srv_loc=/usr/share/java/jdtls

# Lombok addon location
lmb_loc=$HOME/.local/share/java/lombok.jar

# Project location from arguments
prj_loc=$1

# Project unique identifier from location
prj_uid=$(echo -n ${prj_loc} | sha256sum)

# Temporary project directory
tmp_dir="/tmp/jdtls.${prj_uid:0:6}"

# Copy the configuration folder to tmp to be writable
cp -R ${srv_loc}/config_linux "${tmp_dir}"

# And ensure that it is removed on exit
trap "{ rm -rf ${tmp_dir}; }" EXIT

java \
    -cp $lmb_loc \
    -javaagent:$lmb_loc \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -noverify \
    -Xms1G \
    -jar ${srv_loc}/plugins/org.eclipse.equinox.launcher_*.jar \
    -configuration "${tmp_dir}/config_linux" \
    -data "${tmp_dir}/workspace" \
    "$@"
