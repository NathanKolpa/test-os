#include <drivers/vga.h>

/** The entry point of the OS
 * */
void main()
{
	vga_clear();

	vga_print("Hello World\n");
}