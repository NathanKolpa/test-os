%ifndef PRINT_ASM
%define PRINT_ASM

; Prints with a new line
println:
    pusha

    mov ah, 0x0e

    mov al, 0x0a ; \n
    int 0x10

    mov al, 0x0d ; \r
    int 0x10

    popa
    ret

; Prints whatever is located at BX (must be 0 terminated)
print_str:
    pusha

    mov ah, 0x0e
print_str_start:
    mov al, [bx]

    cmp al, 0
    je print_str_end

    int 0x10

    inc bx
    jmp print_str_start
print_str_end:
    popa
    ret

println_str:
    call print_str
    call println
    ret

print_buffer:
    db '00000000', 0

; BX is the number
print_number:
    pusha

    mov si, 7
print_number_begin:

    mov dx, 0
    mov ax, bx
    mov cx, 16 ; base
    div cx

    mov bx, ax

    cmp dx, 10
    jl print_number_less

    add dx, 55
    jmp print_number_endif
print_number_less:
    add dx, 48
print_number_endif:

    mov di, print_buffer
    add di, si
    mov [di], dl

    cmp si, 0
    dec si
    jge print_number_begin

    ; print to screen

    mov ah, 0x0e
    mov al, 48
    int 0x10
    mov al, 120
    int 0x10

    mov bx, print_buffer
    call print_str

    popa
    ret

println_number:
    call print_number
    call println
    ret

%endif