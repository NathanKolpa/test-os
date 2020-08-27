all: run

kernel.bin: kernel_entrypoint.o kernel.o
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_entrypoint.o: boot/kernel_entrypoint.asm
	nasm $< -f elf -o $@

kernel.o: kernel/kernel.c
	i386-elf-gcc -ffreestanding -c $< -o $@

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

boot_sector.bin: boot/boot_sector.asm
	nasm $< -f bin -o $@

os-image.bin: boot_sector.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 -fda $<

clean:
	rm *.bin *.o *.dis