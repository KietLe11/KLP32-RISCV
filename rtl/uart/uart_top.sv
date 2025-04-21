
//  Reg map (each port uses 4 address space)
//    * 0: read data and status
//    * 1: write baud rate 
//    * 2: write data 
//    * 3: dummy write to remove data from head of rx FIFO 

//This is the wrapping circuit for the UART core
module uart_top 
(
        input logic clk, reset,
        // UART slot interface
        input logic cs, //chip select for slot 
        input logic read,//en
        input logic write,//en
        input logic [4:0] addr,//internal address of registers
        input logic [31: 0] wr_data, //data to be written
        output logic [31: 0] rd_data,//data to be read
        // Outside-world interface
        input logic rx,
        output logic tx
);
    

                                            //Internal Signals

    logic wr_dvsr_bdrt;// write enable for baudrate
    logic [13:0] dvsr_reg_bdrt; //stores raw baudrate value

    logic rd_uart;
    logic rx_empty;
    logic [7:0] r_data;

    logic wr_uart;
    logic tx_full;
    //w_data will be taken from the first 8 bits of the input wr_data

                                            //Instantiate UART

    uart_peripheral UART_unit
    (
        .*, .dvsr(dvsr_reg_bdrt), .w_data(wr_data[7:0]) 
    );

                                            //baudrate Register
    
    always_ff @( posedge clk, posedge reset ) 
        if (reset) 
            dvsr_reg_bdrt <= 0;   
        else
            if (wr_dvsr_bdrt)//When is this asserted? check below
                dvsr_reg_bdrt <= wr_data[13:0];//we can write into the dvsr_reg_bdrt and config. a baud rate
              
                                            // Decoding logic  (refer to register map above)

   assign wr_dvsr_bdrt = (write && cs && (addr[1:0]==2'b01)); // Assert wr_dvsr_bdrt if chip select is enabled, and the command to write, and the address points to the second word
   assign wr_uart = (write && cs && (addr[1:0]==2'b10)); // Assert wr_uart if chip select is enabled, and the command to write, and the address points to the third word
   assign rd_uart = (write && cs && (addr[1:0]==2'b11)); // Assert rd_uart if chip select is enabled, and the command to write, and the address points to the fourth word
//Hardcode rd_uart to 1 if automatically want rd_data to update
                                            // Slot read interface

   assign rd_data = {22'h000000, tx_full,  rx_empty, r_data};//22 bits 0, 1 bit, 1 bit, 8 bits  --> reads all possible data (that's meant to be read)
endmodule