
C_SOURCES = $(wildcard kernel/*.c kernel/drivers/*.c kernel/libc/*.c)
HEADERS = $(wildcard kernel/*.h kernel/drivers/*.h kernel/libc/*.h)
OBJ = ${C_SOURCES:.c=.o}

CC = /usr/local/i386elfgcc/bin/i386-elf-gcc
GDB = /usr/local/i386elfgcc/bin/i386-elf-gdb

INC=-I./kernel
CFLAGS = -g

os-image.bin: boot/boot_sector.bin kernel.bin
	cat $^ > os-image.bin



kernel.bin: boot/kernel_entrypoint.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.elf: boot/kernel_entrypoint.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^


run: os-image.bin
	qemu-system-i386 -fda os-image.bin

debug: os-image.bin kernel.elf
	qemu-system-i386 -s -fda os-image.bin &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o