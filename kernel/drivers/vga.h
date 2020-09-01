#ifndef DRIVERS_VGA_H
#define DRIVERS_VGA_H

#include <utills/types.h>

typedef struct
{
	ui8 foreground: 4;
	ui8 background: 4;
} VgaAttribute;

typedef struct
{
	char character;
	VgaAttribute attribute;
} VgaCell;

#define VGA_COLOR_BLACK 0
#define VGA_COLOR_BLUE 1
#define VGA_COLOR_GREEN 2
#define VGA_COLOR_CYAN 3
#define VGA_COLOR_RED 4
#define VGA_COLOR_MAGENTA 5
#define VGA_COLOR_BROWN 6
#define VGA_COLOR_LIGHT_GRAY 7
#define VGA_COLOR_GRAY 8
#define VGA_COLOR_LIGHT_BLUE 9
#define VGA_COLOR_LIGHT_GREEN 10
#define VGA_COLOR_LIGHT_CYAN 11
#define VGA_COLOR_LIGHT_RED 12
#define VGA_COLOR_LIGHT 13
#define VGA_COLOR_LIGHT_MAGENTA 14
#define VGA_COLOR_WHITE 15

/** Clears the entire screen.
 * */
void vga_clear();

/** Prints a string of vga cells at the cursor. This is slightly more efficient printing each character using vga_print_cell.
 * @see vga_print_cell
 *
 * @param str The string of cells.
 * @param str_size The size of the string.
 * */
void vga_print_str(VgaCell* str, int str_size);

/** Prints a vga cell at the cursor
 * @param cell The cell to print
 * */
void vga_print_cell(VgaCell cell);

#endif