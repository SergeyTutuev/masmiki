INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall

EXTRN CompareSizeBigInt@8:FAR
EXTRN CompareBigInt@8:FAR
EXTRN BigIntSign@4: FAR
EXTRN NegBigInt@4: FAR
EXTRN AddBigInt@12: FAR
EXTRN SubtractBigInt@12: FAR
EXTRN AbsBigInt@8: FAR
EXTRN init_BigInt@10: FAR

PUBLIC ModBigInt
BI_CODE SEGMENT READONLY PUBLIC 'CODE'


; [bp+6]  - BIOffset1  ; смещение первого числа (делимое)
; [bp+8]  - BISeg1     ; сегмент первого числа
; [bp+10] - BIOffset2  ; смещение второго числа (делитель)
; [bp+12] - BISeg2     ; сегмент второго числа
; [bp+14] - BIOffset3  ; смещение результата (остатка)
; [bp+16] - BISeg3     ; сегмент результата
ModBigInt proc FAR USES ds es si di bx cx dx, BIOffset1:WORD, BISeg1:WORD, BIOffset2:WORD, BISeg2:WORD, BIOffset3:WORD, BISeg3:WORD
		push ax

		mov ax, word ptr [bp + 12]    ; второе число
		mov es, ax
		mov di, word ptr [bp + 10]
		mov cx, word ptr es:[di + BigInt.BIsize]    ; в cx размер

		mov dx, cx
		shl dx, 1
	
		xor bx, bx

	mass_loop:
		push bx
		loop mass_loop

		mov cx, sp
		mov ax, ss
		shr dx, 1
	
		; В dx - размер в вордах
		; В ax:cx - указатель на current
		push ax

		mov bx, ax
		push bx
		push cx
		push dx

		mov ax, SEG temp
		push ax
		mov ax, OFFSET temp
		push ax
		call init_BigInt@10
		
		mov bx, word ptr es:[di + BigInt.BIptr]
		mov ax, word ptr es:[di + BigInt.BIptr + 2]
		mov es, ax
		mov di, bx

		mov ax, word ptr [bp + 16]
		mov ds, ax
		mov si, word ptr [bp + 14]

		mov bx, word ptr ds:[si + BigInt.BIptr]
		mov ax, word ptr ds:[si + BigInt.BIptr + 2]
		mov ds, ax
		mov si, bx

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
		jz return1

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
		jz return1

		xor bx, bx
	is_num2_zero:
		shl bx, 1
		mov ax, word ptr es:[di+bx]
		shr bx, 1
		test ax, ax
		jnz is_not_num2_zero
		inc bx
		cmp bx, dx
		jb is_num2_zero

		int 0h
		;pop ax
		;jmp return  ;НУЖЕН ВОЗВРАТ ДЛЯ ОШИБКИ!!!!!!!

	is_not_num2_zero:
		mov ax, word ptr [bp + 16]    ; первое число, берём знак
		push ax
		mov ax, word ptr [bp + 14]
		push ax
		call BigIntSign@4
		pushf
		pop ax

		push ds
		mov bx, seg sg1
		mov ds, bx
		mov bx, offset sg1
		mov word ptr ds:[bx], ax
		pop ds

		mov ax, word ptr [bp + 12]    ; второе число, берём знак
		push ax
		mov ax, word ptr [bp + 10]
		push ax
		call BigIntSign@4
		pushf
		pop ax
	  
		push ds
		mov bx, seg sg2
		mov ds, bx
		mov bx, offset sg2
		mov word ptr ds:[bx], ax
		pop ds
	  
		mov ax, word ptr [bp + 16]
		push ax
		mov ax, word ptr [bp + 14]
		push ax
		mov ax, word ptr [bp + 16]
		push ax
		mov ax, word ptr [bp + 14]
		push ax
		call AbsBigInt@8
	
		mov ax, word ptr [bp + 12]
		push ax
		mov ax, word ptr [bp + 10]
		push ax
		mov ax, word ptr [bp + 12]
		push ax
		mov ax, word ptr [bp + 10]
		push ax
		call AbsBigInt@8
	
		pop ax
		xor bx, bx
		shl dx, 1
	div_loop:
		push dx
	   
		;shl bx, 1
		mov dl, byte ptr ds:[si+bx]
		;shr bx, 1

		push ds
		push bx
		push ax

		mov ax, seg worder
		mov ds, ax
		mov bx, offset worder
		mov byte ptr ds:[bx], dl

		pop ax
		pop bx
		pop ds
	   
		pop dx
	   
		push bx

		xor bx, bx
		push es
		push di

		dec dx
		jz skip_shift2
		mov es, ax
		mov di, cx
	shift_left_16b:
		push dx
		;shl bx, 1
		mov dl, byte ptr es:[di+bx+1]
		mov byte ptr es:[di+bx], dl
		;shr bx, 1
		pop dx
		inc bx
		cmp bx, dx
		jl shift_left_16b

	skip_shift2:
		inc dx
		pop di
		pop es
		pop bx

		push dx
		push bx
		mov bx, dx
		mov dl, worder
	 
		push es
		push di
		mov es, ax
		mov di, cx
		;shl bx, 1
		mov byte ptr es:[di+bx-1], dl

		pop di
		pop es
		pop bx
		pop dx

		push ax
		push dx
	   
		xor dx, dx
	counting:
		mov ax, seg temp
		push ax
		mov ax, offset temp
		push ax
		mov ax, word ptr [bp + 12]    ; второе число
		push ax
		mov ax, word ptr [bp + 10]
		push ax
		mov ax, seg temp
		push ax
		mov ax, offset temp
		push ax
		call SubtractBigInt@12
				
		mov ax, seg temp
		push ax
		mov ax, offset temp
		push ax
		call BigIntSign@4
		js without_sub

		inc dx
		jmp counting

	without_sub:
		mov ax, seg temp
		push ax
		mov ax, offset temp
		push ax
		mov ax, word ptr [bp + 12]    ; второе число
		push ax
		mov ax, word ptr [bp + 10]
		push ax
		mov ax, seg temp
		push ax
		mov ax, offset temp
		push ax
		call AddBigInt@12

		mov ax, dx
		pop dx

		push es
		push di
		push bx
		push ax

		mov ax, word ptr [bp + 8]
		mov es, ax
		mov di, word ptr [bp + 6]

		mov bx, word ptr es:[di + BigInt.BIptr]
		mov ax, word ptr es:[di + BigInt.BIptr + 2]
		mov es, ax
		mov di, bx
		  
		pop ax
		pop bx
		
		push bx
		xor bx, bx
		dec dx
		jz skip_shift
	shift_left_16b1:
		push dx
		;shl bx,1
		mov dl, byte ptr es:[di+bx+1]
		mov byte ptr es:[di+bx], dl
		;shr bx,1
		pop dx
		inc bx
		cmp bx, dx
		jl shift_left_16b1

	skip_shift:
		xchg bx, dx
		;shl bx,1
		;xchg ah, al
		mov byte ptr es:[di+bx], al
		;xchg ah, al
		;shr bx, 1
		xchg bx, dx
		inc dx
		pop bx
		pop di
		pop es

		pop ax
		inc bx
		cmp bx, dx
		jl div_loop
	  
		push bx
		push ax

		mov ax, word ptr [bp + 8]
		mov es, ax
		mov di, word ptr [bp + 6]

		mov bx, word ptr es:[di + BigInt.BIptr]
		mov ax, word ptr es:[di + BigInt.BIptr + 2]
		mov es, ax
		mov di, bx
		  
		pop ax
		pop bx

		mov ds, ax
		mov si, cx

		push bx
		xor bx, bx

	copy_res_from_current:    ; копируем из current остаток в result
		push dx
		mov dl, byte ptr ds:[si+bx]
		mov byte ptr es:[di+bx], dl
		pop dx
		inc bx
		cmp bx, dx
		jl copy_res_from_current

		pop bx

		push dx
		mov bx, seg sg1
		mov ds, bx
		mov bx, offset sg1
		mov dx, word ptr ds:[bx]
		cmp dl, 0
		jz skip_neg_1

		mov ax, word ptr [bp + 16]    ; первое число, меняем знак на -
		push ax
		mov ax, word ptr [bp + 14]
		push ax
		call NegBigInt@4
	  
	skip_neg_1:
		mov bx, seg sg2
		mov ds, bx
		mov bx, offset sg2
		mov cx, word ptr ds:[bx]
		cmp cl, 0
		jz skip_neg_2

		mov ax, word ptr [bp + 12]    ; второе число, меняем знак на -
		push ax
		mov ax, word ptr [bp + 10]
		push ax
		call NegBigInt@4

	skip_neg_2:
		cmp dx, cx
		je return
		mov ax, word ptr [bp + 8]    ; result, меняем знак на -
		push ax
		mov ax, word ptr [bp + 6]
		push ax
		call NegBigInt@4

	return:
		pop dx
		pop ax
		;shl dx, 1
		add sp, dx
		ret 12

	return1:
		pop ax
		pop ax
		mov ax, 0404h
		shl dx, 1
		add sp, dx
		ret 12

	sg1 dw 0
	sg2 dw 0
	worder db ?
	temp BigInt <?>

ModBigInt ENDP

BI_CODE ENDS
END
