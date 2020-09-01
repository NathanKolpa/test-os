# this file is only for ide support

cmake_minimum_required (VERSION 2.9)
project (ide_support C)

include_directories(kernel)

add_executable(ide_support
        kernel/kernel.c
        kernel/utills/types.h
        kernel/drivers/ports.h
        kernel/drivers/ports.c kernel/drivers/vga.h kernel/drivers/vga.c)