// Verilog code for the 4-bit pipelined ALU

// define clock,reset signals and input signals A B which are 4 bit data.

module pipe_ALU(input clk,
                input rst,
                input [3:0]A,
                input [3:0]B,
                input [2:0]ALU_sel,
                output reg [3:0]alu_result,
                output reg carry_out);                        

// -----inputs to be stored in input register------- 

  reg [3:0]A_reg,B_reg;        // register inputs
  reg [2:0]ALU_sel_reg;        //opcode stored in input register

// --- output of the ALU block which is stored in output register
  reg [3:0]alu_out;                
  reg carry_out_reg;

// -----Stage-1 : Input Register -----
  always @(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          A_reg<=4'b0000;
          B_reg<=4'b0000;
          ALU_sel_reg<=3'b000;
          end else begin
          A_reg<=A;
          B_reg<=B;
          ALU_sel_reg<=ALU_sel;
        end
    end

// ------Stage-2 : ALU computation block-------
  always @(*)
    begin
      alu_out=4'b0000;        //initial value is 0
      carry_out_reg=1'b0;
      case(ALU_sel_reg)
        3'b000 : {carry_out_reg,alu_out}=A_reg+B_reg; //addition
        3'b001 :{carry_out_reg,alu_out}=A_reg-B_reg; //subtraction
        3'b010 : alu_out=A_reg&B_reg;                //AND operation
        3'b011 : alu_out=A_reg|B_reg;                //OR operation
        3'b100 :alu_out=A_reg^B_reg;                //XOR operation
        3'b101 : alu_out=(A_reg>B_reg)?4'b0001:4'b0000;        //greater than or less than
        3'b110 :alu_out=(A_reg==B_reg)?4'b0001:4'b0000;        //equal to or not
        default : begin
          alu_out=4'b0000;
                        carry_out_reg=1'b0;
        end
      endcase
    end

 // ------Stage-3 : Output Register------- 
  always @(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          alu_result<=4'b0000;
          carry_out<=1'b0;
        end
      else
        begin
          alu_result<=alu_out;
          carry_out<=carry_out_reg;
        end
    end
endmodule
