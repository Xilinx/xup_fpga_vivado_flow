//-----------------------------------------------------------------------------
//  
// MIT License
// Copyright (c) 2022 Advanced Micro Devices, Inc. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// SOFTWARE.
//
//  Project  : Programmable Wave Generator
//  Module   : clk_div.v
//  Parent   : wave_gen.v
//  Children : None
//
//  Description: 
//     This module is a programmable divider use for generating the sample
//     clock (clk_samp). It continuously counts down from pre_clk_tx-1 to
//     0, asserting en_clk_samp during the 0 count.
//
//     To ensure proper reset of the FFs running on the derived clock,
//     en_clk_samp is asserted during reset.
//
//  Parameters:
//
//  Notes       : 
//     pre_clk_tx must be at least 2 for this module to work. Since
//     it is not allowed to be <32 (by the parser), this is not a problem.
//
//  Multicycle and False Paths
//     None

`timescale 1ns/1ps


module clk_div (
  input             clk_tx,          // Clock input
  input             rst_clk_tx,      // Reset - synchronous to clk_tx
  
  input      [15:0] pre_clk_tx,      // Current divider
  output reg        en_clk_samp      // Clock enable for BUFG
);

//***************************************************************************
// Function definitions
//***************************************************************************

//***************************************************************************
// Parameter definitions
//***************************************************************************


//***************************************************************************
// Reg declarations
//***************************************************************************

  reg [15:0]             cnt;            // Counter

//***************************************************************************
// Wire declarations
//***************************************************************************
  
//***************************************************************************
// Code
//***************************************************************************

  always @(posedge clk_tx)
  begin
    if (rst_clk_tx)
    begin
      en_clk_samp    <= #5 1'b1;    // Enable the clock during reset
      cnt            <= 16'b0;
    end
    else // !rst
    begin
      // Since we want en_clk_samp to be 1 when cnt is 0 we compare
      // it to 1 on the clock before
      en_clk_samp <= #5 (cnt == 16'b1);

      if (cnt == 0) // The counter expired and we are still not equal
      begin
        cnt <= pre_clk_tx - 1'b1;
      end
      else // The counter is not 0
      begin
        cnt <= cnt - 1'b1; // decrement it
      end
    end // if rst
  end // always

endmodule
