MAKEFLAGS = -rR
.SUFFIXES:

CC := clang
CFLAGS := -fvisibility=hidden -O2 -fPIC

SWIFTC := swiftc
SWIFTFLAGS := -O

TESTS = filestream_test

OBJS := \
  src/stream_stubs.o

all: $(TESTS) $(OBJS)

check: filestream_test
	./filestream_test

filestream_test: test/main.swift src/FileStream.swift src/stream_stubs.h src/stream_stubs.o
	$(SWIFTC) $(SWIFTFLAGS) $< src/FileStream.swift -Xcc -I./src -import-objc-header src/stream_stubs.h -Xlinker src/stream_stubs.o -o $@

src/stream_stubs.o: src/stream_stubs.c src/stream_stubs.h
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(TESTS) $(OBJS)
