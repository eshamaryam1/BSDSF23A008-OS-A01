#include <stdio.h>
#include <stdlib.h>
#include "../include/mystrfunctions.h"
#include "../include/myfilefunctions.h"

// Helper function to test string functions
void test_string_functions() {
    printf("=== Testing String Functions ===\n\n");
    
    // Test mystrlen
    printf("1. Testing mystrlen:\n");
    const char* test_str = "Hello, World!";
    int length = mystrlen(test_str);
    printf("   Length of '%s' is: %d\n", test_str, length);
    
    // Test mystrcpy
    printf("\n2. Testing mystrcpy:\n");
    char dest1[50];
    int copied = mystrcpy(dest1, test_str);
    printf("   Copied string: '%s', Characters copied: %d\n", dest1, copied);
    
    // Test mystrncpy
    printf("\n3. Testing mystrncpy:\n");
    char dest2[50] = "Initial text - ";
    int processed = mystrncpy(dest2 + 15, test_str, 5); // Copy first 5 chars
    printf("   Result: '%s', Characters processed: %d\n", dest2, processed);
    
    // Test mystrcat
    printf("\n4. Testing mystrcat:\n");
    char dest3[50] = "Hello, ";
    int final_length = mystrcat(dest3, "World!");
    printf("   Concatenated string: '%s', Final length: %d\n", dest3, final_length);
    
    printf("\n=== String Functions Test Complete ===\n\n");
}

// Helper function to test file functions
void test_file_functions() {
    printf("=== Testing File Functions ===\n\n");
    
    // Create a test file
    FILE* test_file = fopen("test.txt", "w+");
    if (test_file == NULL) {
        printf("Error: Could not create test file!\n");
        return;
    }
    
    fprintf(test_file, "Hello world!\nThis is a test file.\n");
    fprintf(test_file, "It contains multiple lines of text.\n");
    fprintf(test_file, "We will search for words in this file.\n");
    fprintf(test_file, "The quick brown fox jumps over the lazy dog.\n");
    fflush(test_file);
    
    // Test wordCount
    printf("1. Testing wordCount:\n");
    int lines, words, chars;
    int result = wordCount(test_file, &lines, &words, &chars);
    
    if (result == 0) {
        printf("   Lines: %d, Words: %d, Characters: %d\n", lines, words, chars);
    } else {
        printf("   Error in wordCount function!\n");
    }
    
    // Test mygrep
    printf("\n2. Testing mygrep:\n");
    char** matches;
    int match_count = mygrep(test_file, "the", &matches);
    
    if (match_count >= 0) {
        printf("   Found %d lines containing 'the':\n", match_count);
        for (int i = 0; i < match_count; i++) {
            printf("   %d: %s", i + 1, matches[i]);
            free(matches[i]); // Free each match
        }
        free(matches); // Free the array itself
    } else {
        printf("   Error in mygrep function!\n");
    }
    
    // Clean up
    fclose(test_file);
    remove("test.txt"); // Delete the test file
    
    printf("\n=== File Functions Test Complete ===\n");
}

int main() {
    printf("Starting Library Function Tests...\n\n");
    
    // Test string functions
    test_string_functions();
    
    // Test file functions
    test_file_functions();
    
    printf("\nAll tests completed successfully!\n");
    return 0;
}
