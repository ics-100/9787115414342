; --------- loader 和 kernel ----------

PAGE_DIR_TABLE_POS equ 0x100000
; --------- 创建页目录及页表 -------------

setup_page:
    ; 先把页目录占用的空间逐字节清 0
    mov ecx, 4096
    mov esi, 0
.clear_page_dir
    mov byte [PAGE_DIR_TABLE_POS + esi], 0
    inc esi
    loop .clear_page_dir



