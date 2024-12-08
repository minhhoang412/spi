
`include "${DIR_TB}/enviroment.sv"

program test (
    itf_spi_env i_spi
);


  class my_trans extends transaction;

    //R1
    bit       SPIE      = 1'b0;  //interupt
    bit       SPE       = 1'b1;  //system enable
    bit       CPOL      = 1'b0;  //Active-low clocks selected. In idle state SCK is high
    bit       CPHA      = 1'b1;  //mode - just setup 1
    bit       LSBFE     = 1'b0;  // first MSB or LSB
    bit       MSTR_M    = 1'b1;  //master
    bit       MSTR_S    = 1'b0;  //slave
    bit       SSOE_M    = 1'b1;  //ONLY 1
    bit       SSOE_S    = 1'b0;  //ONLY 0
    //R2
    bit       SPISWAI   = 1'b0;  //save power
    bit       SPCO      = 1'b0;  //setup bidirection
    bit       MODFEN    = 1'b1;  //on - off CS pin
    bit       MODFEN_S  = 1'b0;
    //Status
    bit       SPIF      = 1'b1;  //set -> received data from data_reg
    bit       MODF      = 1'b0;  //erro master
    //baud rate
    bit [2:0] baud_high = 3'd0;
    bit [2:0] baud_low  = 3'd1;


    function new();
      super.new();
    endfunction


    function void pre_randomize();

      data_config = {
        {SPIE, SPE, 1'b0, MSTR_S, CPOL, CPHA, SSOE_S, LSBFE},
        {3'b0, MODFEN, 2'b0, SPISWAI, SPCO},
        {1'b1, 2'b0, MODF, 4'b0},
        {1'b0, baud_high, 1'b0, baud_low}
      };

    endfunction

  endclass

  enviroment env;
  my_trans   my_tr;
  initial begin
    env = new(i_spi);
    env.gen.repeat_count = 10;
    my_tr = new();
    env.gen.trans = my_tr;
    env.run();
  end
endprogram
