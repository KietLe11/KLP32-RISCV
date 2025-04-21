module uart_peripheral 
(
        input logic clk, reset,
        //Baud Rate Generator
        input logic [13 : 0] dvsr_baudrate,// The actual baudrate value
        //Rx
        input logic rx,
        input logic rd_uart,
        output logic rx_empty,
        output logic [7: 0] r_data,
        //Tx
        input logic [7: 0] w_data,
        input logic wr_uart,
        output logic tx_full,
        output logic tx
);

                                            // Register Declaration

   logic rx_done_tick, tx_done_tick;
   logic tx_empty, tx_fifo_not_empty;
   logic [7: 0] tx_fifo_out, rx_data_out;

                                            // Rx Module and FIFO   

receiver_RxD Receiver //
(
    .clk(clk),
    .reset(reset),
    .RxD(rx), //Input that sends data bit
    .RxData(rx_data_out),   // Received data 8-bit
    .baudrate_reg(dvsr_baudrate),    // Configure baudrate
    .rx_done(rx_done_tick)  //reception done flag
);

fifo #(.DATA_WIDTH(8), .ADDR_WIDTH(8)) RX_FIFO 
(
    .clk(clk),
    .reset(reset),
    .w_data(rx_data_out),
    .r_data(r_data),
    .wr(rx_done_tick),
    .rd(rd_uart),
    .full(),//unused
    .empty(rx_empty)
);
                                            // Tx Module and FIFO

TxD Transmitter 
(
    .clk(clk),
    .reset(reset),
    .transmit(tx_fifo_not_empty),    //Start signal
    .TxD(tx),     //Output bit
    .data(tx_fifo_out),        // 8-bit data input
    .baudrate_reg(dvsr_baudrate),
    .transmission_done(tx_done_tick)    //Done flag
);

fifo #(.DATA_WIDTH(8), .ADDR_WIDTH(8)) TX_FIFO 
(
    .clk(clk),
    .reset(reset),
    .w_data(w_data),
    .r_data(tx_fifo_out),
    .wr(wr_uart),
    .rd(tx_done_tick),
    .full(tx_full),
    .empty(tx_empty)
);

assign tx_fifo_not_empty = ~tx_empty;

endmodule