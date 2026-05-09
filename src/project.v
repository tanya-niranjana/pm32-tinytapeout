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

  wire rst;
  wire start;
  wire done;
  wire [63:0] product;

  assign rst = ~rst_n;
  assign start = ui_in[0];

  pm32 multiplier (
      .clk(clk),
      .rst(rst),
      .start(start),
      .mc({24'b0, uio_in}),
      .mp({24'b0, ui_in}),
      .p(product),
      .done(done)
  );

  assign uo_out = product[7:0];

  assign uio_out = {7'b0, done};
  assign uio_oe  = 8'b11111111;

  wire _unused = &{ena, product[63:8], 1'b0};

endmodule

`default_nettype wire
