#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
ָ��  ����  ����� CPU / ע��  
ADC  ����λ�ļӷ�  -   
ADD  �ӷ�  -   
AND  �߼���  -   
ASL  ��������  ����һ��ѡ�����ָ��   
ASR  ��������  ����һ��ѡ�����ָ��   
B  ��֧  -   
BIC  λ���  -   
BL  �����ӵķ�֧  -   
BX  ��֧�� Thumb ����  StrongARM SA1110 ?  
CDP  Э���������ݲ���  -   
CMN  �Ƚ�ȡ����ֵ  -   
CMP  �Ƚ�ֵ  -   
EOR  �������ֵ  -   
LDC  װ���ڴ浽Э������  -   
LDM  װ�ض���Ĵ���  -   
LDR  װ�ؼĴ���  -   
LDRB  װ���ֽڵ��Ĵ���  -   
LDRH  װ�ذ��ֵ��Ĵ���  StrongARM  
LDRSB  װ���з����ֽڵ��Ĵ���  StrongARM   
LDRSH  װ���з��Ű��ֵ��Ĵ���  StrongARM    
LSL  �߼�����  ����һ��ѡ�����ָ��  
LSR  �߼�����  ����һ��ѡ�����ָ��  
MCR  Э�������Ĵ�������  -  
MLA  ���ۼӵĳ˷�  -   
MOV  ����ֵ/�Ĵ�����һ���Ĵ���  -   
MRC  Э�������Ĵ�������  -   
MRS  ����״̬��־��һ���Ĵ���  ARM 6   
MSR  ����һ���Ĵ��������ݵ�״̬��־  ARM 6   
MUL  �˷�  -   
MVN  ����ȡ����(ֵ)  -   
ORR  �߼���  -   
ROR  ѭ������  ����һ��ѡ�����ָ��    
RRX  ����չ��ѭ������  ����һ��ѡ�����ָ��    
RSB  �������  -    
RSC  ����λ�ķ������  -    
SBC  ����λ�ļ���  -    
SMLAL  ���ۼӵ��з��ų�(64 λ)�˷�  StrongARM    
SMULL  �з��ų�(64 λ)�˷�  StrongARM    
STC  Э���������ݴ���  -    
STM  �洢����Ĵ���  -    
STR  �洢һ���Ĵ���  -    
STRB  �洢һ���ֽ�(��һ���Ĵ���)  -    
STRH  �洢һ������(��һ���Ĵ���)  StrongARM    
STRSB  �洢һ���з����ֽ�(��һ���Ĵ���)  StrongARM    
STRSH  �洢һ���з��Ű���(��һ���Ĵ���)  StrongARM    
SUB  ����  -    
SWI  ����һ�������ж�  -    
SWP  �����Ĵ������ڴ�  ARM 3    
TEQ  ���Եȼ�(�����ϵ� EOR)  -    
TST  ���Բ�����(�����ϵ� AND)  -    
UMLAL  ���ۼӵ��޷��ų�(64 λ)�˷�  StrongARM    
UMULL  �޷��ų�(64 λ)�˷�  StrongARM    
STMFD           SP!, {R4-R8,LR} ; Store Block to Memory #����Ĵ����� ���ڴ�. 