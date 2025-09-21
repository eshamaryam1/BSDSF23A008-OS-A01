#include "../include/mystrfunctions.h"
#include <stdio.h>

// Calculate the length of a string
int mystrlen(const char* s) {
    int len = 0;
    while (s[len] != '\0') {
        len++;
    }
    return len;
}

// Copy source string to destination
int mystrcpy(char* dest, const char* src) {
    int i = 0;
    while (src[i] != '\0') {
        dest[i] = src[i];
        i++;
    }
    dest[i] = '\0'; // Null-terminate the destination string
    return i; // Return number of characters copied (excluding null terminator)
}

// Copy at most n characters from source to destination
int mystrncpy(char* dest, const char* src, int n) {
    int i = 0;
    while (i < n && src[i] != '\0') {
        dest[i] = src[i];
        i++;
    }
    // If we copied fewer than n characters, pad with null bytes
    while (i < n) {
        dest[i] = '\0';
        i++;
    }
    return i; // Return number of characters processed
}

// Concatenate source string to destination string
int mystrcat(char* dest, const char* src) {
    int dest_len = mystrlen(dest);
    int i = 0;
    
    while (src[i] != '\0') {
        dest[dest_len + i] = src[i];
        i++;
    }
    dest[dest_len + i] = '\0'; // Null-terminate the concatenated string
    
    return dest_len + i; // Return total length of new string
}
