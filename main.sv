module main (clk, reset_in, second_clk, pc_inc_led, led0, led1, led2, led3, led4, led5, led6);

    input clk, reset_in;
    output logic second_clk;
    output logic pc_inc_led;
    logic reset;
    assign reset = ~reset_in;

    // Using Clock divider to get 1Hz frequency from 50 MHz system clock
    Clock secondClock(
        .clk_in(clk),
        .clk_out(second_clk)
    );

    logic [31:0] pcOut;
    logic [31:0] pcOut_prev;
    logic [31:0] aluOut;
    logic [31:0] inst;
    logic [31:0] dataMemReadOut;
    logic [31:0] writeBack;
    logic BrEq;
    logic BrLT;
    logic RegWEn;
    logic memRW;
    logic [31:0] regData1;
    logic [31:0] regData2;

    KLP32V1 processor(
        .clk(second_clk),
        .reset(reset),
        .o_pcOut(pcOut),
        .o_aluOut(aluOut),
        .o_inst(inst),
        .o_dataMemReadOut(dataMemReadOut),
        .o_writeBack(writeBack),
        .o_BrEq(BrEq),
        .o_BrLT(BrLT),
        .o_RegWEn(RegWEn),
        .o_memRW(memRW),
        .o_regData1(regData1),
        .o_regData2(regData2)
    );

    always_ff @(posedge second_clk or posedge reset) begin
        if (reset) begin
            pcOut_prev <= 32'b0;
            pc_inc_led <= 1'b0; // Turn off the LED on reset
        end else begin
            if (pcOut != pcOut_prev) begin
                pc_inc_led <= ~pc_inc_led; // Toggle LED on PC increment
            end
            pcOut_prev <= pcOut; // Update previous PC value
        end
    end

    // output logic [6:0] hex0, hex1, hex2, hex3, hex4, hex5;
    // SevenSDisplay hexModule0(.hex_digit(inst[3:0]), .segments(hex0));
    // SevenSDisplay hexModule1(.hex_digit(inst[7:4]), .segments(hex1));
    // SevenSDisplay hexModule2(.hex_digit(inst[10:7]), .segments(hex2));
    // SevenSDisplay hexModule3(.hex_digit(inst[14:11]), .segments(hex3));
    // SevenSDisplay hexModule4(.hex_digit(inst[18:15]), .segments(hex4));
    // SevenSDisplay hexModule5(.hex_digit(inst[22:19]), .segments(hex5));

    output logic led0, led1, led2, led3, led4, led5, led6;
    assign led0 = inst[0];
    assign led1 = inst[1];
    assign led2 = inst[2];
    assign led3 = inst[3];
    assign led4 = inst[4];
    assign led5 = inst[5];
    assign led6 = inst[6];

endmodule
