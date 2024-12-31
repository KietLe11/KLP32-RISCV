module data_memory32 (clk, write_enable, addr, write_data, dataControl, read_data);

    parameter integer n = 32;
    input clk;
    input write_enable;
    input [n-1:0] addr, write_data;
    input [2:0] dataControl;
    output reg [n-1:0] read_data;

    // Byte Addressed Memory
    reg [7:0] memory_block [0:1023];

    // Initialize all registers to zero
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            memory_block[i] = 32'b0;
        end
    end

    // Read Data Out

    wire [7:0] byteData;
    wire [15:0] halfWordData;
    wire [31:0] wordData;

    assign byteData = memory_block[addr];
    assign halfWordData = {memory_block[addr], memory_block[addr+1]};
    assign wordData = {memory_block[addr],
                        memory_block[addr+1],
                        memory_block[addr+2],
                        memory_block[addr+3]};

    wire usigned;
    assign usigned = dataControl[2];

    wire [31:0] byteDataExtended, halfWordDataExtended;
    halfWordExtend HWE(.halfWord(halfWordData),
                        .usigned(usigned),
                        .byteExtend(halfWordDataExtended));
    byteExtend BE(.byte(byteData),
                    .usigned(usigned),
                    .byteExtend(byteDataExtended));

    wire [31:0] targetData;

    always @(*) begin
        case (dataControl)
            3'000 : begin // LB and LBU
                targetData = byteDataExtended;
            end
            3'001 : begin // LH and LHU
                targetData = halfWordDataExtended;
            end
            3'010 : begin // LW
                targetData = wordData;
            end
        endcase
    end

    // Combinational read -> always output data at addr
    always @(*) begin
        read_data = targetData;
    end

    // Write data to memory address

    always @(posedge clk) begin
        if (write_enable) begin
            case (dataControl)
                3'000: begin // SB
                    memory_block[addr] <= write_data[7:0];
                end
                3'001: begin // SH
                    memory_block[addr] <= write_data[15:8];
                    memory_block[addr+1] <= write_data[7:0];
                end
                3'010: begin // SW
                    memory_block[addr] <= write_data[31:24];
                    memory_block[addr+1] <= write_data[23:16];
                    memory_block[addr+2] <= write_data[15:8];
                    memory_block[addr+3] <= write_data[7:0];
                end
            endcase
        end
    end

endmodule

module halfWordExtend (
        input [15:0] halfWord,
        input usigned,
        output [31:0] halfWordExtend
    );

    always @(*) begin
        case (usigned)
            1'0 :
                halfWordExtend = {16{1'b1}, halfWord};
            1'1 :
                halfWordExtend = {16{1'b0}, halfWord};
        endcase
    end

endmodule

module byteExtend (
        input [7:0] byte,
        input usigned,
        output [31:0] byteExtend
    );

    always @(*) begin
        case (usigned)
            1'0 :
                byteExtend = {24{1'b1}, byte};
            1'1 :
                byteExtend = {24{1'b0}, byte};
        endcase
    end

endmodule
