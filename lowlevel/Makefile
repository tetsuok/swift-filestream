MAKEFLAGS = -rR
.SUFFIXES:

CC := clang
CFLAGS := -fvisibility=hidden -O2 -fPIC

SWIFTC := swiftc
SWIFTFLAGS := -O
SWIFT_C_INCLUDE := -Xcc -I./src -import-objc-header src/stream_stubs.h

TESTS = filestream_test

MODULE := FileStream

OBJS := \
	src/FileStream.o \
  src/stream_stubs.o

LIBRARY := lib$(MODULE).a

all: $(TESTS) $(MODULE).swiftmodule $(LIBRARY)

check: filestream_test
	./filestream_test

filestream_test: test/main.swift $(LIBRARY) $(MODULE).swiftmodule
	$(SWIFTC) $(SWIFTFLAGS) -I . -L . -l$(MODULE) $< -o $@

# Module and library

$(MODULE).swiftmodule: src/FileStream.swift src/stream_stubs.h
	$(SWIFTC) -emit-module -module-name $(MODULE) $< $(SWIFT_C_INCLUDE)

$(LIBRARY): $(OBJS)
	ar rcs $@ $^

src/FileStream.o: src/FileStream.swift src/stream_stubs.h
	$(SWIFTC) $(SWIFTFLAGS) -parse-as-library -c $< -o $@ $(SWIFT_C_INCLUDE)

src/stream_stubs.o: src/stream_stubs.c src/stream_stubs.h
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(TESTS) $(OBJS) *.swiftmodule *.swiftdoc $(LIBRARY)
