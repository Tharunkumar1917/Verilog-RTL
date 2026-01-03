// =======================================================
// TOP MODULE
// =======================================================
module MUL_top (
    input clk,
    input start,
    input [7:0] data_in,
    output done,
    output [15:0] product
);

    wire ldA, ldB, ldP, clrP, decB, eqz;

    // Datapath
    MUL_datapath DP (
        .clk(clk),
        .data_in(data_in),
        .ldA(ldA),
        .ldB(ldB),
        .ldP(ldP),
        .clrP(clrP),
        .decB(decB),
        .eqz(eqz),
        .product(product)
    );

    // Controller
    MUL_controller CON (
        .clk(clk),
        .start(start),
        .eqz(eqz),
        .ldA(ldA),
        .ldB(ldB),
        .ldP(ldP),
        .clrP(clrP),
        .decB(decB),
        .done(done)
    );

endmodule


// =======================================================
// DATAPATH MODULE
// =======================================================
module MUL_datapath (
    input clk,
    input [7:0] data_in,
    input ldA, ldB, ldP, clrP, decB,
    output eqz,
    output reg [15:0] product
);

    reg [15:0] A;
    reg [7:0]  B;

    // Zero detect for multiplier register
    assign eqz = (B == 0);

    always @(posedge clk) begin
        if (ldA)
            A <= {8'b0, data_in};   // Load multiplicand

        if (ldB)
            B <= data_in;           // Load multiplier

        if (clrP)
            product <= 0;

        if (ldP) begin
            if (B[0])
                product <= product + A;
        end

        if (decB) begin
            A <= A << 1;            // Shift left multiplicand
            B <= B >> 1;            // Shift right multiplier
        end
    end

endmodule


// =======================================================
// CONTROLLER (FSM)
// =======================================================
module MUL_controller (
    input clk,
    input start,
    input eqz,
    output reg ldA, ldB, ldP, clrP, decB, done
);

    reg [2:0] state;

    // State encoding
    parameter IDLE = 3'b000,
              LOAD = 3'b001,
              CALC = 3'b010,
              DONE = 3'b011;

    always @(posedge clk) begin
        case (state)

            IDLE: begin
                done <= 0;
                if (start)
                    state <= LOAD;
            end

            LOAD: begin
                ldA  <= 1;
                ldB  <= 1;
                clrP <= 1;
                state <= CALC;
            end

            CALC: begin
                ldA  <= 0;
                ldB  <= 0;
                clrP <= 0;
                ldP  <= 1;
                decB <= 1;

                if (eqz)
                    state <= DONE;
            end

            DONE: begin
                ldP  <= 0;
                decB <= 0;
                done <= 1;
                state <= IDLE;
            end

            default: state <= IDLE;
        endcase
    end

endmodule
