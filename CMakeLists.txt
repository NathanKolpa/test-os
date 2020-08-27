cmake_minimum_required (VERSION 2.9)
project (ide_support C)

include_directories(kernel)

add_executable(ide_support
        kernel/kernel.c
        kernel/libc/types.h
        kernel/drivers/ports.h
        )