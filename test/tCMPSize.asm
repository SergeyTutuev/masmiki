INCLUDELIB ..\build\bin\BigInt.lib
INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall
.stack 200h

EXTRN CompareSizeBigInt@8:FAR
EXTRN init_BigInt@10: FAR

.data
	; Данные чисел
	num1_data db 00, 00, 00, 10, 00, 00
	num2_data db 00, 00, 00, 00, 00, 06
	
	num3_data db 00, 00, 00, 10, 00, 00
	num4_data db 00, 06

	; Переменные BigInt
	myNum1 BigInt <?>
	myNum2 BigInt <?>
	
	; Сообщения
	msg1_p db 'Test CompareSizeCase1 passed',13,10,'$',0
	msg2_p db 'Test CompareSizeCase2 passed',13,10,'$',0

	msg1_f db 'Test CompareSizeCase1 failed',13,10,'$',0
	msg2_f db 'Test CompareSizeCase2 failed',13,10,'$',0



.CODE
public TestCompareSizeCase1, TestCompareSizeCase2

TestCompareSizeCase1 proc far
	 ; Инициализация num1
	push ds
	mov ax, offset num1_data
	push ax
	mov ax, 3
	push ax
	mov ax, ds
	push ax
	mov ax, offset myNum1
	push ax
	call init_BigInt@10

	; Инициализация num2
	mov ax, ds
	push ax
	mov ax, offset num2_data
	push ax
	mov ax, 3
	push ax
	mov ax, ds
	push ax
	mov ax, offset myNum2
	push ax
	call init_BigInt@10
   
	mov ax, seg myNum2
	push ax

	mov ax, offset myNum2
	push ax

	mov ax, seg myNum1
	push ax

	mov ax, offset myNum1
	push ax

	call CompareSizeBigInt@8
	cmp ax, 0404h
	jne print_success1
	mov ax, seg msg1_f
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg1_f
	int 21h
	retf

	print_success1:
	mov ax, seg msg1_p
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg1_p
	int 21h
	retf

TestCompareSizeCase1 endp


TestCompareSizeCase2 proc far
	 ; Инициализация num1
	push ds
	mov ax, offset num3_data
	push ax
	mov ax, 3
	push ax
	mov ax, ds
	push ax
	mov ax, offset myNum1
	push ax
	call init_BigInt@10

	; Инициализация num2
	mov ax, ds
	push ax
	mov ax, offset num4_data
	push ax
	mov ax, 1
	push ax
	mov ax, ds
	push ax
	mov ax, offset myNum2
	push ax
	call init_BigInt@10
 
	mov ax, seg myNum2
	push ax

	mov ax, offset myNum2
	push ax

	mov ax, seg myNum1
	push ax

	mov ax, offset myNum1
	push ax

	call CompareSizeBigInt@8
	cmp ax, 0404h
	je print_success2
	mov ax, seg msg2_f
	mov ds, ax

	mov ah, 09h
	mov dx, offset msg2_f
	int 21h
	retf

	print_success2:
	mov ax, seg msg2_p
	mov ds, ax

	mov ah, 09h
	mov dx, offset msg2_p
	int 21h
	
	retf
TestCompareSizeCase2 endp

END
