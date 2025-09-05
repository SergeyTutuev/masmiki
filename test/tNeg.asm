.MODEL HUGE, stdcall
.stack 200h

INCLUDE src\BigInt.inc

EXTERN NegBigInt@4:FAR
EXTERN init_BigInt@10:FAR
EXTERN CompareBigInt@8:FAR

.data
	; Данные чисел
	num1_data 	db 10101010b, 10101010b
	num1_res	db 01010101b, 01010110b
	
	num2_data 	db 00000000b, 00000000b
	num2_res	db 00000000b, 00000000b

	; Переменные BigInt
	myNum1 		BigInt <?, ?>
	myNum2		BigInt <?, ?>
	
	; Сообщения
	msg1_p 		db 'Test NegCase1 passed',13,10,'$',0
	msg2_p		db 'Test NegCase2 passed',13,10,'$',0

	msg1_f 		db 'Test NegCase1 failed',13,10,'$',0
	msg2_f		db 'Test NegCase2 failed',13,10,'$',0
.code
public TestNegCase1, TestNegCase2

; -----------------------------
; Тест 1: Инверсия положительного числа
TestNegCase1 proc far
	; Инициализация num1
	mov   ax, SEG num1_data
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num1_data
	push  ax              ; low word of buffer-pointer
	mov ax, 1
	push  ax              ; size
	mov   ax, SEG myNum1
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET myNum1
	push  ax              ; low word of struct pointer
	call  init_BigInt@10
	
	; Инициализация num2
	mov   ax, SEG num1_res
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num1_res
	push  ax              ; low word of buffer-pointer
	mov ax, 1
	push  ax              ; size
	mov   ax, SEG myNum2
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET myNum2
	push  ax              ; low word of struct pointer
	call  init_BigInt@10
	
	; Вызов функции Neg
	mov ax, seg myNum1
	push ax

	mov ax, offset myNum1
	push ax

	call NegBigInt@4
	
	; Проверка резултата
	mov ax, seg myNum1
	push ax

	mov ax, offset myNum1
	push ax
	
	mov ax, seg myNum2
	push ax

	mov ax, offset myNum2
	push ax
	
	call CompareBigInt@8
	jz print_success1
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
TestNegCase1 endp

; -----------------------------
; Тест 2: Инверсия нуля
TestNegCase2 proc far
	; Инициализация num1
	mov   ax, SEG num2_data
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num2_data
	push  ax              ; low word of buffer-pointer
	mov ax, 1
	push  ax              ; size
	mov   ax, SEG myNum1
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET myNum1
	push  ax              ; low word of struct pointer
	call  init_BigInt@10
	
	; Инициализация num2
	mov   ax, SEG num2_res
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num2_res
	push  ax              ; low word of buffer-pointer
	mov ax, 1
	push  ax              ; size
	mov   ax, SEG myNum2
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET myNum2
	push  ax              ; low word of struct pointer
	call  init_BigInt@10
	
	; Вызов функции Neg
	mov ax, seg myNum1
	push ax

	mov ax, offset myNum1
	push ax

	call NegBigInt@4
	
	; Проверка резултата
	mov ax, seg myNum1
	push ax

	mov ax, offset myNum1
	push ax
	
	mov ax, seg myNum2
	push ax

	mov ax, offset myNum2
	push ax
	
	call CompareBigInt@8
	jz print_success2
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
TestNegCase2 endp

END
