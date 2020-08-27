%ifndef DISK_ASM
%define DISK_ASM

%include "boot/utils/print.asm"

disk_load:
    pusha

    push dx

    mov ah, 2 ; read
    mov cl, 2 ; sector
    mov al, dh ; number of sectors
    mov ch, 0 ; head
    mov dh, 0 ; cylinder

    int 0x13
    jc disk_error

    pop dx
    cmp al, dh
    jne sector_count_error

    jmp disk_exit

disk_error:
    mov bx, msg_disk_error
    call println_str

    mov bx, 0
    mov bl, ah
    call println_number

    jmp $

sector_count_error:

    mov bx, msg_sector_count_error
    call println_str

    jmp $

disk_exit:
    popa
    ret

msg_disk_error: db 'Error while reading disk', 0
msg_sector_count_error: db 'Sectors to read does not match actual read', 0

%endif