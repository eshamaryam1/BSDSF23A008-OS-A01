# ==============================================================================
# Operating Systems Assignment - Complete Makefile (Features 1-4)
# ==============================================================================

# Compiler and flags
CC = gcc
CFLAGS = -Wall -g -I./include
CFLAGS_SHARED = $(CFLAGS) -fPIC
LDFLAGS =

# Directories
SRC_DIR = src
INC_DIR = include
BIN_DIR = bin
LIB_DIR = lib
OBJ_DIR = obj
OBJ_SHARED_DIR = obj_shared
MAN_DIR = man

# Source files
SRC_FILES = $(wildcard $(SRC_DIR)/*.c)
OBJ_FILES = $(SRC_FILES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
OBJ_SHARED_FILES = $(SRC_FILES:$(SRC_DIR)/%.c=$(OBJ_SHARED_DIR)/%.o)

# Library object files (excluding main.o)
LIB_OBJ_FILES = $(filter-out $(OBJ_DIR)/main.o, $(OBJ_FILES))
LIB_OBJ_SHARED_FILES = $(filter-out $(OBJ_SHARED_DIR)/main.o, $(OBJ_SHARED_FILES))

# Targets
TARGET_DIRECT = $(BIN_DIR)/client_direct
STATIC_LIB = $(LIB_DIR)/libmputils.a
DYNAMIC_LIB = $(LIB_DIR)/libmputils.so
TARGET_STATIC = $(BIN_DIR)/client_static
TARGET_DYNAMIC = $(BIN_DIR)/client_dynamic

# Default target - build everything
all: direct static dynamic
# ==============================================================================
# Complete Makefile for Features 2-4
# ==============================================================================

CC = gcc
CFLAGS = -Wall -g -I./include
CFLAGS_SHARED = $(CFLAGS) -fPIC

# Directories
BIN_DIR = bin
LIB_DIR = lib
OBJ_DIR = obj
OBJ_SHARED_DIR = obj_shared

# Default target - build ALL versions
all: direct static dynamic

# ------------------------------------------------------------------------------
# FEATURE 2: Direct compilation
# ------------------------------------------------------------------------------
direct: $(BIN_DIR)/client

$(BIN_DIR)/client: $(OBJ_DIR)/main.o $(OBJ_DIR)/mystrfunctions.o $(OBJ_DIR)/myfilefunctions.o
	@mkdir -p $(BIN_DIR)
	$(CC) $^ -o $@
	@echo "Feature 2: Direct build complete - $(BIN_DIR)/client"

# ------------------------------------------------------------------------------
# FEATURE 3: Static library
# ------------------------------------------------------------------------------
static: $(BIN_DIR)/client_static

$(BIN_DIR)/client_static: $(OBJ_DIR)/main.o $(LIB_DIR)/libmputils.a
	@mkdir -p $(BIN_DIR)
	$(CC) $(OBJ_DIR)/main.o -L$(LIB_DIR) -lmputils -o $@
	@echo "Feature 3: Static build complete - $(BIN_DIR)/client_static"

$(LIB_DIR)/libmputils.a: $(OBJ_DIR)/mystrfunctions.o $(OBJ_DIR)/myfilefunctions.o
	@mkdir -p $(LIB_DIR)
	ar rcs $@ $^
	ranlib $@
	@echo "Static library created - $(LIB_DIR)/libmputils.a"

# ------------------------------------------------------------------------------
# FEATURE 4: Dynamic library
# ------------------------------------------------------------------------------
dynamic: $(BIN_DIR)/client_dynamic

$(BIN_DIR)/client_dynamic: $(OBJ_DIR)/main.o $(LIB_DIR)/libmputils.so
	@mkdir -p $(BIN_DIR)
	$(CC) $(OBJ_DIR)/main.o -L$(LIB_DIR) -lmputils -o $@
	@echo "Feature 4: Dynamic build complete - $(BIN_DIR)/client_dynamic"

$(LIB_DIR)/libmputils.so: $(OBJ_SHARED_DIR)/mystrfunctions.o $(OBJ_SHARED_DIR)/myfilefunctions.o
	@mkdir -p $(LIB_DIR)
	$(CC) -shared $^ -o $@
	@echo "Dynamic library created - $(LIB_DIR)/libmputils.so"

# ------------------------------------------------------------------------------
# Object file compilation
# ------------------------------------------------------------------------------
$(OBJ_DIR)/%.o: src/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_SHARED_DIR)/%.o: src/%.c
	@mkdir -p $(OBJ_SHARED_DIR)
	$(CC) $(CFLAGS_SHARED) -c $< -o $@

# ------------------------------------------------------------------------------
# Clean and utility targets
# ------------------------------------------------------------------------------
clean:
	rm -rf $(BIN_DIR) $(LIB_DIR) $(OBJ_DIR) $(OBJ_SHARED_DIR)
	@echo "Clean complete!"

test:
	@echo "=== Testing Direct Build ==="
	@./$(BIN_DIR)/client
	@echo ""
	@echo "=== Testing Static Build ==="
	@./$(BIN_DIR)/client_static
	@echo ""
	@echo "=== Testing Dynamic Build ==="
	@echo "First try (should fail):"
	@-./$(BIN_DIR)/client_dynamic 2>/dev/null || echo "Expected error: library not found"
	@echo ""
	@echo "Second try with LD_LIBRARY_PATH:"
	@LD_LIBRARY_PATH=./lib ./$(BIN_DIR)/client_dynamic

analyze:
	@echo "=== File Sizes ==="
	@ls -lh $(BIN_DIR)/client $(BIN_DIR)/client_static $(BIN_DIR)/client_dynamic 2>/dev/null || echo "Binaries not built"
	@echo ""
	@echo "=== Library Contents ==="
	@ar -t $(LIB_DIR)/libmputils.a 2>/dev/null || echo "Static library not built"
	@echo ""
	@echo "=== Dynamic Dependencies ==="
	@ldd $(BIN_DIR)/client_dynamic 2>/dev/null || echo "Dynamic executable not built"

.PHONY: all direct static dynamic clean test analyze
