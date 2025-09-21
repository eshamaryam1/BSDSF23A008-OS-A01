#include "../include/myfilefunctions.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// Count lines, words, and characters in a file
int wordCount(FILE* file, int* lines, int* words, int* chars) {
    if (file == NULL) {
        return -1; // Error: file pointer is NULL
    }
    
    // Reset file position to beginning
    rewind(file);
    
    int ch;
    int in_word = 0; // Flag to track if we're inside a word
    *lines = 0;
    *words = 0;
    *chars = 0;
    
    while ((ch = fgetc(file)) != EOF) {
        (*chars)++;
        
        if (ch == '\n') {
            (*lines)++;
        }
        
        if (isspace(ch)) {
            if (in_word) {
                (*words)++;
                in_word = 0;
            }
        } else {
            in_word = 1;
        }
    }
    
    // Handle the case where file ends without a newline
    if (*chars > 0) {
        (*lines)++; // Last line doesn't have trailing newline
    }
    
    // Count the last word if file ends in the middle of a word
    if (in_word) {
        (*words)++;
    }
    
    rewind(file); // Reset file position for future operations
    return 0; // Success
}

// Search for lines containing a specific string in a file
int mygrep(FILE* fp, const char* search_str, char*** matches) {
    if (fp == NULL || search_str == NULL) {
        return -1; // Error: invalid parameters
    }
    
    rewind(fp);
    
    char buffer[1024];
    int match_count = 0;
    int capacity = 10;
    char** results = (char**)malloc(capacity * sizeof(char*));
    
    if (results == NULL) {
        return -1; // Memory allocation failed
    }
    
    while (fgets(buffer, sizeof(buffer), fp) != NULL) {
        if (strstr(buffer, search_str) != NULL) {
            // Found a match
            if (match_count >= capacity) {
                // Need to resize our array
                capacity *= 2;
                char** temp = (char**)realloc(results, capacity * sizeof(char*));
                if (temp == NULL) {
                    // Free already allocated memory before returning error
                    for (int i = 0; i < match_count; i++) {
                        free(results[i]);
                    }
                    free(results);
                    return -1;
                }
                results = temp;
            }
            
            // Allocate memory for this match and copy the line
            results[match_count] = (char*)malloc(strlen(buffer) + 1);
            if (results[match_count] == NULL) {
                // Free already allocated memory before returning error
                for (int i = 0; i < match_count; i++) {
                    free(results[i]);
                }
                free(results);
                return -1;
            }
            strcpy(results[match_count], buffer);
            match_count++;
        }
    }
    
    *matches = results;
    return match_count;
}
