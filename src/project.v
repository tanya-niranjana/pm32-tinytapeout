/*
 * Copyright (c) 2024 Tanya Sharma
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_tanya_pm32 (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

  wire [3:0] A;
  wire [3:0] B;
  wire [7:0] product;

  assign A = ui_in[3:0];
  assign B = ui_in[7:4];

  PM32 mult (
      .A(A),
      .B(B),
      .P(product)
  );

  assign uo_out  = product;
  assign uio_out = 8'b00000000;
  assign uio_oe  = 8'b00000000;

  wire _unused = &{uio_in, ena, clk, rst_n, 1'b0};

endmodule

`default_nettype wire
