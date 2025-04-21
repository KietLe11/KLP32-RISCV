module io_top 
(
    input logic clk,
    input logic reset,
    // Bus Signals
    input logic bus_cs,
    input logic bus_wr,
    input logic bus_rd,
    input logic [31: 0] bus_addr,
    input logic [31: 0] bus_wr_data,
    output logic [31: 0] bus_rd_data,

    // UART
    input logic rx,
    output logic tx,
    // SPI (optional)
    input logic miso,
    output logic sclk,
    output logic mosi,
    output logic ss_n
    // Matrix Multiplier

    // Cordic ?


);
    
    // Register Declaration
    logic [15:0] mem_rd_array;
    logic [15:0] mem_wr_array;
    logic [15:0] cs_array;
    logic [4:0] reg_addr_array [15:0];
    logic [31:0] rd_data_array [15:0]; 
    logic [31:0] wr_data_array [15:0];

    // Instantiate I/O Controller
    io_controller ctrl_unit
    (
    .clk(clk),
    .reset(reset),
    .bus_cs(bus_cs),
    .bus_wr(bus_wr),
    .bus_rd(bus_rd),
    .bus_addr(bus_addr), 
    .bus_wr_data(bus_wr_data),
    .bus_rd_data(bus_rd_data),
    // IO Slot Interface
    .slot_cs_array(cs_array),
    .slot_mem_rd_array(mem_rd_array),
    .slot_mem_wr_array(mem_wr_array),
    .slot_reg_addr_array(reg_addr_array),
    .slot_rd_data_array(rd_data_array), 
    .slot_wr_data_array(wr_data_array)
    );

    // Slot 0: UART
    uart_top UART_MODULE
    (
    .clk(clk),
    .reset(reset),
    .cs(cs_array[0]),
    .read(mem_rd_array[0]),
    .write(mem_wr_array[0]),
    .addr(reg_addr_array[0]),
    .rd_data(rd_data_array[0]),
    .wr_data(wr_data_array[0]), 
    
    .tx(tx),
    .rx(rx)
    );
    // Slot 1: SPI

    // Slot 2: Matrix Multiplier

    // Slot 3: Cordic Module



    // Assign 0's to all unused slot rd_data signals
   generate
      genvar i;
      for (i=4; i<15; i=i+1) //Change as needed, this is assuming we used slots 0->3
        begin
            assign rd_data_array[i] = 32'h0;
        end
   endgenerate

endmodule