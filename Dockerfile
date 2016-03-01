FROM 32bit/ubuntu:14.04

MAINTAINER VyronLee <lwz_jz@hotmail.com>

RUN apt-get update && apt-get install -y python git wget make openjdk-7-jre p7zip-full
RUN mkdir /android-dev

#=============================
#   download dependences
#=============================
#android android-dev
RUN wget -P /tmp http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN tar -vzxf /tmp/android-sdk_r24.4.1-linux.tgz -C /tmp \
    && mv /tmp/android-sdk-linux /android-dev/android-sdk

# 2016-03-01
# 1- Android SDK Tools, revision 24.4.1
# 3- Android SDK Platform-tools, revision 23.1
# 4- Android SDK Build-tools, revision 23.0.2
# 26- SDK Platform Android 6.0, API 23, revision 2
RUN echo yes | /android-dev/android-sdk/tools/android update sdk -u -a -t 1,3,4,26

#android ndk
RUN wget -P /tmp http://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin
RUN chmod a+x /tmp/android-ndk-r10e-linux-x86_64.bin
RUN cd /tmp && ./android-ndk-r10e-linux-x86_64.bin
RUN mv /tmp/android-ndk-r10e /android-dev/android-ndk

#ant
RUN apt-get -y install ant

#cleanup
RUN rm -rf /tmp/*

#=============================
#   download frameworks
#=============================
#cocos2dx dev
RUN git clone --branch cocos2d-x-3.10 https://github.com/cocos2d/cocos2d-x.git /cocos2dx
RUN cd /cocos2dx && ./download-deps.py --remove-download yes
RUN cd /cocos2dx && git submodule update --init


#=============================
#   set environments
#=============================
#develop environment
ENV ANDROID_HOME=/android-dev/android-sdk

# Add environment variable NDK_ROOT for cocos2d-x
ENV NDK_ROOT=/android-dev/android-ndk
ENV PATH=$NDK_ROOT:$PATH

# Add environment variable ANDROID_SDK_ROOT for cocos2d-x
ENV ANDROID_SDK_ROOT=/android-dev/android-sdk
ENV PATH=$ANDROID_SDK_ROOT:$PATH
ENV PATH=$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools:$PATH

# Add environment variable ANT_ROOT for cocos2d-x
ENV ANT_ROOT=/usr/bin
ENV PATH=$ANT_ROOT:$PATH

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
ENV COCOS_CONSOLE_ROOT=/cocos2dx/tools/cocos2d-console/bin
ENV PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
ENV COCOS_TEMPLATES_ROOT=/cocos2dx/templates
ENV PATH=$COCOS_TEMPLATES_ROOT:$PATH

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
ENV COCOS_CONSOLE_ROOT=/cocos2dx/tools/cocos2d-console/bin
ENV PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
ENV COCOS_TEMPLATES_ROOT=/cocos2dx/templates
ENV PATH=$COCOS_TEMPLATES_ROOT:$PATH

#entrypoint
WORKDIR /project
ENTRYPOINT ["/cocos2dx/tools/cocos2d-console/bin/cocos"]

