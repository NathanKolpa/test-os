#ifndef DRIVERS_PORT_H
#define DRIVERS_PORT_H

#include <utills/types.h>

ui8 port_byte_in(ui16 port);
void port_byte_out(ui16 port, ui8 data);

ui16 port_word_in(ui16 port);
void port_word_out(ui16 port, ui16 data);

#endif