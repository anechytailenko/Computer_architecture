main:
    # Initialize Stack Pointer to 0x2000 (Top of data memory)
    lui sp, 0x2       # sp = 0x2000 (0x2 << 12)
    # li t0, 0x1000 - Base address for arrays
    lui t0, 0x1                # t0 = 0x1000 (0x1 << 12 = 0x1000)
    
    # li t1, 0x1000 - A starts at 0x1000  
    lui t1, 0x1                # t1 = 0x1000
    
    # li t2, 0x1014 - B starts at 0x1014 (20 bytes after A)
    lui t2, 0x1                # t2 = 0x1000
    addi t2, t2, 0x14          # t2 = 0x1014
    
    # li t3, 0x1028 - C starts at 0x1028 (20 bytes after B)
    lui t3, 0x1                # t3 = 0x1000
    addi t3, t3, 0x28          # t3 = 0x1028
    
    # li t4, 0x103C - N address at 0x103C
    lui t4, 0x1                # t4 = 0x1000
    addi t4, t4, 0x3C          # t4 = 0x103C
    
    # Store array A values at address 0x1000
    
    # li t5, 15
    addi t5, zero, 15          # Small value fits in addi immediate (-2048 to 2047)
    sw t5, 0(t1)
    
    # li t5, -42
    addi t5, zero, -42         # Small negative fits in addi immediate
    sw t5, 4(t1)
    
    # li t5, 88
    addi t5, zero, 88          # Small value fits in addi immediate
    sw t5, 8(t1)
    
    # li t5, -2
    addi t5, zero, -2          # Small negative fits in addi immediate
    sw t5, 12(t1)
    
    # li t5, 0x80000000 - -2147483648
    lui t5, 0x80000            # t5 = 0x80000000 (0x80000 << 12 = 0x80000000)
    sw t5, 16(t1)
    
    # Store array B values at address 0x1014
    
    # li t5, 0
    addi t5, zero, 0           # Zero fits in addi immediate
    sw t5, 0(t2)
    
    # li t5, 0
    addi t5, zero, 0
    sw t5, 4(t2)
    
    # li t5, -4
    addi t5, zero, -4          # Small negative fits in addi immediate
    sw t5, 8(t2)
    
    # li t5, -1
    addi t5, zero, -1          # -1 fits in addi immediate
    sw t5, 12(t2)
    
    # li t5, -1
    addi t5, zero, -1
    sw t5, 16(t2)
    
    # Store N value at address 0x103C
    # li t5, 5
    addi t5, zero, 5           # Small value fits in addi immediate
    sw t5, 0(t4)
    
    # Initialize C array with zeros at address 0x1028
    # li t5, 0
    addi t5, zero, 0
    sw t5, 0(t3)
    sw t5, 4(t3)
    sw t5, 8(t3)
    sw t5, 12(t3)
    sw t5, 16(t3)
    
    # Load addresses into argument registers using t1-t4
    # mv a0, t1 is pseudo for addi a0, t1, 0
    addi a0, t1, 0             # A address (0x1000)
    addi a1, t2, 0             # B address (0x1014)
    addi a2, t3, 0             # C address (0x1028)
    addi t0, t4, 0             # N address (0x103C)
    lw a3, 0(t0)               # load N value = 5


#arguments: a0=addr(A), a1=addr(B), a2=addr(C), a3=N
process_arrays:
    addi sp, sp, -32           # allocate 8 registers on stack
    sw ra, 28(sp)
    sw s0, 24(sp)
    sw s1, 20(sp)
    sw s2, 16(sp)
    sw s3, 12(sp)
    sw s4, 8(sp)
    sw s5, 4(sp)
    
    #save arguments to stacked registers
    # mv s0, a0 is pseudo for addi s0, a0, 0
    addi s0, a0, 0             # copy address of A to s0
    addi s1, a1, 0             # copy address of B to s1
    addi s2, a2, 0             # copy address of C to s2
    addi s3, a3, 0             # copy N to s3

process_loop:
    beq s3, zero, process_done # if s3(N) == 0
    
    lw s4, 0(s0)               # s4 = memory[s0] -- load A[i]
    lw s5, 0(s1)               # s5 = memory[s1] -- load B[i]
    
    #for divide_signed function load A[i] and B[i] into argument registers
    addi a0, s4, 0             # mv a0, s4
    addi a1, s5, 0             # mv a1, s5
    jal divide_signed
    
    sw a0, 0(s2)               # memory[s2] = a0 -- C[i] = result
    
    #increment array's base address and decrement i
    addi s0, s0, 4             # next element in A
    addi s1, s1, 4             # next element in B
    addi s2, s2, 4             # next element in C
    addi s3, s3, -1            # decrement i
    
    j process_loop

process_done:
    #restore registers and return to main
    lw ra, 28(sp)
    lw s0, 24(sp)
    lw s1, 20(sp)
    lw s2, 16(sp)
    lw s3, 12(sp)
    lw s4, 8(sp)
    lw s5, 4(sp)
    addi sp, sp, 32            # deallocate stack space
    jalr zero, ra, 0 


#arguments: a0=dividend(output quotient), a1=divisor
divide_signed:
    addi sp, sp, -16           # allocate 16 bytes on stack
    sw ra, 12(sp)
    sw s0, 8(sp)               # Save s0 (will store sign flag)
    sw s1, 4(sp)               # Save s1 (will store |dividend|)
    sw s2, 0(sp)               # Save s2 (will store |divisor|)
    
    beq a1, zero, handle_div_zero # Branch if divisor == 0
    
    #check for overflow: -2147483648 / -1
    # li t0, 0x80000000 - -2147483648 
    lui t0, 0x80000            # t0 = 0x80000000
    
    # li t1, -1
    addi t1, zero, -1          # -1 fits in addi immediate
    
    beq a0, t0, check_overflow # if dividend == -2147483648
    j no_overflow

check_overflow:
    beq a1, t1, handle_overflow # if divisor == -1

no_overflow:
    # li s0, 1 - initialize sign flag: pos
    addi s0, zero, 1           # Small value fits in addi immediate
    
    # abs of dividend
    addi s1, a0, 0             # mv s1, a0 -- copy dividend
    bge s1, zero, abs_dividend_done # if s1 >= 0
    sub s1, zero, s1           # s1 = 0 - s1 -- compute abs value
    
    # li s0, 0 - set sign flag to negative
    addi s0, zero, 0           # Zero fits in addi immediate

abs_dividend_done:
    # abs value of divisor
    addi s2, a1, 0             # mv s2, a1 -- copy divisor
    bge s2, zero, abs_divisor_done # if s2 >= 0
    sub s2, zero, s2           # s2 = 0 - s2 -- compute abs value
    xori s0, s0, 1             # toggle sign

abs_divisor_done:
    addi a0, s1, 0             # mv a0, s1 (abs dividend)
    addi a1, s2, 0             # mv a1, s2 (abs divisor)
    
    jal divide_unsigned
    
    beq s0, zero, make_negative # if sign flag == 0 -- negative
    j division_complete         # actual jal

make_negative:
    sub a0, zero, a0           # a0 = 0 - a0 (negate result)

division_complete:
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16            # deallocating stack space
    jalr zero, ra, 0                     # return to process_arrays

handle_div_zero:
    # li s0, 1 - s0 = 1 -- positive sign
    addi s0, zero, 1           # Small value fits in addi immediate
    addi s1, a0, 0             # mv s1, a0 -- actual sign flag
    bge s1, zero, div_zero_sign_done # if dividend >= 0
    
    # li s0, 0 - s0 = 0 -- set negative sign flag
    addi s0, zero, 0           # Zero fits in addi immediate

div_zero_sign_done:
    # li a0, 0x7FFFFFFF - a0 = 2147483647 -- max pos
    lui a0, 0x7FFFF            # a0 = 0x7FFFF000
    addi a0, a0, 0x7FF         # a0 = 0x7FFFF7FF (we need more precision)
    # Actually need better encoding for 0x7FFFFFFF:
    # 0x7FFFFFFF = 0x7FF << 20 + 0xFFF
    lui a0, 0x80000            # a0 = 0x80000000
    addi a0, a0, -1            # a0 = 0x7FFFFFFF (0x80000000 - 1)
    
    beq s0, zero, div_zero_negative # if sign negative
    j div_zero_return

div_zero_negative:
    # li a0, 0x80000000 - a0 = -2147483648 -- min neg
    lui a0, 0x80000            # a0 = 0x80000000

div_zero_return:
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16
    jalr zero, ra, 0                       # return to process_arrays

handle_overflow:
    #case: -2147483648 / -1
    # li a0, 0x7FFFFFFF - a0 = 2147483647 -- max pos
    lui a0, 0x80000            # a0 = 0x80000000
    addi a0, a0, -1            # a0 = 0x7FFFFFFF (0x80000000 - 1)
    
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16
    jalr zero, ra, 0                       # return to process_arrays


# Algorithm: R′ = 0; for i = N−1 to 0:
#   R = {R′ << 1, Ai}; 
#   D = R − B; 
#   if D < 0 
#       then Qi = 0, R′ = R 
#   else Qi = 1, R′ = D
#arguments: a0=dividend(output quotient), a1=divisor
divide_unsigned:
    addi sp, sp, -24           # allocating 24 bytes on stack
    sw ra, 20(sp)
    sw s0, 16(sp)              # store dividend
    sw s1, 12(sp)              # store divisor
    sw s2, 8(sp)               # store quotient
    sw s3, 4(sp)               # store R'
    sw s4, 0(sp)               # store bit counter
    
    addi s0, a0, 0             # mv s0, a0 -- dividend
    addi s1, a1, 0             # mv s1, a1 -- divisor
    
    # li s2, 0 - init quotient to 0
    addi s2, zero, 0           # Zero fits in addi immediate
    
    # li s3, 0 - init R' to 0
    addi s3, zero, 0           # Zero fits in addi immediate
    
    # li s4, 31 - start from bit 31
    addi s4, zero, 31          # Small value fits in addi immediate

division_loop:
    blt s4, zero, division_done # if s4 < 0 -- all bits processed
    
    slli s3, s3, 1             # s-- R' shifted left by 1
    
    srl t0, s0, s4             # -- shift A right by bit position
    andi t0, t0, 1             # -- mask to get only LSB
    or s3, s3, t0              # s3 = s3 | t0 (R = {R' << 1, Ai})
    
    sub t1, s3, s1             # --D = R - B
    
    blt t1, zero, next_bit     # if D < 0 
    
    # D >= 0: Qi = 1, R' = D
    # li t2, 1 
    addi t2, zero, 1           # Small value fits in addi immediate
    sll t2, t2, s4             # -- create mask for bit position
    or s2, s2, t2              # -- set quotient bit to 1 at position s4
    addi s3, t1, 0             # mv s3, t1 -- R' = D
    j next_bit

next_bit:
    addi s4, s4, -1            # -- decrement bit counter
    j division_loop

division_done:
    addi a0, s2, 0             # mv a0, s2 -- Q
    
    lw ra, 20(sp)
    lw s0, 16(sp)
    lw s1, 12(sp)
    lw s2, 8(sp)
    lw s3, 4(sp)
    lw s4, 0(sp)
    addi sp, sp, 24
    jalr zero, ra, 0                       # return to process_arrays

end:
    # End of program - infinite loop
    j end