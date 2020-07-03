assume cs:code

data segment
	a dw 0100h
	b dw 0100h
	x dw 0f0fh
	y dw 0ff00h
data ends

code segment
	start:	
		mov ax, data
		mov ds, ax
		
		mov ax, a
		mul b
		
		mov ax, x
		mul y

		mov ax, 4c00h
		int 21h
code ends

end start