assume cs:codesg

codesg segment
	mov ax, 10011000B
	mov cx, 5
	
s:	sub ax, 01000000B
	loop s
	
	mov ax, 4c00h
	int 21h
codesg ends

end