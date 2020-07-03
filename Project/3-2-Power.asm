assume cs:code, ds:data

data segment
	a dw 10
data ends

code segment
	start:
		mov ax, data
		mov ds, ax
		
		mov bx, 3
		mov ax, a
		call Power
		
		mov ax, 4c00h
		int 21h
		
	Power:
		cmp bx, 0
		jnz lp
		mov ax, 1
		ret
		
		lp:
			mov cx, bx
			mov bx, ax
			mov ax, 1
			s:
				mul bx
				loop s
			ret
code ends
end start