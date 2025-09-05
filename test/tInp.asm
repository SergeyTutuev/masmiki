INCLUDELIB ..\build\bin\BigInt.lib
INCLUDE src/Bigint.inc

.MODEL HUGE, stdcall

EXTRN init_BigInt@10:FAR
EXTRN InputBigInt@14:FAR
EXTRN CompareBigInt@8:FAR

Stk SEGMENT para STACK 'stk'
	DB 400h dup (?)
Stk ENDS

.data
	; Буфер строки
	str_buff db 100h DUP (?)

	; Данные чисел
	num1_data db 00h, 00h, 00h, 00h, 00h, 00h
	num2_data db 00h, 02h, 18h, 71h, 1Ah, 00h

	; Переменные BigInt
	myNum1 BigInt <?>
	myNum2 BigInt <?>

	; Данные чисел
	num3_data db 00h, 00h, 00h, 00h, 00h, 00h
	num4_data db 0FFh, 0FDh, 0E7h, 8Eh, 0E6h, 00h

	; Переменные BigInt
	myNum3 BigInt <?>
	myNum4 BigInt <?>

	; Данные чисел
	num5_data db 00h, 00h

	; Переменные BigInt
	myNum5 BigInt <?>

	; Данные чисел
	num6_data db 00h, 00h

	; Переменные BigInt
	myNum6 BigInt <?>

	; Сообщения
	msg1 db 'TestInpCase1 passed',13,10,'$',0
	msg2 db 'TestInpCase1 failed',13,10,'$',0
	msg3 db 'TestInpCase2 passed',13,10,'$',0
	msg4 db 'TestInpCase2 failed',13,10,'$',0
	msg5 db 'TestInpCase3 passed',13,10,'$',0
	msg6 db 'TestInpCase3 failed',13,10,'$',0
	msg7 db 'Please, input integer 9000000000',13,10,'$',0
	msg8 db 'Please, input integer -9000000000',13,10,'$',0
	msg9 db 'Please, input anything, but integer',13,10,'$',0


.CODE
public TestInpCase1, TestInpCase2, TestInpCase3

pass14 proc
	mov ax, seg msg1
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg1
	int 21h
	ret
pass14 ENDP

fail14 proc
	mov ax, seg msg2
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg2
	int 21h
	ret
fail14 ENDP

pass24 proc
	mov ax, seg msg3
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg3
	int 21h
	ret
pass24 ENDP

fail24 proc
	mov ax, seg msg4
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg4
	int 21h
	ret
fail24 ENDP

pass34 proc
	mov ax, seg msg5
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg5
	int 21h
	ret
pass34 ENDP

fail34 proc
	mov ax, seg msg6
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg6
	int 21h
	ret
fail34 ENDP

integer1 proc
	mov ax, seg msg7
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg7
	int 21h
	ret
integer1 ENDP

integer2 proc
	mov ax, seg msg8
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg8
	int 21h
	ret
integer2 ENDP

integer3 proc
	mov ax, seg msg9
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg9
	int 21h
	ret
integer3 ENDP

TestInpCase1 proc FAR

	mov ax, @data
	mov ds, ax

	call integer1

	mov   ax, SEG str_buff
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET str_buff
	push  ax              ; low word of buffer-pointer
	
	mov ax, 3
	push  ax              ; size
	
	mov   ax, SEG num1_data
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET num1_data
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum1
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum1
	push  ax              ; low word of struct point

	
	call InputBigInt@14
	jb print_fail1
	jo print_fail1

	mov   ax, SEG num2_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num2_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 3
	push  ax              ; size
	
	mov   ax, SEG myNum2
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum2
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG myNum1
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum1
	push  ax              ; low word of struct point

	mov   ax, SEG myNum2
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum2
	push  ax              ; low word of struct point

	call CompareBigInt@8
	jz print_pass1
	jnz print_fail1

	print_pass1:
		call pass14
		ret

	print_fail1:
		call fail14
		ret

TestInpCase1 ENDP

TestInpCase2 proc FAR

	mov ax, @data
	mov ds, ax

	call integer2

	mov   ax, SEG str_buff
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET str_buff
	push  ax              ; low word of buffer-pointer
	
	mov ax, 3
	push  ax              ; size
	
	mov   ax, SEG num3_data
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET num3_data
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum3
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum3
	push  ax              ; low word of struct point

	
	call InputBigInt@14
	jb print_fail2
	jo print_fail2

	mov   ax, SEG num4_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num4_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 3
	push  ax              ; size
	
	mov   ax, SEG myNum4
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum4
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG myNum3
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum3
	push  ax              ; low word of struct point

	mov   ax, SEG myNum4
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum4
	push  ax              ; low word of struct point

	call CompareBigInt@8
	jz print_pass2
	jnz print_fail2

	print_pass2:
		call pass24
		ret

	print_fail2:
		call fail24
		ret

TestInpCase2 ENDP

TestInpCase3 proc FAR

	mov ax, @data
	mov ds, ax

	call integer3

	mov   ax, SEG str_buff
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET str_buff
	push  ax              ; low word of buffer-pointer
	
	mov ax, 1
	push  ax              ; size
	
	mov   ax, SEG num5_data
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET num5_data
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum5
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum5
	push  ax              ; low word of struct point

	
	call InputBigInt@14

	jb print_pass3
	jnb print_fail3

	print_pass3:
		call pass34
		ret

	print_fail3:
		call fail34
		ret

TestInpCase3 ENDP

END
