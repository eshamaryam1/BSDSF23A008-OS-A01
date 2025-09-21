# ==============================================================================
# Static Library Makefile (Feature 3)
# ==============================================================================

# Compiler and flags
CC = gcc
CFLAGS = -Wall -g -I./include
LDFLAGS =

# Directories
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
LIB_DIR = lib

# Source files
SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(SOURCES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

# Filter out main.o for library objects
LIB_OBJECTS = $(filter-out $(OBJ_DIR)/main.o, $(OBJECTS))

# Targets
STATIC_LIB = $(LIB_DIR)/libmputils.a
TARGET_STATIC = $(BIN_DIR)/client_static

# Default target
all: $(TARGET_STATIC)

# Create static library
$(STATIC_LIB): $(LIB_OBJECTS) | $(LIB_DIR)
	@echo "Creating static library: $@"
	ar rcs $@ $(LIB_OBJECTS)
	ranlib $@
	@echo "Static library created: $(STATIC_LIB)"

# Link static executable
$(TARGET_STATIC): $(OBJ_DIR)/main.o $(STATIC_LIB) | $(BIN_DIR)
	@echo "Linking static executable: $@"
	$(CC) $(OBJ_DIR)/main.o -L$(LIB_DIR) -lmputils -o $@
	@echo "Static build successful! Executable: $(TARGET_STATIC)"

# Compile source files to object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@echo "Compiling: $< -> $@"
	$(CC) $(CFLAGS) -c $< -o $@

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

# Analysis targets
analyze:
	@echo "=== Library Contents ==="
	ar -t $(STATIC_LIB) || echo "Library not built yet"
	@echo ""
	@echo "=== Library Symbols ==="
	nm $(STATIC_LIB) || echo "Library not built yet"
	@echo ""
	@echo "=== Executable Symbols ==="
	nm $(TARGET_STATIC) | grep -E "(mystr|wordCount|mygrep)" || echo "Executable not built yet"

# Help target
help:
	@echo "Available targets:"
	@echo "  all      - Build static library and executable"
	@echo "  clean    - Remove all build artifacts"
	@echo "  analyze  - Analyze library and executable contents"
	@echo "  help     - Show this help message"

.PHONY: all clean analyze help
