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
    wire signed [16:0] wAccSum; // 17비트로 확장된 합산 결과
    wire wSatCon_1, wSatCon_2;  // 포화 조건 플래그
    reg signed [15:0] wAccSumSat;      // 포화 처리된 최종 출력값

    // 4개의 입력값 합산 (Signed 16-bit → Signed 17-bit)
    //assign wAccSum = $signed(iMac1) + $signed(iMac2) + $signed(iMac3) + $signed(iMac4);
    assign wAccSum = iMac1 + iMac2 + iMac3 + iMac4;
    // // Condition #1: 양수 오버플로 (MSB가 0 → 1로 변한 경우)
    // assign wSatCon_1 = (wAccSum[16] == 1'b0  // 이전 MSB 0
    //                  && wAccSum[15] == 1'b1); // 결과 MSB 1

    // // Condition #2: 음수 오버플로 (MSB가 1 → 0으로 변한 경우)
    // assign wSatCon_2 = (wAccSum[16] == 1'b1  // 이전 MSB 1
    //                  && wAccSum[15] == 1'b0); // 결과 MSB 0

    // // Saturation Logic (포화 처리)
    // always @(posedge iClk_12M) begin
    //     if (!iRsn) begin
    //         if (iEnSample_600k && iEnDelay) begin // 제어 신호 활성화 시
    //             wAccSumSat = (wSatCon_1) ? 16'h7FFF :   // Condition #1: 최대값
    //                          (wSatCon_2) ? 16'h8000 :   // Condition #2: 최소값
    //                                    wAccSum[15:0]; // 정상 범위 값
    //         end else begin
    //         wAccSumSat = 16'b0; // 제어 신호 비활성화 시 0
    //         end
    //     end
    // end

    // 최종 출력값
    // assign oFirOut = wAccSumSat;
    always @(posedge iClk_12M) begin
		if(!iRsn) begin
			oFirOut<= 16'h0;
		end
		else if(iEnSample_600k==1'b1 && iEnDelay ==1'b1) begin
			oFirOut <= wAccSum;
		end
	end
endmodule