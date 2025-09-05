INCLUDELIB ..\build\bin\BigInt.lib
INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

EXTRN init_BigInt@10:FAR
EXTRN CompareBigInt@8:FAR
EXTRN ModBigInt@12:FAR
EXTRN NegBigInt@4:FAR

.data
	; Данные чисел
	num1_data db 00h, 02h, 0DDh, 9Bh, 0A3h, 0C8h, 31h, 67h, 0EEh, 0BFh, 6Fh, 0D4h
	num2_data db 00h, 00h, 00h, 00h, 00h, 00h, 15h, 1Ah, 94h, 0DFh, 86h, 0F7h
	num3_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num4_data db 00h, 00h, 00h, 00h, 00h, 00h, 0Ch, 0FDh, 68h, 86h, 42h, 49h

	num5_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num6_data db 12 dup(?)
	num7_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

	; Переменные BigInt
	myNum1 BigInt <?>
	myNum2 BigInt <?>
	result1 BigInt <?>
	right1 BigInt <?>
	
	; Сообщения
	msg1_p db 'Test ModCase1 passed',13,10,'$',0
	msg1_f db 'Test ModCase1 failed',13,10,'$',0

	msg2_p db 'Test ModCase2 passed',13,10,'$',0
	msg2_f db 'Test ModCase2 failed',13,10,'$',0

	msg3_p db 'Test ModCase3 passed',13,10,'$',0
	msg3_f db 'Test MOdCase3 failed',13,10,'$',0

	msg4_p db 'Test ModCase4 passed',13,10,'$',0
	msg4_f db 'Test ModCase4 failed',13,10,'$',0


.CODE
public TestModCase1, TestModCase2, TestModCase3, TestModCase4
ASSUME DS:@data
TestModCase1 proc far
	mov ax, @data
	mov ds, ax
	 ; Инициализация num1
	push ds
	mov ax, offset num1_data
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
	mov ax, offset num2_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset myNum2
	push ax
	call init_BigInt@10

	; Инициализация result1
	mov ax, ds
	push ax
	mov ax, offset num3_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset result1
	push ax
	call init_BigInt@10

	; Инициализация result1
	mov ax, ds
	push ax
	mov ax, offset num4_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset right1
	push ax
	call init_BigInt@10

	mov ax, DS
	push ax

	mov ax, offset myNum1
	push ax

	mov ax, DS
	push ax

	mov ax, offset myNum2
	push ax

	mov ax, DS
	push ax

	mov ax, offset result1
	push ax

	call ModBigInt@12

	mov ax, DS
	push ax

	mov ax, offset right1
	push ax

	mov ax, DS
	push ax

	mov ax, offset result1
	push ax

	call CompareBigInt@8
	je print_success1

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
TestModCase1 endp

TestModCase2 proc far
	mov ax, @data
	mov ds, ax
	 ; Инициализация num1
	push ds
	mov ax, offset num1_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset myNum1
	push ax
	call init_BigInt@10

	mov ax, ds
	push ax
	mov ax, offset myNum1
	push ax
	call NegBigInt@4

	; Инициализация num2
	mov ax, ds
	push ax
	mov ax, offset num2_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset myNum2
	push ax
	call init_BigInt@10

	; Инициализация result1
	mov ax, ds
	push ax
	mov ax, offset num3_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset result1
	push ax
	call init_BigInt@10

	; Инициализация right1
	mov ax, ds
	push ax
	mov ax, offset num4_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset right1
	push ax
	call init_BigInt@10

	mov ax, ds
	push ax
	mov ax, offset right1
	push ax
	call NegBigInt@4

	mov ax, DS
	push ax

	mov ax, offset myNum1
	push ax

	mov ax, DS
	push ax

	mov ax, offset myNum2
	push ax

	mov ax, DS
	push ax

	mov ax, offset result1
	push ax

	call ModBigInt@12

	mov ax, DS
	push ax

	mov ax, offset right1
	push ax

	mov ax, DS
	push ax

	mov ax, offset result1
	push ax

	call CompareBigInt@8
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
TestModCase2 endp

TestModCase3 proc far
	mov ax, @data
	mov ds, ax
	 ; Инициализация num1
	push ds
	mov ax, offset num1_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset myNum1
	push ax
	call init_BigInt@10

	mov ax, ds
	push ax
	mov ax, offset myNum1
	push ax
	call NegBigInt@4

	; Инициализация num2
	mov ax, ds
	push ax
	mov ax, offset num2_data
	push ax
	mov ax, 4
	push ax
	mov ax, ds
	push ax
	mov ax, offset myNum2
	push ax
	call init_BigInt@10

	; Инициализация result1
	mov ax, ds
	push ax
	mov ax, offset num3_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset result1
	push ax
	call init_BigInt@10

	; Инициализация right1
	mov ax, ds
	push ax
	mov ax, offset num4_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset right1
	push ax
	call init_BigInt@10

	mov ax, ds
	push ax
	mov ax, offset right1
	push ax
	call NegBigInt@4

	mov ax, DS
	push ax

	mov ax, offset myNum1
	push ax

	mov ax, DS
	push ax

	mov ax, offset myNum2
	push ax

	mov ax, DS
	push ax

	mov ax, offset result1
	push ax

	call ModBigInt@12

	cmp ax, 0404h
	je print_success2

	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg3_f
	int 21h
	ret 0

	print_success2:
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg3_p
	int 21h

	ret 0
TestModCase3 endp

TestModCase4 proc far
	mov ax, @data
	mov ds, ax
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
	mov ax, offset num2_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset myNum2
	push ax
	call init_BigInt@10

	; Инициализация result1
	mov ax, ds
	push ax
	mov ax, offset num6_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset result1
	push ax
	call init_BigInt@10

	; Инициализация right1
	mov ax, ds
	push ax
	mov ax, offset num7_data
	push ax
	mov ax, 6
	push ax
	mov ax, ds
	push ax
	mov ax, offset right1
	push ax
	call init_BigInt@10

	mov ax, DS
	push ax

	mov ax, offset myNum1
	push ax

	mov ax, DS
	push ax

	mov ax, offset myNum2
	push ax

	mov ax, DS
	push ax

	mov ax, offset result1
	push ax

	call ModBigInt@12

	mov ax, DS
	push ax

	mov ax, offset right1
	push ax

	mov ax, DS
	push ax

	mov ax, offset result1
	push ax

	call CompareBigInt@8
	je print_success3

	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg4_f
	int 21h
	ret 0

	print_success3:
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg4_p
	int 21h

	ret 0
TestModCase4 endp
END
