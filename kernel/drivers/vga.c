#include "vga.h"
#include "ports.h"

#define MAX_ROWS 25
#define MAX_COLS 80
#define VIDEO_MEMORY_ADDRESS 0xb8000;
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

/** Sets the cursor
 * @param offset The offset where the cursor will be placed. (MAX_COLS * y + x)
 * */
void vga_set_cursor(int offset);

/** Gets the cursor offset
 * @returns The cursor offset
 * */
int vga_get_cursor();

/** Prints a single cell.
 * @param cell The cell that will be printed
 * @param offset The current offset. The new offset will be written to this variable
 * */
void vga_internal_print_cell(VgaCell cell, int* offset);

/** Move everything one line up
 * */
void vga_scroll_line();

void vga_clear()
{
	VgaCell* video_memory = (VgaCell*)VIDEO_MEMORY_ADDRESS;

	for(int i = 0; i < MAX_ROWS * MAX_COLS; i++)
	{
		video_memory[i] = (VgaCell){ ' ', (VgaAttribute){ VGA_COLOR_WHITE, VGA_COLOR_BLACK } };
	}

	vga_set_cursor(0);
}

void vga_print_cell(VgaCell cell)
{
	VgaCell* video_memory = (VgaCell*)VIDEO_MEMORY_ADDRESS;

	int offset = vga_get_cursor();
	vga_internal_print_cell(cell, &offset);
	vga_set_cursor(offset);
}

void vga_print_str(VgaCell *str, int str_size)
{
	int offset = vga_get_cursor();

	for(int i = 0; i < str_size; i++)
	{
		vga_internal_print_cell(str[i], &offset);
	}

	vga_set_cursor(offset);
}

void vga_print(char *msg)
{
	int offset = vga_get_cursor();

	for(int i = 0; msg[i]; i++)
	{
		vga_internal_print_cell((VgaCell){ msg[i], (VgaAttribute){ VGA_COLOR_WHITE, VGA_COLOR_BLACK } }, &offset);
	}

	vga_set_cursor(offset);
}

void vga_internal_print_cell(VgaCell cell, int* offset)
{
	VgaCell* video_memory = (VgaCell*)VIDEO_MEMORY_ADDRESS;

	if(cell.character == '\n')
	{
		*offset = (*offset + MAX_COLS) - (*offset % MAX_COLS);
	}
	else
	{
		video_memory[*offset] = cell;
		*offset += 1;
	}

	if(*offset >= MAX_COLS * (MAX_ROWS - 1))
	{
		vga_scroll_line();
		*offset -= MAX_COLS;
	}
}

void vga_scroll_line()
{
	VgaCell* video_memory = (VgaCell*)VIDEO_MEMORY_ADDRESS;

	for(int i = MAX_COLS; i < MAX_ROWS * MAX_COLS; i++)
	{
		video_memory[i - MAX_COLS] = video_memory[i];
	}
}

int vga_get_cursor()
{
	port_byte_out(REG_SCREEN_CTRL, 14);
	int offset = port_byte_in(REG_SCREEN_DATA) << 8;
	port_byte_out(REG_SCREEN_CTRL, 15);
	offset += port_byte_in(REG_SCREEN_DATA);
	return offset;
}

void vga_set_cursor(int offset)
{
	port_byte_out(REG_SCREEN_CTRL, 14);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
	port_byte_out(REG_SCREEN_CTRL, 15);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}
