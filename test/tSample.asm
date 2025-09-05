; ------------------------------------------------------------------
; Stub example
; ------------------------------------------------------------------

.MODEL HUGE, stdcall
.stack 200h

.data
msg1_p db 'Test AddCase1 passed',13,10,'$',0
msg2_p db 'Test AddCase2 passed',13,10,'$',0
msg3_p db 'Test AddCase3 passed',13,10,'$',0

msg1_f db 'Test AddCase1 failed',13,10,'$',0
msg2_f db 'Test AddCase2 failed',13,10,'$',0
msg3_f db 'Test AddCase3 failed',13,10,'$',0

.code
public TestAddCase1, TestAddCase2, TestAddCase3

; -----------------------------
TestAddCase1 proc far
		push ds
		mov ax, seg msg1_p
		mov ds, ax
		mov dx, offset msg1_p
		mov ah, 09h
		int 21h
		pop ds
		retf
TestAddCase1 endp
; -----------------------------
TestAddCase2 proc far
		push ds
		mov ax, seg msg2_p
		mov ds, ax
		mov dx, offset msg2_p
		mov ah, 09h
		int 21h
		pop ds
		retf
TestAddCase2 endp
; -----------------------------
TestAddCase3 proc far
		push ds
		mov ax, seg msg3_p
		mov ds, ax
		mov dx, offset msg3_p
		mov ah, 09h
		int 21h
		pop ds
		retf
TestAddCase3 endp
; ------------------------------------------------------------------
end


