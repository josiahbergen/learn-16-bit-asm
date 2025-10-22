
#!/bin/bash

# Build configuration
BUILD_DIR="build"
BOOTLOADER="$BUILD_DIR/boot.asm"
BOOTLOADER_BIN="$BUILD_DIR/boot.bin"
DISK_IMG="disk.img"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to build bootloader
build_bootloader() {
    print_status "Building bootloader..."
    
    if [ ! -f "boot.asm" ]; then
        print_error "boot.asm not found!"
        exit 1
    fi
    
    if ! command_exists nasm; then
        print_error "nasm is not installed. Please install nasm first."
        exit 1
    fi
    
    mkdir -p "$BUILD_DIR"
    nasm -f bin boot.asm -o "$BOOTLOADER_BIN"
    
    if [ $? -eq 0 ]; then
        print_status "Bootloader built successfully!"
    else
        print_error "Failed to build bootloader!"
        exit 1
    fi
}

# Function to create disk image
create_disk() {
    print_status "Creating disk image..."
    
    if [ ! -f "$BOOTLOADER_BIN" ]; then
        print_error "Bootloader binary not found. Building first..."
        build_bootloader
    fi
    
    # Create 100MB disk image
    dd if=/dev/zero of="$DISK_IMG" bs=1M count=100 2>/dev/null
    
    # Write bootloader to first sector
    dd conv=notrunc if="$BOOTLOADER_BIN" of="$DISK_IMG" bs=512 count=1 seek=0 2>/dev/null
    
    if [ $? -eq 0 ]; then
        print_status "Disk image created successfully!"
    else
        print_error "Failed to create disk image!"
        exit 1
    fi
}

# Function to run QEMU
run_qemu() {
    print_status "Starting QEMU..."
    
    if [ ! -f "$DISK_IMG" ]; then
        print_warning "Disk image not found. Creating first..."
        create_disk
    fi
    
    if ! command_exists qemu-system-i386; then
        print_error "qemu-system-i386 is not installed. Please install QEMU first."
        exit 1
    fi
    
    qemu-system-i386 -drive file="$DISK_IMG",format=raw,index=0,media=disk -boot c
}

# Function to clean build artifacts
clean() {
    print_status "Cleaning build artifacts..."
    rm -rf "$BUILD_DIR"
    rm -f "$DISK_IMG"
    print_status "Clean completed!"
}

# Function to show help
show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  build     Build the bootloader"
    echo "  disk      Create disk image"
    echo "  qemu      Run in QEMU"
    echo "  all       Build, create disk, and run QEMU (default)"
    echo "  clean     Remove build artifacts"
    echo "  help      Show this help message"
}

# Main script logic
case "${1:-all}" in
    "build")
        build_bootloader
        ;;
    "disk")
        create_disk
        ;;
    "qemu")
        run_qemu
        ;;
    "all")
        build_bootloader
        create_disk
        run_qemu
        ;;
    "clean")
        clean
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        print_error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac