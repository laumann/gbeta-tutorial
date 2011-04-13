
default: gbeta-1.9.11-i386-linux-elf-bin

force:
	mv -f ../src/main/gbeta ../src/main/gbeta-deleted

linux: default
	rm -f gbeta-1.9.11-i386-linux-elf-bin
	cp -f ../src/main/gbeta gbeta-1.9.11-i386-linux-elf-bin

sun: default
	rm -f gbeta-1.9.11-sparc-sun-solaris-bin
	cp -f ../src/main/gbeta gbeta-1.9.11-sparc-sun-solaris-bin

gbeta-1.9.11-i386-linux-elf-bin: gbeta
	ln -fs ../src/main/gbeta gbeta-1.9.11-i386-linux-elf-bin

.PHONY: gbeta
gbeta:
	( cd ../grammars; ../bin/dogrammar )
	( cd ../src/main; beta -lq gbeta )

.PHONY: clean
clean:
	( cd ../src; find -name \*.ast\* -exec rm {} \; )
	rm -f ../src/main/gbeta
	rm -f gbeta-1.9.11-i386-linux-elf-bin

