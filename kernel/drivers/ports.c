#include "ports.h"

ui8 port_byte_in(ui16 port)
{
	ui8 result;
	__asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
	return result;
}

void port_byte_out(ui16 port, ui8 data)
{
	__asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

ui16 port_word_in(ui16 port)
{
	ui16 result;
	__asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
	return result;}

void port_word_out(ui16 port, ui16 data)
{
	__asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}
