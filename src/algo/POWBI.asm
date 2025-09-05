INCLUDE src/BigInt.inc

PUBLIC PowBigInt

.MODEL HUGE, stdcall

EXTRN SubtractBigInt@12:FAR
EXTRN ShrBigInt@10:FAR
EXTRN MultiplyBigInt@12:FAR
EXTRN CompareSizeBigInt@8:FAR


BI_CODE SEGMENT READONLY PUBLIC 'CODE'

;   [bp+6]  - offset результата
;   [bp+8]  - segment результата
;   [bp+10] - offset основания
;   [bp+12] - segment основания
;   [bp+14] - offset степени
;   [bp+16] - segment степени
PowBigInt PROC FAR USES ds es di si bx cx dx, BIOffset1:WORD, BISeg1:WORD, BIOffset2:WORD, BISeg2:WORD, BIOffset3:WORD, BISeg3:WORD
	push ax


	; Проверка степени на ноль
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


	; Проверка основания на ноль
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


	; Подготовка данных
	mov ax, word ptr [bp + 12]
	mov ds, ax
	mov di, word ptr [bp + 10]

	mov ax, word ptr ds:[di + BigInt.BIsize]
	mov bx, 2
	mul bx
	mov cx, ax

	mov si, word ptr ds:[di + BigInt.BIptr]
	mov ax, word ptr ds:[di + BigInt.BIptr + 2]
	mov es, ax

	mov dx, word ptr 0FFFFh


	; Сохранение исходного числа
	loop_save:
		mov bx, cx
		sub bx, 2
		mov ax, word ptr es:[bx + si]
		cmp ax, 0
		pushf
		pop bx
		and dx, bx
		and dx, word ptr 0040h
		push ax
		dec cx
		loop loop_save


	mov ax, word ptr ds:[di + BigInt.BIsize]
	mov cx, 2
	mul cx
	mov bx, ax

	cmp dx, 0040h
	jz finish


	; Подготовка буфера
	mov ax, ss
	push ss
	mov ax, sp
	sub ax, 8
	push ax
	mov ax, ss
	push ax
	mov ax, sp
	sub ax, 4
	sub ax, bx
	push ax
	mov ax, word ptr ds:[di + BigInt.BIsize]
	push ax
	mov cx, word ptr ds:[di + BigInt.BIsize]
	mov ax, 0100h
	push ax

	dec cx

	loop_buff:
		cmp cx, 0
		jz moveon
		xor dx, dx
		push dx
		loop loop_buff


	; Основной цикл возведения в степень
	moveon:
		mov ax, sp
		mov ds, ax
		mov di, bp

	loop_bin:
		sub bx, 2
		mov ah, byte ptr es:[bx + si]
		mov al, byte ptr es:[bx + si + 1]
		add bx, 2
		xor dx, dx
		push di
		mov di, 2
		div di
		pop di
		cmp dx, 0
		jz do_shr
		jnz do_sub

	do_shr:
		mov ax, word ptr [bp + 8]
		push ax
		mov ax, word ptr [bp + 6]
		push ax
		mov ax, 1
		push ax
		mov ax, word ptr [bp + 12]
		push ax
		mov ax, word ptr [bp + 10]
		push ax
		cld
		call ShrBigInt@10
		mov ax, 2
		push ax
		pushf
		jmp next

	do_sub:
		mov ax, word ptr [bp + 12]
		push ax
		mov ax, word ptr [bp + 10]
		push ax
		mov bp, ds
		add bp, bx
		add bp, 8
		mov ax, word ptr [bp]
		push ax
		sub bp, 2
		mov ax, word ptr [bp]
		push ax
		mov bp, di
		mov ax, word ptr [bp + 8]
		push ax
		mov ax, word ptr [bp + 6]
		push ax
		call SubtractBigInt@12
		mov ax, 1
		push ax
		pushf
		jmp next

	next:
		push ds
		push cx
		push bx
		push es
		push si
		push di
		mov cx, bx
	loop_copy:
		mov ax, word ptr [bp + 8]
		mov es, ax
		mov si, word ptr [bp + 6]
		mov di, word ptr es:[si + BigInt.BIptr]
		mov ax, word ptr es:[si + BigInt.BIptr + 2]
		mov ds, ax
		mov bx, cx
		sub bx, 2
		mov ax, word ptr ds:[bx + di]

		mov bx, word ptr [bp + 12]
		mov es, bx
		mov si, word ptr [bp + 10]
		mov di, word ptr es:[si + BigInt.BIptr]
		mov bx, word ptr es:[si + BigInt.BIptr + 2]
		mov ds, bx
		mov bx, cx
		sub bx, 2
		mov word ptr ds:[bx + di], ax
		dec cx
		loop loop_copy

		pop di
		pop si
		pop es
		pop bx
		pop cx
		pop ds
		pop ax
		push ax
		inc cx
		popf
		jnz loop_bin


	finish:
		mov ax, word ptr [bp + 8]
		mov es, ax
		mov si, word ptr [bp + 6]
		mov di, word ptr es:[si + BigInt.BIptr]
		mov ax, word ptr es:[si + BigInt.BIptr + 2]
		mov ds, ax
		mov ax, 1
		sub bx, 2
		mov byte ptr ds:[bx + di], ah
		mov byte ptr ds:[bx + di + 1], al
		add bx, 2

		push cx
		push bx
		mov cx, bx
		sub cx, 2
	loop_zero:
		cmp cx, 0
		jz moveon2
		mov bx, cx
		sub bx, 2
		xor ax, ax
		mov word ptr ds:[bx + di], ax
		dec cx
		loop loop_zero

	moveon2:
		pop bx
		pop cx
		mov ax, 1

		cmp dx, 0040h
		jz finish2


	; Финальные вычисления
	loop_count:
		pop ax
		cmp ax, 1
		jz do_mul
		jnz do_quad

	do_mul:
		mov ax, word ptr [bp + 12]
		push ax
		mov ax, word ptr [bp + 10]
		push ax
		mov ax, word ptr [bp + 8]
		push ax
		mov ax, word ptr [bp + 6]
		push ax
		mov ax, word ptr [bp + 16]
		push ax
		mov ax, word ptr [bp + 14]
		push ax
		call MultiplyBigInt@12
		jmp next2

	do_quad:
		mov ax, word ptr [bp + 12]
		push ax
		mov ax, word ptr [bp + 10]
		push ax
		mov ax, word ptr [bp + 8]
		push ax
		mov ax, word ptr [bp + 6]
		push ax
		mov ax, word ptr [bp + 8]
		push ax
		mov ax, word ptr [bp + 6]
		push ax
		call MultiplyBigInt@12
		jmp next2

	next2:
		pushf
		push cx
		push bx
		mov cx, bx
	loop_copy2:
		mov ax, word ptr [bp + 12]
		mov es, ax
		mov si, word ptr [bp + 10]
		mov di, word ptr es:[si + BigInt.BIptr]
		mov ax, word ptr es:[si + BigInt.BIptr + 2]
		mov ds, ax
		mov bx, cx
		sub bx, 2
		mov ax, word ptr ds:[bx + di]

		mov bx, word ptr [bp + 8]
		mov es, bx
		mov si, word ptr [bp + 6]
		mov di, word ptr es:[si + BigInt.BIptr]
		mov bx, word ptr es:[si + BigInt.BIptr + 2]
		mov ds, bx
		mov bx, cx
		sub bx, 2
		mov word ptr ds:[bx + di], ax
		dec cx
		loop loop_copy2

		pop bx
		pop cx
		pop ax
		and dx, word ptr 0800h
		or dx, ax
		dec cx
		cmp cx, 0
		jnz loop_count

	mov ax, 0

	finish2:
		cmp ax, 0
		jz set_flags
		jnz skip_further

	set_flags:
		push dx
		popf
		jmp next3

	skip_further:
		cmp dx, 0
		jmp next3

	next3:
		mov ax, word ptr [bp + 12]
		mov es, ax
		mov si, word ptr [bp + 10]
		mov di, word ptr es:[si + BigInt.BIptr]
		mov ax, word ptr es:[si + BigInt.BIptr + 2]
		mov ds, ax
		mov cx, bx
		mov dx, bx
		add sp, bx
		add sp, 10
	loop_ret:
		pop ax
		pushf
		mov bx, dx
		sub bx, cx
		mov word ptr ds:[bx + di], ax
		pop ax
		push ax
		dec cx
		popf
		loop loop_ret


	return:
		pushf
		pop bx
		cmp ax, 0404h
		pop ax
		jnz next4
		mov ax, 0404h

	next4:
		push bx
		popf
		ret 12

PowBigInt ENDP

BI_CODE ENDS

END
