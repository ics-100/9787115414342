## 第4章 保护模式入门

* `Sat Jun  5 15:40:23 CST 2021`


**4.2.3 保护模式之运行模式反转**

* 编译器提供了伪指令 `bits`, 用来向编译器传达，我下面的指令要编译成xx位的
* 默认 [bits 16]
* 反转操作数大小前缀: `0x66`
* 寻址方式前缀: `0x67`

**4.3.2 全局描述表GDT、局部描述表LDT及选择子**

* type 字段是要 S 字段配合在一起才能确定描述符的确切类型
* 什么是系统段？ 各种称为门的结构便是系统段,也就是硬件系统需要的结构
* GDTR / lgdt
* LDTR / lldt 

**4.4.3 打开A20地址线**

* 对于80286 后续的CPU, 通过A20Gate来控制A20地址线
* 将端口 `0x92` 的第一位置1就可以了


**4.3.4 保护模式的开关， CR0寄存器的PE位**

* 控制寄存器是CPU的窗口，既可以用来表示CPU的内部状态，也可以用于控制CPU的运行机制
* PE位为0表示在实模式下运行，PE位为1表示在保护模式下运行
