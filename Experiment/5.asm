assume cs:code, ds:data, ss:stacksg

data segment 
	m dw 01h
	a dw 0fh
	b dw 0ffh
	c dw 0ffffh
	d dd 0ffffffffh
data ends

stacksg segment stack
	dw 5 dup(0)
stacksg ends

code segment
	start:
		mov ax, data
		mov ds, ax
		
		mov ax, stacksg
		mov ss, ax
		mov sp, 8h
		
		mov ax, a
		sa:	
			add ax, m
			cmp ax, a
			jnz sa

		mov ax, b
		sb:
			add ax, m
			cmp ax, b
			jnz sb
		
		mov ax, c
		sc:
			add ax, m
			cmp ax, c
			jnz sc
		
		mov cx, 31h
		mov ax, word ptr d[2]
		mov bx, word ptr d
		sd:
			add ax, m
			adc bx, 0
			loop sd
		
		
		mov ax, 4c00h
		int 21h
code ends

end start
