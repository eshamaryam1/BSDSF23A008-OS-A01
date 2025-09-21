# REPORT.md - Feature 2: Multi-file Project

## Questions for Feature 2 Completion

### 1. Explain the linking rule `$(TARGET): $(OBJECTS)` and how it differs from library linking.

**Answer:**
The rule `$(TARGET): $(OBJECTS)` means the executable depends on all object files. The linker (`gcc`) combines these object files directly into a single executable.

**Difference from library linking:**
- **This method:** `gcc obj/main.o obj/mystrfunctions.o obj/myfilefunctions.o -o bin/client` (direct linking)
- **Library linking:** `gcc obj/main.o -L./lib -lmputils -o bin/client` (links against pre-built library)

Direct linking includes all code in the executable, while library linking references external library code.

---

### 2. What is a git tag and why is it useful? Difference between simple and annotated tags?

**Answer:**
A git tag marks specific commits as important milestones (like releases).

**Why useful:** Tags version releases (v1.0, v2.0) so users can access stable points in history.

**Difference:**
- **Simple tag:** `git tag v1.0` - lightweight, just a pointer
- **Annotated tag:** `git tag -a v1.0 -m "Release message"` - contains author, date, and description (better for releases)

---

### 3. Purpose of GitHub Releases and significance of attaching binaries?

**Answer:**
**Purpose:** GitHub Releases package software versions with release notes for distribution.

**Significance of binaries:** Users can download and run the program immediately without compiling. The attached `bin/client` executable provides a ready-to-use version of our multi-file program.
