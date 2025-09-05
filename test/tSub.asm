INCLUDELIB ..\build\bin\BigInt.lib
INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

EXTRN SubtractBigInt@12:FAR
EXTRN init_BigInt@10:FAR
EXTRN CompareBigInt@8:FAR


Stk SEGMENT para STACK 'stk'
	DB 400h dup (?)
Stk ENDS

.data
	;
	num1_data db 00h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num2_data db 00h, 01h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num3_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num4_data db 00h, 03h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

	;  BigInt
	myNum1 BigInt <?>
	myNum2 BigInt <?>
	myNum3 BigInt <?>
	myNum4 BigInt <?>

	;
	num5_data db 0FFh, 0F4h, 0E5h, 0F2h, 35h, 0B2h, 0C9h, 61h
	num6_data db 0Dh, 0AAh, 22h, 0D7h, 8Dh, 0EDh, 0FDh, 0FEh
	num7_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num8_data db 0F2h, 4Ah, 0C3h, 1Ah, 0A7h, 0C4h, 0CBh, 63h

	;  BigInt
	myNum5 BigInt <?>
	myNum6 BigInt <?>
	myNum7 BigInt <?>
	myNum8 BigInt <?>

	;
	num9_data db 00h, 01h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num10_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 05h, 6Ah, 48h
	num11_data db 00h

	;  BigInt
	myNum9 BigInt <?>
	myNum10 BigInt <?>
	myNum11 BigInt <?>

	
	;
	msg1 db 'TestSubCase1 passed',13,10,'$',0
	msg2 db 'TestSubCase1 failed',13,10,'$',0
	msg3 db 'TestSubCase2 passed',13,10,'$',0
	msg4 db 'TestSubCase2 failed',13,10,'$',0
	msg5 db 'TestSubCase3 passed',13,10,'$',0
	msg6 db 'TestSubCase3 failed',13,10,'$',0


.CODE
public TestSubCase1, TestSubCase2, TestSubCase3

pass12 proc
	mov ax, seg msg1
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg1
	int 21h
	ret
pass12 ENDP

fail12 proc
	mov ax, seg msg2
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg2
	int 21h
	ret
fail12 ENDP

pass22 proc
	mov ax, seg msg3
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg3
	int 21h
	ret
pass22 ENDP

fail22 proc
	mov ax, seg msg4
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg4
	int 21h
	ret
fail22 ENDP

pass32 proc
	mov ax, seg msg5
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg5
	int 21h
	ret
pass32 ENDP

fail32 proc
	mov ax, seg msg6
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg6
	int 21h
	ret
fail32 ENDP


TestSubCase1 proc far
	mov ax, @data
	mov ds, ax

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

	call SubtractBigInt@12

	cmp ax, 0404h
	jz printfail12

	mov   ax, SEG myNum3
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum3
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum4
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum4
	push  ax              ; low word of struct pointer

	call CompareBigInt@8

	jz printpass12
	jnz printfail12

	printpass12:
		call pass12
		ret

	printfail12:
		call fail12
		ret


TestSubCase1 ENDP

TestSubCase2 proc far
	mov ax, @data
	mov ds, ax

	mov   ax, SEG num5_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num5_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 4
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
	
	mov ax, 4
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
	
	mov ax, 4
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
	
	mov ax, 4
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

	call SubtractBigInt@12

	cmp ax, 0404h
	jz printfail22

	mov   ax, SEG myNum7
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum7
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum8
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum8
	push  ax              ; low word of struct pointer

	call CompareBigInt@8

	jz printpass22
	jnz printfail22

	printpass22:
		call pass22
		ret

	printfail22:
		call fail22
		ret

TestSubCase2 ENDP

TestSubCase3 proc far
	mov ax, @data
	mov ds, ax

	mov   ax, SEG num9_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num9_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 9
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

	call SubtractBigInt@12

	cmp ax, 0404h
	
	jz printpass32
	jnz printfail32

	printpass32:
		call pass32
		ret

	printfail32:
		call fail32
		ret

TestSubCase3 ENDP


END
