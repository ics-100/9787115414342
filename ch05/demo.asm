         mov ax,cs
         mov ss,ax
         mov sp,0x7c00

         ;计算GDT所在的逻辑段地址
         mov eax,[cs:pgdt+0x7c00+0x02]      ;GDT的32位物理地址 
         xor edx,edx
         mov ebx,16
         div ebx                            ;分解成16位逻辑地址 

         mov ds,eax                         ;令DS指向该段以进行操作
         mov ebx,edx                        ;段内起始偏移地址 

         ;跳过0#号描述符的槽位
         ;创建1#描述符，这是一个数据段，对应0~4GB的线性地址空间
         mov dword [ebx+0x08],0x0000ffff    ;基地址为0，段界限为0xFFFFF
         mov dword [ebx+0x0c],0x00cf9200    ;粒度为4KB，存储器段描述符 

         ;创建保护模式下初始代码段描述符
         mov dword [ebx+0x10],0x7c0001ff    ;基地址为0x00007c00，界限0x1FF 
         mov dword [ebx+0x14],0x00409800    ;粒度为1个字节，代码段描述符 

         ;建立保护模式下的堆栈段描述符      ;基地址为0x00007C00，界限0xFFFFE 
         mov dword [ebx+0x18],0x7c00fffe    ;粒度为4KB 
         mov dword [ebx+0x1c],0x00cf9600

         ;建立保护模式下的显示缓冲区描述符   
         mov dword [ebx+0x20],0x80007fff    ;基地址为0x000B8000，界限0x07FFF 
         mov dword [ebx+0x24],0x0040920b    ;粒度为字节

         ;初始化描述符表寄存器GDTR
         mov word [cs: pgdt+0x7c00],39      ;描述符表的界限   

         lgdt [cs: pgdt+0x7c00]

         in al,0x92                         ;南桥芯片内的端口 
         or al,0000_0010B
         out 0x92,al                        ;打开A20

         cli                                ;中断机制尚未工作

         mov eax,cr0
         or eax,1
         mov cr0,eax                        ;设置PE位

         ;以下进入保护模式... ...
         jmp dword 0x0010:flush             ;16位的描述符选择子：32位偏移
                                            ;清流水线并串行化处理器
         [bits 32]               
  flush:                                  

    call setup_page

    sgdt [pgdt]

    mov ebx, [pgdt + 2]
    or dword [ebx + 0x18 +4], 0xc000000
    add dword [pgdt + 2], 0xc000000
    add esp, 0xc000000

    ; 把页目录
    mov eax, PAGE_DIR_TABLE_POS
    mov cr3, eax
    mov eax, cr0
    or eax ,0x800000
    mov cro, eax

    ; 在开启分页后用
    lgdt [pgdt]
    
    mov byte [gs:160], 'V'
;-------------------------------------------------------------------------------
         pgdt             dw 0
                          dd 0x00007e00      ;GDT的物理地址
;-------------------------------------------------------------------------------                             
         times 510-($-$$) db 0
                          db 0x55,0xaa
