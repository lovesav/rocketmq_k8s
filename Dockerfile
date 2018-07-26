#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Start from a Java image.
FROM java:8

ARG version=4.1.0-incubating

# Rocketmq version
ENV ROCKETMQ_VERSION ${version}

# Rocketmq home
#ENV ROCKETMQ_HOME  /data

#WORKDIR  ${ROCKETMQ_HOME}

RUN mkdir -p \
		/data/rocketmq/store/commitlog  \
			/data/logs
RUN cd 

RUN apt-get update && apt-get install dnsutils vim -y

RUN curl https://dist.apache.org/repos/dist/release/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip -o rocketmq.zip \
          && unzip rocketmq.zip \
          && mv rocketmq-all-4.1.0-incubating rocketmq \
         # && rmdir rocketmq-all*  \
          && rm rocketmq.zip


RUN chmod +x rocketmq/bin/mqnamesrv

COPY rmq-plus.sh /rmq-plus.sh
COPY broker.properties /broker.properties
COPY rocketmq-console-ng-1.0.0.jar /rocketmq-console-ng-1.0.0.jar

RUN chmod +x /rmq-plus.sh
RUN sed -i  's#${user.home}#/data#g' ./rocketmq/conf/*.xml

#CMD cd ./bin && export JAVA_OPT=" -Duser.home=/opt" && sh mqnamesrv


EXPOSE 8080 9876 10909 10911
VOLUME /data
CMD [ "/rmq-plus.sh" ]
ENTRYPOINT [ "bash", "-c" ]
