#!/bin/sh
sleep 5
export JAVA_OPT=" -Duser.home=/opt"
CLUSTER_SERVICE_NAME=${RMQSVC}
#
#
#    while true ; do 
#	count=$(nslookup ${CLUSTER_SERVICE_NAME} 2>/dev/null | grep 'Address' |awk '{print $2}'|grep -v '172.17.0.2'|wc -l)
#	POD_IPS=$(nslookup ${CLUSTER_SERVICE_NAME} 2>/dev/null | grep 'Address' |awk '{print $2}'|grep -v '172.17.0.2')
#        if test $count -gt "1" ; then
#		for I in ${POD_IPS};
#			do
#		        IP_PORT=${I}:9876";"${IP_PORT}
#		        echo ${IP_PORT} >>/log
#		done
#			IP_=`echo ${IP_PORT}|awk '{print $0"\b "}'`
#			sed -i "s/namesrvAddr=/namesrvAddr=${IP_PORT}/g" /broker.properties
#		break
#        fi
#        sleep 8
#    done
#
#sleep 5
 
	sed -i "1ibrokerClusterName=${CLUSTERNAME}" /broker.properties
	sed -i "2ibrokerName=${MY_POD_NAME}" /broker.properties
	sed -i "3inamesrvAddr=${RMQNODE}-0.${CLUSTER_SERVICE_NAME}.${MY_POD_NAMESPACE}:${PORT};${RMQNODE}-1.${CLUSTER_SERVICE_NAME}.${MY_POD_NAMESPACE}:${PORT}" /broker.properties
sh ./rocketmq/bin/mqnamesrv & sh ./rocketmq/bin/mqbroker -c /broker.properties & java -jar /rocketmq-console-ng-1.0.0.jar
