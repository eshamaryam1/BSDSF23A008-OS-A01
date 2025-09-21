# ==============================================================================
# Multi-file Project Makefile (Feature 2)
# ==============================================================================

# Compiler and flags
CC = gcc
CFLAGS = -Wall -g -I./include
LDFLAGS =

# Directories
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin

# Source files
SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(SOURCES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

# Target executable
TARGET = $(BIN_DIR)/client

# Default target (when you just type 'make')
all: $(TARGET)

# Main linking rule - creates the final executable
$(TARGET): $(OBJECTS) | $(BIN_DIR)
	@echo "Linking executable: $@"
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	@echo "Build successful! Executable created: $(TARGET)"

# Compilation rule - creates object files from source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@echo "Compiling: $< -> $@"
	$(CC) $(CFLAGS) -c $< -o $@

# Directory creation rules
$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

# Clean target - removes all generated files
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(OBJ_DIR) $(BIN_DIR)
	@echo "Clean complete!"

# Install target (placeholder for future use)
install:
	@echo "Install target not implemented yet"

# Uninstall target (placeholder for future use)
uninstall:
	@echo "Uninstall target not implemented yet"

# Help target - shows available commands
help:
	@echo "Available targets:"
	@echo "  all       - Build the project (default)"
	@echo "  clean     - Remove all build artifacts"
	@echo "  install   - Install the program (not implemented)"
	@echo "  uninstall - Uninstall the program (not implemented)"
	@echo "  help      - Show this help message"

# Phony targets (targets that aren't actual files)
.PHONY: all clean install uninstall help

# Dependency information (optional but good practice)
$(OBJ_DIR)/mystrfunctions.o: include/mystrfunctions.h
$(OBJ_DIR)/myfilefunctions.o: include/myfilefunctions.h  
$(OBJ_DIR)/main.o: include/mystrfunctions.h include/myfilefunctions.h
