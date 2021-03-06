// Name: alu.v
// Module: simp_alu_comb
// Input: op1[32] - operand 1
//        op2[32] - operand 2
//        oprn[6] - operation code
// Output: result[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Sep 06, 2014	Kaushik Patra	kpatra@sjsu.edu		Fixed encoding for not and slt
//  1.2     Sep 08, 2014	Kaushik Patra	kpatra@sjsu.edu		Changed logical operation to bitwise operation for and, or, nor.
//------------------------------------------------------------------------------------------
//
//Make reference to use the prj_definition.v file as a module
// backtick to define global variable. 
`include "prj_definition.v"
//Declare a module, and end it with endmodule.
module alu(result, op1, op2, oprn);
//Square brackets are used to defined a data bus. 
//For example, the code below declare a mDataBus input port of 16 bit data, from 0 to 15. 
//input [15:0] mDataBus;
// input list
input [`DATA_INDEX_LIMIT:0] op1; // operand 1, 32 bit data input bus
input [`DATA_INDEX_LIMIT:0] op2; // operand 2, 32 bit data input bus
input [`ALU_OPRN_INDEX_LIMIT:0] oprn; // operation code, 6 bit data input bus

// output list
output [`DATA_INDEX_LIMIT:0] result; // result of the operation, 32 bit data input bus. 
//Beside input and output ports, Verilog also support bi-directional port, inout

// simulator internal storage - this is not h/w register
reg [`DATA_INDEX_LIMIT:0] result; 
// In hardware, there are 2 types of data type: register (reg) and wire (wire)
// reg: register data type is used for storing values.
// wire: wire data type is used for connecting two points. 
// To facilitate code readability, it can be helpful to name register the same as it port, for example to store its value.
// For wire, its name can be a combination of the 2 points it connects with. 

// Whenever op1, op2 or oprn changes do something
// An always block executes always. An always block should have a sensitive list or a delay associated with it.
// The sensitive list determine input variable, which trigger the block when changes occur. 
// There are 2 types of sensitive list: level-sensitive (for combinational circuits) and edge sensitive (for flip-flops)
always @ (op1 or op2 or oprn)
begin
    case (oprn)
        `ALU_OPRN_WIDTH'h01 : result = op1 + op2; // addition
	`ALU_OPRN_WIDTH'h02 : result = op1 - op2; // subtraction
	`ALU_OPRN_WIDTH'h03 : result = op1 * op2; // multiplication
	`ALU_OPRN_WIDTH'h04 : result = op1 << op2; // shift_right
	`ALU_OPRN_WIDTH'h05 : result = op1 >> op2; // shift_left
	`ALU_OPRN_WIDTH'h06 : result = op1 & op2; // and
	`ALU_OPRN_WIDTH'h07 : result = op1 | op2; // or
	`ALU_OPRN_WIDTH'h08 : result = ~(op1 | op2); // not
	`ALU_OPRN_WIDTH'h09 : result = (op1 < op2)? `ALU_OPRN_INDEX_LIMIT'b1 : `ALU_OPRN_INDEX_LIMIT'b0; // set less than
 
        default: result = `DATA_WIDTH'hxxxxxxxx;
                 
    endcase
end
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//begin and end keywords act as curly braces in other languages.
//The definition of constants in Verilog supports the addition of a width parameter. The basic syntax is: 
// <width in bits>'<base letter><numer>
//e.g. `ALU_OPRN_WIDTH'h01 means a 6 bit hexadecimal value 000001
//The base letter can be b for binary, h for hexadecimal or d for decimal 

endmodule
//Reference list: 
//Verilog Tutorial (http://www.asic-world.com/verilog/verilog_one_day.html)
//always blocks (http://www.asic-world.com/verilog/verilog_one_day3.html)
//Wiki on definition of constants (https://en.wikipedia.org/wiki/Verilog)
//ASIC-world (http://www.asic-world.com/verilog/syntax2.html)