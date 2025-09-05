INCLUDE src/BigInt.inc
PUBLIC AbsBigInt

.MODEL HUGE, stdcall

EXTRN BigIntSign@4:FAR
EXTRN NegBigInt@4:FAR
EXTRN CompareSizeBigInt@8:FAR


BI_CODE SEGMENT READONLY PUBLIC 'CODE'
AbsBigInt PROC FAR USES es ds di si bx cx dx BIOffset1:WORD, BISeg1:WORD, BIOffset2:WORD, BISeg2:WORD

	push ax

	mov ax, word ptr [bp + 12]
	push ax

	mov ax, word ptr [bp + 10]
	push ax

	mov ax, word ptr [bp + 8]
	push ax

	mov ax, word ptr [bp + 6]
	push ax

	mov ax, 0000h

	call CompareSizeBigInt@8

	cmp ax, 0404h
	jz return

	mov ax, word ptr [bp + 12]
	push ax

	mov ax, word ptr [bp + 10]
	push ax

	call BigIntSign@4

	pushf
	pop dx

	jns finish

	mov ax, word ptr [bp + 12]
	push ax

	mov ax, word ptr [bp + 10]
	push ax

	call NegBigInt@4

	finish:
		mov ax, word ptr [bp + 12]
		mov es, ax
		mov di, word ptr [bp + 10]

		mov ax, word ptr [bp + 8]
		mov ds, ax
		mov si, word ptr [bp + 6]

		mov ax, word ptr es:[di + BigInt.BIsize]
		mov cx, 2
		mul cx
		mov cx, ax

		loop_copy:
			mov bx, word ptr es:[di + BigInt.BIptr]
			mov ax, word ptr es:[di + BigInt.BIptr + 2]
			push es
			push di
			mov es, ax
			mov di, bx
			mov bx, cx
			sub bx, 2
			mov ax, word ptr es:[bx + di]
			pop di
			pop es

			push di
			mov bx, word ptr ds:[si + BigInt.BIptr]
			mov di, word ptr ds:[si + BigInt.BIptr + 2]
			push ds
			push si
			mov ds, di
			mov si, bx
			mov bx, cx
			sub bx, 2
			mov word ptr ds:[bx + si], ax
			pop si
			pop ds
			pop di
			dec cx
			loop loop_copy

		
	mov ax, 0000h

	return:
		cmp ax, 0404h
		pop ax
		jnz next
		mov ax, 0404h
		next: push dx
		popf
		ret 8

AbsBigInt ENDP
BI_CODE ENDS

END
