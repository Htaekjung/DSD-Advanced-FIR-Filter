/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : SpSram_10x16.v
  - Description      : SpSram that can store 10 of 16-bits coefficient 
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/
`timescale 1ns/10ps

module SpSram_10x16(

  // Clock & reset
  input            iClk_12M,            // Rising edge
  input            iRsn,               // Sync. & low reset

  // SP-SRAM Input & Output
  input            iCsnRam,            // Chip selected @ low
  input            iWrnRam,            // 0: Write, 1: Read
  input  [3:0]     iAddrRam,           // 16-bit data address
  input signed [15:0] iWrDtRam,           // Write data

  output signed [15:0] oRdDtRam            // Read data
);

  // Integer declaration
  integer          i;

  // wire & reg declaration
  reg  [15:0]      rMem[1:10];          // 10*16 array
  reg  [15:0]      rRdDt;

  /*************************************************************/
  // SP-SRAM function
  /*************************************************************/
  // rMem write operation
  always @(posedge iClk_12M)
  begin
    // Synchronous & low reset
    if (!iRsn)
    begin
      for (i=1 ; i<=10 ; i=i+1)
      begin
        rMem[i] <= 16'h0;
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
      rRdDt <= 16'h0;
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

	
	
	
	
	
	
	
		
				
		
			
				