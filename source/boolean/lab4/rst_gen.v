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
//  Module   : rst_gen.v
//  Parent   : wave_gen.v
//  Children : reset_bridge.v
//
//  Description: 
//     This module is the reset generator for the design.
//     It takes the asynchronous reset in (from the IBUF), and generates
//     three synchronous resets - one on each clock domain.
//
//  Parameters:
//     None
//
//  Notes       : 
//
//  Multicycle and False Paths
//     None

`timescale 1ns/1ps


module rst_gen (
  input             clk_rx,          // Receive clock
  input             clk_tx,          // Transmit clock
  input             clk_samp,        // Sample clock

  input             rst_i,           // Asynchronous input - from IBUF
  input             clock_locked,    // Locked signal from clk_core

  output            rst_clk_rx,      // Reset, synchronized to clk_rx
  output            rst_clk_tx,      // Reset, synchronized to clk_tx
  output            rst_clk_samp     // Reset, synchronized to clk_samp
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

//***************************************************************************
// Wire declarations
//***************************************************************************

  wire int_rst;
  
//***************************************************************************
// Code
//***************************************************************************

  // Generate the internal reset - it is asserted whenever the reset pin
  // is asserted, or the DCM is not locked
  assign int_rst = rst_i || !clock_locked;

  // Instantiate the reset bridges

  // For clk_rx
  reset_bridge reset_bridge_clk_rx_i0 (
    .clk_dst   (clk_rx),
    .rst_in    (int_rst),
    .rst_dst   (rst_clk_rx)
  );

  // For clk_tx
  reset_bridge reset_bridge_clk_tx_i0 (
    .clk_dst   (clk_tx),
    .rst_in    (int_rst),
    .rst_dst   (rst_clk_tx)
  );
  

  // For clk_samp
  reset_bridge reset_bridge_clk_samp_i0 (
    .clk_dst   (clk_samp),
    .rst_in    (int_rst),
    .rst_dst   (rst_clk_samp)
  );

endmodule
