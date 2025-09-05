.MODEL HUGE, stdcall
.stack 400h

; declaring EXTRNal procedures (example)
; ----------------------------
EXTRN TestAddCase1@0:FAR
EXTRN TestAddCase2@0:FAR
EXTRN TestAddCase3@0:FAR
EXTRN TestSignCase1@0:FAR
EXTRN TestSignCase2@0:FAR
EXTRN TestCompareCase1@0:FAR
EXTRN TestCompareCase2@0:FAR
EXTRN TestCompareCase3@0:FAR
EXTRN TestCompareSizeCase1@0:FAR
EXTRN TestCompareSizeCase2@0:FAR
EXTRN TestNegCase1@0:FAR
EXTRN TestNegCase2@0:FAR
EXTRN TestShrBigIntCase1@0:FAR
EXTRN TestShlBigIntCase1@0:FAR
EXTRN TestSumCase1@0:FAR
EXTRN TestSumCase2@0:FAR
EXTRN TestSumCase3@0:FAR
EXTRN TestSumCase4@0:FAR
EXTRN TestSubCase1@0:FAR
EXTRN TestSubCase2@0:FAR
EXTRN TestSubCase3@0:FAR
EXTRN TestAbsCase1@0:FAR
EXTRN TestAbsCase2@0:FAR
EXTRN TestMulCase1@0:FAR
EXTRN TestMulCase2@0:FAR
EXTRN TestMulCase3@0:FAR
EXTRN TestMulCase4@0:FAR
EXTRN TestDivCase1@0:FAR
EXTRN TestDivCase2@0:FAR
EXTRN TestDivCase3@0:FAR
EXTRN TestDivCase4@0:FAR
EXTRN TestModCase1@0:FAR
EXTRN TestModCase2@0:FAR
EXTRN TestModCase3@0:FAR
EXTRN TestModCase4@0:FAR
EXTRN TestInpCase1@0:FAR
EXTRN TestInpCase2@0:FAR
EXTRN TestInpCase3@0:FAR
EXTRN TestPowCase1@0:FAR
EXTRN TestPowCase2@0:FAR
EXTRN TestPowCase3@0:FAR
EXTRN TestPowCase4@0:FAR
EXTRN TestGCDCase1@0:FAR
EXTRN TestGCDCase2@0:FAR
EXTRN TestGCDCase3@0:FAR



.data
test_list dw offset TestNegCase1@0, seg TestNegCase1@0
		  dw offset TestNegCase2@0, seg TestNegCase2@0
		  dw offset TestAddCase1@0, seg TestAddCase1@0
		  dw offset TestAddCase2@0, seg TestAddCase2@0
		  dw offset TestAddCase3@0, seg TestAddCase3@0
		  dw offset TestSignCase1@0, seg TestSignCase1@0
		  dw offset TestSignCase2@0, seg TestSignCase2@0
		  dw offset TestCompareCase1@0, seg TestCompareCase1@0
		  dw offset TestCompareCase2@0, seg TestCompareCase2@0
		  dw offset TestCompareCase3@0, seg TestCompareCase3@0
		  dw offset TestCompareSizeCase1@0, seg TestCompareSizeCase1@0
		  dw offset TestCompareSizeCase2@0, seg TestCompareSizeCase2@0
		  dw offset TestShrBigIntCase1@0, seg TestShrBigIntCase1@0
		  dw offset TestShlBigIntCase1@0, seg TestShlBigIntCase1@0
		  dw offset TestSumCase1@0, seg TestSumCase1@0
		  dw offset TestSumCase2@0, seg TestSumCase2@0
		  dw offset TestSumCase3@0, seg TestSumCase3@0
		  dw offset TestSumCase4@0, seg TestSumCase4@0
		  dw offset TestSubCase1@0, seg TestSubCase1@0
		  dw offset TestSubCase2@0, seg TestSubCase2@0
		  dw offset TestSubCase3@0, seg TestSubCase3@0
		  dw offset TestAbsCase1@0, seg TestAbsCase1@0
		  dw offset TestAbsCase2@0, seg TestAbsCase2@0
		  dw offset TestMulCase1@0, seg TestMulCase1@0
		  dw offset TestMulCase2@0, seg TestMulCase2@0
	      dw offset TestMulCase3@0, seg TestMulCase3@0
	      dw offset TestMulCase4@0, seg TestMulCase4@0
		  dw offset TestDivCase1@0, seg TestDivCase1@0
		  dw offset TestDivCase2@0, seg TestDivCase2@0
	      dw offset TestDivCase3@0, seg TestDivCase3@0
	      dw offset TestDivCase4@0, seg TestDivCase4@0
		  dw offset TestModCase1@0, seg TestModCase1@0
	      dw offset TestModCase2@0, seg TestModCase2@0
	      dw offset TestModCase3@0, seg TestModCase3@0
	      dw offset TestModCase4@0, seg TestModCase4@0
		  dw offset TestInpCase1@0, seg TestInpCase1@0
		  dw offset TestInpCase2@0, seg TestInpCase2@0
	      dw offset TestInpCase3@0, seg TestInpCase3@0
		  dw offset TestPowCase1@0, seg TestPowCase1@0
		  dw offset TestPowCase2@0, seg TestPowCase2@0
		  dw offset TestPowCase3@0, seg TestPowCase3@0
		  dw offset TestPowCase4@0, seg TestPowCase4@0
		  dw offset TestGCDCase1@0, seg TestGCDCase1@0
	      dw offset TestGCDCase2@0, seg TestGCDCase2@0
		  dw offset TestGCDCase3@0, seg TestGCDCase3@0


test_list_end label word
; ----------------------------

.code
public main
main proc far
	push ds
	mov ax, seg test_list
	mov es, ax
	mov si, offset test_list

next_test:
	cmp si, offset test_list_end
	jae done

	call far ptr es:[si]

	add si, 4
	jmp next_test

done:
	pop ds
	; ===========
	mov ax, 4c00h
	int 21h
	; ===========
	retf
main endp
end main
