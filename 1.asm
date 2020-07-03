assume cs:codesg

codesg segment
	start:
		mov ax, 0
		mov bx, 0
		mov cx, 5
		s:  
			inc bx
			add ax, bx
			loop s
		
		mov ax, 4c00H
		int 21h

codesg ends

end start