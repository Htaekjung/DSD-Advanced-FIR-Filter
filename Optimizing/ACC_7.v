/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : ACC.v
  - Description      : MAC(Multiply + Add + Accumulate) w/ 10 taps
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/
module ACC_7 #(              // Number of taps (default: 10)
    parameter COEFF_WIDTH = 16,        // Coefficient width (default: 16 bits)
    parameter DATA_WIDTH = 16         // Data width for input and output (default: 16 bits)
)(
    input iClk_12M,
    input iRsn,
    input [3:0] iEnMul,               // Enable for specific multiplier (up to TAPS)
    input iEnAdd,
    input iEnAcc,
    input signed [COEFF_WIDTH-1:0] iCoeff,  // Coefficient input
    input signed [DATA_WIDTH-1:0] iDelay1,
    input signed [DATA_WIDTH-1:0] iDelay2,
    input signed [DATA_WIDTH-1:0] iDelay3,
    input signed [DATA_WIDTH-1:0] iDelay4,
    input signed [DATA_WIDTH-1:0] iDelay5,
    input signed [DATA_WIDTH-1:0] iDelay6,
    input signed [DATA_WIDTH-1:0] iDelay7,
    output signed [DATA_WIDTH-1:0] oMac    // Output accumulator result
);

    /*****************************/
    // reg declaration
    /*****************************/
    reg signed [DATA_WIDTH-1:0] rAccOut;    // Accumulated Value
    reg signed [DATA_WIDTH-1:0] rMul;       // Current Multiplier Output
    reg [DATA_WIDTH-1:0] rVal;              // Intermediate Accumulated Value
    reg signed [DATA_WIDTH-1:0] wAccOut;    // Current Accumulation Result
    /*****************************/
    // wire declaration
    /*****************************/
    wire signed [DATA_WIDTH-1:0] wMul1;
    wire signed [DATA_WIDTH-1:0] wMul2;
    wire signed [DATA_WIDTH-1:0] wMul3;
    wire signed [DATA_WIDTH-1:0] wMul4;
    wire signed [DATA_WIDTH-1:0] wMul5;
    wire signed [DATA_WIDTH-1:0] wMul6;
    wire signed [DATA_WIDTH-1:0] wMul7;


    /*****************************/
    // Multiplier Logic
    /*****************************/
    assign wMul1  = iDelay1  * iCoeff;
    assign wMul2  = iDelay2  * iCoeff;
    assign wMul3  = iDelay3  * iCoeff;
    assign wMul4  = iDelay4  * iCoeff;
    assign wMul5  = iDelay5  * iCoeff;
    assign wMul6  = iDelay6  * iCoeff;
    assign wMul7  = iDelay7  * iCoeff;

    /*****************************/
    // Accumulation Logic
    /*****************************/
    always @(*) begin
        case (iEnMul)
            4'b0001: rMul = wMul1;
            4'b0010: rMul = wMul2;
            4'b0011: rMul = wMul3;
            4'b0100: rMul = wMul4;
            4'b0101: rMul = wMul5;
            4'b0110: rMul = wMul6;
            4'b0111: rMul = wMul7;
            default: rMul = {DATA_WIDTH{1'b0}}; // Default to 0 for invalid iEnMul
        endcase
    end

    // Accumulator 동작
    always @(*) begin
        if (!iRsn) begin
            wAccOut <= {DATA_WIDTH{1'b0}};  // Reset accumulator output to zero
        end else if (iEnAdd) begin
            wAccOut <= rVal + rMul;
        end else begin
            wAccOut <= {DATA_WIDTH{1'b0}};  // Reset if no addition enabled
        end
    end

    always @(*) begin
        if (!iRsn) begin
            rVal <= {DATA_WIDTH{1'b0}};  // Reset rVal on reset
        end else if (iEnMul == 1'b1) begin
            rVal <= {DATA_WIDTH{1'b0}};   // Reset rVal on multiplier enable
        end else begin
            rVal <= rAccOut;  // Pass the accumulator output to rVal
        end
    end

    // Coefficient값이 signed로 구현되도록 수정
    always @(posedge iClk_12M) begin
        if (!iRsn) begin
            rAccOut <= {DATA_WIDTH{1'b0}};  // Reset accumulator on reset
        end else begin
            if (iEnAcc) rAccOut <= wAccOut;  // Accumulate the result if enabled
        end
    end

    /*****************************/
    // Output Assignment
    /*****************************/
    assign oMac = rAccOut;  // Assign the accumulator result to the output

endmodule
