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
    -Dlog.level=VERBOSE \
    -noverify \
    -jar ${srv_loc}/plugins/org.eclipse.equinox.launcher_*.jar \
    -configuration "${tmp_dir}/config_linux" \
    -data "${tmp_dir}/workspace" \
    --add-modules=ALL-SYSTEM --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED \
    -XX:+AggressiveOpts `# Turn on performance compiler optimizations` \
    -XX:PermSize=512m -XX:MaxPermSize=512m `# Increase permanent generation space (where new objects are allocated)` \
    -Xms512m -Xmx2048m `# Increase min and max heap sizes (which includes young and tenured generations)` \
    -Xmn512m `# Increase heap size for the young generation` \
    -Xss2m `# Set stack size for each thread` \
    -XX:+UseG1GC -XX:+UseLargePages `# Tweak garbage collection` \
    "$@"
