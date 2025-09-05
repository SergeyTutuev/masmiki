.MODEL HUGE, stdcall
.stack 200h

INCLUDE src\BigInt.inc

EXTERN MultiplyBigInt@12:FAR
EXTERN init_BigInt@10:FAR
EXTERN CompareBigInt@8:FAR

.data
	; Данные чисел
	num1_left 		db 00h, 00h, 00h, 00h, 00h, 00h, 13h, 0DCh, 96h, 0E3h, 07Ah, 0F4h
	num1_right		db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 1Fh, 12h, 48h, 05h, 04h
	num1_result 	db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num1_result_c 	db 00h, 02h, 69h, 21h, 5Eh, 95h, 0F0h, 90h, 89h, 94h, 0AFh, 0D0h
		
		
	num2_left 		db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 1Fh, 12h, 48h, 05h, 04h
	num2_right		db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0ECh, 23h, 69h, 1Ch, 85h, 0Ch
	num2_result 	db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num2_result_c 	db 0FFh, 0FDh, 96h, 0DEh, 0A1h, 6Ah, 0Fh, 6Fh, 76h, 6Bh, 50h, 30h
	
	num3_left 		db 02h, 80h, 00h, 00h, 00h, 24h, 93h, 0F1h, 8Fh, 66h, 0EAh, 2Ah, 40h, 00h
	num3_right		db 00h, 1Fh, 12h, 48h, 05h, 04h
	num3_result 	db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	
	num4_left 		db 00h, 01h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num4_right		db 00h, 02h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num4_result 	db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num4_result_c 	db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

	

	; Переменные BigInt
	Num_resut 			BigInt <?, ?>
	Num_right			BigInt <?, ?>
	Num_left			BigInt <?, ?>
	Num_resut_c 		BigInt <?, ?>
	
	; Сообщения
	msg1_p 		db 'Test MulCase1 passed',13,10,'$',0
	msg2_p		db 'Test MulCase2 passed',13,10,'$',0
	msg3_p		db 'Test MulCase3 passed',13,10,'$',0
	msg4_p		db 'Test MulCase4 passed',13,10,'$',0

	msg1_f 		db 'Test MulCase1 failed',13,10,'$',0
	msg2_f		db 'Test MulCase2 failed',13,10,'$',0
	msg3_f		db 'Test MulCase3 failed',13,10,'$',0
	msg4_f		db 'Test MulCase4 failed',13,10,'$',0
.code

public TestMulCase1, TestMulCase2, TestMulCase3, TestMulCase4

; -----------------------------
; Тест 1: Произведение положительных чисел
TestMulCase1 proc far
	; Инициализация num_result_c
	mov   ax, SEG num1_result_c
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num1_result_c
	push  ax              ; low word of buffer-pointer
	mov ax, 6
	push  ax              ; size
	mov   ax, SEG Num_resut_c
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_resut_c
	push  ax              ; low word of struct pointer
	call  init_BigInt@10
	
	; Инициализация num_right
	mov   ax, SEG num1_right
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num1_right
	push  ax              ; low word of buffer-pointer
	mov ax, 6
	push  ax              ; size
	mov   ax, SEG Num_right
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_right
	push  ax              ; low word of struct pointer
	call  init_BigInt@10

	; Инициализация num_left
	mov   ax, SEG num1_left
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num1_left
	push  ax              ; low word of buffer-pointer
	mov ax, 6
	push  ax              ; size
	mov   ax, SEG Num_left
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_left
	push  ax              ; low word of struct pointer
	call  init_BigInt@10
	
	; Инициализация num_result
	mov   ax, SEG num1_result
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num1_result
	push  ax              ; low word of buffer-pointer
	mov ax, 6
	push  ax              ; size
	mov   ax, SEG Num_resut
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_resut
	push  ax              ; low word of struct pointer
	call  init_BigInt@10

	
	; Вызов функции Mul
	mov ax, seg Num_resut
	push ax
	mov ax, offset Num_resut
	push ax
	mov ax, seg Num_right
	push ax
	mov ax, offset Num_right
	push ax
	mov ax, seg Num_left
	push ax
	mov ax, offset Num_left
	push ax
	call MultiplyBigInt@12
	
	; Проверка резултата
	mov ax, seg Num_resut
	push ax
	mov ax, offset Num_resut
	push ax
	mov ax, seg Num_resut_c
	push ax
	mov ax, offset Num_resut_c
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
TestMulCase1 endp

; Тест 2: Произведение положительного на отрицательное
TestMulCase2 proc far
	; Инициализация num_result_c
	mov   ax, SEG num2_result_c
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num2_result_c
	push  ax              ; low word of buffer-pointer
	mov ax, 6
	push  ax              ; size
	mov   ax, SEG Num_resut_c
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_resut_c
	push  ax              ; low word of struct pointer
	call  init_BigInt@10
	
	; Инициализация num_right
	mov   ax, SEG num2_right
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num2_right
	push  ax              ; low word of buffer-pointer
	mov ax, 6
	push  ax              ; size
	mov   ax, SEG Num_right
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_right
	push  ax              ; low word of struct pointer
	call  init_BigInt@10

	; Инициализация num_left
	mov   ax, SEG num2_left
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num2_left
	push  ax              ; low word of buffer-pointer
	mov ax, 6
	push  ax              ; size
	mov   ax, SEG Num_left
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_left
	push  ax              ; low word of struct pointer
	call  init_BigInt@10
	
	; Инициализация num_result
	mov   ax, SEG num2_result
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num2_result
	push  ax              ; low word of buffer-pointer
	mov ax, 6
	push  ax              ; size
	mov   ax, SEG Num_resut
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_resut
	push  ax              ; low word of struct pointer
	call  init_BigInt@10

	
	; Вызов функции Mul
	mov ax, seg Num_resut
	push ax
	mov ax, offset Num_resut
	push ax
	mov ax, seg Num_right
	push ax
	mov ax, offset Num_right
	push ax
	mov ax, seg Num_left
	push ax
	mov ax, offset Num_left
	push ax
	call MultiplyBigInt@12
	
	; Проверка резултата
	mov ax, seg Num_resut
	push ax
	mov ax, offset Num_resut
	push ax
	mov ax, seg Num_resut_c
	push ax
	mov ax, offset Num_resut_c
	push ax
	call CompareBigInt@8
	
	jz print_success1
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg2_f
	int 21h

	ret 0

	print_success1:
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg2_p
	int 21h

	ret 0
TestMulCase2 endp

; Тест 3: Размеры операндов не совпадают
TestMulCase3 proc far
	; Инициализация num_right
	mov   ax, SEG num3_right
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num3_right
	push  ax              ; low word of buffer-pointer
	mov ax, 6
	push  ax              ; size
	mov   ax, SEG Num_right
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_right
	push  ax              ; low word of struct pointer
	call  init_BigInt@10

	; Инициализация num_left
	mov   ax, SEG num3_left
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num3_left
	push  ax              ; low word of buffer-pointer
	mov ax, 7
	push  ax              ; size
	mov   ax, SEG Num_left
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_left
	push  ax              ; low word of struct pointer
	call  init_BigInt@10
	
	; Инициализация num_result
	mov   ax, SEG num3_result
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num3_result
	push  ax              ; low word of buffer-pointer
	mov ax, 3
	push  ax              ; size
	mov   ax, SEG Num_resut
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_resut
	push  ax              ; low word of struct pointer
	call  init_BigInt@10

	
	; Вызов функции Mul
	mov ax, seg Num_resut
	push ax
	mov ax, offset Num_resut
	push ax
	mov ax, seg Num_right
	push ax
	mov ax, offset Num_right
	push ax
	mov ax, seg Num_left
	push ax
	mov ax, offset Num_left
	push ax
	call MultiplyBigInt@12
	
	; Проверка резултата
	cmp ax, 0404h
	
	jz print_success1
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg3_f
	int 21h

	ret 0

	print_success1:
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg3_p
	int 21h

	ret 0
TestMulCase3 endp

; Тест 4: Переполнение
TestMulCase4 proc far
	; Инициализация num_result_c
	mov   ax, SEG num4_result_c
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num4_result_c
	push  ax              ; low word of buffer-pointer
	mov ax, 5
	push  ax              ; size
	mov   ax, SEG Num_resut_c
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_resut_c
	push  ax              ; low word of struct pointer
	call  init_BigInt@10
	
	; Инициализация num_right
	mov   ax, SEG num4_right
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num4_right
	push  ax              ; low word of buffer-pointer
	mov ax, 5
	push  ax              ; size
	mov   ax, SEG Num_right
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_right
	push  ax              ; low word of struct pointer
	call  init_BigInt@10

	; Инициализация num_left
	mov   ax, SEG num4_left
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num4_left
	push  ax              ; low word of buffer-pointer
	mov ax, 5
	push  ax              ; size
	mov   ax, SEG Num_left
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_left
	push  ax              ; low word of struct pointer
	call  init_BigInt@10
	
	; Инициализация num_result
	mov   ax, SEG num4_result
	push  ax              ; high word of buffer-pointer
	mov   ax, OFFSET num4_result
	push  ax              ; low word of buffer-pointer
	mov ax, 5
	push  ax              ; size
	mov   ax, SEG Num_resut
	push  ax              ; high word of struct pointer
	mov   ax, OFFSET Num_resut
	push  ax              ; low word of struct pointer
	call  init_BigInt@10

	
	; Вызов функции Mul
	mov ax, seg Num_resut
	push ax
	mov ax, offset Num_resut
	push ax
	mov ax, seg Num_right
	push ax
	mov ax, offset Num_right
	push ax
	mov ax, seg Num_left
	push ax
	mov ax, offset Num_left
	push ax
	call MultiplyBigInt@12
	
	;Проверка регистра переполнения
	PUSHF
	POP ax
	TEST ax, 0800h
	JZ failed
	
	; Проверка резултата
	mov ax, seg Num_resut
	push ax
	mov ax, offset Num_resut
	push ax
	mov ax, seg Num_resut_c
	push ax
	mov ax, offset Num_resut_c
	push ax
	call CompareBigInt@8
	
	jz print_success1
	
	failed:
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg4_f
	int 21h

	ret 0

	print_success1:
	mov ax, @data
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg4_p
	int 21h

	ret 0
TestMulCase4 endp

end
