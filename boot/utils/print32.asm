%ifndef PRINT_32_ASM
%define PRINT_32_ASM

[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

print_32_str:
    pusha

    mov edx, VIDEO_MEMORY
print_32_str_start:
    mov al, [ebx]
    mov ah, WHITE_ON_BLACK

    cmp al, 0
    je print_32_str_end

    mov [edx], ax
    inc ebx
    add edx, 2
    jmp print_32_str_start
print_32_str_end:
    popa
    ret

%endif
