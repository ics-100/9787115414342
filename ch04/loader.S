%include "boot.inc"

section loader vstart=LOADER_BASE_ADDR
LOADER_STACK_TOP equ LOADER_BASE_ADDR

; 构建gdt 及其内部描述符

GDT_BASE: dd 0x00
          dd 0x00

CODE_DESC:  dd 0x000FFFF
            dd DESC_CODE_HIGH4

GDT_SIZE equ $ - GDT_BASE
GDT_LIMIT equ GDT_SZie -1

times 60 dq 0
