; -----创建页目录及页表
setup_page:
; 先把页目录占用的空间逐字节清0
    mov ecx, 4096
    mov esi, 0
.clear_page_dir
    mov byte [PAGE_DIR_TABLE_POS + esi], 0
    inc esi
    loop .clear_page_dir

;开始创建页目录项
.create_pde:
    mov, eax, PAGE_DIR_TABLE_POS
    add eax, 0x1000     ; 第一个页表的位置及属性
    mov ebx, eax

    or eax, PG_US_U | PG_RW_W | PG_P ; or eax, 0x7
    mov  [PAGE_DIR_TABLE_POS + 0x0], eax
    mov  [PAGE_DIR_TABLE_POS + 0xc00], eax

    sub eax, 0x1000
    mov  [PAGE_DIR_TABLE + 4096], eax

; 创建页表项
    mov ecx, 256 ; 1M低端内存/ 每页大小4kb = 256
    mov esi, 0
    mov edx, PG_US_U | PG_RW_W | PG_P

.create_pte:
    mov [ebx + esi *4], edx
    add edx, 4096
    inc esi
    loop .create_pte

; 创建内核其他页表的PDE

    mov eax, PAGE_DIR_TABLE_POS
    add eax, 0x2000
    or eax, PG_US_U | PG_RW_W | PG_P
    


