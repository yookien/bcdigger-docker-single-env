#!/bin/sh

basedir="$(cd `dirname $0`; pwd)"
echo basedir:$basedir
cd ${basedir}

# docker-compose要管理的环境
compose(){
	echo batch $1: mysql ...
	
	cd mysql
	docker-compose $1
	cd ..
	
#	cd activemq
#	docker-compose $1
#	cd ..

#	cd redis-single
#	docker-compose $1
#	cd ..

#	cd solr
#	docker-compose $1
#	cd ..

#	cd zookeeper
#	docker-compose $1
#	cd ..
	
#	cd fastdfs
#	docker-compose $1
#	cd ..
}

if [ "$1" = "" ]; then
    echo ERROR: parameter init\|start\|stop\|rm  missing.
    
elif [ "$1" = "init" ]; then
	
	echo "Initializing env ..."
    # 自定义bridge网络：bcdigger
	BCDIGGER_NET=`docker network ls|grep bcdigger_net`
	if [ -z "${BCDIGGER_NET}" ]; then
		echo "docker network \"bcdigger_net\" does not exists. Creating ..."
		docker network create -d bridge bcdigger_net
        if [ $? = 0 ]; then
            echo 'docker network "bcdigger_net" created.'
        else
            echo ERROR: Creating bcdigger_net error. Please check docker network by using \"docker network ls\".
        fi
	else
		echo $BCDIGGER_NET
		echo \"bcdigger_net\" already exists.
	fi

	# 准备数据文件夹
	# mysql数据文件夹
	if [ ! -d "/home/bcdigger/docker_mapping_file/mysql" ] ; then
		echo "Creating mysql data dir ${HOME}/docker_mapping_file/mysql ..."
		mkdir -p /home/bcdigger/docker_mapping_file/mysql/conf/
		cp /home/bcdigger/bcdigger-docker-single-env/mysql/my.cnf /home/bcdigger/docker_mapping_file/mysql/conf/
		mkdir -p /home/bcdigger/docker_mapping_file/mysql/data/
	fi
	#activeMQ
#	if [ -d "${basedir}/activemq" ] ; then
		# mysql数据文件夹
#		echo "Downloading activeMQ intall file ..."
#		cd ${basedir}/activemq
#		wget http://apache.fayea.com/activemq/5.15.3/apache-activemq-5.15.3-bin.tar.gz
#		cd ..
#	fi
	
#	if [ ! -d "${HOME}/docker-data/fdfs" ] ; then
		# fastdfs数据文件夹
#		echo "Creating fastdfs data dir ${HOME}/docker-data/fdfs ..."
#		mkdir -p ${HOME}/docker-data/fdfs
#	fi
#    if [ ! -d "${HOME}/docker-data/solr-home" ] ; then
		# solr数据文件夹
#        echo "Copy solr-home to ${HOME}/docker-data/ ..."
#        cp -r solr/solr-home ${HOME}/docker-data/
#    fi
    
	# 给sh文件添加执行权限
	echo Add execute permission to *.sh
	find . -name "*.sh" |xargs chmod u+x
	
	echo Initialize env Done...
    
elif [ "$1" = "start" ]; then
        
    # 更新fastfs的IP, 此处也可直接填写虚拟机IP
    # IP=`ifconfig enp0s8 | grep inet | awk '{print $2}'| awk -F: '{print $2}'`
    #sed -i "s|IP=.*$|IP=${IP}|g" fastdfs/docker-compose.yaml
    
    echo BATCH START ...
    compose "up -d"
	
elif [ "$1" = "stop" ]; then
	echo BATCH STOP ...
    compose "stop"
	
elif [ "$1" = "rm" -o "$1" = "del" -o "$1" = "delete" ]; then
	echo BATCH RM ...
    compose "rm"

fi

exit 0
