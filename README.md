# AELibrary

This repository uses Aethelium (.ae) exclusively and no other programming languages.

AELibrary contains the core Aethelium library source files for building on the Windows platform. It provides the essential logic segments required to build native Windows applications using the Aethelium compiler (`aethelc`).

These files are designed to be incorporated into the final executable as source inputs, ensuring the resulting program remains a standalone EXE file without the need for DLL packaging.

## Architectural Principle: Source Weaving

Unlike traditional compiled libraries (.lib, .dll, or .a), AELibrary is distributed exclusively as **Aethelium source files (.ae)**.

During the compilation phase, the `aethelc` compiler reads these blueprints and performs **Logic Weaving**. The library code is integrated directly into the main Abstract Syntax Tree (AST), enabling efficient Dead Code Elimination (DCE) and zero-cost abstractions. No dynamic linking occurs within the final executable.

## Integration and Usage

To use AELibrary, download the source code and provide the path to the Aethelium compiler using the `--lib` flag.

### 1. Obtain Resources
Download the latest `AELibrary.zip` from the Releases section and extract it to your project directory.

### 2. Add Environment Variable
Run the following command in PowerShell:
`[Environment]::SetEnvironmentVariable("AELibraryPATH", "C:\Your\AELibrary\Path", "User")`

### 3. Compile with Weaving
Invoke the compiler and point to the library environment variable:
`aethelc main.ae --lib . --format exe -o app.exe`

## Specifications

**Naming**: Strictly follows the "Leaning Tower" naming convention (forward slashes represent hierarchical structures, backslashes represent members). Underscores are not permitted.

**Dependencies**: Zero C Runtime (CRT) dependency. Directly mapped to `ntdll.dll` via the Windows Native Portal system.
