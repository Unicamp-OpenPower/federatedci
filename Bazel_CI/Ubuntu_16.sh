python3 bazel_version.py
if [ $(cat current_version.txt) != $(cat ftp_version.txt) ]
then
    version=$(cat current_version.txt)
    sudo rm -rf work/*
    sudo rm -r work/.bazelci
    sudo wget -P work https://github.com/bazelbuild/bazel/releases/download/$version/bazel-$version-dist.zip
    sudo unzip work/bazel-$version-dist.zip -d work/
    sudo EXTRA_BAZEL_ARGS=--host_javabase=@local_jdk//:jdk ./work/compile.sh
    cd work
    sudo ./../deb-pkg $version
    sudo mv bazel.deb bazel_ppc64le_$version.deb
    sudo mv output/bazel output/bazel_bin_ppc64le_$version
    lftp -c "open -u <LOGIN>,<PASSWORD> <FTP_SERVER>; put -O /ppc64el/bazel/ubuntu_16.04 /home/ubuntu/workspace/bazel-ubuntu16-ppc64le-releases/work/output/bazel_bin_ppc64le_$version" 
    lftp -c "open -u <LOGIN>,<PASSWORD> <FTP_SERVER>; put -O /ppc64el/bazel/ubuntu_16.04/deb_packages /home/ubuntu/workspace/bazel-ubuntu16-ppc64le-releases/work/bazel_ppc64le_$version.deb" 
    cd ..
    del_version=$(cat delete_version.txt)
    lftp -c "open -u <LOGIN>,<PASSWORD> <FTP_SERVER>; rm /ppc64el/bazel/ubuntu_16.04/bazel_bin_ppc64le_$del_version" 
    lftp -c "open -u <LOGIN>,<PASSWORD> <FTP_SERVER>; rm /ppc64el/bazel/ubuntu_16.04/deb_packages/bazel_ppc64le_$del_version.deb" 
fi
