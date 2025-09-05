INCLUDELIB ..\build\bin\BigInt.lib
INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

EXTRN CompareBigInt@8:FAR
EXTRN init_BigInt@10:FAR

.data
	; Данные чисел
	num1_data db 77, 77, 77, 77, 77, 77, 77, 77, 77, 77
	num2_data db 00, 00, 00, 00, 00, 00, 20, 00, 00, 00
	
	num3_data db 77, 77, 77, 77, 77, 77, 77, 77, 77, 77
	num4_data db 00, 00, 00, 00, 20, 00, 00, 00

	num5_data db 11111111b, 11111101b, 87h, 56h, 11101110b, 11110010b, 94h, 18h, 98h, 21h, 56h, 1Dh
	num6_data db 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 01

	; Переменные BigInt
	myNum1 BigInt <?>
	myNum2 BigInt <?>
	
	; Сообщения
	msg1_p db 'Test CompareCase1 passed',13,10,'$',0
	msg2_p db 'Test CompareCase2 passed',13,10,'$',0
	msg3_p db 'Test CompareCase3 passed',13,10,'$',0

	msg1_f db 'Test CompareCase1 failed',13,10,'$',0
	msg2_f db 'Test CompareCase2 failed',13,10,'$',0
	msg3_f db 'Test CompareCase3 failed',13,10,'$',0

.CODE
public TestCompareCase1, TestCompareCase2, TestCompareCase3
ASSUME DS:@data
TestCompareCase1 proc far
	 ; Инициализация num1
	push ds
	mov ax, offset num1_data
	push ax
	mov ax, 5
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
	mov ax, 5
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

	call CompareBigInt@8
	jg print_success1
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg1_f
	int 21h
	ret 0

	print_success1:
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg1_p
	int 21h

	ret 0
TestCompareCase1 endp


TestCompareCase2 proc far
	 ; Инициализация num1
	push ds
	mov ax, offset num3_data
	push ax
	mov ax, 5
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
	mov ax, 4
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

	call CompareBigInt@8
	cmp ax, 0404h
	je print_success2
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg2_f
	int 21h
	ret 0

	print_success2:
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg2_p
	int 21h
	ret 0
TestCompareCase2 endp


TestCompareCase3 proc far
	; Инициализация num1
	push ds
	mov ax, offset num5_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset myNum1
	push ax
	call init_BigInt@10

	; Инициализация num2
	mov ax, ds
	push ax
	mov ax, offset num6_data
	push ax
	mov ax, 6
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

	call CompareBigInt@8
	jl print_success3
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg3_f
	int 21h
	ret 0

	print_success3:
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg3_p
	int 21h
	
	ret 0
TestCompareCase3 endp

END
