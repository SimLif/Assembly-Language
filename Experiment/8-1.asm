assume cs:code, ds:data

data segment
	a dw 00100001b, 00010010b, 01100101b, 01000110b, 01110100b, 01000011b
	b dw 01110001b, 01001001b, 10000010b, 00110011b, 01011000b, 01010100b
	c dw 6 dup(0)
data ends

code segment
	start:
		mov ax, data
		mov ds, ax
		
		mov ax, 0
		mov si, 0
		mov cx, 3
		s1:
			mov al, byte ptr a[si]
			add al, byte ptr b[si]
			daa
			mov bl, al
			mov al, byte ptr a[si+1]
			adc al, byte ptr b[si+1]
			daa
			mov bh, al
			mov c[si], bx
			inc si
			inc si
			loop s1
		
		mov cx, 3
		s2:
			mov al, byte ptr a[si]
			sub al, byte ptr b[si]
			das
			mov bl, al
			mov al, byte ptr a[si+1]
			sbb al, byte ptr b[si+1]
			das
			mov bh, al
			mov c[si], bx
			inc si
			inc si
			loop s2
		
		mov ax, 4c00h
		int 21h
code ends

end start