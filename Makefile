# ==============================================================================
# Dynamic Library Makefile (Feature 4)
# ==============================================================================

# Compiler and flags
CC = gcc
CFLAGS = -Wall -g -I./include
CFLAGS_SHARED = -Wall -g -I./include -fPIC
LDFLAGS =

# Directories
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
LIB_DIR = lib

# Targets
DYNAMIC_LIB = $(LIB_DIR)/libmputils.so
TARGET_DYNAMIC = $(BIN_DIR)/client_dynamic

# Default target
all: $(TARGET_DYNAMIC)

# Create dynamic (shared) library
$(DYNAMIC_LIB): $(SRC_DIR)/mystrfunctions.c $(SRC_DIR)/myfilefunctions.c | $(LIB_DIR)
	@echo "Creating dynamic library: $@"
	$(CC) $(CFLAGS_SHARED) -shared $^ -o $@
	@echo "Dynamic library created: $(DYNAMIC_LIB)"

# Link dynamic executable
$(TARGET_DYNAMIC): $(SRC_DIR)/main.c $(DYNAMIC_LIB) | $(BIN_DIR)
	@echo "Compiling main program..."
	$(CC) $(CFLAGS) -c $< -o $(OBJ_DIR)/main.o
	@echo "Linking dynamic executable: $@"
	$(CC) $(OBJ_DIR)/main.o -L$(LIB_DIR) -lmputils -o $@
	@echo "Dynamic build successful! Executable: $(TARGET_DYNAMIC)"

# Directory creation rules
$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

$(LIB_DIR):
	@mkdir -p $(LIB_DIR)

# Clean target
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(LIB_DIR)
	@echo "Clean complete!"

# Test dynamic linking
test:
	@echo "=== Testing Dynamic Linking ==="
	@echo "1. Trying to run without LD_LIBRARY_PATH (should fail)..."
	-./$(TARGET_DYNAMIC) || echo "Expected error occurred!"
	@echo ""
	@echo "2. Setting LD_LIBRARY_PATH and testing..."
	export LD_LIBRARY_PATH=./lib:$$LD_LIBRARY_PATH && ./$(TARGET_DYNAMIC)
	@echo ""
	@echo "3. Library dependencies:"
	ldd $(TARGET_DYNAMIC)

.PHONY: all clean test
