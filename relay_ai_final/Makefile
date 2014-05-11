CC=/usr/local/arm-linux-4.1.1/bin/arm-iwmmxt-linux-gnueabi-gcc -lm -pthread

CFLAGS += -mcpu=iwmmxt -mtune=iwmmxt -mabi=aapcs-linux  \
		-I./ -I./lib -DDEBUG_BUILD

SRC_COMMON = lib/camera.c lib/overlay2.c

SRC_YELLOW = linetracing_client.c module/threePoint_Y.c $(SRC_COMMON)
SRC_RED = linetracing_server.c module/threePoint_R.c $(SRC_COMMON)

OBJ_YELLOW = ${SRC_YELLOW:.c=.o}
OBJ_RED = ${SRC_RED:.c=.o}

LFLAGS += -lpthread

BUILDDIR = bin/

OUT_YELLOW = linetrace_yellow_norang
OUT_RED = linetrace_red_bbalgang

all: $(OUT_YELLOW) $(OUT_RED)

$(OUT_YELLOW): $(OBJ_YELLOW)
	mkdir -p $(BUILDDIR)
	$(CC) $(LDFLAGS) -o $(BUILDDIR)$(OUT_YELLOW) $(OBJ_YELLOW) $(LIBS)

$(OUT_RED): $(OBJ_RED)
	mkdir -p $(BUILDDIR)
	$(CC) $(LDFLAGS) -o $(BUILDDIR)$(OUT_RED) $(OBJ_RED) $(LIBS)

clean: 
	rm -f $(BUILDDIR)$(OUT_YELLOW) $(BUILDDIR)$(OUT_RED) *.o *.?~ module/*.o module/*.?~ 
