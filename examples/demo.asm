INCLUDE build/bin/BigInt.inc
INCLUDELIB build/bin/BigInt.lib

.MODEL HUGE, stdcall
.STACK 8192

EXTRN init_BigInt@10:FAR
EXTRN BigIntSign@4:FAR
EXTRN AddBigInt@12:FAR
EXTRN SubtractBigInt@12:FAR
EXTRN MultiplyBigInt@12:FAR
EXTRN PowBigInt@12:FAR
EXTRN CompareBigInt@8:FAR
EXTRN InputBigInt@14:FAR
EXTRN OutputBigInt@8:FAR

SIZEBI EQU 35 ; 35 words

.data
    ; 70 bytes
    ; 35 bytes in each line
    x_data db 70 DUP (00h)
    xBI BigInt <>

    ; Constants
    ; One
    one_data db 69 DUP (00h), 01h
    oneBI BigInt <>
    ; Two
    two_data db 69 DUP (00h), 02h
    twoBI BigInt <>
    ; Three
    three_data db 69 DUP (00h), 03h
    threeBI BigInt <>
    ; Five
    five_data db 69 DUP (00h), 05h
    fiveBI BigInt <>

    ; Helper temp BigInts
    tmp1_data db 70 DUP (00h)
    tmp1BI BigInt <>
    tmp2_data db 70 DUP (00h)
    tmp2BI BigInt <>
    tmp3_data db 70 DUP (00h)
    tmp3BI BigInt <>
    tmp4_data db 70 DUP (00h)
    tmp4BI BigInt <>
    tmp5_data db 70 DUP (00h)
    tmp5BI BigInt <>

    msg0 db 'Input x: ', '$'
    msg1 db 'x! = ', '$'
    msg2 db '2^x = ', '$'
    msg3 db 'x^3 - 2 * x^2 + 5 = ', '$'
    msg4 db 'Unable to calculate factorial of negative number!', '$'

    ; Input buffer
    str_buff db 100h DUP (?)
    outputString db 100h DUP (?)
.code

fact proc far
    ; Copy x to tmp3 (multiply x by oneBI=1 and save result to tmp3)
    mov ax, SEG tmp3BI ; Seg result
    push ax

    mov ax, OFFSET tmp3BI ; Offset result
    push ax

    mov ax, SEG oneBI ; Seg op2
    push ax

    mov ax, OFFSET oneBI ; Offset op2
    push ax

    mov ax, SEG xBI ; Seg op1
    push ax

    mov ax, OFFSET xBI ; Offset op1
    push ax

    call MultiplyBigInt@12

    ; Copy x to tmp1 (multiply x by oneBI=1 and save result to tmp1)
    mov ax, SEG tmp1BI ; Seg result
    push ax

    mov ax, OFFSET tmp1BI ; Offset result
    push ax

    mov ax, SEG oneBI ; Seg op2
    push ax

    mov ax, OFFSET oneBI ; Offset op2
    push ax

    mov ax, SEG xBI ; Seg op1
    push ax

    mov ax, OFFSET xBI ; Offset op1
    push ax

    call MultiplyBigInt@12

    ; Corner case (x<0)
    ; = Test sign and save 0404h in ax indicating error =
    ; js
    mov ax, SEG xBI
    push ax

    mov ax, OFFSET xBI
    push ax

    call BigIntSign@4
    jns fact_cont_calc

    ; Save error and exit from function (for x<0)
    mov ax,0404h ; Error
    ret 0

    fact_cont_calc:
    ; Corner case (x==0)
    ; = Compare =
    ; cmp tmp1BI, oneBI
    ; jl (exit if <1)
    mov ax, SEG oneBI
    push ax

    mov ax, OFFSET oneBI
    push ax

    mov ax, SEG tmp1BI
    push ax

    mov ax, OFFSET tmp1BI
    push ax

    call CompareBigInt@8
    jl sv_fac_one

    ; Corner case (x<=1)
    ; = Compare =
    ; cmp tmp1BI, oneBI
    ; jle (exit if <=1)
    mov ax, SEG oneBI
    push ax

    mov ax, OFFSET oneBI
    push ax

    mov ax, SEG tmp1BI
    push ax

    mov ax, OFFSET tmp1BI
    push ax

    call CompareBigInt@8
    jle sv_fac_tmp3

    ; In loop: If bx==0, we sub 1 from tmp1 and save result in tmp2 (first variant). Then multiply tmp2 by tmp3 and save the result in tmp4.
    ;          If bx==1, we sub 1 from tmp2 and save result in tmp1 (second variant). Then multiply tmp1 by tmp4 and save the result in tmp3.
    xor bx,bx ; At first bx=0

    fact_loop:
    ; Get next multiplier by subtracting oneBI from x and saving result to tmp1
    ; a - b = c
    cmp bx,1
    je fact_lp_var_2

    ; = First variant =
    fact_lp_var_1:
    ; = Subtract =
    mov ax, SEG tmp1BI ; Seg a
    push ax
    
    mov ax, OFFSET tmp1BI ; Offset a
    push ax

    mov ax, SEG oneBI ; Seg oneBI
    push ax
    
    mov ax, OFFSET oneBI ; Offset oneBI
    push ax

    mov ax, SEG tmp2BI ; Seg c
    push ax
    
    mov ax, OFFSET tmp2BI ; Offset c
    push ax

    call SubtractBigInt@12

    ; = Multiply =
    mov ax, SEG tmp4BI ; Seg result
    push ax

    mov ax, OFFSET tmp4BI ; Offset result
    push ax

    mov ax, SEG tmp3BI ; Seg op2
    push ax

    mov ax, OFFSET tmp3BI ; Offset op2
    push ax

    mov ax, SEG tmp2BI ; Seg op1
    push ax

    mov ax, OFFSET tmp2BI ; Offset op1
    push ax

    call MultiplyBigInt@12

    ; = Compare =
    ; cmp tmp2BI, twoBI
    ; jle (exit if <=2)
    mov ax, SEG twoBI
    push ax

    mov ax, OFFSET twoBI
    push ax

    mov ax, SEG tmp1BI
    push ax

    mov ax, OFFSET tmp1BI
    push ax

    call CompareBigInt@8
    jle sv_res_fac

    mov cx,0001h
    xor bx,cx
    jmp fact_loop

    ; = Second variant =
    fact_lp_var_2:
    ; = Subtract =
    mov ax, SEG tmp2BI ; Seg a
    push ax
    
    mov ax, OFFSET tmp2BI ; Offset a
    push ax

    mov ax, SEG oneBI ; Seg oneBI
    push ax
    
    mov ax, OFFSET oneBI ; Offset oneBI
    push ax

    mov ax, SEG tmp1BI ; Seg c
    push ax
    
    mov ax, OFFSET tmp1BI ; Offset c
    push ax

    call SubtractBigInt@12

    ; = Multiply =
    mov ax, SEG tmp3BI ; Seg result
    push ax

    mov ax, OFFSET tmp3BI ; Offset result
    push ax

    mov ax, SEG tmp4BI ; Seg op2
    push ax

    mov ax, OFFSET tmp4BI ; Offset op2
    push ax

    mov ax, SEG tmp1BI ; Seg op1
    push ax

    mov ax, OFFSET tmp1BI ; Offset op1
    push ax

    call MultiplyBigInt@12

    ; = Compare =
    ; cmp tmp1BI, twoBI
    ; jle (exit if <=2)
    mov ax, SEG twoBI
    push ax

    mov ax, OFFSET twoBI
    push ax

    mov ax, SEG tmp2BI
    push ax

    mov ax, OFFSET tmp2BI
    push ax

    call CompareBigInt@8
    jle sv_res_fac

    mov cx,0001h
    xor bx,cx
    jmp fact_loop

    sv_res_fac:
    cmp bx,1
    je sv_fac_tmp3

    ; = Save to res (tmp5) from tmp4 =
    ; Copy tmp4 to tmp5 (multiply tmp4 by oneBI=1 and save result to tmp5)
    mov ax, SEG tmp5BI ; Seg result
    push ax

    mov ax, OFFSET tmp5BI ; Offset result
    push ax

    mov ax, SEG oneBI ; Seg op2
    push ax

    mov ax, OFFSET oneBI ; Offset op2
    push ax

    mov ax, SEG tmp4BI ; Seg op1
    push ax

    mov ax, OFFSET tmp4BI ; Offset op1
    push ax

    call MultiplyBigInt@12
    ret 0

    ; = Save to res (tmp5) from tmp3 =
    sv_fac_tmp3:
    mov ax, SEG tmp5BI ; Seg result
    push ax

    mov ax, OFFSET tmp5BI ; Offset result
    push ax

    mov ax, SEG oneBI ; Seg op2
    push ax

    mov ax, OFFSET oneBI ; Offset op2
    push ax

    mov ax, SEG tmp3BI ; Seg op1
    push ax

    mov ax, OFFSET tmp3BI ; Offset op1
    push ax

    call MultiplyBigInt@12
    ret 0

    ; = Edge case: x==0. Return 1 =
    sv_fac_one:
    ; Copy 1 to tmp5 (add x to oneBI=1 and save result to tmp5)
    mov   ax, SEG xBI
    push  ax
    
    mov   ax, OFFSET xBI
    push  ax

    mov   ax, SEG oneBI
    push  ax
    
    mov   ax, OFFSET oneBI
    push  ax

    mov   ax, SEG tmp5BI
    push  ax
    
    mov   ax, OFFSET tmp5BI
    push  ax

    call AddBigInt@12
    ret 0
fact endp

; 2^x
fun2 proc far
    mov   ax, SEG twoBI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET twoBI
    push  ax              ; low word of struct pointer

    mov   ax, SEG xBI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET xBI
    push  ax              ; low word of struct pointer

    mov   ax, SEG tmp5BI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET tmp5BI
    push  ax              ; low word of struct pointer

    call PowBigInt@12
    ret 0
fun2 endp

; x^3 - 2 * x^2 + 5
fun3 proc far
    ; Copy x to tmp1 (multiply x by oneBI=1 and save result to tmp1)
    mov ax, SEG tmp1BI ; Seg result
    push ax

    mov ax, OFFSET tmp1BI ; Offset result
    push ax

    mov ax, SEG oneBI ; Seg op2
    push ax

    mov ax, OFFSET oneBI ; Offset op2
    push ax

    mov ax, SEG xBI ; Seg op1
    push ax

    mov ax, OFFSET xBI ; Offset op1
    push ax

    call MultiplyBigInt@12

    ; Multiply xBI by x (in tmp1) and save result (x^2) in tmp2
    mov ax, SEG tmp2BI ; Seg result
    push ax

    mov ax, OFFSET tmp2BI ; Offset result
    push ax

    mov ax, SEG tmp1BI ; Seg op2
    push ax

    mov ax, OFFSET tmp1BI ; Offset op2
    push ax

    mov ax, SEG xBI ; Seg op1
    push ax

    mov ax, OFFSET xBI ; Offset op1
    push ax

    call MultiplyBigInt@12

    ; Multiply xBI by x^2 (in tmp2) and save result (x^3) in tmp3
    mov ax, SEG tmp3BI ; Seg result
    push ax

    mov ax, OFFSET tmp3BI ; Offset result
    push ax

    mov ax, SEG tmp2BI ; Seg op2
    push ax

    mov ax, OFFSET tmp2BI ; Offset op2
    push ax

    mov ax, SEG xBI ; Seg op1
    push ax

    mov ax, OFFSET xBI ; Offset op1
    push ax

    call MultiplyBigInt@12

    ; Now tmp1=x, tmp2=x^2. tmp3=x^3
    ; Multiply tmp2 by 2 and save result (2*x^2) in tmp4
    mov ax, SEG tmp4BI ; Seg result
    push ax

    mov ax, OFFSET tmp4BI ; Offset result
    push ax

    mov ax, SEG tmp2BI ; Seg op2
    push ax

    mov ax, OFFSET tmp2BI ; Offset op2
    push ax

    mov ax, SEG twoBI ; Seg op1
    push ax

    mov ax, OFFSET twoBI ; Offset op1
    push ax

    call MultiplyBigInt@12

    ; Subtract tmp4 from tmp3 and save result (x^3 - 2*x^2) in tmp1
    ; a - b = c
    mov ax, SEG tmp3BI ; Seg a
    push ax
    
    mov ax, OFFSET tmp3BI ; Offset a
    push ax

    mov ax, SEG tmp4BI ; Seg oneBI
    push ax
    
    mov ax, OFFSET tmp4BI ; Offset oneBI
    push ax

    mov ax, SEG tmp1BI ; Seg c
    push ax
    
    mov ax, OFFSET tmp1BI ; Offset c
    push ax

    call SubtractBigInt@12

    ; Add fiveBI to tmp1 and save result (x^3 - 2*x^2 + 5) in tmp5
    mov   ax, SEG tmp1BI
    push  ax
    
    mov   ax, OFFSET tmp1BI
    push  ax

    mov   ax, SEG fiveBI
    push  ax
    
    mov   ax, OFFSET fiveBI
    push  ax

    mov   ax, SEG tmp5BI
    push  ax
    
    mov   ax, OFFSET tmp5BI
    push  ax

    call AddBigInt@12

    ret 0
fun3 endp

outTmp5 proc far
    mov ax, seg outputString
	push ax
	mov ax, offset outputString
	push ax
	mov ax, seg tmp5BI
	push ax
	mov ax, offset tmp5BI
	push ax
	call OutputBigInt@8
    ret
outTmp5 endp

print_offset_dx proc
    mov ah, 09h
    int 21h
    ret
print_offset_dx ENDP

nextline macro
	mov dl,0Ah
	mov ah,02h
	int 21h
endm

main proc far
    ; Initialize BigInts
    mov ax, @data
    mov ds, ax

    ; X
    mov   ax, SEG x_data
    push  ax              ; high word of buffer-pointer

    mov   ax, OFFSET x_data
    push  ax              ; low word of buffer-pointer
    
    mov ax, SIZEBI
    push  ax              ; size
    
    mov   ax, SEG xBI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET xBI
    push  ax              ; low word of struct pointer
    
    call  init_BigInt@10

    ; One
    mov   ax, SEG one_data
    push  ax              ; high word of buffer-pointer
    
    mov   ax, OFFSET one_data
    push  ax              ; low word of buffer-pointer
    
    mov ax, SIZEBI
    push  ax              ; size
    
    mov   ax, SEG oneBI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET oneBI
    push  ax              ; low word of struct pointer
    
    call  init_BigInt@10

    ; Two
    mov   ax, SEG two_data
    push  ax              ; high word of buffer-pointer
    
    mov   ax, OFFSET two_data
    push  ax              ; low word of buffer-pointer
    
    mov ax, SIZEBI
    push  ax              ; size
    
    mov   ax, SEG twoBI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET twoBI
    push  ax              ; low word of struct pointer
    
    call  init_BigInt@10

    ; Three
    mov   ax, SEG three_data
    push  ax              ; high word of buffer-pointer
    
    mov   ax, OFFSET three_data
    push  ax              ; low word of buffer-pointer
    
    mov ax, SIZEBI
    push  ax              ; size
    
    mov   ax, SEG threeBI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET threeBI
    push  ax              ; low word of struct pointer
    
    call  init_BigInt@10

    ; Five
    mov   ax, SEG five_data
    push  ax              ; high word of buffer-pointer
    
    mov   ax, OFFSET five_data
    push  ax              ; low word of buffer-pointer
    
    mov ax, SIZEBI
    push  ax              ; size
    
    mov   ax, SEG fiveBI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET fiveBI
    push  ax              ; low word of struct pointer
    
    call  init_BigInt@10

    ; tmp1
    mov   ax, SEG tmp1_data
    push  ax              ; high word of buffer-pointer
    
    mov   ax, OFFSET tmp1_data
    push  ax              ; low word of buffer-pointer
    
    mov ax, SIZEBI
    push  ax              ; size
    
    mov   ax, SEG tmp1BI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET tmp1BI
    push  ax              ; low word of struct pointer
    
    call  init_BigInt@10

    ; tmp2
    mov   ax, SEG tmp2_data
    push  ax              ; high word of buffer-pointer
    
    mov   ax, OFFSET tmp2_data
    push  ax              ; low word of buffer-pointer
    
    mov ax, SIZEBI
    push  ax              ; size
    
    mov   ax, SEG tmp2BI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET tmp2BI
    push  ax              ; low word of struct pointer
    
    call  init_BigInt@10

    ; tmp3
    mov   ax, SEG tmp3_data
    push  ax              ; high word of buffer-pointer
    
    mov   ax, OFFSET tmp3_data
    push  ax              ; low word of buffer-pointer
    
    mov ax, SIZEBI
    push  ax              ; size
    
    mov   ax, SEG tmp3BI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET tmp3BI
    push  ax              ; low word of struct pointer
    
    call  init_BigInt@10

    ; tmp4
    mov   ax, SEG tmp4_data
    push  ax              ; high word of buffer-pointer
    
    mov   ax, OFFSET tmp4_data
    push  ax              ; low word of buffer-pointer
    
    mov ax, SIZEBI
    push  ax              ; size
    
    mov   ax, SEG tmp4BI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET tmp4BI
    push  ax              ; low word of struct pointer
    
    call  init_BigInt@10

    ; tmp5
    mov   ax, SEG tmp5_data
    push  ax              ; high word of buffer-pointer
    
    mov   ax, OFFSET tmp5_data
    push  ax              ; low word of buffer-pointer
    
    mov ax, SIZEBI
    push  ax              ; size
    
    mov   ax, SEG tmp5BI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET tmp5BI
    push  ax              ; low word of struct pointer
    
    call  init_BigInt@10

    ; = INPUT X =
    ; = Prompt X message =
    mov ah, 09h
    mov dx, offset msg0
    int 21h
    ; = Read input =
    mov   ax, SEG str_buff
    push  ax              ; high word of buffer-pointer
    
    mov   ax, OFFSET str_buff
    push  ax              ; low word of buffer-pointer
    
    mov ax, SIZEBI
    push  ax              ; size
    
    mov   ax, SEG x_data
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET x_data
    push  ax              ; low word of struct pointer

    mov   ax, SEG xBI
    push  ax              ; high word of struct pointer
    
    mov   ax, OFFSET xBI
    push  ax              ; low word of struct point

    
    call InputBigInt@14

    ; Clear ax if fact results in error
    xor ax,ax
    ; = CALCULATE FACTORIAL =
    call fact

    cmp ax,0404h
    jne print_fac_res

    ; Else print error
    mov dx, offset msg4
    call print_offset_dx
    nextline
    jmp main_fun2

    print_fac_res:
    mov dx, offset msg1
    call print_offset_dx

    ; = OUTPUT RESULT =
    call outTmp5

    main_fun2:
    ; = CALCULATE FUNCTION 2 =
    call fun2

    mov dx, offset msg2
    call print_offset_dx

    ; = OUTPUT RESULT =
    call outTmp5

    ; = CALCULATE FUNCTION 3 =
    call fun3

    mov dx, offset msg3
    call print_offset_dx

    ; = OUTPUT RESULT =
    call outTmp5

    mov ax, 4c00h
    int 21h
main endp
end main