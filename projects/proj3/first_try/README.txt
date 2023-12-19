Morgan Noonan
Men83
men83@pitt.edu
Everything
None known

Instruction Signals:
	determined by the opcode 1 per instruction
	(add, addui, addi, mflo, etc...)
Decoded Instruction:
	signals derived from instruction
	(opcode, rs, rt, imm, subop)
ALU outputs:
	outputs of the ALU
	(ALUOut, Hi, Lo, GT, Z, LT)
redDataSrc: selects what data is going into the register file
ALUbSRC: whether ALU second input is from register or immediate
Func: operation for ALU
DataRA: data in register from rs
DataRB: data in register form rt
weReg: write enable for register file
Imm16: immediate extended to 16 bits (zero or signed)
PC: current program counter
PC+1: next instruction in memory (for jal)
Branch: 1 if branch condition is satisfied
DataMemOut: data at selected address in memory