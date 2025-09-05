INCLUDELIB ..\build\bin\BigInt.lib
INCLUDE src/BigInt.inc

.MODEL HUGE, stdcall
.stack 200h

EXTRN init_BigInt@10:FAR
EXTRN ShlBigInt@10:FAR
EXTRN CompareBigInt@8:FAR

BYTES_1 EQU 4
WORDS_1 EQU 2
.data
	test_number db 00000000b, 00000100b, 01111001b, 01111101b
	shift_right db 02
	correct_number db 00000000b, 00010001b, 11100101b, 11110100b

	source_bi   BigInt <>
	result_bi   BigInt <>
	correct_bi  BigInt <>
	
	source_buf  db BYTES_1 dup(0)
	result_buf  db BYTES_1 dup(0)
	correct_buf db BYTES_1 dup(0)
	
	msg1 db 'TestShlBigIntCase1 passed',13,10,'$',0
	msg2 db 'TestShlBigIntCase1 FAILED',13,10,'$',0


.CODE
public TestShlBigIntCase1
TestShlBigIntCase1 proc far uses si
	mov ax, @data
	mov ds, ax
	mov es, ax
	
	mov si, offset test_number
	mov di, offset source_buf
	mov cx, BYTES_1
	rep movsb
	
	mov si, offset correct_number
	mov di, offset correct_buf
	mov cx, BYTES_1
	rep movsb
 

	mov ax, seg source_buf
	push ax         ; segment buf
	mov ax, offset source_buf
	push ax      ; offset buf
	mov ax, WORDS_1
	push ax
	mov ax, seg source_bi
	push ax          ; segment myBigInt
	mov ax, offset source_bi
	push ax       ; offset myBigInt
	call init_BigInt@10
	
	mov ax, seg result_buf
	push ax         ; segment buf
	mov ax, offset result_buf
	push ax      ; offset buf
	mov ax, WORDS_1
	push ax
	mov ax, seg result_bi
	push ax          ; segment myBigInt
	mov ax, offset result_bi
	push ax
	call init_BigInt@10
	
	mov ax, seg result_bi
	push ax                 ; segment result
	mov ax, offset result_bi
	push ax                 ; offset result
	mov al, shift_right
	xor ah, ah
	push ax
	mov ax, seg source_bi
	push ax                  ; segment source
	mov ax, offset source_bi
	push ax                  ; offset source
	call ShlBigInt@10
 

	mov ax, seg correct_buf
	push ax         ; segment buf
	mov ax, offset correct_buf
	push ax      ; offset buf
	mov ax, WORDS_1
	push ax
	mov ax, seg correct_bi
	push ax          ; segment myBigInt
	mov ax, offset correct_bi
	push ax
	call init_BigInt@10
	
	mov ax, seg result_bi
	push ax                 ; segment result
	mov ax, offset result_bi
	push ax                 ; offset result
	mov ax, seg correct_bi
	push ax          ; segment myBigInt
	mov ax, offset correct_bi
	push ax
	call CompareBigInt@8
	
	jnz fail

success:
	mov ah, 09h
	mov dx, offset msg1
	int 21h
	jmp done
	
fail:
	mov ah, 09h
	mov dx, offset msg2
	int 21h

done:
	ret 0
TestShlBigIntCase1 endp

END
