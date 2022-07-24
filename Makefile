GCCPARAMS = -m32 -Iheaders -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore -Wno-write-strings -fcheck-new -std=c++17

ASPARAMS = --32
LDPARAMS = -melf_i386

objects = obj/loader.o \
		  obj/kernel.o

obj/%.o: src/%.cpp
	mkdir -p $(@D)
	g++ $(GCCPARAMS) -c -o $@ $<

obj/%.o: src/%.s
	mkdir -p $(@D)
	as $(ASPARAMS) -o $@ $<

kernel.bin: linker.ld $(objects)
	mkdir -p bin
	ld $(LDPARAMS) -T $< -o bin/$@ $(objects)

install: kernel.bin
	sudo cp $< /boot/kernel.bin

kernel.iso: kernel.bin
	grub-mkrescue --output=bin/$@ bin

clean:
	rm -rf obj iso kernel.bin kernel.iso

build-docker:
	docker build --platform linux/x86-64 -t simple-os .

docker:
	docker run --rm -v "$$(pwd)":/simple-os --platform linux/x86-64 simple-os