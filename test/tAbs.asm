INCLUDELIB ..\build\bin\BigInt.lib
INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

EXTRN AbsBigInt@8:FAR
EXTRN init_BigInt@10:FAR
EXTRN CompareBigInt@8:FAR


Stk SEGMENT para STACK 'stk'
	DB 400h dup (?)
Stk ENDS

.data
	;
	num1_data db 17h, 0AEh, 0A6h, 57h, 0Fh, 29h, 0BBh, 0EAh, 04h, 0F5h, 6Ch, 3Dh
	num2_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num3_data db 17h, 0AEh, 0A6h, 57h, 0Fh, 29h, 0BBh, 0EAh, 04h, 0F5h, 6Ch, 3Dh

	;  BigInt
	myNum1 BigInt <?>
	myNum2 BigInt <?>
	myNum3 BigInt <?>

	;
	num4_data db 0E8h, 51h, 59h, 0A8h, 0F0h, 0D6h, 44h, 15h, 0FBh, 0Ah, 93h, 0C3h
	num5_data db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
	num6_data db 17h, 0AEh, 0A6h, 57h, 0Fh, 29h, 0BBh, 0EAh, 04h, 0F5h, 6Ch, 3Dh

	;  BigInt
	myNum4 BigInt <?>
	myNum5 BigInt <?>
	myNum6 BigInt <?>

	
	;
	msg1 db 'TestAbsCase1 passed',13,10,'$',0
	msg2 db 'TestAbsCase1 failed',13,10,'$',0
	msg3 db 'TestAbsCase2 passed',13,10,'$',0
	msg4 db 'TestAbsCase2 failed',13,10,'$',0


.CODE
public TestAbsCase1, TestAbsCase2

pass13 proc
	mov ax, seg msg1
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg1
	int 21h
	ret
pass13 ENDP

fail13 proc
	mov ax, seg msg2
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg2
	int 21h
	ret
fail13 ENDP

pass23 proc
	mov ax, seg msg3
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg3
	int 21h
	ret
pass23 ENDP

fail23 proc
	mov ax, seg msg4
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg4
	int 21h
	ret
fail23 ENDP


TestAbsCase1 proc far
	mov ax, @data
	mov ds, ax

	mov   ax, SEG num1_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num1_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 6
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
	
	mov ax, 6
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
	
	mov ax, 6
	push  ax              ; size
	
	mov   ax, SEG myNum3
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum3
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

	call AbsBigInt@8

	cmp ax, 0404h
	jz printfail13

	mov   ax, SEG myNum2
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum2
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum3
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum3
	push  ax              ; low word of struct pointer

	call CompareBigInt@8

	jz printpass13
	jnz printfail13

	printpass13:
		call pass13
		ret

	printfail13:
		call fail13
		ret


TestAbsCase1 ENDP

TestAbsCase2 proc far
	mov ax, @data
	mov ds, ax

	mov   ax, SEG num4_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num4_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 6
	push  ax              ; size
	
	mov   ax, SEG myNum4
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum4
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG num5_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num5_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 6
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
	
	mov ax, 6
	push  ax              ; size
	
	mov   ax, SEG myNum6
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum6
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG myNum4
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum4
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum5
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum5
	push  ax              ; low word of struct pointer

	call AbsBigInt@8

	cmp ax, 0404h
	jz printfail23

	mov   ax, SEG myNum5
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum5
	push  ax              ; low word of struct pointer

	mov   ax, SEG myNum6
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum6
	push  ax              ; low word of struct pointer

	call CompareBigInt@8

	jz printpass23
	jnz printfail23

	printpass23:
		call pass23
		ret

	printfail23:
		call fail23
		ret


TestAbsCase2 ENDP

END
