#include <drivers/vga.h>

/** The entry point of the OS
 * */
void main()
{
	vga_clear();

	VgaAttribute black_on_white = (VgaAttribute){ VGA_COLOR_WHITE, VGA_COLOR_BLACK };
	VgaCell str[] = { { 'T', black_on_white }, { 'e', black_on_white }, { 's', black_on_white }, { 't', black_on_white }, { '\n', black_on_white } };

	vga_print_str(str, sizeof(str) / sizeof(VgaCell));


	for(int i = 0;; i++)
	{
		vga_print_cell((VgaCell){ 'X', (VgaAttribute){ VGA_COLOR_WHITE, i % 16 } });
		vga_print_cell((VgaCell){ '\n', (VgaAttribute){ VGA_COLOR_WHITE, VGA_COLOR_BLACK } });
	}
}