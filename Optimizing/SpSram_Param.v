/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : SpSram_Param.v
  - Description      : SpSram with parameterized size
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/
`timescale 1ns/10ps

module SpSram_Param #(
  parameter DATA_WIDTH = 16,  // Data width
  parameter ADDR_DEPTH = 10   // Address depth
)(
  // Clock & reset
  input                    iClk_12M,            // Rising edge
  input                    iRsn,               // Sync. & low reset

  // SP-SRAM Input & Output
  input                    iCsnRam,            // Chip selected @ low
  input                    iWrnRam,            // 0: Write, 1: Read
  input [$clog2(ADDR_DEPTH)-1:0] iAddrRam,      // Data address
  input signed [DATA_WIDTH-1:0] iWrDtRam,       // Write data

  output signed [DATA_WIDTH-1:0] oRdDtRam       // Read data
);

  // Integer declaration
  integer          i;

  // wire & reg declaration
  reg  [DATA_WIDTH-1:0] rMem [1:ADDR_DEPTH]; // Memory array
  reg  [DATA_WIDTH-1:0] rRdDt;

  /*************************************************************/
  // SP-SRAM function
  /*************************************************************/
  // rMem write operation
  always @(posedge iClk_12M)
  begin
    // Synchronous & low reset
    if (!iRsn)
    begin
      for (i = 1; i <= ADDR_DEPTH; i = i + 1)
      begin
        rMem[i] <= {DATA_WIDTH{1'b0}};
      end
    end
    // Write condition
    else if (iCsnRam == 1'b0 && iWrnRam == 1'b0)
    begin
      rMem[iAddrRam] <= iWrDtRam;
    end
  end

  // rMem read operation
  always @(posedge iClk_12M)
  begin
    // Synchronous & low reset
    if (!iRsn)
    begin
      rRdDt <= {DATA_WIDTH{1'b0}};
    end
    // Read condition
    else if (iCsnRam == 1'b0 && iWrnRam == 1'b1)
    begin
      rRdDt <= rMem[iAddrRam];
    end
  end

  // Output mapping
  assign oRdDtRam = rRdDt;

endmodule
