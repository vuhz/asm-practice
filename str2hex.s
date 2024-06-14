# spaghetti code
# Convert string to hexadecimal, read in stack until not a num
# Example: "1111" -> 0x457
# input :   [rsp+0x0] 
# output:   r8        
# example usage:
#    mov rbx, rsp
#    mov rdx, [rbx]
#    call tohex

tohex:
    xor r14, r14
    call get_len
    xor r15, r15
    
tohexloop:
    xor rcx, rcx
    mov cl, [rbx+r15]
    add r15, 0x1
    cmp cl, 0x30
    jl end
    cmp cl, 0x39
    jg end

    sub cl, 0x30
    mov rax, r15
    sub rax, 0x1
    mov r13, r14
    call shl_loop
    sub r14, 0x1
    cmp rcx, 0x100
    push rbx
    jge hex2hex1
    jl hex2hex2
    jmp fin

shl_loop:
    cmp r13, 0x1
    jle end
    shl rcx, 4
    sub r13, 0x1
    jmp shl_loop

get_len:
    shr rdx, 8
    inc r14
    cmp rdx, 0x0
    jg get_len
    ret

hex2hex1:
    xor rax, rax

    mov rbx, r14
    sub rbx, 2
    mov rax, 16
    call mul16
    mov r12, rax

    mov rbx, r14
    sub rbx, 2
    mov rax, 1
    call mul10
    mov r11, rax

    mov rax, rcx
    shr rax, 2
    div r12
    mov rcx, 25
    mul rcx
    mul r11
    jmp fin

fin_:
    mov rax, rcx

fin:
    pop rbx
    add r8, rax
    jmp tohexloop

end:
    ret

mul16:
    cmp rbx, 0x0
    jle end
    mov r10, 0x10
    mul r10
    sub rbx, 1
    cmp rbx, 0x0
    jg mul16
    ret

mul10:
    cmp rbx, 0x0
    jle end
    mov r10, 0xa
    mul r10
    sub rbx, 1
    cmp rbx, 0x0
    jg mul10
    ret

hex2hex2:
    cmp rcx, 0x10
    jl fin_
    mov rax, rcx
    shr rax, 4
    mov rcx, 0xa
    mul rcx
    mov rcx, rax
    jmp fin
