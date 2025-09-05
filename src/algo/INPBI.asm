INCLUDE src/Bigint.inc
PUBLIC InputBigInt

.MODEL HUGE, stdcall

EXTRN init_BigInt@10:FAR
EXTRN StringToBigInt@10:FAR


BI_CODE SEGMENT READONLY PUBLIC 'CODE'


; [bp+6]  - BIOffset     ; смещение BigInt
; [bp+8]  - BISeg        ; сегмент BigInt
; [bp+10] - BIBuffOff    ; смещение буфера BigInt
; [bp+12] - BIBuffSeg    ; сегмент буфера BigInt
; [bp+14] - BIBuffSize   ; размер буфера BigInt
; [bp+16] - BuffOff      ; смещение входного буфера
; [bp+18] - BuffSeg      ; сегмент входного буфера
InputBigInt PROC FAR USES ds di ax bx BIOffset:WORD, BISeg:WORD, BIBuffOff:WORD, BIBuffSeg:WORD, BIBuffSize:WORD, BuffOff:WORD, BuffSeg:WORD
	mov ax, word ptr [bp + 12]
	push ax

	mov ax, word ptr [bp + 10]
	push ax

	mov ax, word ptr [bp + 14]
	push ax

	mov ax, word ptr [bp + 8]
	push ax

	mov ax, word ptr [bp + 6]
	push ax

	call init_BigInt@10

	mov ax, word ptr [bp + 18]
	mov ds, ax
	mov di, word ptr [bp + 16]

	mov bx, 0

inp:
	mov AH, 01h
	int 21h
	cmp AL, 0Dh
	je end_inp
	mov byte ptr ds:[di], al
	inc di
	inc bx
	jmp inp

end_inp:
	push bx

	mov ax, word ptr [bp + 18]
	push ax

	mov ax, word ptr [bp + 16]
	push ax

	mov ax, word ptr [bp + 8]
	push ax

	mov ax, word ptr [bp + 6]
	push ax

	call StringToBigInt@10

	ret 14
InputBigInt ENDP


BI_CODE ENDS

END
