python3 bazel_version.py
if [ $(cat current_version.txt) != $(cat ftp_version.txt) ]
then
    version=$(cat current_version.txt)
    sudo rm -rf troca/*
    sudo rm -r troca/.bazelci
    sudo docker exec -i c458d4a0d091 /bin/sh -c "
        wget -P /home/ubuntu/troca https://github.com/bazelbuild/bazel/releases/download/$version/bazel-$version-dist.zip
        unzip /home/ubuntu/troca/bazel-$version-dist.zip -d /home/ubuntu/troca/
        rm /home/ubuntu/troca/bazel-$version-dist.zip
        EXTRA_BAZEL_ARGS=--host_javabase=@local_jdk//:jdk /home/ubuntu/troca/./compile.sh
    "
    cd troca
    sudo ./../deb-pkg $version
    sudo mv bazel.deb bazel_ppc64le_$version.deb
    cd ..
    sudo mv troca/output/bazel troca/output/bazel_bin_ppc64le_$version
    lftp -c "open -u <LOGIN>,<PASSWORD> <FTP_SERVER>; put -O /ppc64el/bazel/ubuntu_14.04 /home/ubuntu/workspace/bazel-docker-ubuntu14-ppc64le-releases/troca/output/bazel_bin_ppc64le_$version" 
    lftp -c "open -u <LOGIN>,<PASSWORD> <FTP_SERVER>; put -O /ppc64el/bazel/ubuntu_14.04/deb_packages /home/ubuntu/workspace/bazel-docker-ubuntu14-ppc64le-releases/troca/bazel_ppc64le_$version.deb" 
    del_version=$(cat delete_version.txt)
    lftp -c "open -u <LOGIN>,<PASSWORD> <FTP_SERVER>; rm /ppc64el/bazel/ubuntu_14.04/bazel_bin_ppc64le_$del_version" 
    lftp -c "open -u <LOGIN>,<PASSWORD> <FTP_SERVER>; rm /ppc64el/bazel/ubuntu_14.04/deb_packages/bazel_ppc64le_$del_version.deb" 
fi