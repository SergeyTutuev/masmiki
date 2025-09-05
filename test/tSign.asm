INCLUDELIB ..\build\bin\BigInt.lib
INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

EXTRN BigIntSign@4:FAR
EXTRN init_BigInt@10:FAR


Stk SEGMENT para STACK 'stk'
	DB 400h dup (?)
Stk ENDS

.data
	; Данные чисел
	num1_data db 0AAh, 0AAh
	num2_data db 00, 00

	; Переменные BigInt
	myNum1 BigInt <?>
	myNum2 BigInt <?>
	
	; Сообщения
	msg1 db 'TestSignCase1 passed',13,10,'$',0
	msg2 db 'TestSignCase1 failed',13,10,'$',0
	msg3 db 'TestSignCase2 passed',13,10,'$',0
	msg4 db 'TestSignCase2 failed',13,10,'$',0


.CODE
public TestSignCase1, TestSignCase2

pass1 proc
	mov ax, seg msg1
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg1
	int 21h
	ret
pass1 ENDP

fail1 proc
	mov ax, seg msg2
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg2
	int 21h
	ret
fail1 ENDP

pass2 proc
	mov ax, seg msg3
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg3
	int 21h
	ret
pass2 ENDP

fail2 proc
	mov ax, seg msg4
	mov ds, ax
	mov ah, 09h
	mov dx, offset msg4
	int 21h
	ret
fail2 ENDP

TestSignCase1 proc far
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

	mov   ax, SEG myNum1
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum1
	push  ax              ; low word of struct pointer

	call BigIntSign@4

	js printpass1
	jns printfail1

	printpass1:
		call pass1
		ret

	printfail1:
		call fail1
		ret
  
TestSignCase1 ENDP

TestSignCase2 proc far
	mov   ax, SEG num2_data
	push  ax              ; high word of buffer-pointer
	
	mov   ax, OFFSET num2_data
	push  ax              ; low word of buffer-pointer
	
	mov ax, 1
	push  ax              ; size
	
	mov   ax, SEG myNum2
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum2
	push  ax              ; low word of struct pointer
	
	call  init_BigInt@10

	mov   ax, SEG myNum2
	push  ax              ; high word of struct pointer
	
	mov   ax, OFFSET myNum2
	push  ax              ; low word of struct pointer

	call BigIntSign@4

	js printfail2
	jns printpass2

	printpass2:
		call pass2
		ret

	printfail2:
		call fail2
		ret
  
TestSignCase2 ENDP


END
