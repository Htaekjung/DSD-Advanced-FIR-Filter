/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : Sum.v
  - Description      : Sum w/ saturation
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/
module Sum(
    input iClk_12M,
    input iRsn,
    input signed [15:0] iMac1, iMac2, iMac3, iMac4, // 입력값 4개
    input iEnDelay,                          // 지연 신호 활성화
    input iEnSample_600k,                    // 샘플링 신호 활성화
    output reg signed [15:0] oFirOut                   // 출력값 (포화 처리된 값)
);
    wire signed [15:0] wAccSum; // 17비트로 확장된 합산 결과
    wire wSatCon_1, wSatCon_2;  // 포화 조건 플래그
    wire signed [15:0] wAccSumSat;      // 포화 처리된 최종 출력값

    //4개의 입력값 합산 (Signed 16-bit → Signed 17-bit)
    // assign wAccSum = $signed(iMac1) + $signed(iMac2) + $signed(iMac3) + $signed(iMac4);
    assign wAccSum = iMac1 + iMac2 + iMac3 + iMac4;
    // Condition #1: 양수 오버플로 (MSB가 0 → 1로 변한 경우)
    assign wSatCon_1 = (wAccSum[15] == 1'b0 && (wAccSum[15] + 16'b0) == 1'b1) ? 1'b1 : 1'b0;

    // Condition #2: 음수 오버플로 (MSB가 1 → 0으로 변한 경우)
    assign wSatCon_2 = (wAccSum[15] == 1'b1 && (wAccSum[15] + 16'b1) == 1'b0) ? 1'b1 : 1'b0;

    // Saturation Logic (포화 처리)
    assign wAccSumSat = (wSatCon_1 == 1'b1) ? 16'h7FFF : (wSatCon_2== 1'b1) ? 16'h8000 : wAccSum;

    always @(posedge iClk_12M) begin
		if(!iRsn) begin
			oFirOut<= 16'h0;
		end
		else if(iEnSample_600k==1'b1 && iEnDelay ==1'b1) begin
			oFirOut <= wAccSumSat;
		end
	end
endmodule