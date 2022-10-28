run:
	nasm -felf -o main.o main.asm && ld -m elf_i386 -o main main.o && ./main
