module main_v2 
    (
        input logic clk, 
        input logic reset_in

    );

    // Button on DE10 lite is default high unpressed
    // Change according to needs
    logic reset;
    assign reset = ~reset_in;

    // Instantiate MMCM Clock Generator


    // Instantiate CPU
    KLP32V2 processor
    (
        .clk(clk),
        .reset(reset),

        // MMIO Bus
        .bus_addr(bus_addr),
        .bus_wr_data(bus_wr_data),
        .bus_rd_data(bus_rd_data),
        .bus_cs(bus_cs),
        .bus_wr(bus_wr),
        .bus_rd(bus_rd)
    );

    //Instantiate Peripheral Module
    io_top io_unit
    (
        
    );
    

endmodule