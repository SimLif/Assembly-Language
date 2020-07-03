assume cs:code, ds:data

data segment
	a dw 0,0002h, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h
	b dw 0,0001h, 0000h, 0000h, 0001h, 0000h, 0000h, 0000h
data ends

code segment
	start:
		mov ax, data
		mov ds, ax
		
		mov ax, b[14]
		sub a[14], ax
		pushf
		
		mov bx, 12
		stadd:
			cmp bx, 0
			jz endadd
			mov ax, b[bx]
			popf
			sbb a[bx], ax
			pushf
			dec bx
			dec bx
			jmp stadd
			endadd:
				nop
		
		
		mov ax, 4c00h
		int 21h

code ends
end start
