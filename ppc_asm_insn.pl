#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

add[ o][ .] Add 
addc[ o][ .] Add Carrying 
adde[ o][ .] Add Extended 
addi Add Immediate 
addic Add Immediate Carrying 
addic. Add Immediate Carrying and Record 
addis Add Immediate Shifted 
addme[ o][ .] Add to Minus One Extended 
addze[ o][ .] Add to Zero Extended 
and[ .] AND 
andc[ .] AND with Complement 
andi. AND Immediate 
andis. AND Immediate Shifted 
b[ l][ a] Branch 
bc[ l][ a] Branch Conditional 
bcctr[ l] Branch Conditional to Count Register 
bclr[ l] Branch Conditional to Link Register 
bctr  Branch unconditionally
beq       Branch if equal
bgt       Branch if greater than
bge		  Branch if greater than or equal
bl        Branch
bne       Branch if not equal
cmp Compare 
cmpi Compare Immediate 
cmpl Compare Logical 
cmpli Compare Logical Immediate 
cmpwi     Compare Word Immediate
cmpdi	   Compare    Immediate
cntlzd[ .] Count Leading Zeros Doubleword 
cntlzw[ .] Count Leading Zeros Word 
crand Condition Register AND 
crandc Condition Register AND with Complement 
creqv Condition Register Equivalent 
crnand Condition Register NAND 
crnor Condition Register NOR 
cror Condition Register OR 
crorc Condition Register OR with Complement 
crxor Condition Register XOR 
dcbf Data Cache Block Flush 
dcbst Data Cache Block Store 
dcbt Data Cache Block Touch 
dcbtst Data Cache Block Touch for Store 
dcbz Data Cache Block set to Zero 
divd[ o][ .] Divide Doubleword 
divdu[ o][ .] Divide Doubleword Unsigned 
divw[ o][ .] Divide Word 
divwu[ o][ .] Divide Word Unsigned 
eciwx External Control In Word Indexed 
ecowx External Control Out Word Indexed 
eieio Enforce In-order Execution of I/O 
eqv[ .] Equivalent 
extsb[ .] Extend Sign Byte 
extsh[ .] Extend Sign Halfword 
extsw[ .] Extend Sign Word 
fabs[ .] Floating Absolute Value 
fadd[ .] Floating Add 
fadds[ .] Floating Add Single 
fcfid[ .] Floating Convert From Integer  bleword 
fcmpo Floating Compare Ordered 
fcmpu Floating Compare Unordered 
fctid[ .] Floating Convert To Integer Doubleword 
fctidz[ .] Floating Convert To Integer Doubleword with round 
fctidz[ .] Floating Convert To Integer Doubleword with round toward 
fctiw[ .] Floating Convert To Integer Word 
fctiwz[ .] Floating Convert To Integer Word with round toward Zero 
fdiv[ .] Floating Divide 
fdivs[ .] Floating Divide Single 
fmadd[ .] Floating Multiply-Add 
fmadds[ .] Floating Multiply-Add Single 
fmr[ .] Floating Move Register 
fmsub[ .] Floating Multiply-Subtract 
fmsubs[ .] Floating Multiply-Subtract Single 
fmul[ .] Floating Multiply 
fmuls[ .] Floating Multiply Single 
fnabs[ .] Floating Negative Absolute Value 
fneg[ .] Floating Negate 
fnmadd[ .] Floating Negative Multiply-Add 
fnmadds[ .] Floating Negative Multiply-Add Single 
fnmsub[ .] Floating Negative Multiply-Subtract 
fnmsubs[ .] Floating Negative Multiply-Subtract Single 
fres[ .] Floating Reciprocal Estimate Single 
frsp[ .] Floating Round to Single-Precision 
frsqrte[ .] Floating Reciprocal Square Root Estimate 
fsel[ .] Floating Select 
fsqrt[ .] Floating Square Root 
fsqrts[ .] Floating Square Root Single 
fsub[ .] Floating Subtract 
fsubs[ .] Floating Subtract Single 
icbi Instruction Cache Block Invalidate 
isync Instruction Synchronize 
lbz Load Byte and Zero 
lbzu Load Byte and Zero with Update 
lbzux Load Byte and Zero with Update Indexed 
lbzx Load Byte and Zero Indexed 
ld Load Doubleword 
ldarx Load Doubleword And Reserve Indexed 
ldu Load Doubleword with Update 
ldux Load Doubleword with Update Indexed 
ldx Load Doubleword Indexed 
lfd Load Floating-Point Double 
lfdu Load Floating-Point Double with Update 
lfdux Load Floating-Point Double with Update Indexed 
lfdx Load Floating-Point Double Indexed 
lfs Load Floating-Point Single 
lfsu Load Floating-Point Single with Update 
lfsux Load Floating-Point Single with Update Indexed 
lfsx Load Floating-Point Single Indexed 
lha Load Halfword Algebraic 
lhau Load Halfword Algebraic with Update 
lhaux Load Halfword Algebraic with Update Indexed 
lhax Load Halfword Algebraic Indexed 
lhbrx Load Halfword Byte-Reverse Indexed 
lhz Load Halfword and Zero 
lhzu Load Halfword and Zero with Update 
lhzux Load Halfword and Zero with Update Indexed 
lhzx Load Halfword and Zero Indexed 
li        Load Immediate
lis        Load Immediate shift
lmw Load Multiple Word 
lswi Load String Word Immediate 
lswx Load String Word Indexed 
lwa Load Word Algebraic 
lwarx Load Word And Reserve Indexed 
lwaux Load Word Algebraic with Update Indexed 
lwax Load Word Algebraic Indexed 
lwbrx Load Word Byte-Reverse Indexed 
lwz Load Word and Zero 
lwzu Load Word and Zero with Update 
lwzux Load Word and Zero with Update Indexed 
lwzx Load Word and Zero Indexed 
mcrf Move Condition Register Field 
mcrfs Move to Condition Register from FPSCR 
mcrxr Move to Condition Register from XER 
mfcr Move From Condition Register 
mffs[ .] Move From FPSCR 
mflr       Move from link register
mfmsr Move From Machine State Register 
mfocrf Move From One Condition Register Field 
mfspr Move From Special Purpose Register 
mfsr Move From Segment Register 
mfsrin Move From Segment Register Indirect 
mftb Move From Time Base 
mr        Move Register
mtcrf Move To Condition Register Fields 
mtctr     Move to count register
mtfsb0[ .] Move To FPSCR Bit 0 
mtfsb1[ .] Move To FPSCR Bit 1 
mtfsf[ .] Move To FPSCR Fields 
mtfsfi[ .] Move To FPSCR Field Immediate 
mtmsr Move To Machine State Register 
mtmsrd Move To Machine State Register Doubleword 
mtocrf Move To One Condition Register Field 
mtspr Move To Special Purpose Register 
mtsr Move To Segment Register 
mtsrin Move To Segment Register Indirect 
mulhd[ .] Multiply High Doubleword 
mulhdu[ .] Multiply High Doubleword Unsigned 
mulhw[ .] Multiply High Word 
mulhwu[ .] Multiply High Word Unsigned 
mulld[ o][ .] Multiply Low Doubleword 
mulli Multiply Low Immediate 
mullw[ o][ .] Multiply Low Word 
nand[ .] NAND 
neg[ o][ .] Negate 
nor[ .] NOR 
or[ .] OR 
orc[ .] OR with Complement 
ori OR Immediate 
oris OR Immediate Shifted 
rfid Return from Interrupt Doubleword 
rldcl[ .] Rotate Left Doubleword then Clear Left 
rldcr[ .] Rotate Left Doubleword then Clear Right 
rldic[ .] Rotate Left Doubleword Immediate then Clear 
rldicl[ .] Rotate Left Doubleword Immediate then Clear Left 
rldicr[ .] Rotate Left Doubleword Immediate then Clear Right 
rldimi[ .] Rotate Left Doubleword Immediate then Mask Insert 
rlwimi[ .] Rotate Left Word Immediate then Mask Insert 
rlwinm[ .] Rotate Left Word Immediate then AND with Mask 
rlwnm[ .] Rotate Left Word then AND with Mask 
sc System Call 
slbia SLB Invalidate All 
slbie SLB Invalidate Entry 
slbmfee SLB Move From Entry ESID 
slbmfev SLB Move From Entry VSID 
slbmte SLB Move To Entry 
sld[ .] Shift Left Doubleword 
slw[ .] Shift Left Word 
srad[ .] Shift Right Algebraic Doubleword 
sradi[ .] Shift Right Algebraic Doubleword Immediate 
sraw[ .] Shift Right Algebraic Word 
srawi[ .] Shift Right Algebraic Word Immediate 
srd[ .] Shift Right Doubleword 
srw[ .] Shift Right Word 
srwi      Shift Right Immediate
stb Store Byte 
stbu Store Byte with Update 
stbux Store Byte with Update Indexed 
stbx Store Byte Indexed 
std Store Doubleword 
stdcx. Store Doubleword Conditional Indexed 
stdu Store Doubleword with Update 
stdux Store Doubleword with Update Indexed 
stdx Store Doubleword Indexed 
stfd Store Floating-Point Double 
stfdu Store Floating-Point Double with Update 
stfdux Store Floating-Point Double with Update Indexed 
stfdx Store Floating-Point Double Indexed 
stfiwx Store Floating-Point as Integer Word Indexed 
stfs Store Floating-Point Single 
stfsu Store Floating-Point Single with Update 
stfsux Store Floating-Point Single with Update Indexed 
stfsx Store Floating-Point Single Indexed 
sth Store Halfword 
sthbrx Store Halfword Byte-Reverse Indexed 
sthu Store Halfword with Update 
sthux Store Halfword with Update Indexed 
sthx Store Halfword Indexed 
stmw Store Multiple Word 
stswi Store String Word Immediate 
stswx Store String Word Indexed 
stw Store Word 
stwbrx Store Word Byte-Reverse Indexed 
stwcx. Store Word Conditional Indexed 
stwu Store Word with Update 
stwux Store Word with Update Indexed 
stwx Store Word Indexed 
subf[ o][ .] Subtract From 
subfc[ o][ .] Subtract From Carrying 
subfe[ o][ .] Subtract From Extended 
subfic Subtract From Immediate Carrying 
subfme[ o][ .] Subtract From Minus One Extended 
subfze[ o][ .] Subtract From Zero Extended 
sync Synchronize 
td Trap Doubleword 
tdi Trap Doubleword Immediate 
tlbia TLB Invalidate All 
tlbie TLB Invalidate Entry 
tlbsync TLB Synchronize 
tw Trap Word 
twi Trap Word Immediate 
xor[ .] XOR 
xori XOR Immediate 
xoris XOR Immediate Shifted 
mtlr      Move to link register
mfpvr     Move from processor version register
