# AELibrary

**This repository is written entirely in the Aethelium (.ae) language and contains no other programming languages.**

AELibrary is a multi-platform core fundamental library designed specifically for the Aethelium compiler (`aethelc`). It currently provides low-level logic implementation and development scaffolding for both **Windows** (based on dependency-free Native API calls) and **UEFI** (bare-metal firmware environment) platforms.

These library files participate in the compilation process directly as source code, ensuring that the final generated programs (such as Windows EXE or UEFI EFI firmware) remain independent, lightweight, and free from the need for additional dynamic link libraries (DLLs).

---

## Core Design Principles

### 1. Source Weaving
Unlike traditional binary libraries compiled into `.lib`, `.dll`, or `.a` formats, AELibrary adopts a **pure source weaving** mode. During the compilation stage, `aethelc` reads the library files together with your main program to construct an Abstract Syntax Tree (AST). This allows the compiler to perform deep Dead Code Elimination (DCE) and inline optimization, achieving maximum efficiency and minimal file size.

### 2. Zero CRT Dependency
- **Windows Branch**: Does not rely on any C Runtime (CRT) libraries; it maps directly to underlying system interfaces such as `ntdll.dll` via the Windows Native Portal.
- **UEFI Branch**: Runs directly in the bare-metal firmware environment, interacting with hardware by calling the Boot Services and Runtime Services provided by the UEFI System Table.

### 3. Leaning Tower Naming Convention
Strictly follows Aethelium's naming conventions:
- Use forward slashes `/` to indicate hierarchical structure (e.g., `Aura/Host/create/panel`).
- Use backslashes `\` for member access.
- The use of underscores `_` is strictly prohibited.

---

## Directory Structure

```
AELibrary/
├── UEFI/                         # UEFI firmware environment related libraries
│   ├── Gfx/                      # Low-level GOP video memory operations and bitmap font rendering
│   ├── Platform/                 # UEFI System Table, Boot/Runtime Services adaptation
│   └── examples/                 # UEFI GUI dashboard application examples and QEMU launch scripts
│
├── Windows/                      # Windows desktop environment related libraries
│   ├── Core/GUI/                 # Aura & Flux declarative lightweight GUI framework
│   ├── Core/IO/                  # Contains low-level interfaces for files, asynchronous I/O, networking (AFD/Sockets), processes, etc.
│   ├── Core/Math/                # Software math library
│   └── examples/                 # Integration verification examples for file system, memory, and text processing
│
├── LICENSE
└── README.md
```

---

## Integration and Usage Guide

### 1. Preparation
Add the `lib:yes` parameter to your aecf configuration file, or download/clone this repository locally and add its path to your system environment variables (e.g., `AELibraryPATH`) to reference it during compilation.

---

### 2. Windows Platform Compilation Example

For Windows applications, you can compile directly using `--format exe`.

**Example compilation command:**
```bash
aethelc main.ae \
        /lib:. \
        /format:exe \
        /o:app.exe
```

*Note: The `Core/IO` and `Core/Math` modules under the Windows directory provide near-NT-native system call interfaces, making them ideal for writing lightweight and secure desktop tools.*

---

### 3. UEFI Platform Compilation and Execution Example

For UEFI firmware programs, you need to compile them into the `efi` format, which can be tested using virtual machines like QEMU or on x64 platforms such as Intel/AMD hardware.

**Example compilation command:**
```bash
aethelc main.ae /lib:. /:format:efi /o:BOOTX64.EFI
```

**Test Run:**
You can use the `UEFI/examples/UEFIGUI/launch.sh` script. This script will automatically:
1. Compile the UEFI example program.
2. Create a FAT32-formatted ESP virtual disk image.
3. Place the compiled `BOOTX64.EFI` into the standard path `/EFI/BOOT/BOOTX64.EFI`.
4. Invoke QEMU and load the OVMF firmware to boot the image.

---

## License

This repository is open-sourced under the [MIT License](LICENSE).
