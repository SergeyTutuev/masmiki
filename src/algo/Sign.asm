INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

PUBLIC BigIntSign

BI_CODE SEGMENT READONLY PUBLIC 'CODE'

; [bp+6]  - BIOffset1  ; смещение BigInt
; [bp+8]  - BISeg1     ; сегмент BigInt
BigIntSign PROC FAR USES es di ax bx BIOffset1:WORD, BISeg1:WORD


	mov ax, word ptr [bp + 8]
	mov es, ax
	mov di, word ptr [bp + 6]

	mov bx, word ptr es:[di + BigInt.BIptr]
	mov ax, word ptr es:[di + BigInt.BIptr + 2]
	mov di, bx
	mov es, ax

	mov ah, byte ptr es:[di]
	mov bh, 80h
	and ah, bh
	sahf


	ret 4
BigIntSign ENDP


BI_CODE ENDS

END
