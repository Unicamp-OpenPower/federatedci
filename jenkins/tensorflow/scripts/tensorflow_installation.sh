#!/bin/sh
CONF_ENTRY="tf_conf_entries" #missing path
PIP_PACKAGE="/tmp/tensorflow_pkg/tensorflow-1.5.0rc0-cp27-cp27mu-linux_ppc64le.whl" #it depends on OS, CPU only vs. GPU support and Python version.
BZB_ARGS=""

cd /tensorflow_cpu01 #missing part of the path
./configure < $CONF_ENTRY
bazel build --copt="-mcpu=native" --jobs 1 --local_resources 2048,0.5,1.0 //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
sudo pip install $PIP_PACKAGE
