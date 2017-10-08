#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

ld -Tarch/templatae.lds -Bstatic

	#. = TEXTADDR;

SECTIONS {
  . = 0x33f00000;
  .text : { *(.text) }
  .data ALIGN(4) : { *(.data) }
  .bss ALIGN(4) : { *(.bss) *(COMMON) }
}


