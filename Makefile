# Docker section
IMAGE_NAME:=ga-tsp-mpi

.PHONY: build rebuild start bash

build:
	docker build -t $(IMAGE_NAME) .

rebuild:
	docker build --no-cache -t $(IMAGE_NAME) .

start:
	docker run --name $(IMAGE_NAME) -it --rm $(IMAGE_NAME)

bash:
	docker run --name $(IMAGE_NAME) -it --rm --entrypoint="bash" $(IMAGE_NAME)

in_bash:
	docker exec -it $(IMAGE_NAME) bash

.PHONY: build rebuild start bash

# Inside Docker
CC := gcc
CFLAGS := -Wall -O2

OMPI_CC := mpicc
OMPI_CXX := mpic++
OMPI_CFLAGS := -Wall -O2
OMPI_LDFLAGS :=

OUTPUT := ga-tsp-mpi.out

SRCS := $(wildcard *.c)
DEPS := $(patsubst %.c,%.d, $(OBJS))

all: $(OUTPUT)

run: $(OUTPUT)
	mpirun -np 4 --allow-run-as-root $(OUTPUT) cities.txt

$(OUTPUT): main.c
	$(OMPI_CC) -o "$@" -MMD -MP -MT "$@" -MF "$(patsubst %.c,%.d, $<)" $< $(OMPI_CFLAGS) $(OMPI_LDFLAGS)

-include $(DEPS)

