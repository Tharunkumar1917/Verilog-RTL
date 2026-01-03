module simple_traffic_fsm (
    input wire clk,
    input wire rst,
    output reg red,
    output reg yellow,
    output reg green
);

    // Define states
    typedef enum logic [1:0] {
        S_RED    = 2'd0,
        S_GREEN  = 2'd1,
        S_YELLOW = 2'd2
    } state_t;

    state_t state, next_state;
    reg [3:0] timer;   // simple counter for timing

    // State transition
    always @(posedge clk) begin
        if (rst) begin
            state <= S_RED;
            timer <= 5;
        end else begin
            if (timer == 0) begin
                state <= next_state;
                case (next_state)
                    S_RED:    timer <= 5;
                    S_GREEN:  timer <= 5;
                    S_YELLOW: timer <= 2;
                endcase
            end else begin
                timer <= timer - 1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S_RED:    next_state = S_GREEN;
            S_GREEN:  next_state = S_YELLOW;
            S_YELLOW: next_state = S_RED;
            default:  next_state = S_RED;
        endcase
    end

    // Output logic
    always @(*) begin
        red    = (state == S_RED);
        green  = (state == S_GREEN);
        yellow = (state == S_YELLOW);
    end

endmodule
