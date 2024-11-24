# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aaoutem- <aaoutem-@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/03/26 18:07:58 by aaoutem-          #+#    #+#              #
#    Updated: 2024/11/24 23:10:28 by aaoutem-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

wpVolumeDir = /home/aaoutem-/data/wordpressvolume
dbVolumeDir = /home/aaoutem-/data/mariadbvolume

all : run

run: build
	docker-compose -f ./srcs/docker-compose.yml up

build:
	@mkdir -p $(wpVolumeDir)
	@mkdir -p $(dbVolumeDir)
	docker-compose -f ./srcs/docker-compose.yml build

rm:
	docker-compose -f ./srcs/docker-compose.yml down
rmi:
	docker image rm srcs-nginx srcs-wordpress srcs-mariadb
rmv:
	docker volume rm -f srcs_mariadb srcs_wordpress

stop:
	docker-compose -f ./srcs/docker-compose.yml stop
start:
	docker-compose -f ./srcs/docker-compose.yml start

prune:
	docker stop $(docker ps -aq) || true
	docker rm -f $(docker ps -aq) || true
	@rm -rf $(wpVolumeDir)
	@rm -rf $(dbVolumeDir)
	docker system prune -a || true

re : prune build