.global main

.data
.eqv N,5

A: .word 100,50,36,25,16
B: .word 50, 2,6,5,4

C : .space 20

.text

main:
	addi s0, x0, 0
	la s1, A
	la s2, B
	la s3, C
	
array_loop:
	addi t0,x0,5
	bge s0, t0 , end_program
	
	slli t1, s0,2
	add t2,s1,t1
	lw a0, 0(t2)
	
	add t2, s2, t1
	lw a1, 0(t2)
	
	jal ra, divide_func
	
	add t2, s3, t1
	sw a0, 0(t2)
	
	addi s0, s0 , 1
	jal x0, array_loop
	
end_program:
	addi a7,x0,10
	ecall
	

	
divide_func:
	beq a1, x0, division_by_zero
	
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw s1, 4(sp)
	sw s2, 0(sp)
	
							
	mv s0, a0
	addi s1, x0, 0																		
	addi s2, x0, 0
	addi t3, x0, 31

division_loop:
	blt t3, x0, division_done
	
	slli s1,s1,1
	srli t4, s0, 31
	or s1, s1, t4
	
	slli s0, s0,1
	
	sub t5,s1,a1
	
	blt t5, x0, Q_is_zero
	
			
	mv s1,t5
	slli s2,s2,1
	ori s2,s2,1
	jal x0, decrement_iterative_bit
	
Q_is_zero: 
	slli s2,s2,1

decrement_iterative_bit:
	addi t3,t3,-1
	jal x0, division_loop

division_done:
	mv a0, s2
	
	lw s2, 0(sp)
	lw s1, 4(sp)
	lw s0, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	
	jalr x0, 0(ra)

division_by_zero:
	lui a0, 0xFFFFF
	addi a0, a0, -1
	jalr x0, 0(ra)		
		
					
	
	
					
	
	
				