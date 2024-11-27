/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : ACC_small.v
  - Description      : MAC(Multiply + Add + Accumulate) w/3 taps
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/
module ACC_small(
    input iClk_12M,
    input iRsn,
    input [3:0] iEnMul,
    input iEnAdd,
    input iEnAcc,
    input signed [15:0] iCoeff,  // 16-bit Coefficient
    input signed [2:0] iDelay1,
    input signed  [2:0] iDelay2,
    input signed  [2:0] iDelay3,
    output signed [15:0] oMac    // 16-bit Output
);

    /*****************************/
    // reg declaration
    /*****************************/
    reg signed [15:0] rAccOut;    // Accumulated Value
    reg signed [15:0] rMul;       // Current Multiplier Output
    reg [15:0] rVal;       // Intermediate Accumulated Value
    reg signed [15:0] wAccOut;   // Current Accumulation Result
    /*****************************/
    // wire declaration
    /*****************************/
    wire signed [15:0] wMul1;
    wire signed [15:0] wMul2;
    wire signed [15:0] wMul3;


    /*****************************/
    // Multiplier Logic
    /*****************************/
    assign wMul1  = iDelay1  * iCoeff;
    assign wMul2  = iDelay2  * iCoeff;
    assign wMul3  = iDelay3  * iCoeff;

    /*****************************/
    // Accumulation Logic
    /*****************************/
    always @(*) begin
        case (iEnMul)
            4'b0001: rMul = wMul1;
            4'b0010: rMul = wMul2;
            4'b0011: rMul = wMul3;
            default: rMul = 16'h0; // Default to 0 for invalid iEnMul
        endcase
    end

    	// Accumulator 동작
	always@(*) begin
		if(!iRsn) begin
			wAccOut <= 16'h0;
		end else if(iEnAdd) begin
			wAccOut <= rVal + rMul;
		end
		else begin
			wAccOut <= 16'h0;
		end
	end

	always @(*) begin
		if(!iRsn) begin
		rVal  <= 16'h0;
		end
		else if(iEnMul == 1'b1) begin
			rVal <= 16'h0;		
			end		
		else begin
			rVal <= rAccOut;
		end
	end
		
	//Coefficient값이 지금 다 unsigned로 구현해서 -> signed로 구현하는거  
	always @(posedge iClk_12M) begin
		if(!iRsn) 
		begin
			rAccOut <= 16'h0;
		end
		else begin
			if(iEnAcc) rAccOut  <= wAccOut;
		end
	end




    /*****************************/
    // Output Assignment
    /*****************************/
    assign oMac = rAccOut;

endmodule
