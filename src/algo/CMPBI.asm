INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

BI_CODE SEGMENT PUBLIC 'CODE'


; [bp+22] - FirstOffset
; [bp+24] - FirstSeg
; [bp+26] - SecondOffset
; [bp+28] - SecondSegment
CompareBigInt PROC FAR PUBLIC USES ds es si di bx cx dx, FirstOffset:WORD, FirstSeg:WORD, SecondOffset:WORD, SecondSegment:WORD
	push ax
	mov bp, sp
	mov es, word ptr [bp + 24]
	mov di, word ptr [bp + 22]

	mov cx, es:[di+BigInt.BIsize]
	shl cx, 1

	mov ds, word ptr [bp + 28]
	mov si, word ptr [bp + 26]
	
	mov dx, ds:[si+BigInt.BIsize]
	shl dx, 1

	cmp cx, dx
	jne return_ne

	mov ax, word ptr es:[di + BigInt.BIptr + 2]
	mov bx, word ptr es:[di + BigInt.BIptr]

	mov es, ax
	mov di, bx

	mov ax, word ptr ds:[si + BigInt.BIptr + 2]
	mov bx, word ptr ds:[si + BigInt.BIptr]

	mov ds, ax
	mov si, bx
	;Теперь в ds:si лежит указатель на второй буффер, es:di - на первый

	xor bx, bx
	xor ax, ax
	xor dx, dx
	mov al, byte ptr es:[di]
	mov dl, byte ptr ds:[si]

	and ax, 80h ;Старшие биты
	and dx, 80h

	cmp ax, dx
	je compare_loop
	cmp dx, 0080h
	je diff_sign_l

	cmp ax, 1000h
	jmp return

diff_sign_l:
	cmp dx, 0000h
	jmp return

compare_loop:
	mov al, byte ptr es:[di + bx]
	mov dl, byte ptr ds:[si + bx]

	cmp al, dl
	jne return

	inc bx
	cmp bx, cx
	jb compare_loop

return:
	pop ax
	ret 8

return_ne:
	pop ax
	mov ax, 0404h
	ret 8
CompareBigInt ENDP

BI_CODE ENDS

END
