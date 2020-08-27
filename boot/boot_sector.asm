; == initialization ==
[org 0x7c00]
mov [boot_drive], dl
; stack
mov bp, 0x9000
mov sp, bp

; == begin execution ==

mov bx, msg_realmode
call println_str

call load_kernel
call switch_to_protected_mode
jmp $

; == begin includes ==
KERNEL_OFFSET equ 0x1000

load_kernel:
    mov bx, KERNEL_OFFSET
    mov dh, 2
    mov dl, [boot_drive]
    call disk_load

    mov bx, msg_load_kernel
    call println_str

    ret

%include "boot/utils/print.asm"
%include "boot/utils/disk.asm"

; ==== begin 32 bit ====

; == begin gdt ==

gdt_start:
    dd 0x0
    dd 0x0

gdt_code:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0

gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; ==== begin 32 bit code ====

%include "boot/utils/print32.asm"

; == 32bit switch ==
[bits 16]
switch_to_protected_mode:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:initialize_protected_mode

[bits 32]
initialize_protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    call protected_mode_main

[bits 32]
protected_mode_main:
    mov ebx, msg_protected_mode
    call print_32_str
    call KERNEL_OFFSET ; finally move out of this assembly shithole
    jmp $
; ==== begin data ====


boot_drive db 0
msg_realmode db "Entered in 16-bit real mode", 0
msg_protected_mode db "Entered in 32-bit protected mode", 0
msg_load_kernel db "Kernel loaded from disk", 0

; ==== fill the rest of the file with padding ====
times 510-($-$$) db 0
dw 0xaa55