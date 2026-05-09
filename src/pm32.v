`timescale 1ns/1ps
`default_nettype none

module pm32 (
    input wire          clk,
    input wire          rst,
    input wire          start,
    input wire  [31:0]  mc,
    input wire  [31:0]  mp,
    output reg  [63:0]  p,
    output wire         done
);

    wire        pw;
    reg [31:0] Y;
    reg [7:0]  cnt, ncnt;
    reg [1:0]  state, nstate;

    localparam IDLE    = 2'd0;
    localparam RUNNING = 2'd1;
    localparam DONE    = 2'd2;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= nstate;
    end

    always @* begin
        case (state)
            IDLE:    if (start) nstate = RUNNING; else nstate = IDLE;
            RUNNING: if (cnt == 8'd64) nstate = DONE; else nstate = RUNNING;
            DONE:    if (start) nstate = RUNNING; else nstate = DONE;
            default: nstate = IDLE;
        endcase
    end

    always @(posedge clk) begin
        cnt <= ncnt;
    end

    always @* begin
        case (state)
            IDLE:    ncnt = 8'd0;
            RUNNING: ncnt = cnt + 8'd1;
            DONE:    ncnt = 8'd0;
            default: ncnt = 8'd0;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            Y <= 32'b0;
        else if (start)
            Y <= mp;
        else if (state == RUNNING)
            Y <= (Y >> 1);
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            p <= 64'b0;
        else if (start)
            p <= 64'b0;
        else if (state == RUNNING)
            p <= {pw, p[63:1]};
    end

    wire y;
    assign y = (state == RUNNING) ? Y[0] : 1'b0;

    spm #(.SIZE(32)) spm32 (
        .clk(clk),
        .rst(rst),
        .x(mc),
        .y(y),
        .p(pw)
    );

    assign done = (state == DONE);

endmodule

`default_nettype wire
