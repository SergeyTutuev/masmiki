INCLUDE src/BigInt.inc
PUBLIC SubtractBigInt

.MODEL HUGE, stdcall

EXTRN AddBigInt@12:FAR
EXTRN NegBigInt@4:FAR
EXTRN CompareSizeBigInt@8:FAR


BI_CODE SEGMENT READONLY PUBLIC 'CODE'
SubtractBigInt PROC FAR USES bx BIOffset1:WORD, BISeg1:WORD, BIOffset2:WORD, BISeg2:WORD, BIOffset3:WORD, BISeg3:WORD

	push ax

	mov ax, word ptr [bp + 16]
	push ax

	mov ax, word ptr [bp + 14]
	push ax

	mov ax, word ptr [bp + 12]
	push ax

	mov ax, word ptr [bp + 10]
	push ax

	mov ax, 0000h

	call CompareSizeBigInt@8

	cmp ax, 0404h
	jz return

	mov ax, word ptr [bp + 16]
	push ax

	mov ax, word ptr [bp + 14]
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

	call NegBigInt@4

	mov ax, word ptr [bp + 16]
	push ax

	mov ax, word ptr [bp + 14]
	push ax

	mov ax, word ptr [bp + 12]
	push ax

	mov ax, word ptr [bp + 10]
	push ax

	mov ax, word ptr [bp + 8]
	push ax

	mov ax, word ptr [bp + 6]
	push ax

	call AddBigInt@12

	mov ax, word ptr [bp + 12]
	push ax

	mov ax, word ptr [bp + 10]
	push ax

	call NegBigInt@4

	mov ax, 0000h

	return:
		pushf
		pop bx
		cmp ax, 0404h
		pop ax
		jnz next
		mov ax, 0404h
		next: push bx
		popf
		ret 12


SubtractBigInt ENDP
BI_CODE ENDS

END
