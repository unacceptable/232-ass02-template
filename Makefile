CC = gcc
# The -g flag is essential for the debugger (F5 in VS Code)
# The -Isrc flag allows easy inclusion of header files
CFLAGS = -Wall -g -Isrc

# Windows (mingw32-make) sets OS=Windows_NT and runs recipes in cmd.exe,
# which has md/rmdir but no mkdir -p. Everything else gets a POSIX shell.
ifeq ($(OS),Windows_NT)
    EXE = .exe
    MKDIR = md $(subst /,\,$1)
    RMDIR = if exist $(subst /,\,$1) rmdir /S /Q $(subst /,\,$1)
else
    EXE =
    MKDIR = mkdir -p $1
    RMDIR = rm -rf $1
endif

# Name of the target executable file
TARGET = bin/main$(EXE)

# Object files are placed in the obj/ folder
OBJS = obj/main.o obj/code.o

.PHONY: all clean

all: $(TARGET)

# Linking the program into the bin/ folder
$(TARGET): $(OBJS) | bin
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)

bin:
	$(call MKDIR,bin)

obj:
	$(call MKDIR,obj)

# Compiling main.c -> obj/main.o
obj/main.o: src/main.c | obj
	$(CC) $(CFLAGS) -c src/main.c -o obj/main.o

# Compiling code.c -> obj/code.o
obj/code.o: src/code.c | obj
	$(CC) $(CFLAGS) -c src/code.c -o obj/code.o

clean:
	$(call RMDIR,bin)
	$(call RMDIR,obj)
