/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : Controller.v
  - Description      : Controller w/FSM
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/
module Controller(
    input iClk_12M,
    input iRsn,
    input iEnSample_600k,
    input iCsnRam,
    input iWrnRam,
    input iCoeffiUpdateFlag,
    input [3:0] iAddrRam_neg,
    input [3:0] iAddrRam_pos,
    input signed [15:0] iWrDtRam,
    input [5:0] iNumOfCoeff,
    output [3:0] oEnMul1, oEnMul2, // Selection_pos 용도
    output oEnAdd1, oEnAdd2,
    output oEnAcc1, oEnAcc2,
    output oCsnRam1, oCsnRam2,
    output oWrnRam1, oWrnRam2,
    output signed [15:0] oWrDtRam1, oWrDtRam2,
    output [3:0] oAddrRam_neg, oAddrRam_pos,
    output oEnDelay
);
    parameter p_Idle = 3'b000,
              p_SpSram = 3'b001,
              p_Acc = 3'b010,
              p_Sum = 3'b011;

    reg [2:0] rCurState;
    reg [2:0] rNxtState;
    reg [3:0] Selection_pos;
    reg [3:0] Selection_neg;
    reg rEnAddDelay;
    reg rEnAccDelay;

    // Current state update
    always @(posedge iClk_12M) begin
        if (!iRsn)
            rCurState <= p_Idle;
        else
            rCurState <= rNxtState;
    end

    // Next state decision
    always @(*) begin
        case (rCurState)
            p_Idle://0
                rNxtState <= (iCoeffiUpdateFlag && !iCsnRam && !iWrnRam) ? p_SpSram : p_Idle;

            p_SpSram://1
                rNxtState <= (!iCoeffiUpdateFlag && iWrnRam) ? p_Acc : p_SpSram;

            p_Acc://2
                rNxtState <= (iCsnRam) ? p_Sum : p_Acc;

            p_Sum://3
            if (iCoeffiUpdateFlag == 0 && iCsnRam == 0 && iWrnRam == 1) begin
                rNxtState <= p_Acc;  // iCoeffiUpdateFlag = 0, iCsnRam = 0, iWrnRam = 1일 때 p_Acc로 전이
            end else if (iCoeffiUpdateFlag == 1 && iCsnRam == 1 && iWrnRam == 0) begin
                rNxtState <= p_Idle;  // iCoeffiUpdateFlag = 1, iCsnRam = 1, iWrnRam = 0일 때 p_Idle로 전이
            end else begin
                rNxtState <= p_Sum;   // 나머지 경우는 p_Sum 상태 유지
            end
            default:
                rNxtState <= p_Idle;
        endcase
    end

    // Control signals
    assign oCsnRam1 = ((rCurState == p_SpSram && (iNumOfCoeff  == 1 || iNumOfCoeff  == 3 || iNumOfCoeff  == 5 || iNumOfCoeff  == 7 || iNumOfCoeff  == 9 || iNumOfCoeff  == 11 || iNumOfCoeff  == 12 )) || rCurState == p_Acc) ? 1'b0 : 1'b1;
    assign oCsnRam2 = ((rCurState == p_SpSram && (iNumOfCoeff  == 2 || iNumOfCoeff  == 4 || iNumOfCoeff  == 6 || iNumOfCoeff  == 8 || iNumOfCoeff  == 10)) || rCurState == p_Acc) ? 1'b0 : 1'b1;

    assign oWrnRam1 = (rCurState == p_SpSram && (iNumOfCoeff  == 1 || iNumOfCoeff  == 3 || iNumOfCoeff  == 5 || iNumOfCoeff  == 7 || iNumOfCoeff  == 9 || iNumOfCoeff  == 11 || iNumOfCoeff  == 12 )) ? 1'b0 : 1'b1;
    assign oWrnRam2 = (rCurState == p_SpSram && (iNumOfCoeff  == 2 || iNumOfCoeff  == 4 || iNumOfCoeff  == 6 || iNumOfCoeff  == 8 || iNumOfCoeff  == 10)) ? 1'b0 : 1'b1;

    assign oAddrRam_pos = ((rCurState == p_SpSram && (iNumOfCoeff  == 1 || iNumOfCoeff  == 3 || iNumOfCoeff  == 5 || iNumOfCoeff  == 7 || iNumOfCoeff  == 9 || iNumOfCoeff  == 11 || iNumOfCoeff  == 12 ))  || rCurState == p_Acc) ? iAddrRam_pos [3:0] : 4'b0000;
    assign oAddrRam_neg = ((rCurState == p_SpSram && (iNumOfCoeff  == 2 || iNumOfCoeff  == 4 || iNumOfCoeff  == 6 || iNumOfCoeff  == 8 || iNumOfCoeff  == 10)) || rCurState == p_Acc) ? iAddrRam_neg[3:0] : 4'b0000;

    assign oWrDtRam1 = (rCurState == p_SpSram && (iNumOfCoeff  == 1 || iNumOfCoeff  == 3 || iNumOfCoeff  == 5 || iNumOfCoeff  == 7 || iNumOfCoeff  == 9 || iNumOfCoeff  == 11 || iNumOfCoeff  == 12 )) ? iWrDtRam : 16'b0;
    assign oWrDtRam2 = (rCurState == p_SpSram && (iNumOfCoeff  == 2 || iNumOfCoeff  == 4 || iNumOfCoeff  == 6 || iNumOfCoeff  == 8 || iNumOfCoeff  == 10)) ? iWrDtRam : 16'b0;

    // Enable delay signal
    assign oEnDelay = (rCurState == p_Idle || rCurState == p_SpSram) ? 1'b0 : 1'b1;

    // Selection_pos logic
    always @(posedge iClk_12M) begin
        if (!iRsn) begin
            Selection_pos <= 4'd0; // Reset 시 Selection 초기화
        end else if (rCurState == p_Acc) begin
            if (Selection_pos == 4'd9) 
                Selection_pos <= 4'd0; // 9에서 다시 0으로 초기화
            else 
                Selection_pos <= Selection_pos + 1'b1; // 0~9까지 순차적으로 증가
        end else begin
            Selection_pos <= 4'd0; // 다른 상태에서는 초기화
        end
    end
    always @(posedge iClk_12M) begin
        if (!iRsn) begin
            Selection_neg <= 4'd0; // Reset 시 Selection 초기화
        end else if (rCurState == p_Acc) begin
            if (Selection_neg == 4'd8) 
                Selection_neg <= 4'd0; // 9에서 다시 0으로 초기화
            else 
                Selection_neg <= Selection_neg + 1'b1; // 0~9까지 순차적으로 증가
        end else begin
            Selection_neg <= 4'd0; // 다른 상태에서는 초기화
        end
    end
    // Control signal for Add and Accumulator delay
always @(posedge iClk_12M) begin
    if (!iRsn) begin
        rEnAddDelay <= 1'b0; // 리셋 상태에서 초기화
        rEnAccDelay <= 1'b0;
    end else begin
        if (rCurState == p_Acc) begin
            rEnAddDelay <= 1'b1; // 특정 상태에서만 활성화
            rEnAccDelay <= 1'b1;
        end else begin
            rEnAddDelay <= 1'b0; // 다른 상태에서는 비활성화
            rEnAccDelay <= 1'b0;
        end
    end
end
    // Output enable signals for Adders, Accumulators, and Multipliers
    assign oEnAdd1 = rEnAddDelay;
    assign oEnAcc1 = rEnAccDelay;
    assign oEnMul1 = (rCurState == p_Acc) ? Selection_pos : 4'b0000;

    assign oEnAdd2 = rEnAddDelay;
    assign oEnAcc2 = rEnAccDelay;
    assign oEnMul2 = (rCurState == p_Acc) ? Selection_neg : 4'b0000;

endmodule