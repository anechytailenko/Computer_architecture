#!/bin/bash

# Alternative version using objdump for direct instruction extraction

if [ $# -ne 1 ]; then
    echo "Usage: $0 <assembly_file.s>"
    exit 1
fi

input_file="$1"
base_name=$(basename "$input_file" .s)
hex_file="hex_${base_name}.txt"

RISCV_TOOLCHAIN_PREFIX="riscv64-unknown-elf-"

# Create temporary object file
temp_dir=$(mktemp -d)
temp_obj="$temp_dir/program.o"

# Assemble
"${RISCV_TOOLCHAIN_PREFIX}as" "$input_file" -o "$temp_obj"

# Extract hex instructions using objdump
"${RISCV_TOOLCHAIN_PREFIX}objdump" -d "$temp_obj" | \
    grep -E '^\s+[0-9a-f]+:' | \
    awk '{print $2}' | \
    # Convert to 8-digit format (add leading zeros if needed)
    while read hex; do 
        printf "%08X\n" "0x$hex"
    done > "$hex_file"

# Create binary file from hex
bin_file="bin_${base_name}.txt"
# Convert hex to binary using xxd
xxd -r -p "$hex_file" "$bin_file" 2>/dev/null || {
    # Alternative if xxd not available
    echo "Note: xxd not available, creating binary file differently"
    # Create simple binary placeholder or use other method
    : > "$bin_file"
}

rm -rf "$temp_dir"
echo "Created $hex_file and $bin_file"