INCLUDELIB ..\build\bin\BigInt.lib
INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

EXTRN PowBigInt@12:FAR
EXTRN init_BigInt@10:FAR
EXTRN CompareBigInt@8:FAR

Stk SEGMENT para STACK 'stk'
	DB 400h dup (?)
Stk ENDS

.data
	;
	num1_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0FFh, 0FFh, 0FFh, 0E0h, 0CDh, 0FFh, 4Ch, 0DAh
	num2_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 02h
	num3_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num4_data db 00h, 00h, 0FFh, 0FFh, 0FFh, 0C1h, 9Bh, 0FEh, 9Dh, 81h, 25h, 0EFh, 0A9h, 2Fh, 55h, 5Eh, 29h, 0A4h

	;  BigInt
	myNum1 BigInt <?>
	myNum2 BigInt <?>
	myNum3 BigInt <?>
	myNum4 BigInt <?>

	;
	num5_data db 00h, 22h
	num6_data db 00h, 00h, 00h, 19h
	num7_data db 00h, 00h

	;  BigInt
	myNum5 BigInt <?>
	myNum6 BigInt <?>
	myNum7 BigInt <?>

	;
	num8_data db 80h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num9_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num10_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num11_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 01h

	;  BigInt
	myNum8 BigInt <?>
	myNum9 BigInt <?>
	myNum10 BigInt <?>
	myNum11 BigInt <?>

	;
	num12_data db 40h, 98h, 0FCh, 15h, 0A3h, 0Dh, 2Dh, 0Ah
	num13_data db 00h, 00h, 00h, 00h, 00h, 00h, 02h, 2Ch
	num14_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num15_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

	;  BigInt
	myNum12 BigInt <?>
	myNum13 BigInt <?>
	myNum14 BigInt <?>
	myNum15 BigInt <?>


	;
	msg1 db 'TestPowCase1 passed',13,10,'$',0
	msg2 db 'TestPowCase1 failed',13,10,'$',0
	msg3 db 'TestPowCase2 passed',13,10,'$',0
	msg4 db 'TestPowCase2 failed',13,10,'$',0
	msg5 db 'TestPowCase3 passed',13,10,'$',0
	msg6 db 'TestPowCase3 failed',13,10,'$',0
	msg7 db 'TestPowCase4 passed',13,10,'$',0
	msg8 db 'TestPowCase4 failed',13,10,'$',0


.CODE
public TestPowCase1, TestPowCase2, TestPowCase3, TestPowCase4


pass15 proc
	mov ax, seg msg1
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg1
	int 21h
	ret
pass15 ENDP

fail15 proc
	mov ax, seg msg2
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg2
	int 21h
	ret
fail15 ENDP

pass25 proc
	mov ax, seg msg3
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg3
	int 21h
	ret
pass25 ENDP

fail25 proc
	mov ax, seg msg4
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg4
	int 21h
	ret
fail25 ENDP

pass35 proc
	mov ax, seg msg5
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg5
	int 21h
	ret
pass35 ENDP

fail35 proc
	mov ax, seg msg6
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg6
	int 21h
	ret
fail35 ENDP

pass45 proc
	mov ax, seg msg7
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg7
	int 21h
	ret
pass45 ENDP

fail45 proc
	mov ax, seg msg8
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg8
	int 21h
	ret
fail45 ENDP

TestPowCase1 proc far
	mov ax, @data
	mov ds, ax

	mov   ax, SEG num1_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num1_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 9
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
	
	mov ax, 9
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
	
	mov ax, 9
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
	
	mov ax, 9
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

	call PowBigInt@12

	mov   ax, SEG myNum3
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum3
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum4
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum4
	push  ax              ; low word of struct pointer

	call CompareBigInt@8

	jz printpass15
	jnz printfail15

	printpass15:
		call pass15
		ret

	printfail15:
		call fail15
		ret

TestPowCase1 ENDP

TestPowCase2 proc far
	mov ax, @data
	mov ds, ax

	mov   ax, SEG num5_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num5_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 1
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
	
	mov ax, 2
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
	
	mov ax, 1
	push  ax              ; size
	
	mov   ax, SEG myNum7
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum7
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

	call PowBigInt@12

	cmp ax, 0404h

	jz printpass25
	jnz printfail25

	printpass25:
		call pass25
		ret

	printfail25:
		call fail25
		ret

TestPowCase2 ENDP

TestPowCase3 proc far
	mov ax, @data
	mov ds, ax

	mov   ax, SEG num8_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num8_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 6
	push  ax              ; size
	
	mov   ax, SEG myNum8
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum8
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num9_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num9_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 6
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
	
	mov ax, 6
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
	
	mov ax, 6
	push  ax              ; size
	
	mov   ax, SEG myNum11
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum11
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG myNum8
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum8
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum9
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum9
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum10
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum10
	push  ax              ; low word of struct pointer

	call PowBigInt@12

	mov   ax, SEG myNum10
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum10
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum11
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum11
	push  ax              ; low word of struct pointer

	call CompareBigInt@8

	jz printpass35
	jnz printfail35

	printpass35:
		call pass35
		ret

	printfail35:
		call fail35
		ret

TestPowCase3 ENDP

TestPowCase4 proc far
	mov ax, @data
	mov ds, ax

	mov   ax, SEG num12_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num12_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 4
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
	
	mov ax, 4
	push  ax              ; size
	
	mov   ax, SEG myNum14
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum14
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num15_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num15_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 4
	push  ax              ; size
	
	mov   ax, SEG myNum15
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum15
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

	call PowBigInt@12

	mov   ax, SEG myNum14
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum14
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum15
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum15
	push  ax              ; low word of struct pointer

	call CompareBigInt@8


	jz printpass45
	jnz printfail45

	printpass45:
		call pass45
		ret

	printfail45:
		call fail45
		ret

TestPowCase4 ENDP

END
