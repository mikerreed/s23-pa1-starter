# define CPPFLAGS=-I... for other (system) includes
# define LDFLAGS=-L... for other (system) libs to link

CC = g++ -g -Wno-float-conversion -Wno-narrowing -Wreturn-type -Wunused-function -Wreorder -Wunused-variable

CC_DEBUG = @$(CC) -std=c++11
CC_RELEASE = @$(CC) -std=c++11 -O3 -DNDEBUG

G_SRC = src/*.cpp *.cpp
G_TEST_SRC = apps/tests*

G_INC = -Iinclude -Iapps $(CPPFLAGS)

G_LINK = $(LDFLAGS)

all: image tests bench

image : $(G_SRC) apps/image.cpp apps/image_recs.cpp
	$(CC_DEBUG) $(G_INC) $(G_SRC) apps/image.cpp apps/image_recs.cpp -o image

tests : $(G_SRC) $(G_TEST_SRC) $(G_DEPS) apps/tests.cpp apps/tests_recs.cpp
	$(CC_DEBUG) $(G_INC) $(G_SRC) apps/tests.cpp apps/tests_recs.cpp -o tests

bench : $(G_SRC) $(G_DEPS) apps/bench.cpp apps/bench_recs.cpp apps/GTime.cpp
	$(CC_RELEASE) $(G_INC) $(G_SRC) apps/GTime.cpp apps/bench.cpp apps/bench_recs.cpp -o bench

# debug variant of bench -- not any good for timing, but helps debugging --once
dbench : $(G_SRC) $(G_DEPS) apps/bench.cpp apps/bench_recs.cpp apps/GTime.cpp
	$(CC_DEBUG) $(G_INC) $(G_SRC) apps/GTime.cpp apps/bench.cpp apps/bench_recs.cpp -o dbench

DRAW_SRC = apps/draw.cpp apps/GWindow.cpp apps/GTime.cpp
draw: $(DRAW_SRC) $(G_SRC)
	$(CC_RELEASE) $(G_INC) $(G_SRC) $(G_LINK) $(DRAW_SRC) -lSDL2 -o draw

clean:
	@rm -rf image tests bench dbench draw *.png *.dSYM

