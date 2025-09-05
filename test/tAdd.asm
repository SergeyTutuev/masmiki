INCLUDELIB ..\build\bin\BigInt.lib
INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

EXTRN AddBigInt@12:FAR
EXTRN init_BigInt@10:FAR
EXTRN CompareBigInt@8:FAR


Stk SEGMENT para STACK 'stk'
	DB 400h dup (?)
Stk ENDS

.data
	; Данные чисел
	num1_data db 00h, 06h, 66h, 66h, 66h, 66h, 99h, 99h, 0DCh, 45h
	num2_data db 00h, 02h, 00h, 00h, 00h, 00h, 00h, 00h, 20h, 01h
	num3_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num4_data db 00h, 08h, 66h, 66h, 66h, 66h, 99h, 99h, 0FCh, 46h

	; Переменные BigInt
	myNum1 BigInt <?>
	myNum2 BigInt <?>
	myNum3 BigInt <?>
	myNum4 BigInt <?>

	; Данные чисел
	num5_data db 00h, 68h, 0C1h, 1Ch, 5Eh, 02h, 94h, 52h, 0FEh, 11h
	num6_data db 00h, 00h, 00h, 00h, 01h, 0C3h, 92h, 4Dh, 80h, 0E3h
	num7_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num8_data db 00h, 68h, 0C1h, 1Ch, 5Fh, 0C6h, 26h, 0A0h, 7Eh, 0F4h

	; Переменные BigInt
	myNum5 BigInt <?>
	myNum6 BigInt <?>
	myNum7 BigInt <?>
	myNum8 BigInt <?>

	; Данные чисел
	num9_data db 00h, 68h, 0C1h, 1Ch, 5Eh, 02h, 94h, 52h, 0FEh, 11h
	num10_data db 00h, 00h, 00h, 00h, 01h, 0C3h, 92h, 4Dh, 80h, 0E3h
	num11_data db 00h

	; Переменные BigInt
	myNum9 BigInt <?>
	myNum10 BigInt <?>
	myNum11 BigInt <?>

	; Данные чисел
	num12_data db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
	num13_data db 00h, 00h, 00h, 00h, 00h, 00h, 68h, 65h
	num14_data db 00h

	; Переменные BigInt
	myNum12 BigInt <?>
	myNum13 BigInt <?>
	myNum14 BigInt <?>
	
	; Сообщения
	msg1 db 'TestSumCase1 passed',13,10,'$',0
	msg2 db 'TestSumCase1 failed',13,10,'$',0
	msg3 db 'TestSumCase2 passed',13,10,'$',0
	msg4 db 'TestSumCase2 failed',13,10,'$',0
	msg5 db 'TestSumCase3 passed',13,10,'$',0
	msg6 db 'TestSumCase3 failed',13,10,'$',0
	msg7 db 'TestSumCase4 passed',13,10,'$',0
	msg8 db 'TestSumCase4 failed',13,10,'$',0


.CODE
public TestSumCase1, TestSumCase2, TestSumCase3, TestSumCase4

pass11 proc
	mov ax, seg msg1
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg1
	int 21h
	ret
pass11 ENDP

fail11 proc
	mov ax, seg msg2
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg2
	int 21h
	ret
fail11 ENDP

pass21 proc
	mov ax, seg msg3
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg3
	int 21h
	ret
pass21 ENDP

fail21 proc
	mov ax, seg msg4
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg4
	int 21h
	ret
fail21 ENDP

pass3 proc
	mov ax, seg msg5
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg5
	int 21h
	ret
pass3 ENDP

fail3 proc
	mov ax, seg msg6
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg6
	int 21h
	ret
fail3 ENDP

pass4 proc
	mov ax, seg msg7
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg7
	int 21h
	ret
pass4 ENDP

fail4 proc
	mov ax, seg msg8
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg8
	int 21h
	ret
fail4 ENDP

TestSumCase1 proc far
	mov   ax, SEG num1_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num1_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 5
	push  ax              ; size
	
	mov   ax, SEG myNum1
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum1
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num2_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num2_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 5
	push  ax              ; size
	
	mov   ax, SEG myNum2
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum2
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num3_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num3_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 5
	push  ax              ; size
	
	mov   ax, SEG myNum3
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum3
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num4_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num4_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 5
	push  ax              ; size
	
	mov   ax, SEG myNum4
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum4
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG myNum1
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum1
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum2
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum2
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum3
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum3
	push  ax              ; low word of struct pointer

	call AddBigInt@12

	cmp ax, 0404h
	jz printfail11

	mov   ax, SEG myNum3
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum3
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum4
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum4
	push  ax              ; low word of struct pointer

	call CompareBigInt@8

	jz printpass11
	jnz printfail11

	printpass11:
		call pass11
		ret

	printfail11:
		call fail11
		ret


TestSumCase1 ENDP

TestSumCase2 proc far
	mov   ax, SEG num5_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num5_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 5
	push  ax              ; size
	
	mov   ax, SEG myNum5
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum5
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num6_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num6_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 5
	push  ax              ; size
	
	mov   ax, SEG myNum6
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum6
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num7_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num7_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 5
	push  ax              ; size
	
	mov   ax, SEG myNum7
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum7
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num4_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num8_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 5
	push  ax              ; size
	
	mov   ax, SEG myNum8
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum8
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG myNum5
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum5
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum6
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum6
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum7
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum7
	push  ax              ; low word of struct pointer

	call AddBigInt@12

	cmp ax, 0404h
	jz printfail21

	mov   ax, SEG myNum7
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum7
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum8
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum8
	push  ax              ; low word of struct pointer

	call CompareBigInt@8

	jz printpass21
	jnz printfail21

	printpass21:
		call pass21
		ret

	printfail21:
		call fail21
		ret

TestSumCase2 ENDP

TestSumCase3 proc far
	mov   ax, SEG num9_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num9_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 5
	push  ax              ; size
	
	mov   ax, SEG myNum9
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum9
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num10_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num10_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 5
	push  ax              ; size
	
	mov   ax, SEG myNum10
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum10
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num11_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num11_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 1
	push  ax              ; size
	
	mov   ax, SEG myNum11
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum11
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10


	mov   ax, SEG myNum9
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum9
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum10
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum10
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum11
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum11
	push  ax              ; low word of struct pointer

	call AddBigInt@12

	cmp ax, 0404h
	
	jz printpass3
	jnz printfail3

	printpass3:
		call pass3
		ret

	printfail3:
		call fail3
		ret

TestSumCase3 ENDP

TestSumCase4 proc far
	mov   ax, SEG num12_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num12_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 8
	push  ax              ; size
	
	mov   ax, SEG myNum12
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum12
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num13_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num13_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 4
	push  ax              ; size
	
	mov   ax, SEG myNum13
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum13
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num14_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num14_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 1
	push  ax              ; size
	
	mov   ax, SEG myNum14
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum14
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10


	mov   ax, SEG myNum12
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum12
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum13
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum13
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum14
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum14
	push  ax              ; low word of struct pointer

	call AddBigInt@12

	cmp ax, 0404h
	
	jz printpass4
	jnz printfail4

	printpass4:
		call pass4
		ret

	printfail4:
		call fail4
		ret

TestSumCase4 ENDP


END
