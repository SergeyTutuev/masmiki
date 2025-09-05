INCLUDE BigInt.inc

.MODEL HUGE, stdcall

PUBLIC init_BigInt
BI_CODE SEGMENT READONLY PUBLIC 'CODE'
init_BigInt PROC FAR USES es di ax BIOffset:WORD, BISeg:WORD, SizeBI:WORD, BufOffset:WORD, BufSeg:WORD
	; Memory layout:
	; [bp+6] = offset myBigInt
	; [bp+8] = segment myBigInt
	; [bp+10]= size
	; [bp+12]= offset buf
	; [bp+14]= segment buf

	mov   ax, word ptr [bp+8]   ; load segment of myBigInt
	mov   es, ax                ; ES = target struct‐segment
	mov   di, word ptr [bp+6]   ; DI = offset of myBigInt

	mov   ax, word ptr [bp+10]   ; AX = size
	mov   es:[di+BigInt.BIsize], ax

	mov   ax, word ptr [bp+12]  ; AX = low word of buf ptr (offset)
	mov   word ptr es:[di+BigInt.BIptr], ax

	mov   ax, word ptr [bp+14]  ; AX = high word of buf ptr
	mov   word ptr es:[di+BigInt.BIptr+2], ax

	ret 10
init_BigInt ENDP
BI_CODE ENDS

END

