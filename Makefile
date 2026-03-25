END      := $(shell printf "\033[0m")
WHITE    := $(shell printf "\033[1;37m")
NC       := $(shell printf "\033[0m")
PINK     := $(shell printf "\033[1;35m")
GREEN    := $(shell printf "\033[32m")
BOLD     := $(shell printf "\033[1m")
L_PURPLE := $(shell printf "\033[38;5;55m")
YELLOW   := $(shell printf "\033[33m")
BLUE     := $(shell printf "\033[34m")
BLACK    := $(shell printf "\033[1;90m")

all:			up

up:				
				mkdir -p /home/atomasi/data
				mkdir -p /home/atomasi/data/wordpress
				mkdir -p /home/atomasi/data/mariadb
				@docker-compose -f ./srcs/docker-compose.yml up -d --build
				@docker-compose -f ./srcs/docker-compose.yml ps
				@echo "${BOLD}${GREEN}Containers up${END}"

down:
				@echo "${BOLD}${BLUE}Stopping containers...${END}"
				@docker-compose -f ./srcs/docker-compose.yml down
				@echo "${BOLD}${BLUE}Containers stopped. Volumes and images still available.${END}"

clean:			down
				@echo "${BOLD}${YELLOW}Removing containers, and volumes...${END}"
				@docker-compose -f ./srcs/docker-compose.yml down -v
				@echo "${BOLD}${YELLOW}Containers and volumes removed. Images still available.${END}"

fclean:			down
				@echo "${BOLD}${PINK}Removing containers, volumes, and images...${END}"
				@docker-compose -f ./srcs/docker-compose.yml down -v --rmi all
				@docker image prune -f
				@docker-compose -f ./srcs/docker-compose.yml ps
				@echo "${BOLD}${PINK}Complete cleanup done!${END}"

re:				fclean all

.PHONY:			all down re up clean fclean


