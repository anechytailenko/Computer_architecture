main:

    lui sp, 0x00000200            # sp = 0x20000000
    lui t0, 0x00000100            # t0 = base address for configs 
    lui t1, 0xF0000             # t1 = address of control register, next to status register


    # CONFIG 1:Vent=1, Pause=1, Irrig=1, Enable=1
    lui t2, 0x00200
    addi t2, t2, 3
    addi t2, t2, 1024
    addi t2, t2, 1024
    
    sw t2, 0(t0)            # store at dmem[0x10000000]

    # CONFIG 2: Vent=1, Pause=10, Irrig=10, Enable=1

    lui t2, 0x00200 
    addi t2, t2, 21
    addi t2, t2, 2047 
    addi t2, t2, 2047
    addi t2, t2, 2047
    addi t2, t2, 2047
    addi t2, t2, 2047 
    addi t2, t2, 2047
    addi t2, t2, 2047
    addi t2, t2, 2047
    addi t2, t2, 2047
    addi t2, t2, 2047
    addi t2, t2, 1940
    
    sw t2, 4(t0)                # store at dmem[0x10000004]


    # CONFIG 3: Vent=10, Pause=1, Irrig=100, Enable=1

    lui t2, 0x02800
    addi t2, t2, 201
    addi t2, t2, 1024
    addi t2, t2, 1024 
    
    sw t2, 8(t0)                # store at dmem[0x10000008]



    addi s0, zero, 3             # config counter = 3 
    addi s1, t0, 0              # s1 point of the current config 

config_loop: # loop over configurations
    beq s0, zero, end_program   

    lw s2, 0(s1)                
    addi s3, zero, 2            # anount how many times to run each config 

run_loop: # loop over runs for each configuration
    beq s3, zero, next_config   

    addi a0, s2, 0             # config  value
    addi a1, t1, 0             # control register address 

    jal run_fsm_cycle

    addi s3, s3, -1
    jal zero, run_loop          

next_config:
    addi s1, s1, 4
    addi s0, s0, -1
    jal zero, config_loop       

end_program:
    jal zero, end_program       



run_fsm_cycle:
    addi sp, sp, -4             
    sw ra, 0(sp)                

    sw a0, 0(a1)        # write config to control register

polling_loop:
    lw t3, 4(a1)        # read status register
    andi t3, t3, 1              
    beq t3, zero, polling_loop

    sw zero, 0(a1)      # reset control register

    lw ra, 0(sp)                
    addi sp, sp, 4              
    jalr zero, ra, 0