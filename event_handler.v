module event_handler (
    input wire clk,
    input wire reset,      // Active high synchronous reset
    input wire button,     // Button input
    output reg [3:0] count // 4-bit event counter
);

    // FSM states
    parameter IDLE  = 2'b00;
    parameter COUNT = 2'b01;
    parameter WAIT  = 2'b10;

    reg [1:0] state, next_state;

    // Edge detection
    reg button_prev;
    wire button_rising = ~button_prev & button;

    // FSM and counter logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            button_prev <= 0;
        end else begin
            state <= next_state;
            button_prev <= button;

            if (state == COUNT)
                count <= count + 1;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = button_rising ? COUNT : IDLE;
            COUNT: next_state = WAIT;
            WAIT:  next_state = button ? WAIT : IDLE;
            default: next_state = IDLE;
        endcase
    end
endmodule
