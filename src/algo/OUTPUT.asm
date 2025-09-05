INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall
.stack 200h

EXTRN init_BigInt@10:FAR
EXTRN NegBigInt@4:FAR

OUT_CODE SEGMENT READONLY PUBLIC 'CODE'
public OutputBigInt


; [bp+6] = offset BigInt
; [bp+8] = segment BigInt
; [bp+10] = offset str_out
; [bp+12] = segment str_out
OutputBigInt PROC FAR USES es ds si di ax bx cx dx BIOffset:WORD, BISeg:WORD, StrOffset:WORD, StrSeg:WORD
	
	LOCAL is_neg:BYTE
	LOCAL digits_count:WORD
	LOCAL tmp_bigint:BigInt
	
	mov ax, word ptr [bp + 8]     ; segment BigInt
	mov es, ax
	mov si, word ptr [bp + 6]     ; offset BigInt
	mov ax, es:[si + BigInt.BIsize]  ; размер в словах
	
	shl ax, 1
	
	sub sp, ax
	mov di, sp
	
	lea bx, tmp_bigint
	push ss                     ; segment буфера
	push di                     ; offset буфера
	shr ax, 1
	push ax                     ; размер
	push ss                     ; segment tmp_bigint
	push bx                     ; offset tmp_bigint
	call init_BigInt@10
	
	shl ax, 1
	
	push ds
	push ax
	mov ax, word ptr es:[si + BigInt.BIptr + 2]
	mov ds, ax
	pop ax
	mov si, word ptr es:[si + BigInt.BIptr]
	push ax
	mov ax, ss
	mov es, ax
	pop ax
	mov cx, ax
	cld
	push di
	rep movsb
	pop di
	pop ds
	push ax
	mov ax, ss
	mov es, ax
	pop ax
	mov si, di
	mov al, es:[si]
	test al, 80h
	jz positive_number
	
	mov is_neg, 1
	
	lea bx, tmp_bigint
	push ss
	push bx
	call NegBigInt@4
	jmp check_zero

positive_number:
	mov is_neg, 0
		  
check_zero:
	mov digits_count, 0
	
	lea bx, tmp_bigint
	mov ax, ss:[bx + BigInt.BIsize]
	shl ax, 1
	mov cx, 3
	mul cx
	sub sp, ax
	mov di, sp
	
	
convert_loop:
	jmp check_if_zero
cnt:
	cmp ax, 1
	je conversion_done
	
	jmp divide_by_10
cnt1:
	add al, '0'
	mov es:[di], al
	inc di
	inc digits_count
	
	jmp convert_loop
	
conversion_done:
	cmp digits_count, 0
	jne form_string
	mov al, '0'
	mov es:[di], al
	inc di
	inc digits_count
	
form_string:
	mov es, word ptr [bp + 12]    ; segment str_out
	mov di, word ptr [bp + 10]    ; offset str_out
	
	cmp is_neg, 0
	je copy_digits
	mov al, '-'
	mov es:[di], al
	inc di
	
copy_digits:
	mov cx, digits_count
	mov si, sp
	add si, cx
	dec si
	
copy_loop:
	push ds
	push ax
	mov ax, ss
	mov ds, ax
	pop ax
	mov al, ds:[si]
	pop ds
	
	mov es:[di], al  ; записываем в str_out
	inc di
	dec si
	dec cx
	jnz copy_loop
	
	mov al, 0
	mov es:[di], al
	
	mov si, word ptr [bp + 10]
	mov es, word ptr [bp + 12]
output_char_loop:
	mov al, es:[si]
	cmp al, 0
	je output_done
	mov dl, al
	
	mov ah, 02h
	int 21h
	inc si
	jmp output_char_loop
	
output_done:
	mov dl, 0Dh
	mov ah, 02h
	int 21h
	mov dl, 0Ah
	mov ah, 02h
	int 21h
	
	mov ax, word ptr [bp + 8]     ; segment исходного BigInt
	mov es, ax
	mov si, word ptr [bp + 6]     ; offset исходного BigInt
	mov ax, es:[si + BigInt.BIsize]  ; размер исходного буфера
	shl ax, 1
	
	; Освобождаем место цифр
	mov cx, 3
	mul cx
	add sp, ax
	
	; Освобождаем место tmp буфера
	mov ax, es:[si + BigInt.BIsize]
	shl ax, 1
	add sp, ax
	
	ret 8
	
	
check_if_zero:
	lea bx, tmp_bigint
	mov cx, ss:[bx+BigInt.BIsize]
	shl cx, 1
	mov es, word ptr ss:[bx + BigInt.BIptr + 2]
	mov si, word ptr ss:[bx + BigInt.BIptr]
	
check_zero_loop:
	mov al, es:[si]
	cmp al, 0
	jne not_zero
	inc si
	loop check_zero_loop
	
	mov ax, 1
	jmp cnt
	
not_zero:
	mov ax, 0
	jmp cnt
	

divide_by_10:
	lea bx, tmp_bigint
	mov cx, word ptr ss:[bx + BigInt.BIsize]
	shl cx, 1
	mov es, word ptr ss:[bx + BigInt.BIptr + 2]
	mov si, word ptr ss:[bx + BigInt.BIptr]
	mov dx, 0
	
divid_loop:
	mov al, es:[si]
	mov ah, dl
	
	mov dx, 0
	
	mov bx, 10
	div bx
	
	mov es:[si], al
	
	inc si
	loop divid_loop
	
	mov al, dl
	jmp cnt1
OutputBigInt ENDP


OUT_CODE ENDS
END

