.globl main

.data
A: .word 15, -42, 88, -2, -2147483648 
B: .word 0, 0, -4, -1, -1
N: .word 5
C: .space 20

.text

main:
    addi sp, sp, -4     #sp = sp - 4 -- allocate 4 bytes on stack
    sw ra, 0(sp)        #store ra at memory_stack[sp]
    
    #load base addresses of arrays into argument registers
    la a0, A
    la a1, B
    la a2, C
    la t0, N 
    lw a3, 0(t0)        #load N value = 5
    
    jal process_arrays
    
    #finish with deallocating stack space
    lw ra, 0(sp)
    addi sp, sp, 4
    ret


#arguments: a0=addr(A), a1=addr(B), a2=addr(C), a3=N
process_arrays:
    addi sp, sp, -32    #allocate 8 registers on stack
    sw ra, 28(sp)
    sw s0, 24(sp)
    sw s1, 20(sp)
    sw s2, 16(sp)
    sw s3, 12(sp)
    sw s4, 8(sp)
    sw s5, 4(sp)
    
    #save arguments to stacked registers
    mv s0, a0           #copy address of A to s0
    mv s1, a1           #copy address of B to s1
    mv s2, a2           #copy address of C to s2
    mv s3, a3           #copy N to s3

process_loop:
    beq s3, zero, process_done  #if s3(N) == 0
    
    lw s4, 0(s0)        # s4 = memory[s0] -- load A[i]
    lw s5, 0(s1)        # s5 = memory[s1] -- load B[i]
    
    #for divide_signed function load A[i] and B[i] into argument registers
    mv a0, s4
    mv a1, s5
    jal divide_signed
    
    sw a0, 0(s2)        # memory[s2] = a0 -- C[i] = result
    
    #increment array's base address and decrement i
    addi s0, s0, 4      #next element in A
    addi s1, s1, 4      #next element in B
    addi s2, s2, 4      #next element in C
    addi s3, s3, -1     #decrement i
    
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
    addi sp, sp, 32   # deallocate stack space
    jr ra


#arguments: a0=dividend(output quotient), a1=divisor
divide_signed:
    addi sp, sp, -16    # allocate 16 bytes on stack
    sw ra, 12(sp)
    sw s0, 8(sp)        # Save s0 (will store sign flag)
    sw s1, 4(sp)        # Save s1 (will store |dividend|)
    sw s2, 0(sp)        # Save s2 (will store |divisor|)
    
    beq a1, zero, handle_div_zero  # Branch if divisor == 0
    
    #check for overflow: -2147483648 / -1
    li t0, 0x80000000   # -2147483648 
    li t1, -1
    beq a0, t0, check_overflow  #if dividend == -2147483648
    j no_overflow

check_overflow:
    beq a1, t1, handle_overflow  #if divisor == -1

no_overflow:
    li s0, 1            # initialize sign flag: pos
    
    # abs of dividend
    mv s1, a0           # s1 = a0 -- copy dividend
    bge s1, zero, abs_dividend_done  # if s1 >= 0
    sub s1, zero, s1    # s1 = 0 - s1 -- compute abs value
    li s0, 0            #set sign flag to negative

abs_dividend_done:
    # abs value of divisor
    mv s2, a1           # s2 = a1 -- copy divisor
    bge s2, zero, abs_divisor_done  # if s2 >= 0
    sub s2, zero, s2    # s2 = 0 - s2 -- compute abs value
    xori s0, s0, 1      # toggle sign


abs_divisor_done:
    mv a0, s1           # a0 = s1 (abs divined)
    mv a1, s2           # a1 = s2 (abs divisor)
    
    jal divide_unsigned
    
    beq s0, zero, make_negative  #if sign flag == 0 -- negative
    j division_complete

make_negative:
    sub a0, zero, a0    # a0 = 0 - a0 (negate result)

division_complete:
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16     #deallocating stack space
    jr ra               #return to process_arrays

handle_div_zero:
    li s0, 1            #s0 = 1 -- positive sign
    mv s1, a0           #s1 = a0  -- actual sign flag
    bge s1, zero, div_zero_sign_done  #if dividend >= 0
    li s0, 0            #s0 = 0 -- set negative sign flag

div_zero_sign_done:
    li a0, 0x7FFFFFFF   #a0 = 2147483647 -- max pos
    beq s0, zero, div_zero_negative  #if sign negative
    j div_zero_return

div_zero_negative:
    li a0, 0x80000000   #a0 = -2147483648 -- min neg

div_zero_return:
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16
    jr ra		#return to process_arrays

handle_overflow:
    #case: -2147483648 / -1
    li a0, 0x7FFFFFFF   #a0 = 2147483647 -- max pos
    
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16
    jr ra		#return to process_arrays


# Algorithm: R′ = 0; for i = N−1 to 0:
		# R = {R′ << 1, Ai}; 
		# D = R − B; 
             	#if D < 0 
			#then Qi = 0, R′ = R 
		#else Qi = 1, R′ = D
#arguments: a0=dividend(output quotient), a1=divisor
divide_unsigned:
    addi sp, sp, -24    #allocating 24 bytes on stack
    sw ra, 20(sp)
    sw s0, 16(sp)       #store dividend
    sw s1, 12(sp)	#store divisor
    sw s2, 8(sp)        #store quotient
    sw s3, 4(sp)        #store R'
    sw s4, 0(sp)        #store bit counter
    
    mv s0, a0           # s0 = a0 -- dividend
    mv s1, a1           # s1 = a1 -- divisor
    li s2, 0            # init quotient to 0
    li s3, 0            # init R' to 0
    li s4, 31           # -start from bit 31

division_loop:
    blt s4, zero, division_done  #if s4 < 0 -- all bits processed
    
    slli s3, s3, 1      # s-- R' shifted left by 1
    

    srl t0, s0, s4      # -- shift A right by bit position
    andi t0, t0, 1      # -- mask to get only LSB
    or s3, s3, t0       # s3 = s3 | t0 (R = {R' << 1, Ai})
    
  
    sub t1, s3, s1      # --D = R - B
    
 
    blt t1, zero, next_bit  #if D < 0 
    
    # D >= 0: Qi = 1, R' = D
    li t2, 1 
    sll t2, t2, s4      # -- create mask for bit position
    or s2, s2, t2       # -- set quotient bit to 1 at position s4 // no branch to set 0 cause it done by itself
    mv s3, t1           # -- R' = D
    j next_bit

next_bit:
    addi s4, s4, -1     # -- decrement bit counter
    j division_loop

division_done:
    mv a0, s2           # Q
    
    lw ra, 20(sp)
    lw s0, 16(sp)
    lw s1, 12(sp)
    lw s2, 8(sp)
    lw s3, 4(sp)
    lw s4, 0(sp)
    addi sp, sp, 24
    jr ra               #return to process_arrays

.end
