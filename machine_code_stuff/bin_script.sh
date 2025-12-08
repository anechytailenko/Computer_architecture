#!/bin/bash

# Correct hex to binary text converter
# Each hex digit converts to 4 binary bits

if [ ! -f "hex_program.txt" ]; then
    echo "Error: hex_program.txt not found!"
    exit 1
fi

output_file="bin_program.txt"
> "$output_file"

echo "Converting hex to binary text..."

while IFS= read -r hex_line; do
    # Clean the input
    hex_line=$(echo "$hex_line" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
    [ -z "$hex_line" ] && continue
    
    binary_line=""
    
    # Convert each hex digit
    for ((i=0; i<${#hex_line}; i++)); do
        hex_char="${hex_line:$i:1}"
        case "$hex_char" in
            0) binary_line+="0000" ;;
            1) binary_line+="0001" ;;
            2) binary_line+="0010" ;;
            3) binary_line+="0011" ;;
            4) binary_line+="0100" ;;
            5) binary_line+="0101" ;;
            6) binary_line+="0110" ;;
            7) binary_line+="0111" ;;
            8) binary_line+="1000" ;;
            9) binary_line+="1001" ;;
            A) binary_line+="1010" ;;
            B) binary_line+="1011" ;;
            C) binary_line+="1100" ;;
            D) binary_line+="1101" ;;
            E) binary_line+="1110" ;;
            F) binary_line+="1111" ;;
            *) binary_line+="????" ;;
        esac
    done
    
    echo "$binary_line" >> "$output_file"
done < "hex_program.txt"

echo "Conversion complete! Created $output_file"

# Show test case
echo -e "\nTest conversion:"
echo "000012B7 (hex) = 00000000000000000001001010110111 (binary)"
echo "Your result:"
grep -A1 -B1 "000012B7" hex_program.txt 2>/dev/null || echo "Checking output..."
head -1 "$output_file" 2>/dev/null || echo "No output yet"