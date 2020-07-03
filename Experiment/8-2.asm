assume cs:code, ds:data

data segment
	a dw 0201h, 0102h, 0605h, 0406h, 0704h, 0403h
	b dw 0701h, 0409h, 0802h, 0303h, 0508h, 0504h
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
			aaa
			mov dl, al
			
			mov al, byte ptr a[si+1]
			adc al, byte ptr b[si+1]
			aaa
			mov dh, al
			
			mov c[si], dx
			
			inc si
			inc si
			
			loop s1
		
		mov cx, 3
		s2:
			mov al, byte ptr a[si]
			sub al, byte ptr b[si]
			aas
			mov dl, al
			
			mov al, byte ptr a[si+1]
			sbb al, byte ptr b[si+1]
			aas
			mov dh, al
			
			mov c[si], dx
			
			inc si
			inc si
			
			loop s2
		
		mov ax, 4c00h
		int 21h
code ends

end start