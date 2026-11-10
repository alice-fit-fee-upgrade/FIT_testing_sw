/* Machine-generated using Migen */
module pm12_ipbus_adc(
	input MCLK1_P,
	input MCLK1_N,
	input MGTCLK_P,
	input MGTCLK_N,
	output TX_P,
	output TX_N,
	input RX_P,
	input RX_N,
	input [12:0] DI1,
	input STR1,
	input [12:0] DI2,
	input STR2,
	input [12:0] DI3,
	input STR3,
	input [12:0] DI4,
	input STR4,
	input [12:0] DI5,
	input STR5,
	input [12:0] DI6,
	input STR6,
	input [12:0] DI7,
	input STR7,
	input [12:0] DI8,
	input STR8,
	input [12:0] DI9,
	input STR9,
	input [12:0] DI10,
	input STR10,
	input [12:0] DI11,
	input STR11,
	input [12:0] DI12,
	input STR12,
	input I2C_SDA,
	input I2C_SCL,
	input I2C_RESET_N,
	input TDCCLK1_P,
	input TDCCLK1_N,
	input INA1_P,
	input INA1_N,
	input RSA1_P,
	input RSA1_N,
	input RDA1_P,
	input RDA1_N,
	input INB1_P,
	input INB1_N,
	input RSB1_P,
	input RSB1_N,
	input RDB1_P,
	input RDB1_N,
	input INC1_P,
	input INC1_N,
	input RSC1_P,
	input RSC1_N,
	input RDC1_P,
	input RDC1_N,
	input IND1_P,
	input IND1_N,
	input RSD1_P,
	input RSD1_N,
	input RDD1_P,
	input RDD1_N,
	input TDCCLK2_P,
	input TDCCLK2_N,
	input MCLK2_P,
	input MCLK2_N,
	input INA2_P,
	input INA2_N,
	input RSA2_P,
	input RSA2_N,
	input RDA2_P,
	input RDA2_N,
	input INB2_P,
	input INB2_N,
	input RSB2_P,
	input RSB2_N,
	input RDB2_P,
	input RDB2_N,
	input INC2_P,
	input INC2_N,
	input RSC2_P,
	input RSC2_N,
	input RDC2_P,
	input RDC2_N,
	input IND2_P,
	input IND2_N,
	input RSD2_P,
	input RSD2_N,
	input RDD2_P,
	input RDD2_N,
	input TDCCLK3_P,
	input TDCCLK3_N,
	input MCLK3_P,
	input MCLK3_N,
	input INA3_P,
	input INA3_N,
	input RSA3_P,
	input RSA3_N,
	input RDA3_P,
	input RDA3_N,
	input INB3_P,
	input INB3_N,
	input RSB3_P,
	input RSB3_N,
	input RDB3_P,
	input RDB3_N,
	input INC3_P,
	input INC3_N,
	input RSC3_P,
	input RSC3_N,
	input RDC3_P,
	input RDC3_N,
	input IND3_P,
	input IND3_N,
	input RSD3_P,
	input RSD3_N,
	input RDD3_P,
	input RDD3_N,
	output HDMI_P0,
	output HDMI_N0,
	output HDMI_P1,
	output HDMI_N1,
	output HDMI_P2,
	output HDMI_N2,
	output HDMI_P3,
	output HDMI_N3,
	input HSCK,
	input HSEL,
	input HMOSI,
	output HMISO,
	output EVNT,
	input SCK,
	input MOSI,
	output MISO,
	input CS
);

wire sys_clk;
wire sys_rst;
wire top_m;
wire top_ref;
wire top_sys_ref;
wire top_refdiv;
wire top_fixed100;
reg top_fixed_cm_reset = 1'd0;
reg top_fixed_cm_power_down = 1'd0;
wire top_fixed_cm_locked;
wire top_s7mmcm0_clkin_signal;
wire top_s7mmcm0_clkout;
wire top_s7mmcm0_clkout_buf;
wire cap_clk;
wire cap_rst;
reg top_cap_cm_reset = 1'd0;
reg top_cap_cm_power_down = 1'd0;
wire top_cap_cm_locked;
wire top_s7mmcm1_clkin_signal;
wire top_s7mmcm1_clkout;
wire top_s7mmcm1_clkout_buf;
wire net_clk;
wire net_rst;
reg top_pcstx_config_valid = 1'd0;
reg [15:0] top_pcstx_config_reg;
reg [1:0] top_pcstx_sgmii_speed;
wire top_pcstx_sink_valid;
reg top_pcstx_sink_ready;
wire top_pcstx_sink_first;
wire top_pcstx_sink_last;
wire [7:0] top_pcstx_sink_payload_data;
reg top_pcstx_encoder_ce0 = 1'd1;
reg [7:0] top_pcstx_encoder0;
reg top_pcstx_encoder1;
reg [9:0] top_pcstx_encoder2 = 10'd0;
reg top_pcstx_encoder3 = 1'd0;
wire [7:0] top_pcstx_encoder_d;
wire top_pcstx_encoder_k;
reg top_pcstx_encoder_disp_in = 1'd0;
reg [9:0] top_pcstx_encoder_output;
reg top_pcstx_encoder_disp_out;
reg [5:0] top_pcstx_encoder_code6b = 6'd0;
reg top_pcstx_encoder_code6b_unbalanced = 1'd0;
reg top_pcstx_encoder_code6b_flip = 1'd0;
reg [3:0] top_pcstx_encoder_code4b = 4'd0;
reg top_pcstx_encoder_code4b_unbalanced = 1'd0;
reg top_pcstx_encoder_code4b_flip = 1'd0;
reg top_pcstx_encoder_alt7_rd0 = 1'd0;
reg top_pcstx_encoder_alt7_rd1 = 1'd0;
reg [5:0] top_pcstx_encoder_output_6b;
wire top_pcstx_encoder_disp_inter;
reg [3:0] top_pcstx_encoder_output_4b;
wire [9:0] top_pcstx_encoder_output_msb_first;
wire top_pcstx_encoder_ce1;
reg top_pcstx_count0 = 1'd0;
reg top_pcstx_parity = 1'd0;
reg top_pcstx_ctype = 1'd0;
reg top_pcstx_enable;
wire top_pcstx_done;
reg [6:0] top_pcstx_count1 = 7'd0;
reg top_pcsrx_seen_valid_ci;
reg top_pcsrx_seen_config_reg;
reg [15:0] top_pcsrx_config_reg = 16'd0;
reg [1:0] top_pcsrx_sgmii_speed;
reg top_pcsrx_source_valid;
wire top_pcsrx_source_ready;
reg top_pcsrx_source_first;
reg top_pcsrx_source_last;
reg [7:0] top_pcsrx_source_payload_data;
reg top_pcsrx_source_payload_error;
wire top_pcsrx_decoder_ce;
wire [9:0] top_pcsrx_decoder_input;
wire [7:0] top_pcsrx_decoder_d;
reg top_pcsrx_decoder_k = 1'd0;
wire top_pcsrx_decoder_invalid;
reg [9:0] top_pcsrx_decoder_input_msb_first;
wire [4:0] top_pcsrx_decoder_code5b;
reg [2:0] top_pcsrx_decoder_code3b = 3'd0;
wire [5:0] top_pcsrx_decoder_adr;
wire [4:0] top_pcsrx_decoder_dat_r;
wire top_pcsrx_decoder_re;
reg [3:0] top_pcsrx_decoder_ones = 4'd0;
reg top_pcsrx_count0 = 1'd0;
reg top_pcsrx_enable;
wire top_pcsrx_done;
reg [6:0] top_pcsrx_count1 = 7'd0;
wire top_pcsrx_timer_ce;
reg top_pcsrx_sink_sink_valid;
wire top_pcsrx_sink_sink_ready;
reg top_pcsrx_sink_sink_first = 1'd0;
reg top_pcsrx_sink_sink_last = 1'd0;
reg [7:0] top_pcsrx_sink_sink_payload_data;
wire top_pcsrx_source_source_valid;
reg top_pcsrx_source_source_ready;
wire top_pcsrx_source_source_first;
wire top_pcsrx_source_source_last;
wire [7:0] top_pcsrx_source_source_payload_data;
wire top_pcsrx_pipe_valid_sink_valid;
wire top_pcsrx_pipe_valid_sink_ready;
wire top_pcsrx_pipe_valid_sink_first;
wire top_pcsrx_pipe_valid_sink_last;
wire [7:0] top_pcsrx_pipe_valid_sink_payload_data;
reg top_pcsrx_pipe_valid_source_valid = 1'd0;
wire top_pcsrx_pipe_valid_source_ready;
reg top_pcsrx_pipe_valid_source_first = 1'd0;
reg top_pcsrx_pipe_valid_source_last = 1'd0;
reg [7:0] top_pcsrx_pipe_valid_source_payload_data = 8'd0;
wire top_sink_sink_valid;
wire top_sink_sink_ready;
wire top_sink_sink_first;
wire top_sink_sink_last;
wire [7:0] top_sink_sink_payload_data;
wire top_sink_sink_payload_be;
wire top_sink_sink_payload_error;
wire top_source_source_valid;
wire top_source_source_ready;
wire top_source_source_first;
wire top_source_source_last;
wire [7:0] top_source_source_payload_data;
wire top_source_source_payload_be;
wire top_source_source_payload_error;
reg top_link_up = 1'd0;
reg top_restart = 1'd0;
wire top_align;
reg [15:0] top_lp_abi_i = 16'd0;
reg [15:0] top_lp_abi_o = 16'd0;
reg top_lp_abi_starter = 1'd1;
wire top_lp_abi_ping_i;
wire top_lp_abi_ping_o0;
reg top_lp_abi_ping_toggle_i = 1'd0;
wire top_lp_abi_ping_toggle_o;
reg top_lp_abi_ping_toggle_o_r = 1'd0;
reg top_lp_abi_ping_o1 = 1'd0;
wire top_lp_abi_pong_i;
wire top_lp_abi_pong_o;
reg top_lp_abi_pong_toggle_i = 1'd0;
wire top_lp_abi_pong_toggle_o;
reg top_lp_abi_pong_toggle_o_r = 1'd0;
wire top_lp_abi_wait;
wire top_lp_abi_done;
reg [7:0] top_lp_abi_count = 8'd128;
(* no_retiming = "true" *) reg [15:0] top_lp_abi_ibuffer = 16'd0;
wire [15:0] top_lp_abi_obuffer;
reg top_config_empty = 1'd0;
wire top_is_sgmii;
reg top_linkdown;
reg top_autoneg_ack = 1'd0;
wire top_seen_valid_ci_i;
wire top_seen_valid_ci_o;
reg top_seen_valid_ci_toggle_i = 1'd0;
wire top_seen_valid_ci_toggle_o;
reg top_seen_valid_ci_toggle_o_r = 1'd0;
reg top_rx_config_reg_abi_i = 1'd0;
wire top_rx_config_reg_abi_o;
reg top_rx_config_reg_abi_toggle_i = 1'd0;
wire top_rx_config_reg_abi_toggle_o;
reg top_rx_config_reg_abi_toggle_o_r = 1'd0;
reg top_rx_config_reg_ack_i = 1'd0;
wire top_rx_config_reg_ack_o;
reg top_rx_config_reg_ack_toggle_i = 1'd0;
wire top_rx_config_reg_ack_toggle_o;
reg top_rx_config_reg_ack_toggle_o_r = 1'd0;
reg top_waittimer0_wait = 1'd0;
wire top_waittimer0_done;
reg [20:0] top_waittimer0_count = 21'd1200000;
reg top_waittimer1_wait = 1'd0;
wire top_waittimer1_done;
reg [20:0] top_waittimer1_count = 21'd1200000;
reg top_waittimer2_wait = 1'd0;
wire top_waittimer2_done;
reg [17:0] top_waittimer2_count = 18'd192000;
reg [19:0] top_checker_count = 20'd0;
reg top_checker_tick = 1'd0;
reg top_checker_error = 1'd0;
wire top_sgmii_speed_valid;
wire [1:0] top_sgmii_tx_speed;
wire [1:0] top_sgmii_rx_speed;
wire top_pma_k7_gtx_basex_reset;
wire top_pma_k7_gtx_basex_align;
wire top_pma_k7_gtx_basex_restart;
wire top_pma_k7_gtx_basex_rx_valid;
wire eth_tx_clk;
wire eth_tx_rst;
wire eth_rx_clk;
wire eth_rx_rst;
wire eth_tx_half_clk;
wire eth_rx_half_clk;
wire top_pma_k7_gtx_basex_txoutclk;
wire top_pma_k7_gtx_basex_rxoutclk;
wire top_pma_k7_gtx_basex_tx_reset;
wire top_pma_k7_gtx_basex_tx_mmcm_locked0;
(* no_retiming = "true" *) reg top_pma_k7_gtx_basex_tx_mmcm_reset0 = 1'd1;
wire [19:0] top_pma_k7_gtx_basex_tx_data0;
wire top_pma_k7_gtx_basex_tx_reset_done;
wire top_pma_k7_gtx_basex_rx_reset;
wire top_pma_k7_gtx_basex_rx_mmcm_locked0;
(* no_retiming = "true" *) reg top_pma_k7_gtx_basex_rx_mmcm_reset0 = 1'd1;
wire [19:0] top_pma_k7_gtx_basex_rx_data0;
wire top_pma_k7_gtx_basex_rx_reset_done;
wire top_pma_k7_gtx_basex_pll_reset;
wire top_pma_k7_gtx_basex_pll_lock;
wire top_pma_k7_gtx_basex0;
wire top_pma_k7_gtx_basex1;
wire top_pma_k7_gtx_basex2;
wire top_pma_k7_gtx_basex3;
wire top_pma_k7_gtx_basex4;
wire top_pma_k7_gtx_basex5;
wire top_pma_k7_gtx_basex6;
wire top_pma_k7_gtx_basex7;
wire top_pma_k7_gtx_basex8;
wire top_pma_k7_gtx_basex9;
wire top_pma_k7_gtx_basex10;
wire top_pma_k7_gtx_basex11;
wire top_pma_k7_gtx_basex12;
wire top_pma_k7_gtx_basex13;
wire top_pma_k7_gtx_basex14;
wire top_pma_k7_gtx_basex15;
wire top_pma_k7_gtx_basex16;
wire top_pma_k7_gtx_basex17;
wire top_pma_k7_gtx_basex18;
wire top_pma_k7_gtx_basex19;
wire top_pma_k7_gtx_basex20;
wire top_pma_k7_gtx_basex21;
wire top_pma_k7_gtx_basex22;
wire top_pma_k7_gtx_basex23;
wire top_pma_k7_gtx_basex24;
wire top_pma_k7_gtx_basex25;
wire top_pma_k7_gtx_basex26;
wire top_pma_k7_gtx_basex27;
wire top_pma_k7_gtx_basex28;
wire top_pma_k7_gtx_basex29;
wire top_pma_k7_gtx_basex30;
wire top_pma_k7_gtx_basex31;
wire top_pma_k7_gtx_basex32;
wire top_pma_k7_gtx_basex33;
wire top_pma_k7_gtx_basex34;
wire top_pma_k7_gtx_basex35;
wire top_pma_k7_gtx_basex36;
wire top_pma_k7_gtx_basex37;
wire top_pma_k7_gtx_basex38;
wire top_pma_k7_gtx_basex39;
wire top_pma_k7_gtx_basex40;
wire top_pma_k7_gtx_basex41;
wire top_pma_k7_gtx_basex42;
wire top_pma_k7_gtx_basex43;
wire top_pma_k7_gtx_basex44;
wire top_pma_k7_gtx_basex45;
wire top_pma_k7_gtx_basex46;
wire top_pma_k7_gtx_basex47;
wire top_pma_k7_gtx_basex48;
wire top_pma_k7_gtx_basex49;
wire top_pma_k7_gtx_basex50;
wire top_pma_k7_gtx_basex51;
wire top_pma_k7_gtx_basex52;
wire top_pma_k7_gtx_basex53;
wire top_pma_k7_gtx_basex_txoutclk_rebuffer;
wire top_pma_k7_gtx_basex_rxoutclk_rebuffer;
wire top_pma_k7_gtx_basex_tx_mmcm_reset1;
reg top_pma_k7_gtx_basex_tx_mmcm_power_down = 1'd0;
wire top_pma_k7_gtx_basex_tx_mmcm_locked1;
wire top_pma_k7_gtx_basex_s7mmcm0_clkin_signal;
wire top_pma_k7_gtx_basex_s7mmcm0_clkout0;
wire top_pma_k7_gtx_basex_s7mmcm0_clkout_buf0;
wire top_pma_k7_gtx_basex_s7mmcm0_clkout1;
wire top_pma_k7_gtx_basex_s7mmcm0_clkout_buf1;
wire top_pma_k7_gtx_basex_rx_mmcm_reset1;
reg top_pma_k7_gtx_basex_rx_mmcm_power_down = 1'd0;
wire top_pma_k7_gtx_basex_rx_mmcm_locked1;
wire top_pma_k7_gtx_basex_s7mmcm1_clkin_signal;
wire top_pma_k7_gtx_basex_s7mmcm1_clkout0;
wire top_pma_k7_gtx_basex_s7mmcm1_clkout_buf0;
wire top_pma_k7_gtx_basex_s7mmcm1_clkout1;
wire top_pma_k7_gtx_basex_s7mmcm1_clkout_buf1;
reg top_pma_k7_gtx_basex_gtxtxinit_done;
reg top_pma_k7_gtx_basex_gtxtxinit_restart = 1'd0;
wire top_pma_k7_gtx_basex_gtxtxinit_plllock0;
reg top_pma_k7_gtx_basex_gtxtxinit_pllreset0 = 1'd0;
reg top_pma_k7_gtx_basex_gtxtxinit_gtXxreset0 = 1'd0;
reg top_pma_k7_gtx_basex_gtxtxinit_gtXxpd0 = 1'd0;
wire top_pma_k7_gtx_basex_gtxtxinit_Xxresetdone0;
reg top_pma_k7_gtx_basex_gtxtxinit_Xxdlysreset0 = 1'd0;
reg top_pma_k7_gtx_basex_gtxtxinit_Xxdlysresetdone0 = 1'd0;
reg top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone0 = 1'd0;
reg top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy0 = 1'd0;
reg top_pma_k7_gtx_basex_gtxtxinit_drp_start;
reg top_pma_k7_gtx_basex_gtxtxinit_drp_done = 1'd1;
wire top_pma_k7_gtx_basex_gtxtxinit_plllock1;
wire top_pma_k7_gtx_basex_gtxtxinit_Xxresetdone1;
wire top_pma_k7_gtx_basex_gtxtxinit_Xxdlysresetdone1;
wire top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone1;
reg top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone_r = 1'd1;
wire top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone_rising;
reg top_pma_k7_gtx_basex_gtxtxinit_pllreset1;
reg top_pma_k7_gtx_basex_gtxtxinit_gtXxreset1;
reg top_pma_k7_gtx_basex_gtxtxinit_gtXxpd1;
reg top_pma_k7_gtx_basex_gtxtxinit_Xxdlysreset1;
reg top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy1;
wire top_pma_k7_gtx_basex_gtxtxinit_reset;
wire top_pma_k7_gtx_basex_gtxtxinit_init_delay_wait;
wire top_pma_k7_gtx_basex_gtxtxinit_init_delay_done;
reg [4:0] top_pma_k7_gtx_basex_gtxtxinit_init_delay_count = 5'd20;
reg top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_wait;
wire top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_done;
reg [10:0] top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_count = 11'd1024;
wire top_pma_k7_gtx_basex_gtxtxinit_watchdog_wait;
wire top_pma_k7_gtx_basex_gtxtxinit_watchdog_done;
reg [15:0] top_pma_k7_gtx_basex_gtxtxinit_watchdog_count = 16'd40000;
wire top_pma_k7_gtx_basex_tx_init_reset;
reg top_pma_k7_gtx_basex_gtxrxinit_done;
wire top_pma_k7_gtx_basex_gtxrxinit_restart;
wire top_pma_k7_gtx_basex_gtxrxinit_plllock0;
reg top_pma_k7_gtx_basex_gtxrxinit_pllreset0 = 1'd0;
reg top_pma_k7_gtx_basex_gtxrxinit_gtXxreset0 = 1'd0;
reg top_pma_k7_gtx_basex_gtxrxinit_gtXxpd0 = 1'd0;
wire top_pma_k7_gtx_basex_gtxrxinit_Xxresetdone0;
reg top_pma_k7_gtx_basex_gtxrxinit_Xxdlysreset0 = 1'd0;
reg top_pma_k7_gtx_basex_gtxrxinit_Xxdlysresetdone0 = 1'd0;
reg top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone0 = 1'd0;
reg top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy0 = 1'd0;
reg top_pma_k7_gtx_basex_gtxrxinit_drp_start;
reg top_pma_k7_gtx_basex_gtxrxinit_drp_done = 1'd1;
wire top_pma_k7_gtx_basex_gtxrxinit_plllock1;
wire top_pma_k7_gtx_basex_gtxrxinit_Xxresetdone1;
wire top_pma_k7_gtx_basex_gtxrxinit_Xxdlysresetdone1;
wire top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone1;
reg top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone_r = 1'd1;
wire top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone_rising;
reg top_pma_k7_gtx_basex_gtxrxinit_pllreset1;
reg top_pma_k7_gtx_basex_gtxrxinit_gtXxreset1;
reg top_pma_k7_gtx_basex_gtxrxinit_gtXxpd1;
reg top_pma_k7_gtx_basex_gtxrxinit_Xxdlysreset1;
reg top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy1;
wire top_pma_k7_gtx_basex_gtxrxinit_reset;
wire top_pma_k7_gtx_basex_gtxrxinit_init_delay_wait;
wire top_pma_k7_gtx_basex_gtxrxinit_init_delay_done;
reg [4:0] top_pma_k7_gtx_basex_gtxrxinit_init_delay_count = 5'd20;
reg top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_wait;
wire top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_done;
reg [10:0] top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_count = 11'd1024;
wire top_pma_k7_gtx_basex_gtxrxinit_watchdog_wait;
wire top_pma_k7_gtx_basex_gtxrxinit_watchdog_done;
reg [15:0] top_pma_k7_gtx_basex_gtxrxinit_watchdog_count = 16'd40000;
wire top_pma_k7_gtx_basex_rx_init_reset;
wire top_pma_k7_gtx_basex_i;
wire top_pma_k7_gtx_basex_o;
reg top_pma_k7_gtx_basex_toggle_i = 1'd0;
wire top_pma_k7_gtx_basex_toggle_o;
reg top_pma_k7_gtx_basex_toggle_o_r = 1'd0;
reg [10:0] top_pma_k7_gtx_basex_cdr_lock_counter = 11'd0;
reg top_pma_k7_gtx_basex_cdr_locked = 1'd0;
wire [9:0] top_pma_k7_gtx_basex_tx_data1;
reg [19:0] top_pma_k7_gtx_basex_tx_data_half = 20'd0;
wire [19:0] top_pma_k7_gtx_basex_rx_data_half;
reg [9:0] top_pma_k7_gtx_basex_rx_data1 = 10'd0;
reg [19:0] top_pma_k7_gtx_basex_buf = 20'd0;
reg top_pma_k7_gtx_basex_phase_half = 1'd0;
reg top_pma_k7_gtx_basex_phase_half_rereg = 1'd0;
wire top_sink_valid;
wire top_sink_ready;
wire top_sink_first;
wire top_sink_last;
wire [7:0] top_sink_payload_data;
wire top_sink_payload_be;
wire top_sink_payload_error;
wire top_source_valid;
wire top_source_ready;
wire top_source_first;
wire top_source_last;
wire [7:0] top_source_payload_data;
wire top_source_payload_be;
wire top_source_payload_error;
wire top_tx_padding_sink_valid;
reg top_tx_padding_sink_ready;
wire top_tx_padding_sink_first;
wire top_tx_padding_sink_last;
wire [7:0] top_tx_padding_sink_payload_data;
wire top_tx_padding_sink_payload_be;
wire top_tx_padding_sink_payload_error;
reg top_tx_padding_source_valid;
wire top_tx_padding_source_ready;
reg top_tx_padding_source_first;
reg top_tx_padding_source_last;
reg [7:0] top_tx_padding_source_payload_data;
reg top_tx_padding_source_payload_be;
reg top_tx_padding_source_payload_error;
reg [15:0] top_tx_padding_counter = 16'd0;
wire top_tx_padding_counter_done;
wire top_tx_crc_sink_valid;
reg top_tx_crc_sink_ready;
wire top_tx_crc_sink_first;
wire top_tx_crc_sink_last;
wire [7:0] top_tx_crc_sink_payload_data;
wire top_tx_crc_sink_payload_be;
wire top_tx_crc_sink_payload_error;
reg top_tx_crc_source_valid;
wire top_tx_crc_source_ready;
reg top_tx_crc_source_first;
reg top_tx_crc_source_last;
reg [7:0] top_tx_crc_source_payload_data;
reg top_tx_crc_source_payload_be;
reg top_tx_crc_source_payload_error;
reg [31:0] top_tx_crc_crc_packet = 32'd0;
reg top_tx_crc_be0 = 1'd0;
wire [7:0] top_tx_crc_data0;
wire top_tx_crc_be1;
reg [31:0] top_tx_crc_value;
reg top_tx_crc_error;
wire [7:0] top_tx_crc_data1;
wire [31:0] top_tx_crc_crc_prev;
reg [31:0] top_tx_crc_crc_next;
reg [31:0] top_tx_crc_reg = 32'd4294967295;
reg top_tx_crc_ce;
reg top_tx_crc_reset;
reg [1:0] top_tx_crc_cnt = 2'd3;
wire top_tx_crc_cnt_done;
reg top_tx_crc_is_ongoing0;
reg top_tx_crc_is_ongoing1;
wire top_tx_crc_sink_sink_valid;
wire top_tx_crc_sink_sink_ready;
wire top_tx_crc_sink_sink_first;
wire top_tx_crc_sink_sink_last;
wire [7:0] top_tx_crc_sink_sink_payload_data;
wire top_tx_crc_sink_sink_payload_be;
wire top_tx_crc_sink_sink_payload_error;
wire top_tx_crc_source_source_valid;
wire top_tx_crc_source_source_ready;
wire top_tx_crc_source_source_first;
wire top_tx_crc_source_source_last;
wire [7:0] top_tx_crc_source_source_payload_data;
wire top_tx_crc_source_source_payload_be;
wire top_tx_crc_source_source_payload_error;
wire top_tx_crc_pipe_valid_sink_valid;
wire top_tx_crc_pipe_valid_sink_ready;
wire top_tx_crc_pipe_valid_sink_first;
wire top_tx_crc_pipe_valid_sink_last;
wire [7:0] top_tx_crc_pipe_valid_sink_payload_data;
wire top_tx_crc_pipe_valid_sink_payload_be;
wire top_tx_crc_pipe_valid_sink_payload_error;
reg top_tx_crc_pipe_valid_source_valid = 1'd0;
wire top_tx_crc_pipe_valid_source_ready;
reg top_tx_crc_pipe_valid_source_first = 1'd0;
reg top_tx_crc_pipe_valid_source_last = 1'd0;
reg [7:0] top_tx_crc_pipe_valid_source_payload_data = 8'd0;
reg top_tx_crc_pipe_valid_source_payload_be = 1'd0;
reg top_tx_crc_pipe_valid_source_payload_error = 1'd0;
wire top_tx_preamble_sink_valid;
reg top_tx_preamble_sink_ready;
wire top_tx_preamble_sink_first;
wire top_tx_preamble_sink_last;
wire [7:0] top_tx_preamble_sink_payload_data;
wire top_tx_preamble_sink_payload_be;
wire top_tx_preamble_sink_payload_error;
reg top_tx_preamble_source_valid;
wire top_tx_preamble_source_ready;
reg top_tx_preamble_source_first;
reg top_tx_preamble_source_last;
reg [7:0] top_tx_preamble_source_payload_data;
reg top_tx_preamble_source_payload_be;
reg top_tx_preamble_source_payload_error;
reg [63:0] top_tx_preamble_preamble = 64'd15372286728091293013;
reg [2:0] top_tx_preamble_count = 3'd0;
wire top_txdatapath_sink_sink_valid;
wire top_txdatapath_sink_sink_ready;
wire top_txdatapath_sink_sink_first;
wire top_txdatapath_sink_sink_last;
wire [7:0] top_txdatapath_sink_sink_payload_data;
wire top_txdatapath_sink_sink_payload_be;
wire top_txdatapath_sink_sink_payload_error;
wire top_txdatapath_source_source_valid;
wire top_txdatapath_source_source_ready;
wire top_txdatapath_source_source_first;
wire top_txdatapath_source_source_last;
wire [7:0] top_txdatapath_source_source_payload_data;
wire top_txdatapath_source_source_payload_be;
wire top_txdatapath_source_source_payload_error;
wire top_txdatapath_cdc_sink_valid;
wire top_txdatapath_cdc_sink_ready;
wire top_txdatapath_cdc_sink_first;
wire top_txdatapath_cdc_sink_last;
wire [7:0] top_txdatapath_cdc_sink_payload_data;
wire top_txdatapath_cdc_sink_payload_be;
wire top_txdatapath_cdc_sink_payload_error;
wire top_txdatapath_cdc_source_valid;
wire top_txdatapath_cdc_source_ready;
wire top_txdatapath_cdc_source_first;
wire top_txdatapath_cdc_source_last;
wire [7:0] top_txdatapath_cdc_source_payload_data;
wire top_txdatapath_cdc_source_payload_be;
wire top_txdatapath_cdc_source_payload_error;
wire top_txdatapath_cdc_asyncfifo_we;
wire top_txdatapath_cdc_asyncfifo_writable;
wire top_txdatapath_cdc_asyncfifo_re;
wire top_txdatapath_cdc_asyncfifo_readable;
wire [11:0] top_txdatapath_cdc_asyncfifo_din;
wire [11:0] top_txdatapath_cdc_asyncfifo_dout;
wire top_txdatapath_cdc_graycounter0_ce;
(* no_retiming = "true" *) reg [5:0] top_txdatapath_cdc_graycounter0_q = 6'd0;
wire [5:0] top_txdatapath_cdc_graycounter0_q_next;
reg [5:0] top_txdatapath_cdc_graycounter0_q_binary = 6'd0;
reg [5:0] top_txdatapath_cdc_graycounter0_q_next_binary;
wire top_txdatapath_cdc_graycounter1_ce;
(* no_retiming = "true" *) reg [5:0] top_txdatapath_cdc_graycounter1_q = 6'd0;
wire [5:0] top_txdatapath_cdc_graycounter1_q_next;
reg [5:0] top_txdatapath_cdc_graycounter1_q_binary = 6'd0;
reg [5:0] top_txdatapath_cdc_graycounter1_q_next_binary;
wire [5:0] top_txdatapath_cdc_produce_rdomain;
wire [5:0] top_txdatapath_cdc_consume_wdomain;
wire [4:0] top_txdatapath_cdc_wrport_adr;
wire [11:0] top_txdatapath_cdc_wrport_dat_r;
wire top_txdatapath_cdc_wrport_we;
wire [11:0] top_txdatapath_cdc_wrport_dat_w;
wire [4:0] top_txdatapath_cdc_rdport_adr;
wire [11:0] top_txdatapath_cdc_rdport_dat_r;
wire [7:0] top_txdatapath_cdc_fifo_in_payload_data;
wire top_txdatapath_cdc_fifo_in_payload_be;
wire top_txdatapath_cdc_fifo_in_payload_error;
wire top_txdatapath_cdc_fifo_in_first;
wire top_txdatapath_cdc_fifo_in_last;
wire [7:0] top_txdatapath_cdc_fifo_out_payload_data;
wire top_txdatapath_cdc_fifo_out_payload_be;
wire top_txdatapath_cdc_fifo_out_payload_error;
wire top_txdatapath_cdc_fifo_out_first;
wire top_txdatapath_cdc_fifo_out_last;
wire top_tx_packet_fifo_sink_sink_valid;
wire top_tx_packet_fifo_sink_sink_ready;
wire top_tx_packet_fifo_sink_sink_first;
wire top_tx_packet_fifo_sink_sink_last;
wire [7:0] top_tx_packet_fifo_sink_sink_payload_data;
wire top_tx_packet_fifo_sink_sink_payload_be;
wire top_tx_packet_fifo_sink_sink_payload_error;
wire top_tx_packet_fifo_source_source_valid;
wire top_tx_packet_fifo_source_source_ready;
reg top_tx_packet_fifo_source_source_first;
wire top_tx_packet_fifo_source_source_last;
wire [7:0] top_tx_packet_fifo_source_source_payload_data;
wire top_tx_packet_fifo_source_source_payload_be;
wire top_tx_packet_fifo_source_source_payload_error;
wire top_tx_packet_fifo_payload_fifo_sink_valid;
wire top_tx_packet_fifo_payload_fifo_sink_ready;
wire top_tx_packet_fifo_payload_fifo_sink_first;
wire top_tx_packet_fifo_payload_fifo_sink_last;
wire [7:0] top_tx_packet_fifo_payload_fifo_sink_payload_data;
wire top_tx_packet_fifo_payload_fifo_sink_payload_be;
wire top_tx_packet_fifo_payload_fifo_sink_payload_error;
wire top_tx_packet_fifo_payload_fifo_source_valid;
wire top_tx_packet_fifo_payload_fifo_source_ready;
wire top_tx_packet_fifo_payload_fifo_source_first;
wire top_tx_packet_fifo_payload_fifo_source_last;
wire [7:0] top_tx_packet_fifo_payload_fifo_source_payload_data;
wire top_tx_packet_fifo_payload_fifo_source_payload_be;
wire top_tx_packet_fifo_payload_fifo_source_payload_error;
wire top_tx_packet_fifo_payload_fifo_re;
reg top_tx_packet_fifo_payload_fifo_readable = 1'd0;
wire top_tx_packet_fifo_payload_fifo_syncfifo_we;
wire top_tx_packet_fifo_payload_fifo_syncfifo_writable;
wire top_tx_packet_fifo_payload_fifo_syncfifo_re;
wire top_tx_packet_fifo_payload_fifo_syncfifo_readable;
wire [11:0] top_tx_packet_fifo_payload_fifo_syncfifo_din;
wire [11:0] top_tx_packet_fifo_payload_fifo_syncfifo_dout;
reg [11:0] top_tx_packet_fifo_payload_fifo_level0 = 12'd0;
reg top_tx_packet_fifo_payload_fifo_replace = 1'd0;
reg [10:0] top_tx_packet_fifo_payload_fifo_produce = 11'd0;
reg [10:0] top_tx_packet_fifo_payload_fifo_consume = 11'd0;
reg [10:0] top_tx_packet_fifo_payload_fifo_wrport_adr;
wire [11:0] top_tx_packet_fifo_payload_fifo_wrport_dat_r;
wire top_tx_packet_fifo_payload_fifo_wrport_we;
wire [11:0] top_tx_packet_fifo_payload_fifo_wrport_dat_w;
wire top_tx_packet_fifo_payload_fifo_do_read;
wire [10:0] top_tx_packet_fifo_payload_fifo_rdport_adr;
wire [11:0] top_tx_packet_fifo_payload_fifo_rdport_dat_r;
wire top_tx_packet_fifo_payload_fifo_rdport_re;
wire [11:0] top_tx_packet_fifo_payload_fifo_level1;
wire [7:0] top_tx_packet_fifo_payload_fifo_fifo_in_payload_data;
wire top_tx_packet_fifo_payload_fifo_fifo_in_payload_be;
wire top_tx_packet_fifo_payload_fifo_fifo_in_payload_error;
wire top_tx_packet_fifo_payload_fifo_fifo_in_first;
wire top_tx_packet_fifo_payload_fifo_fifo_in_last;
wire [7:0] top_tx_packet_fifo_payload_fifo_fifo_out_payload_data;
wire top_tx_packet_fifo_payload_fifo_fifo_out_payload_be;
wire top_tx_packet_fifo_payload_fifo_fifo_out_payload_error;
wire top_tx_packet_fifo_payload_fifo_fifo_out_first;
wire top_tx_packet_fifo_payload_fifo_fifo_out_last;
wire top_tx_packet_fifo_param_fifo_sink_valid;
wire top_tx_packet_fifo_param_fifo_sink_ready;
reg top_tx_packet_fifo_param_fifo_sink_first = 1'd0;
reg top_tx_packet_fifo_param_fifo_sink_last = 1'd0;
reg top_tx_packet_fifo_param_fifo_sink_param_dummy = 1'd0;
wire top_tx_packet_fifo_param_fifo_source_valid;
wire top_tx_packet_fifo_param_fifo_source_ready;
wire top_tx_packet_fifo_param_fifo_source_first;
wire top_tx_packet_fifo_param_fifo_source_last;
wire top_tx_packet_fifo_param_fifo_source_param_dummy;
wire top_tx_packet_fifo_param_fifo_re;
reg top_tx_packet_fifo_param_fifo_readable = 1'd0;
wire top_tx_packet_fifo_param_fifo_syncfifo_we;
wire top_tx_packet_fifo_param_fifo_syncfifo_writable;
wire top_tx_packet_fifo_param_fifo_syncfifo_re;
wire top_tx_packet_fifo_param_fifo_syncfifo_readable;
wire [2:0] top_tx_packet_fifo_param_fifo_syncfifo_din;
wire [2:0] top_tx_packet_fifo_param_fifo_syncfifo_dout;
reg [2:0] top_tx_packet_fifo_param_fifo_level0 = 3'd0;
reg top_tx_packet_fifo_param_fifo_replace = 1'd0;
reg [2:0] top_tx_packet_fifo_param_fifo_produce = 3'd0;
reg [2:0] top_tx_packet_fifo_param_fifo_consume = 3'd0;
reg [2:0] top_tx_packet_fifo_param_fifo_wrport_adr;
wire [2:0] top_tx_packet_fifo_param_fifo_wrport_dat_r;
wire top_tx_packet_fifo_param_fifo_wrport_we;
wire [2:0] top_tx_packet_fifo_param_fifo_wrport_dat_w;
wire top_tx_packet_fifo_param_fifo_do_read;
wire [2:0] top_tx_packet_fifo_param_fifo_rdport_adr;
wire [2:0] top_tx_packet_fifo_param_fifo_rdport_dat_r;
wire top_tx_packet_fifo_param_fifo_rdport_re;
wire [2:0] top_tx_packet_fifo_param_fifo_level1;
wire top_tx_packet_fifo_param_fifo_fifo_in_param_dummy;
wire top_tx_packet_fifo_param_fifo_fifo_in_first;
wire top_tx_packet_fifo_param_fifo_fifo_in_last;
wire top_tx_packet_fifo_param_fifo_fifo_out_param_dummy;
wire top_tx_packet_fifo_param_fifo_fifo_out_first;
wire top_tx_packet_fifo_param_fifo_fifo_out_last;
wire top_tx_gap_sink_valid;
reg top_tx_gap_sink_ready;
wire top_tx_gap_sink_first;
wire top_tx_gap_sink_last;
wire [7:0] top_tx_gap_sink_payload_data;
wire top_tx_gap_sink_payload_be;
wire top_tx_gap_sink_payload_error;
reg top_tx_gap_source_valid;
wire top_tx_gap_source_ready;
reg top_tx_gap_source_first;
reg top_tx_gap_source_last;
reg [7:0] top_tx_gap_source_payload_data;
reg top_tx_gap_source_payload_be;
reg top_tx_gap_source_payload_error;
reg [3:0] top_tx_gap_counter = 4'd0;
reg [31:0] top_preamble_errors_status = 32'd0;
reg [31:0] top_crc_errors_status = 32'd0;
reg [31:0] top_drops_status = 32'd0;
wire top_rx_packet_fifo_sink_sink_valid;
wire top_rx_packet_fifo_sink_sink_ready;
wire top_rx_packet_fifo_sink_sink_first;
wire top_rx_packet_fifo_sink_sink_last;
wire [7:0] top_rx_packet_fifo_sink_sink_payload_data;
wire top_rx_packet_fifo_sink_sink_payload_be;
wire top_rx_packet_fifo_sink_sink_payload_error;
wire top_rx_packet_fifo_source_source_valid;
wire top_rx_packet_fifo_source_source_ready;
wire top_rx_packet_fifo_source_source_first;
wire top_rx_packet_fifo_source_source_last;
wire [7:0] top_rx_packet_fifo_source_source_payload_data;
wire top_rx_packet_fifo_source_source_payload_be;
wire top_rx_packet_fifo_source_source_payload_error;
reg top_rx_packet_fifo_discard = 1'd0;
wire top_rx_packet_fifo_drop;
wire top_rx_packet_fifo_param_fifo_sink_valid;
wire top_rx_packet_fifo_param_fifo_sink_ready;
reg top_rx_packet_fifo_param_fifo_sink_first = 1'd0;
wire top_rx_packet_fifo_param_fifo_sink_last;
reg top_rx_packet_fifo_param_fifo_sink_param_dummy = 1'd0;
wire top_rx_packet_fifo_param_fifo_source_valid;
wire top_rx_packet_fifo_param_fifo_source_ready;
wire top_rx_packet_fifo_param_fifo_source_first;
wire top_rx_packet_fifo_param_fifo_source_last;
wire top_rx_packet_fifo_param_fifo_source_param_dummy;
wire top_rx_packet_fifo_param_fifo_syncfifo_we;
wire top_rx_packet_fifo_param_fifo_syncfifo_writable;
wire top_rx_packet_fifo_param_fifo_syncfifo_re;
wire top_rx_packet_fifo_param_fifo_syncfifo_readable;
wire [2:0] top_rx_packet_fifo_param_fifo_syncfifo_din;
wire [2:0] top_rx_packet_fifo_param_fifo_syncfifo_dout;
reg [2:0] top_rx_packet_fifo_param_fifo_level = 3'd0;
reg top_rx_packet_fifo_param_fifo_replace = 1'd0;
reg [1:0] top_rx_packet_fifo_param_fifo_produce = 2'd0;
reg [1:0] top_rx_packet_fifo_param_fifo_consume = 2'd0;
reg [1:0] top_rx_packet_fifo_param_fifo_wrport_adr;
wire [2:0] top_rx_packet_fifo_param_fifo_wrport_dat_r;
wire top_rx_packet_fifo_param_fifo_wrport_we;
wire [2:0] top_rx_packet_fifo_param_fifo_wrport_dat_w;
wire top_rx_packet_fifo_param_fifo_do_read;
wire [1:0] top_rx_packet_fifo_param_fifo_rdport_adr;
wire [2:0] top_rx_packet_fifo_param_fifo_rdport_dat_r;
wire top_rx_packet_fifo_param_fifo_fifo_in_param_dummy;
wire top_rx_packet_fifo_param_fifo_fifo_in_first;
wire top_rx_packet_fifo_param_fifo_fifo_in_last;
wire top_rx_packet_fifo_param_fifo_fifo_out_param_dummy;
wire top_rx_packet_fifo_param_fifo_fifo_out_first;
wire top_rx_packet_fifo_param_fifo_fifo_out_last;
wire [10:0] top_rx_packet_fifo_wr_port_adr;
wire [11:0] top_rx_packet_fifo_wr_port_dat_r;
wire top_rx_packet_fifo_wr_port_we;
wire [11:0] top_rx_packet_fifo_wr_port_dat_w;
wire [10:0] top_rx_packet_fifo_rd_port_adr;
wire [11:0] top_rx_packet_fifo_rd_port_dat_r;
wire top_rx_packet_fifo_rd_port_re;
reg [11:0] top_rx_packet_fifo_wr_ptr = 12'd0;
reg [11:0] top_rx_packet_fifo_commit_ptr = 12'd0;
reg [11:0] top_rx_packet_fifo_rd_ptr = 12'd0;
reg top_rx_packet_fifo_out_valid = 1'd0;
wire [11:0] top_rx_packet_fifo_used;
wire top_rx_packet_fifo_full;
reg top_rx_packet_fifo_overflow = 1'd0;
reg top_rx_packet_fifo_invalid = 1'd0;
wire top_rx_packet_fifo_commit;
wire top_rx_packet_fifo_fetch;
wire top_i;
wire top_o;
reg top_toggle_i = 1'd0;
wire top_toggle_o;
reg top_toggle_o_r = 1'd0;
wire top_rx_cdc_sink_sink_valid;
wire top_rx_cdc_sink_sink_ready;
wire top_rx_cdc_sink_sink_first;
wire top_rx_cdc_sink_sink_last;
wire [7:0] top_rx_cdc_sink_sink_payload_data;
wire top_rx_cdc_sink_sink_payload_be;
wire top_rx_cdc_sink_sink_payload_error;
wire top_rx_cdc_source_source_valid;
wire top_rx_cdc_source_source_ready;
wire top_rx_cdc_source_source_first;
wire top_rx_cdc_source_source_last;
wire [7:0] top_rx_cdc_source_source_payload_data;
wire top_rx_cdc_source_source_payload_be;
wire top_rx_cdc_source_source_payload_error;
wire top_rx_cdc_cdc_sink_valid;
wire top_rx_cdc_cdc_sink_ready;
wire top_rx_cdc_cdc_sink_first;
wire top_rx_cdc_cdc_sink_last;
wire [7:0] top_rx_cdc_cdc_sink_payload_data;
wire top_rx_cdc_cdc_sink_payload_be;
wire top_rx_cdc_cdc_sink_payload_error;
wire top_rx_cdc_cdc_source_valid;
wire top_rx_cdc_cdc_source_ready;
wire top_rx_cdc_cdc_source_first;
wire top_rx_cdc_cdc_source_last;
wire [7:0] top_rx_cdc_cdc_source_payload_data;
wire top_rx_cdc_cdc_source_payload_be;
wire top_rx_cdc_cdc_source_payload_error;
wire top_rx_cdc_cdc_asyncfifo_we;
wire top_rx_cdc_cdc_asyncfifo_writable;
wire top_rx_cdc_cdc_asyncfifo_re;
wire top_rx_cdc_cdc_asyncfifo_readable;
wire [11:0] top_rx_cdc_cdc_asyncfifo_din;
wire [11:0] top_rx_cdc_cdc_asyncfifo_dout;
wire top_rx_cdc_cdc_graycounter0_ce;
(* no_retiming = "true" *) reg [5:0] top_rx_cdc_cdc_graycounter0_q = 6'd0;
wire [5:0] top_rx_cdc_cdc_graycounter0_q_next;
reg [5:0] top_rx_cdc_cdc_graycounter0_q_binary = 6'd0;
reg [5:0] top_rx_cdc_cdc_graycounter0_q_next_binary;
wire top_rx_cdc_cdc_graycounter1_ce;
(* no_retiming = "true" *) reg [5:0] top_rx_cdc_cdc_graycounter1_q = 6'd0;
wire [5:0] top_rx_cdc_cdc_graycounter1_q_next;
reg [5:0] top_rx_cdc_cdc_graycounter1_q_binary = 6'd0;
reg [5:0] top_rx_cdc_cdc_graycounter1_q_next_binary;
wire [5:0] top_rx_cdc_cdc_produce_rdomain;
wire [5:0] top_rx_cdc_cdc_consume_wdomain;
wire [4:0] top_rx_cdc_cdc_wrport_adr;
wire [11:0] top_rx_cdc_cdc_wrport_dat_r;
wire top_rx_cdc_cdc_wrport_we;
wire [11:0] top_rx_cdc_cdc_wrport_dat_w;
wire [4:0] top_rx_cdc_cdc_rdport_adr;
wire [11:0] top_rx_cdc_cdc_rdport_dat_r;
wire [7:0] top_rx_cdc_cdc_fifo_in_payload_data;
wire top_rx_cdc_cdc_fifo_in_payload_be;
wire top_rx_cdc_cdc_fifo_in_payload_error;
wire top_rx_cdc_cdc_fifo_in_first;
wire top_rx_cdc_cdc_fifo_in_last;
wire [7:0] top_rx_cdc_cdc_fifo_out_payload_data;
wire top_rx_cdc_cdc_fifo_out_payload_be;
wire top_rx_cdc_cdc_fifo_out_payload_error;
wire top_rx_cdc_cdc_fifo_out_first;
wire top_rx_cdc_cdc_fifo_out_last;
wire top_rx_preamble_sink_valid;
reg top_rx_preamble_sink_ready;
wire top_rx_preamble_sink_first;
wire top_rx_preamble_sink_last;
wire [7:0] top_rx_preamble_sink_payload_data;
wire top_rx_preamble_sink_payload_be;
wire top_rx_preamble_sink_payload_error;
reg top_rx_preamble_source_valid;
wire top_rx_preamble_source_ready;
reg top_rx_preamble_source_first;
reg top_rx_preamble_source_last;
wire [7:0] top_rx_preamble_source_payload_data;
wire top_rx_preamble_source_payload_be;
reg top_rx_preamble_source_payload_error;
reg top_rx_preamble_error;
reg [63:0] top_rx_preamble_preamble = 64'd15372286728091293013;
wire top_pulsesynchronizer0_i;
wire top_pulsesynchronizer0_o;
reg top_pulsesynchronizer0_toggle_i = 1'd0;
wire top_pulsesynchronizer0_toggle_o;
reg top_pulsesynchronizer0_toggle_o_r = 1'd0;
wire top_liteethmaccrc32checker_sink_sink_valid;
reg top_liteethmaccrc32checker_sink_sink_ready;
wire top_liteethmaccrc32checker_sink_sink_first;
wire top_liteethmaccrc32checker_sink_sink_last;
wire [7:0] top_liteethmaccrc32checker_sink_sink_payload_data;
wire top_liteethmaccrc32checker_sink_sink_payload_be;
wire top_liteethmaccrc32checker_sink_sink_payload_error;
reg top_liteethmaccrc32checker_source_source_valid;
wire top_liteethmaccrc32checker_source_source_ready;
wire top_liteethmaccrc32checker_source_source_first;
reg top_liteethmaccrc32checker_source_source_last;
wire [7:0] top_liteethmaccrc32checker_source_source_payload_data;
reg top_liteethmaccrc32checker_source_source_payload_be;
reg top_liteethmaccrc32checker_source_source_payload_error;
reg top_liteethmaccrc32checker_error;
wire [7:0] top_liteethmaccrc32checker_crc_data0;
wire top_liteethmaccrc32checker_crc_be;
reg top_liteethmaccrc32checker_crc_error;
reg [7:0] top_liteethmaccrc32checker_crc_data1;
wire [31:0] top_liteethmaccrc32checker_crc_crc_prev;
reg [31:0] top_liteethmaccrc32checker_crc_crc_next;
reg [31:0] top_liteethmaccrc32checker_crc_reg = 32'd4294967295;
reg top_liteethmaccrc32checker_crc_ce;
reg top_liteethmaccrc32checker_crc_reset;
reg top_liteethmaccrc32checker_syncfifo_sink_valid;
wire top_liteethmaccrc32checker_syncfifo_sink_ready;
wire top_liteethmaccrc32checker_syncfifo_sink_first;
wire top_liteethmaccrc32checker_syncfifo_sink_last;
wire [7:0] top_liteethmaccrc32checker_syncfifo_sink_payload_data;
wire top_liteethmaccrc32checker_syncfifo_sink_payload_be;
wire top_liteethmaccrc32checker_syncfifo_sink_payload_error;
wire top_liteethmaccrc32checker_syncfifo_source_valid;
reg top_liteethmaccrc32checker_syncfifo_source_ready;
wire top_liteethmaccrc32checker_syncfifo_source_first;
wire top_liteethmaccrc32checker_syncfifo_source_last;
wire [7:0] top_liteethmaccrc32checker_syncfifo_source_payload_data;
wire top_liteethmaccrc32checker_syncfifo_source_payload_be;
wire top_liteethmaccrc32checker_syncfifo_source_payload_error;
wire top_liteethmaccrc32checker_syncfifo_syncfifo_we;
wire top_liteethmaccrc32checker_syncfifo_syncfifo_writable;
wire top_liteethmaccrc32checker_syncfifo_syncfifo_re;
wire top_liteethmaccrc32checker_syncfifo_syncfifo_readable;
wire [11:0] top_liteethmaccrc32checker_syncfifo_syncfifo_din;
wire [11:0] top_liteethmaccrc32checker_syncfifo_syncfifo_dout;
reg [2:0] top_liteethmaccrc32checker_syncfifo_level = 3'd0;
reg top_liteethmaccrc32checker_syncfifo_replace = 1'd0;
reg [2:0] top_liteethmaccrc32checker_syncfifo_produce = 3'd0;
reg [2:0] top_liteethmaccrc32checker_syncfifo_consume = 3'd0;
reg [2:0] top_liteethmaccrc32checker_syncfifo_wrport_adr;
wire [11:0] top_liteethmaccrc32checker_syncfifo_wrport_dat_r;
wire top_liteethmaccrc32checker_syncfifo_wrport_we;
wire [11:0] top_liteethmaccrc32checker_syncfifo_wrport_dat_w;
wire top_liteethmaccrc32checker_syncfifo_do_read;
wire [2:0] top_liteethmaccrc32checker_syncfifo_rdport_adr;
wire [11:0] top_liteethmaccrc32checker_syncfifo_rdport_dat_r;
wire [7:0] top_liteethmaccrc32checker_syncfifo_fifo_in_payload_data;
wire top_liteethmaccrc32checker_syncfifo_fifo_in_payload_be;
wire top_liteethmaccrc32checker_syncfifo_fifo_in_payload_error;
wire top_liteethmaccrc32checker_syncfifo_fifo_in_first;
wire top_liteethmaccrc32checker_syncfifo_fifo_in_last;
wire [7:0] top_liteethmaccrc32checker_syncfifo_fifo_out_payload_data;
wire top_liteethmaccrc32checker_syncfifo_fifo_out_payload_be;
wire top_liteethmaccrc32checker_syncfifo_fifo_out_payload_error;
wire top_liteethmaccrc32checker_syncfifo_fifo_out_first;
wire top_liteethmaccrc32checker_syncfifo_fifo_out_last;
reg top_liteethmaccrc32checker_fifo_reset;
wire top_liteethmaccrc32checker_fifo_in;
wire top_liteethmaccrc32checker_fifo_out;
wire top_liteethmaccrc32checker_fifo_full;
reg top_liteethmaccrc32checker_is_ongoing0;
reg top_liteethmaccrc32checker_is_ongoing1;
reg top_liteethmaccrc32checker_be = 1'd0;
reg top_liteethmaccrc32checker_last_error = 1'd0;
wire top_liteethmaccrc32checker_last_word_error;
reg top_liteethmaccrc32checker_packet_error = 1'd0;
reg top_liteethmaccrc32checker_is_ongoing2;
wire top_bufferizeendpoints_sink_sink_valid;
wire top_bufferizeendpoints_sink_sink_ready;
wire top_bufferizeendpoints_sink_sink_first;
wire top_bufferizeendpoints_sink_sink_last;
wire [7:0] top_bufferizeendpoints_sink_sink_payload_data;
wire top_bufferizeendpoints_sink_sink_payload_be;
wire top_bufferizeendpoints_sink_sink_payload_error;
wire top_bufferizeendpoints_source_source_valid;
wire top_bufferizeendpoints_source_source_ready;
wire top_bufferizeendpoints_source_source_first;
wire top_bufferizeendpoints_source_source_last;
wire [7:0] top_bufferizeendpoints_source_source_payload_data;
wire top_bufferizeendpoints_source_source_payload_be;
wire top_bufferizeendpoints_source_source_payload_error;
wire top_bufferizeendpoints_pipe_valid_sink_valid;
wire top_bufferizeendpoints_pipe_valid_sink_ready;
wire top_bufferizeendpoints_pipe_valid_sink_first;
wire top_bufferizeendpoints_pipe_valid_sink_last;
wire [7:0] top_bufferizeendpoints_pipe_valid_sink_payload_data;
wire top_bufferizeendpoints_pipe_valid_sink_payload_be;
wire top_bufferizeendpoints_pipe_valid_sink_payload_error;
reg top_bufferizeendpoints_pipe_valid_source_valid = 1'd0;
wire top_bufferizeendpoints_pipe_valid_source_ready;
reg top_bufferizeendpoints_pipe_valid_source_first = 1'd0;
reg top_bufferizeendpoints_pipe_valid_source_last = 1'd0;
reg [7:0] top_bufferizeendpoints_pipe_valid_source_payload_data = 8'd0;
reg top_bufferizeendpoints_pipe_valid_source_payload_be = 1'd0;
reg top_bufferizeendpoints_pipe_valid_source_payload_error = 1'd0;
wire top_pulsesynchronizer1_i;
wire top_pulsesynchronizer1_o;
reg top_pulsesynchronizer1_toggle_i = 1'd0;
wire top_pulsesynchronizer1_toggle_o;
reg top_pulsesynchronizer1_toggle_o_r = 1'd0;
wire top_rx_padding_sink_valid;
wire top_rx_padding_sink_ready;
wire top_rx_padding_sink_first;
wire top_rx_padding_sink_last;
wire [7:0] top_rx_padding_sink_payload_data;
wire top_rx_padding_sink_payload_be;
wire top_rx_padding_sink_payload_error;
wire top_rx_padding_source_valid;
wire top_rx_padding_source_ready;
wire top_rx_padding_source_first;
wire top_rx_padding_source_last;
wire [7:0] top_rx_padding_source_payload_data;
wire top_rx_padding_source_payload_be;
reg top_rx_padding_source_payload_error;
reg [10:0] top_rx_padding_length = 11'd0;
wire [3:0] top_rx_padding_length_inc;
reg top_first = 1'd1;
wire top_capture_arm;
wire top_capture_done;
wire [11:0] top_capture_address;
wire top_capture_pattern0;
wire top_capture_bank0;
wire top_capture_arm_cdc_i;
wire top_capture_arm_cdc_o;
reg top_capture_arm_cdc_toggle_i = 1'd0;
wire top_capture_arm_cdc_toggle_o;
reg top_capture_arm_cdc_toggle_o_r = 1'd0;
wire top_capture_done_cdc_i;
wire top_capture_done_cdc_o;
reg top_capture_done_cdc_toggle_i = 1'd0;
wire top_capture_done_cdc_toggle_o;
reg top_capture_done_cdc_toggle_o_r = 1'd0;
wire top_capture_pattern1;
wire top_capture_bank1;
reg top_capture_active = 1'd0;
reg [11:0] top_capture_index = 12'd0;
wire [13:0] top_capture_sampled0;
wire [11:0] top_capture_wp_memory0_adr;
wire [15:0] top_capture_wp_memory0_dat_r;
wire top_capture_wp_memory0_we;
wire [15:0] top_capture_wp_memory0_dat_w;
wire [11:0] top_capture_rp_memory0_adr;
wire [15:0] top_capture_rp_memory0_dat_r;
wire [13:0] top_capture_sampled1;
wire [11:0] top_capture_wp_memory1_adr;
wire [15:0] top_capture_wp_memory1_dat_r;
wire top_capture_wp_memory1_we;
wire [15:0] top_capture_wp_memory1_dat_w;
wire [11:0] top_capture_rp_memory1_adr;
wire [15:0] top_capture_rp_memory1_dat_r;
wire [13:0] top_capture_sampled2;
wire [11:0] top_capture_wp_memory2_adr;
wire [15:0] top_capture_wp_memory2_dat_r;
wire top_capture_wp_memory2_we;
wire [15:0] top_capture_wp_memory2_dat_w;
wire [11:0] top_capture_rp_memory2_adr;
wire [15:0] top_capture_rp_memory2_dat_r;
wire [13:0] top_capture_sampled3;
wire [11:0] top_capture_wp_memory3_adr;
wire [15:0] top_capture_wp_memory3_dat_r;
wire top_capture_wp_memory3_we;
wire [15:0] top_capture_wp_memory3_dat_w;
wire [11:0] top_capture_rp_memory3_adr;
wire [15:0] top_capture_rp_memory3_dat_r;
wire [13:0] top_capture_sampled4;
wire [11:0] top_capture_wp_memory4_adr;
wire [15:0] top_capture_wp_memory4_dat_r;
wire top_capture_wp_memory4_we;
wire [15:0] top_capture_wp_memory4_dat_w;
wire [11:0] top_capture_rp_memory4_adr;
wire [15:0] top_capture_rp_memory4_dat_r;
wire [13:0] top_capture_sampled5;
wire [11:0] top_capture_wp_memory5_adr;
wire [15:0] top_capture_wp_memory5_dat_r;
wire top_capture_wp_memory5_we;
wire [15:0] top_capture_wp_memory5_dat_w;
wire [11:0] top_capture_rp_memory5_adr;
wire [15:0] top_capture_rp_memory5_dat_r;
wire [13:0] top_capture_sampled6;
wire [11:0] top_capture_wp_memory6_adr;
wire [15:0] top_capture_wp_memory6_dat_r;
wire top_capture_wp_memory6_we;
wire [15:0] top_capture_wp_memory6_dat_w;
wire [11:0] top_capture_rp_memory6_adr;
wire [15:0] top_capture_rp_memory6_dat_r;
wire [13:0] top_capture_sampled7;
wire [11:0] top_capture_wp_memory7_adr;
wire [15:0] top_capture_wp_memory7_dat_r;
wire top_capture_wp_memory7_we;
wire [15:0] top_capture_wp_memory7_dat_w;
wire [11:0] top_capture_rp_memory7_adr;
wire [15:0] top_capture_rp_memory7_dat_r;
wire [13:0] top_capture_sampled8;
wire [11:0] top_capture_wp_memory8_adr;
wire [15:0] top_capture_wp_memory8_dat_r;
wire top_capture_wp_memory8_we;
wire [15:0] top_capture_wp_memory8_dat_w;
wire [11:0] top_capture_rp_memory8_adr;
wire [15:0] top_capture_rp_memory8_dat_r;
wire [13:0] top_capture_sampled9;
wire [11:0] top_capture_wp_memory9_adr;
wire [15:0] top_capture_wp_memory9_dat_r;
wire top_capture_wp_memory9_we;
wire [15:0] top_capture_wp_memory9_dat_w;
wire [11:0] top_capture_rp_memory9_adr;
wire [15:0] top_capture_rp_memory9_dat_r;
wire [13:0] top_capture_sampled10;
wire [11:0] top_capture_wp_memory10_adr;
wire [15:0] top_capture_wp_memory10_dat_r;
wire top_capture_wp_memory10_we;
wire [15:0] top_capture_wp_memory10_dat_w;
wire [11:0] top_capture_rp_memory10_adr;
wire [15:0] top_capture_rp_memory10_dat_r;
wire [13:0] top_capture_sampled11;
wire [11:0] top_capture_wp_memory11_adr;
wire [15:0] top_capture_wp_memory11_dat_r;
wire top_capture_wp_memory11_we;
wire [15:0] top_capture_wp_memory11_dat_w;
wire [11:0] top_capture_rp_memory11_adr;
wire [15:0] top_capture_rp_memory11_dat_r;
wire [2:0] top_raw;
wire [15:0] top_command;
wire top_analyzer_arm;
reg [31:0] top_analyzer_arm_count = 32'd0;
wire [10:0] top_analyzer_address;
wire [34:0] top_analyzer_data;
wire [2:0] top_analyzer_lines;
reg [11:0] top_analyzer_count = 12'd0;
reg top_analyzer_active = 1'd0;
reg [31:0] top_analyzer_elapsed = 32'd0;
reg [31:0] top_analyzer_tick = 32'd0;
wire [34:0] top_analyzer_selected;
wire [15:0] top_analyzer_cmd;
reg [2:0] top_analyzer_prev = 3'd7;
wire top_analyzer_arming;
wire top_analyzer_storing;
wire [10:0] top_analyzer_index;
wire [34:0] top_analyzer_word;
wire [31:0] top_analyzer_stamp;
wire [10:0] top_analyzer_wp_memory0_adr;
wire [34:0] top_analyzer_wp_memory0_dat_r;
wire top_analyzer_wp_memory0_we;
wire [34:0] top_analyzer_wp_memory0_dat_w;
wire [10:0] top_analyzer_rp_memory0_adr;
wire [34:0] top_analyzer_rp_memory0_dat_r;
wire [10:0] top_analyzer_wp_memory1_adr;
wire [34:0] top_analyzer_wp_memory1_dat_r;
wire top_analyzer_wp_memory1_we;
wire [34:0] top_analyzer_wp_memory1_dat_w;
wire [10:0] top_analyzer_rp_memory1_adr;
wire [34:0] top_analyzer_rp_memory1_dat_r;
wire [511:0] top_analyzer_report;
wire [511:0] top_jtag_report;
wire top_tdc_frontend_tdcbuffers_arm;
wire top_tdc_frontend_tdcbuffers_stop;
wire top_tdc_frontend_tdcbuffers_ready;
wire top_tdc_frontend_tdcbuffers_started;
reg top_tdc_frontend_tdcbuffers_busy = 1'd0;
reg top_tdc_frontend_tdcbuffers_valid = 1'd0;
reg top_tdc_frontend_tdcbuffers_done = 1'd0;
reg top_tdc_frontend_tdcbuffers_rejected = 1'd0;
reg [31:0] top_tdc_frontend_tdcbuffers_capture_id = 32'd0;
wire [11:0] top_tdc_frontend_tdcbuffers_address;
wire top_tdc_frontend_tdcbuffers_event0;
wire top_tdc_frontend_tdcbuffers_event1;
wire top_tdc_frontend_tdcbuffers_event2;
wire top_tdc_frontend_tdcbuffers_event3;
wire top_tdc_frontend_tdcbuffers_event4;
wire top_tdc_frontend_tdcbuffers_event5;
wire top_tdc_frontend_tdcbuffers_event6;
wire top_tdc_frontend_tdcbuffers_event7;
wire top_tdc_frontend_tdcbuffers_event8;
wire top_tdc_frontend_tdcbuffers_event9;
wire top_tdc_frontend_tdcbuffers_event10;
wire top_tdc_frontend_tdcbuffers_event11;
wire [12:0] top_tdc_frontend_tdcbuffers_raw0;
wire [12:0] top_tdc_frontend_tdcbuffers_raw1;
wire [12:0] top_tdc_frontend_tdcbuffers_raw2;
wire [12:0] top_tdc_frontend_tdcbuffers_raw3;
wire [12:0] top_tdc_frontend_tdcbuffers_raw4;
wire [12:0] top_tdc_frontend_tdcbuffers_raw5;
wire [12:0] top_tdc_frontend_tdcbuffers_raw6;
wire [12:0] top_tdc_frontend_tdcbuffers_raw7;
wire [12:0] top_tdc_frontend_tdcbuffers_raw8;
wire [12:0] top_tdc_frontend_tdcbuffers_raw9;
wire [12:0] top_tdc_frontend_tdcbuffers_raw10;
wire [12:0] top_tdc_frontend_tdcbuffers_raw11;
reg [12:0] top_tdc_frontend_tdcbuffers0 = 13'd0;
reg [12:0] top_tdc_frontend_tdcbuffers1 = 13'd0;
reg [12:0] top_tdc_frontend_tdcbuffers2 = 13'd0;
reg [12:0] top_tdc_frontend_tdcbuffers3 = 13'd0;
reg [12:0] top_tdc_frontend_tdcbuffers4 = 13'd0;
reg [12:0] top_tdc_frontend_tdcbuffers5 = 13'd0;
reg [12:0] top_tdc_frontend_tdcbuffers6 = 13'd0;
reg [12:0] top_tdc_frontend_tdcbuffers7 = 13'd0;
reg [12:0] top_tdc_frontend_tdcbuffers8 = 13'd0;
reg [12:0] top_tdc_frontend_tdcbuffers9 = 13'd0;
reg [12:0] top_tdc_frontend_tdcbuffers10 = 13'd0;
reg [12:0] top_tdc_frontend_tdcbuffers11 = 13'd0;
reg top_tdc_frontend_tdcbuffers_epoch = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_epoch = 1'd0;
wire top_tdc_frontend_tdcbuffers_request0;
wire top_tdc_frontend_tdcbuffers_stop_request0;
reg top_tdc_frontend_tdcbuffers_seen0 = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_seen0 = 1'd0;
reg top_tdc_frontend_tdcbuffers_acknowledged0 = 1'd0;
reg top_tdc_frontend_tdcbuffers_active0 = 1'd0;
reg [12:0] top_tdc_frontend_tdcbuffers_count0 = 13'd0;
wire top_tdc_frontend_tdcbuffers_ack_sys0;
wire top_tdc_frontend_tdcbuffers_seen_sys0;
wire [12:0] top_tdc_frontend_tdcbuffers_snapshot0;
wire [11:0] top_tdc_frontend_tdcbuffers_wp_memory0_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory0_dat_r;
wire top_tdc_frontend_tdcbuffers_wp_memory0_we;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory0_dat_w;
wire [11:0] top_tdc_frontend_tdcbuffers_rp_memory0_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_rp_memory0_dat_r;
wire top_tdc_frontend_tdcbuffers_request1;
wire top_tdc_frontend_tdcbuffers_stop_request1;
reg top_tdc_frontend_tdcbuffers_seen1 = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_seen1 = 1'd0;
reg top_tdc_frontend_tdcbuffers_acknowledged1 = 1'd0;
reg top_tdc_frontend_tdcbuffers_active1 = 1'd0;
reg [12:0] top_tdc_frontend_tdcbuffers_count1 = 13'd0;
wire top_tdc_frontend_tdcbuffers_ack_sys1;
wire top_tdc_frontend_tdcbuffers_seen_sys1;
wire [12:0] top_tdc_frontend_tdcbuffers_snapshot1;
wire [11:0] top_tdc_frontend_tdcbuffers_wp_memory1_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory1_dat_r;
wire top_tdc_frontend_tdcbuffers_wp_memory1_we;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory1_dat_w;
wire [11:0] top_tdc_frontend_tdcbuffers_rp_memory1_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_rp_memory1_dat_r;
wire top_tdc_frontend_tdcbuffers_request2;
wire top_tdc_frontend_tdcbuffers_stop_request2;
reg top_tdc_frontend_tdcbuffers_seen2 = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_seen2 = 1'd0;
reg top_tdc_frontend_tdcbuffers_acknowledged2 = 1'd0;
reg top_tdc_frontend_tdcbuffers_active2 = 1'd0;
reg [12:0] top_tdc_frontend_tdcbuffers_count2 = 13'd0;
wire top_tdc_frontend_tdcbuffers_ack_sys2;
wire top_tdc_frontend_tdcbuffers_seen_sys2;
wire [12:0] top_tdc_frontend_tdcbuffers_snapshot2;
wire [11:0] top_tdc_frontend_tdcbuffers_wp_memory2_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory2_dat_r;
wire top_tdc_frontend_tdcbuffers_wp_memory2_we;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory2_dat_w;
wire [11:0] top_tdc_frontend_tdcbuffers_rp_memory2_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_rp_memory2_dat_r;
wire top_tdc_frontend_tdcbuffers_request3;
wire top_tdc_frontend_tdcbuffers_stop_request3;
reg top_tdc_frontend_tdcbuffers_seen3 = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_seen3 = 1'd0;
reg top_tdc_frontend_tdcbuffers_acknowledged3 = 1'd0;
reg top_tdc_frontend_tdcbuffers_active3 = 1'd0;
reg [12:0] top_tdc_frontend_tdcbuffers_count3 = 13'd0;
wire top_tdc_frontend_tdcbuffers_ack_sys3;
wire top_tdc_frontend_tdcbuffers_seen_sys3;
wire [12:0] top_tdc_frontend_tdcbuffers_snapshot3;
wire [11:0] top_tdc_frontend_tdcbuffers_wp_memory3_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory3_dat_r;
wire top_tdc_frontend_tdcbuffers_wp_memory3_we;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory3_dat_w;
wire [11:0] top_tdc_frontend_tdcbuffers_rp_memory3_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_rp_memory3_dat_r;
wire top_tdc_frontend_tdcbuffers_request4;
wire top_tdc_frontend_tdcbuffers_stop_request4;
reg top_tdc_frontend_tdcbuffers_seen4 = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_seen4 = 1'd0;
reg top_tdc_frontend_tdcbuffers_acknowledged4 = 1'd0;
reg top_tdc_frontend_tdcbuffers_active4 = 1'd0;
reg [12:0] top_tdc_frontend_tdcbuffers_count4 = 13'd0;
wire top_tdc_frontend_tdcbuffers_ack_sys4;
wire top_tdc_frontend_tdcbuffers_seen_sys4;
wire [12:0] top_tdc_frontend_tdcbuffers_snapshot4;
wire [11:0] top_tdc_frontend_tdcbuffers_wp_memory4_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory4_dat_r;
wire top_tdc_frontend_tdcbuffers_wp_memory4_we;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory4_dat_w;
wire [11:0] top_tdc_frontend_tdcbuffers_rp_memory4_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_rp_memory4_dat_r;
wire top_tdc_frontend_tdcbuffers_request5;
wire top_tdc_frontend_tdcbuffers_stop_request5;
reg top_tdc_frontend_tdcbuffers_seen5 = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_seen5 = 1'd0;
reg top_tdc_frontend_tdcbuffers_acknowledged5 = 1'd0;
reg top_tdc_frontend_tdcbuffers_active5 = 1'd0;
reg [12:0] top_tdc_frontend_tdcbuffers_count5 = 13'd0;
wire top_tdc_frontend_tdcbuffers_ack_sys5;
wire top_tdc_frontend_tdcbuffers_seen_sys5;
wire [12:0] top_tdc_frontend_tdcbuffers_snapshot5;
wire [11:0] top_tdc_frontend_tdcbuffers_wp_memory5_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory5_dat_r;
wire top_tdc_frontend_tdcbuffers_wp_memory5_we;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory5_dat_w;
wire [11:0] top_tdc_frontend_tdcbuffers_rp_memory5_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_rp_memory5_dat_r;
wire top_tdc_frontend_tdcbuffers_request6;
wire top_tdc_frontend_tdcbuffers_stop_request6;
reg top_tdc_frontend_tdcbuffers_seen6 = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_seen6 = 1'd0;
reg top_tdc_frontend_tdcbuffers_acknowledged6 = 1'd0;
reg top_tdc_frontend_tdcbuffers_active6 = 1'd0;
reg [12:0] top_tdc_frontend_tdcbuffers_count6 = 13'd0;
wire top_tdc_frontend_tdcbuffers_ack_sys6;
wire top_tdc_frontend_tdcbuffers_seen_sys6;
wire [12:0] top_tdc_frontend_tdcbuffers_snapshot6;
wire [11:0] top_tdc_frontend_tdcbuffers_wp_memory6_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory6_dat_r;
wire top_tdc_frontend_tdcbuffers_wp_memory6_we;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory6_dat_w;
wire [11:0] top_tdc_frontend_tdcbuffers_rp_memory6_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_rp_memory6_dat_r;
wire top_tdc_frontend_tdcbuffers_request7;
wire top_tdc_frontend_tdcbuffers_stop_request7;
reg top_tdc_frontend_tdcbuffers_seen7 = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_seen7 = 1'd0;
reg top_tdc_frontend_tdcbuffers_acknowledged7 = 1'd0;
reg top_tdc_frontend_tdcbuffers_active7 = 1'd0;
reg [12:0] top_tdc_frontend_tdcbuffers_count7 = 13'd0;
wire top_tdc_frontend_tdcbuffers_ack_sys7;
wire top_tdc_frontend_tdcbuffers_seen_sys7;
wire [12:0] top_tdc_frontend_tdcbuffers_snapshot7;
wire [11:0] top_tdc_frontend_tdcbuffers_wp_memory7_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory7_dat_r;
wire top_tdc_frontend_tdcbuffers_wp_memory7_we;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory7_dat_w;
wire [11:0] top_tdc_frontend_tdcbuffers_rp_memory7_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_rp_memory7_dat_r;
wire top_tdc_frontend_tdcbuffers_request8;
wire top_tdc_frontend_tdcbuffers_stop_request8;
reg top_tdc_frontend_tdcbuffers_seen8 = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_seen8 = 1'd0;
reg top_tdc_frontend_tdcbuffers_acknowledged8 = 1'd0;
reg top_tdc_frontend_tdcbuffers_active8 = 1'd0;
reg [12:0] top_tdc_frontend_tdcbuffers_count8 = 13'd0;
wire top_tdc_frontend_tdcbuffers_ack_sys8;
wire top_tdc_frontend_tdcbuffers_seen_sys8;
wire [12:0] top_tdc_frontend_tdcbuffers_snapshot8;
wire [11:0] top_tdc_frontend_tdcbuffers_wp_memory8_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory8_dat_r;
wire top_tdc_frontend_tdcbuffers_wp_memory8_we;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory8_dat_w;
wire [11:0] top_tdc_frontend_tdcbuffers_rp_memory8_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_rp_memory8_dat_r;
wire top_tdc_frontend_tdcbuffers_request9;
wire top_tdc_frontend_tdcbuffers_stop_request9;
reg top_tdc_frontend_tdcbuffers_seen9 = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_seen9 = 1'd0;
reg top_tdc_frontend_tdcbuffers_acknowledged9 = 1'd0;
reg top_tdc_frontend_tdcbuffers_active9 = 1'd0;
reg [12:0] top_tdc_frontend_tdcbuffers_count9 = 13'd0;
wire top_tdc_frontend_tdcbuffers_ack_sys9;
wire top_tdc_frontend_tdcbuffers_seen_sys9;
wire [12:0] top_tdc_frontend_tdcbuffers_snapshot9;
wire [11:0] top_tdc_frontend_tdcbuffers_wp_memory9_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory9_dat_r;
wire top_tdc_frontend_tdcbuffers_wp_memory9_we;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory9_dat_w;
wire [11:0] top_tdc_frontend_tdcbuffers_rp_memory9_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_rp_memory9_dat_r;
wire top_tdc_frontend_tdcbuffers_request10;
wire top_tdc_frontend_tdcbuffers_stop_request10;
reg top_tdc_frontend_tdcbuffers_seen10 = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_seen10 = 1'd0;
reg top_tdc_frontend_tdcbuffers_acknowledged10 = 1'd0;
reg top_tdc_frontend_tdcbuffers_active10 = 1'd0;
reg [12:0] top_tdc_frontend_tdcbuffers_count10 = 13'd0;
wire top_tdc_frontend_tdcbuffers_ack_sys10;
wire top_tdc_frontend_tdcbuffers_seen_sys10;
wire [12:0] top_tdc_frontend_tdcbuffers_snapshot10;
wire [11:0] top_tdc_frontend_tdcbuffers_wp_memory10_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory10_dat_r;
wire top_tdc_frontend_tdcbuffers_wp_memory10_we;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory10_dat_w;
wire [11:0] top_tdc_frontend_tdcbuffers_rp_memory10_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_rp_memory10_dat_r;
wire top_tdc_frontend_tdcbuffers_request11;
wire top_tdc_frontend_tdcbuffers_stop_request11;
reg top_tdc_frontend_tdcbuffers_seen11 = 1'd0;
reg top_tdc_frontend_tdcbuffers_stop_seen11 = 1'd0;
reg top_tdc_frontend_tdcbuffers_acknowledged11 = 1'd0;
reg top_tdc_frontend_tdcbuffers_active11 = 1'd0;
reg [12:0] top_tdc_frontend_tdcbuffers_count11 = 13'd0;
wire top_tdc_frontend_tdcbuffers_ack_sys11;
wire top_tdc_frontend_tdcbuffers_seen_sys11;
wire [12:0] top_tdc_frontend_tdcbuffers_snapshot11;
wire [11:0] top_tdc_frontend_tdcbuffers_wp_memory11_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory11_dat_r;
wire top_tdc_frontend_tdcbuffers_wp_memory11_we;
wire [15:0] top_tdc_frontend_tdcbuffers_wp_memory11_dat_w;
wire [11:0] top_tdc_frontend_tdcbuffers_rp_memory11_adr;
wire [15:0] top_tdc_frontend_tdcbuffers_rp_memory11_dat_r;
wire [31:0] top_tdc_frontend_address;
wire [31:0] top_tdc_frontend_wdata;
wire top_tdc_frontend_write;
wire top_tdc_frontend_commit;
wire top_tdc_frontend_selected;
wire top_tdc_frontend_error;
reg [31:0] top_tdc_frontend_rdata;
wire top_tdc_frontend_frontend_ready0;
wire [31:0] top_tdc_frontend_frontend_status;
reg top_tdc_frontend_fault = 1'd0;
wire top_tdc_frontend_valid;
reg top_tdc_frontend_arm = 1'd0;
reg top_tdc_frontend_stop = 1'd0;
reg [25:0] top_tdc_frontend_elapsed = 26'd0;
reg top_tdc_frontend_pending = 1'd0;
wire top_tdc_frontend_cfd0;
wire top_tdc_frontend_cfd1;
wire top_tdc_frontend_cfd2;
wire top_tdc_frontend_cfd3;
wire top_tdc_frontend_cfd4;
wire top_tdc_frontend_cfd5;
wire top_tdc_frontend_cfd6;
wire top_tdc_frontend_cfd7;
wire top_tdc_frontend_cfd8;
wire top_tdc_frontend_cfd9;
wire top_tdc_frontend_cfd10;
wire top_tdc_frontend_cfd11;
wire top_tdc_frontend_rstr0;
wire top_tdc_frontend_rstr1;
wire top_tdc_frontend_rstr2;
wire top_tdc_frontend_rstr3;
wire top_tdc_frontend_rstr4;
wire top_tdc_frontend_rstr5;
wire top_tdc_frontend_rstr6;
wire top_tdc_frontend_rstr7;
wire top_tdc_frontend_rstr8;
wire top_tdc_frontend_rstr9;
wire top_tdc_frontend_rstr10;
wire top_tdc_frontend_rstr11;
wire top_tdc_frontend_rdata0;
wire top_tdc_frontend_rdata1;
wire top_tdc_frontend_rdata2;
wire top_tdc_frontend_rdata3;
wire top_tdc_frontend_rdata4;
wire top_tdc_frontend_rdata5;
wire top_tdc_frontend_rdata6;
wire top_tdc_frontend_rdata7;
wire top_tdc_frontend_rdata8;
wire top_tdc_frontend_rdata9;
wire top_tdc_frontend_rdata10;
wire top_tdc_frontend_rdata11;
wire top_tdc_frontend_clk300_0;
wire top_tdc_frontend_clk300_1;
wire top_tdc_frontend_clk300_2;
wire top_tdc_frontend_clk600_0;
wire top_tdc_frontend_clk600_1;
wire top_tdc_frontend_clk600_2;
wire top_tdc_frontend_clk600_90_0;
wire top_tdc_frontend_clk600_90_1;
wire top_tdc_frontend_clk600_90_2;
reg [3:0] top_tdc_frontend_coarse_count0 = 4'd0;
reg [3:0] top_tdc_frontend_coarse_count1 = 4'd0;
reg [3:0] top_tdc_frontend_coarse_count2 = 4'd0;
reg [6:0] top_tdc_frontend_bc_time0 = 7'd0;
reg [6:0] top_tdc_frontend_bc_time1 = 7'd0;
reg [6:0] top_tdc_frontend_bc_time2 = 7'd0;
reg [2:0] top_tdc_frontend_receiver_reset;
wire top_tdc_frontend_frontend_ready1;
wire top_tdc_frontend_sys_reference;
reg [2:0] top_tdc_frontend_ready;
reg [2:0] top_tdc_frontend_locks;
reg [2:0] top_tdc_frontend_phased;
reg [2:0] top_tdc_frontend_alive;
wire tdc1_clk;
wire tdc1_rst;
wire coarse1_clk;
reg coarse1_rst = 1'd0;
wire top_tdc_frontend_result_v0;
wire top_tdc_frontend_clock_in0;
wire [2:0] top_tdc_frontend_bits0;
wire top_tdc_frontend_st0;
wire top_tdc_frontend_lock0;
wire top_tdc_frontend_done0;
wire top_tdc_frontend_feedback0;
wire top_tdc_frontend_fb0;
wire top_tdc_frontend_c6000;
wire top_tdc_frontend_c900;
wire top_tdc_frontend_c3000;
wire top_tdc_frontend_ps_en0;
wire top_tdc_frontend_ps_dir0;
reg top_tdc_frontend_jump0 = 1'd0;
reg [1:0] top_tdc_frontend_old0 = 2'd0;
reg top_tdc_frontend_s10 = 1'd0;
reg top_tdc_frontend_s20 = 1'd0;
wire top_tdc_frontend_local_reset0;
reg [4:0] top_tdc_frontend_heartbeat0 = 5'd0;
wire top_tdc_frontend_hb_sys0;
reg top_tdc_frontend_previous0 = 1'd0;
reg [12:0] top_tdc_frontend_age0 = 13'd8191;
wire top_tdc_frontend_frontend_v0;
wire top_tdc_frontend_frontend_v1;
wire top_tdc_frontend_frontend_v2;
wire top_tdc_frontend_frontend_v3;
wire top_tdc_frontend_frontend_v4;
wire top_tdc_frontend_frontend_v5;
wire top_tdc_frontend_frontend_v6;
wire top_tdc_frontend_frontend_v7;
wire top_tdc_frontend_frontend_v8;
wire top_tdc_frontend_frontend_v9;
wire top_tdc_frontend_frontend_v10;
wire top_tdc_frontend_frontend_v11;
wire tdc2_clk;
wire tdc2_rst;
wire coarse2_clk;
reg coarse2_rst = 1'd0;
wire top_tdc_frontend_result_v1;
wire top_tdc_frontend_reference_v0;
wire top_tdc_frontend_clock_in1;
wire [2:0] top_tdc_frontend_bits1;
wire top_tdc_frontend_st1;
wire top_tdc_frontend_lock1;
wire top_tdc_frontend_done1;
wire top_tdc_frontend_feedback1;
wire top_tdc_frontend_fb1;
wire top_tdc_frontend_c6001;
wire top_tdc_frontend_c901;
wire top_tdc_frontend_c3001;
wire top_tdc_frontend_ps_en1;
wire top_tdc_frontend_ps_dir1;
reg top_tdc_frontend_jump1 = 1'd0;
reg [1:0] top_tdc_frontend_old1 = 2'd0;
reg top_tdc_frontend_s11 = 1'd0;
reg top_tdc_frontend_s21 = 1'd0;
wire top_tdc_frontend_local_reset1;
reg [4:0] top_tdc_frontend_heartbeat1 = 5'd0;
wire top_tdc_frontend_hb_sys1;
reg top_tdc_frontend_previous1 = 1'd0;
reg [12:0] top_tdc_frontend_age1 = 13'd8191;
wire top_tdc_frontend_frontend_v12;
wire top_tdc_frontend_frontend_v13;
wire top_tdc_frontend_frontend_v14;
wire top_tdc_frontend_frontend_v15;
wire top_tdc_frontend_frontend_v16;
wire top_tdc_frontend_frontend_v17;
wire top_tdc_frontend_frontend_v18;
wire top_tdc_frontend_frontend_v19;
wire top_tdc_frontend_frontend_v20;
wire top_tdc_frontend_frontend_v21;
wire top_tdc_frontend_frontend_v22;
wire top_tdc_frontend_frontend_v23;
wire tdc3_clk;
wire tdc3_rst;
wire coarse3_clk;
reg coarse3_rst = 1'd0;
wire top_tdc_frontend_result_v2;
wire top_tdc_frontend_reference_v1;
wire top_tdc_frontend_clock_in2;
wire [2:0] top_tdc_frontend_bits2;
wire top_tdc_frontend_st2;
wire top_tdc_frontend_lock2;
wire top_tdc_frontend_done2;
wire top_tdc_frontend_feedback2;
wire top_tdc_frontend_fb2;
wire top_tdc_frontend_c6002;
wire top_tdc_frontend_c902;
wire top_tdc_frontend_c3002;
wire top_tdc_frontend_ps_en2;
wire top_tdc_frontend_ps_dir2;
reg top_tdc_frontend_jump2 = 1'd0;
reg [1:0] top_tdc_frontend_old2 = 2'd0;
reg top_tdc_frontend_s12 = 1'd0;
reg top_tdc_frontend_s22 = 1'd0;
wire top_tdc_frontend_local_reset2;
reg [4:0] top_tdc_frontend_heartbeat2 = 5'd0;
wire top_tdc_frontend_hb_sys2;
reg top_tdc_frontend_previous2 = 1'd0;
reg [12:0] top_tdc_frontend_age2 = 13'd8191;
wire top_tdc_frontend_frontend_v24;
wire top_tdc_frontend_frontend_v25;
wire top_tdc_frontend_frontend_v26;
wire top_tdc_frontend_frontend_v27;
wire top_tdc_frontend_frontend_v28;
wire top_tdc_frontend_frontend_v29;
wire top_tdc_frontend_frontend_v30;
wire top_tdc_frontend_frontend_v31;
wire top_tdc_frontend_frontend_v32;
wire top_tdc_frontend_frontend_v33;
wire top_tdc_frontend_frontend_v34;
wire top_tdc_frontend_frontend_v35;
wire [31:0] top_hdmi_address;
wire [31:0] top_hdmi_wdata;
wire top_hdmi_write;
wire top_hdmi_commit;
wire top_hdmi_selected;
wire top_hdmi_error;
reg [31:0] top_hdmi_rdata;
reg [7:0] top_hdmi_command = 8'd0;
wire [15:0] top_hdmi_scratch;
wire [15:0] top_hdmi_writes;
wire top_hdmi_locked;
wire [7:0] top_hdmi_cmd;
reg [2:0] top_hdmi_phase = 3'd0;
reg [7:0] top_hdmi_div = 8'd0;
reg [1:0] top_hdmi_oldmode = 2'd0;
reg [6:0] top_hdmi0 = 7'd1;
reg [6:0] top_hdmi1 = 7'd19;
reg [6:0] top_hdmi2 = 7'd53;
reg [6:0] top_hdmi3 = 7'd87;
wire [3:0] top_hdmi_idle;
wire [3:0] top_hdmi_data;
wire top_hdmi_mi;
wire [15:0] top_hdmi_hs;
wire [15:0] top_hdmi_hw;
wire [31:0] top_registers_address;
wire [31:0] top_registers_wdata;
wire top_registers_strobe;
wire top_registers_write;
reg [31:0] top_registers_rdata = 32'd0;
reg top_registers_ack = 1'd0;
reg top_registers_err = 1'd0;
wire top_registers_link;
wire top_registers_locked;
reg top_registers_ev = 1'd0;
reg [31:0] top_registers_scratch = 32'd0;
reg [31:0] top_registers_writes = 32'd0;
reg top_registers_valid = 1'd0;
reg top_registers_busy = 1'd0;
reg [31:0] top_registers_capture_id = 32'd0;
reg top_registers_timed_out = 1'd0;
wire [15:0] top_registers_mcu_scratch;
wire [15:0] top_registers_mcu_writes;
reg top_registers_pattern = 1'd0;
reg top_registers_bank = 1'd0;
reg [15:0] top_registers_remaining = 16'd0;
reg top_registers_settling = 1'd0;
reg top_registers_arm = 1'd0;
reg top_registers_trace_arm = 1'd0;
reg [31:0] top_registers_adr = 32'd0;
reg [31:0] top_registers_wd = 32'd0;
reg top_registers_wr = 1'd0;
reg [63:0] top_registers_uptime = 64'd0;
reg top_registers_valid_address;
reg [31:0] top_registers_read_value;
reg top_registers_writable;
reg top_registers_bad_write;
reg top_registers_is_ongoing0;
reg top_registers_is_ongoing1;
wire top_phy_request;
reg [20:0] top_startup = 21'd2000000;
wire top_link;
wire top_lock;
wire top_netlock;
wire top_got_ip;
reg [31:0] top_rx_bytes = 32'd0;
reg [31:0] top_rx_frames = 32'd0;
reg [31:0] top_tx_bytes = 32'd0;
reg [31:0] top_tx_frames = 32'd0;
reg [15:0] top_rx_errors = 16'd0;
reg [31:0] top_ipb_count = 32'd0;
reg [31:0] top_net_tick = 32'd0;
wire top_mi;
wire [15:0] top_scratch;
wire [15:0] top_writes;
wire s7mmcm0_reset0;
wire s7mmcm0_reset1;
wire s7mmcm0_reset2;
wire s7mmcm0_reset3;
wire s7mmcm0_reset4;
wire s7mmcm0_reset5;
wire s7mmcm0_reset6;
wire s7mmcm0_reset7;
wire s7mmcm0_mmcm_fb0;
wire s7mmcm1_reset0;
wire s7mmcm1_reset1;
wire s7mmcm1_reset2;
wire s7mmcm1_reset3;
wire s7mmcm1_reset4;
wire s7mmcm1_reset5;
wire s7mmcm1_reset6;
wire s7mmcm1_reset7;
wire s7mmcm1_mmcm_fb0;
reg [2:0] clockdomainsrenamer0_state = 3'd0;
reg [2:0] clockdomainsrenamer0_next_state;
reg top_pcstx_count0_clockdomainsrenamer0_next_value0;
reg top_pcstx_count0_clockdomainsrenamer0_next_value_ce0;
reg top_pcstx_ctype_clockdomainsrenamer0_next_value1;
reg top_pcstx_ctype_clockdomainsrenamer0_next_value_ce1;
reg [2:0] clockdomainsrenamer1_state = 3'd0;
reg [2:0] clockdomainsrenamer1_next_state;
reg top_pcsrx_count0_clockdomainsrenamer1_next_value;
reg top_pcsrx_count0_clockdomainsrenamer1_next_value_ce;
reg [7:0] clockdomainsrenamer1_next_value0;
reg clockdomainsrenamer1_next_value_ce0;
reg [7:0] clockdomainsrenamer1_next_value1;
reg clockdomainsrenamer1_next_value_ce1;
wire s7mmcm0_reset8;
wire s7mmcm0_reset9;
wire s7mmcm0_reset10;
wire s7mmcm0_reset11;
wire s7mmcm0_reset12;
wire s7mmcm0_reset13;
wire s7mmcm0_reset14;
wire s7mmcm0_reset15;
wire s7mmcm0_mmcm_fb1;
wire s7mmcm1_reset8;
wire s7mmcm1_reset9;
wire s7mmcm1_reset10;
wire s7mmcm1_reset11;
wire s7mmcm1_reset12;
wire s7mmcm1_reset13;
wire s7mmcm1_reset14;
wire s7mmcm1_reset15;
wire s7mmcm1_mmcm_fb1;
reg [3:0] gtxtxinit_state = 4'd0;
reg [3:0] gtxtxinit_next_state;
reg [3:0] gtxrxinit_state = 4'd0;
reg [3:0] gtxrxinit_next_state;
reg txdatapath_liteethmacpaddinginserter_state = 1'd0;
reg txdatapath_liteethmacpaddinginserter_next_state;
reg [15:0] top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value;
reg top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value_ce;
reg [1:0] txdatapath_bufferizeendpoints_state = 2'd0;
reg [1:0] txdatapath_bufferizeendpoints_next_state;
reg [31:0] top_tx_crc_crc_packet_clockdomainsrenamer_clockdomainsrenamer1_next_value0;
reg top_tx_crc_crc_packet_clockdomainsrenamer_clockdomainsrenamer1_next_value_ce0;
reg top_tx_crc_be0_clockdomainsrenamer_clockdomainsrenamer1_next_value1;
reg top_tx_crc_be0_clockdomainsrenamer_clockdomainsrenamer1_next_value_ce1;
reg [1:0] txdatapath_liteethmacpreambleinserter_state = 2'd0;
reg [1:0] txdatapath_liteethmacpreambleinserter_next_state;
reg [2:0] top_tx_preamble_count_clockdomainsrenamer_clockdomainsrenamer2_next_value;
reg top_tx_preamble_count_clockdomainsrenamer_clockdomainsrenamer2_next_value_ce;
reg txdatapath_liteethmacgap_state = 1'd0;
reg txdatapath_liteethmacgap_next_state;
reg [3:0] top_tx_gap_counter_clockdomainsrenamer_clockdomainsrenamer3_next_value;
reg top_tx_gap_counter_clockdomainsrenamer_clockdomainsrenamer3_next_value_ce;
reg rxdatapath_liteethmacpreamblechecker_state = 1'd0;
reg rxdatapath_liteethmacpreamblechecker_next_state;
reg [1:0] rxdatapath_bufferizeendpoints_state = 2'd0;
reg [1:0] rxdatapath_bufferizeendpoints_next_state;
reg top_liteethmaccrc32checker_be_clockdomainsrenamer_next_value0;
reg top_liteethmaccrc32checker_be_clockdomainsrenamer_next_value_ce0;
reg top_liteethmaccrc32checker_last_error_clockdomainsrenamer_next_value1;
reg top_liteethmaccrc32checker_last_error_clockdomainsrenamer_next_value_ce1;
reg [1:0] state = 2'd0;
reg [1:0] next_state;
reg [31:0] top_registers_adr_registers_next_value0;
reg top_registers_adr_registers_next_value_ce0;
reg [31:0] top_registers_wd_registers_next_value1;
reg top_registers_wd_registers_next_value_ce1;
reg top_registers_wr_registers_next_value2;
reg top_registers_wr_registers_next_value_ce2;
reg top_registers_ack_registers_next_value3;
reg top_registers_ack_registers_next_value_ce3;
reg top_registers_err_registers_next_value4;
reg top_registers_err_registers_next_value_ce4;
reg [31:0] top_registers_rdata_registers_next_value5;
reg top_registers_rdata_registers_next_value_ce5;
reg [31:0] top_registers_writes_registers_next_value6;
reg top_registers_writes_registers_next_value_ce6;
reg [31:0] top_registers_scratch_registers_next_value7;
reg top_registers_scratch_registers_next_value_ce7;
reg top_registers_valid_registers_t_next_value0;
reg top_registers_valid_registers_t_next_value_ce0;
reg top_registers_bank_registers_t_next_value1;
reg top_registers_bank_registers_t_next_value_ce1;
reg top_registers_pattern_registers_t_next_value2;
reg top_registers_pattern_registers_t_next_value_ce2;
reg top_registers_ev_registers_t_next_value3;
reg top_registers_ev_registers_t_next_value_ce3;
reg top_registers_busy_registers_t_next_value4;
reg top_registers_busy_registers_t_next_value_ce4;
reg top_registers_timed_out_registers_t_next_value5;
reg top_registers_timed_out_registers_t_next_value_ce5;
reg top_registers_settling_registers_t_next_value6;
reg top_registers_settling_registers_t_next_value_ce6;
reg [15:0] top_registers_remaining_registers_t_next_value7;
reg top_registers_remaining_registers_t_next_value_ce7;
reg top_registers_trace_arm_registers_f_next_value;
reg top_registers_trace_arm_registers_f_next_value_ce;
wire [39:0] slice_proxy;
reg [12:0] comb_rhs_self;
reg [12:0] comb_t_self0;
reg [15:0] comb_t_self1;
reg [15:0] comb_t_self2;
reg [2:0] sync_t_self0;
reg [2:0] sync_t_self1;
reg [2:0] sync_f_self;
reg [5:0] sync_rhs_self0;
reg sync_rhs_self1;
reg sync_rhs_self2;
reg [3:0] sync_rhs_self3;
reg sync_rhs_self4;
reg sync_rhs_self5;
wire xilinxasyncresetsynchronizerimpl0_async_reset;
wire xilinxasyncresetsynchronizerimpl0_rst_meta;
wire xilinxasyncresetsynchronizerimpl1_async_reset;
wire xilinxasyncresetsynchronizerimpl1_rst_meta;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl00 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl01 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl10 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl11 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl20 = 16'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl21 = 16'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl30 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl31 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl40 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl41 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl50 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl51 = 1'd0;
wire xilinxasyncresetsynchronizerimpl2_async_reset;
wire xilinxasyncresetsynchronizerimpl2_rst_meta;
wire xilinxasyncresetsynchronizerimpl3_async_reset;
wire xilinxasyncresetsynchronizerimpl3_rst_meta;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl60 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl61 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl70 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl71 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl80 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl81 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl90 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl91 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl100 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl101 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl110 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl111 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl120 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl121 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl130 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl131 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl140 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl141 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [5:0] xilinxmultiregimpl150 = 6'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [5:0] xilinxmultiregimpl151 = 6'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [5:0] xilinxmultiregimpl160 = 6'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [5:0] xilinxmultiregimpl161 = 6'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl170 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl171 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [5:0] xilinxmultiregimpl180 = 6'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [5:0] xilinxmultiregimpl181 = 6'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [5:0] xilinxmultiregimpl190 = 6'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [5:0] xilinxmultiregimpl191 = 6'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl200 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl201 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl210 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl211 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl220 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl221 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl230 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl231 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl240 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl241 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl250 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl251 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl26_xilinxmultiregimpl260 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl26_xilinxmultiregimpl261 = 14'd0;
wire xilinxmultiregimpl26_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl27_xilinxmultiregimpl270 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl27_xilinxmultiregimpl271 = 14'd0;
wire xilinxmultiregimpl27_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl28_xilinxmultiregimpl280 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl28_xilinxmultiregimpl281 = 14'd0;
wire xilinxmultiregimpl28_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl29_xilinxmultiregimpl290 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl29_xilinxmultiregimpl291 = 14'd0;
wire xilinxmultiregimpl29_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl30_xilinxmultiregimpl300 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl30_xilinxmultiregimpl301 = 14'd0;
wire xilinxmultiregimpl30_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl31_xilinxmultiregimpl310 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl31_xilinxmultiregimpl311 = 14'd0;
wire xilinxmultiregimpl31_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl32_xilinxmultiregimpl320 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl32_xilinxmultiregimpl321 = 14'd0;
wire xilinxmultiregimpl32_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl33_xilinxmultiregimpl330 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl33_xilinxmultiregimpl331 = 14'd0;
wire xilinxmultiregimpl33_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl34_xilinxmultiregimpl340 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl34_xilinxmultiregimpl341 = 14'd0;
wire xilinxmultiregimpl34_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl35_xilinxmultiregimpl350 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl35_xilinxmultiregimpl351 = 14'd0;
wire xilinxmultiregimpl35_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl36_xilinxmultiregimpl360 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl36_xilinxmultiregimpl361 = 14'd0;
wire xilinxmultiregimpl36_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl37_xilinxmultiregimpl370 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl37_xilinxmultiregimpl371 = 14'd0;
wire xilinxmultiregimpl37_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [2:0] xilinxmultiregimpl380 = 3'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [2:0] xilinxmultiregimpl381 = 3'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl390 = 16'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl391 = 16'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl400 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl401 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl402 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl410 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl411 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl412 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl420 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl421 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl422 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl430 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl431 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl432 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl440 = 13'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl441 = 13'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl450 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl451 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl452 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl460 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl461 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl462 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl470 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl471 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl472 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl480 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl481 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl482 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl490 = 13'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl491 = 13'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl500 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl501 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl502 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl510 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl511 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl512 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl520 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl521 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl522 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl530 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl531 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl532 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl540 = 13'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl541 = 13'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl550 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl551 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl552 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl560 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl561 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl562 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl570 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl571 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl572 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl580 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl581 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl582 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl590 = 13'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl591 = 13'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl600 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl601 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl602 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl610 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl611 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl612 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl620 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl621 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl622 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl630 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl631 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl632 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl640 = 13'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl641 = 13'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl650 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl651 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl652 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl660 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl661 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl662 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl670 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl671 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl672 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl680 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl681 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl682 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl690 = 13'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl691 = 13'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl700 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl701 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl702 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl710 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl711 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl712 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl720 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl721 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl722 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl730 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl731 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl732 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl740 = 13'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl741 = 13'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl750 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl751 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl752 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl760 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl761 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl762 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl770 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl771 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl772 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl780 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl781 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl782 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl790 = 13'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl791 = 13'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl800 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl801 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl802 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl810 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl811 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl812 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl820 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl821 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl822 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl830 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl831 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl832 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl840 = 13'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl841 = 13'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl850 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl851 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl852 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl860 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl861 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl862 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl870 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl871 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl872 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl880 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl881 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl882 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl890 = 13'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl891 = 13'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl900 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl901 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl902 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl910 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl911 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl912 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl920 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl921 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl922 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl930 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl931 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl932 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl940 = 13'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl941 = 13'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl950 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl951 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl952 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl960 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl961 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl962 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl970 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl971 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl972 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl980 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl981 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl982 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl990 = 13'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [12:0] xilinxmultiregimpl991 = 13'd0;
wire xilinxasyncresetsynchronizerimpl4_rst_meta;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1000 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1001 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl101_xilinxmultiregimpl1010 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl101_xilinxmultiregimpl1011 = 1'd0;
wire xilinxmultiregimpl101_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1020 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1021 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1030 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1031 = 1'd0;
wire xilinxasyncresetsynchronizerimpl5_rst_meta;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1040 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1041 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl105_xilinxmultiregimpl1050 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl105_xilinxmultiregimpl1051 = 1'd0;
wire xilinxmultiregimpl105_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1060 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1061 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1070 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1071 = 1'd0;
wire xilinxasyncresetsynchronizerimpl6_rst_meta;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1080 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1081 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl109_xilinxmultiregimpl1090 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl109_xilinxmultiregimpl1091 = 1'd0;
wire xilinxmultiregimpl109_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1100 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1101 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1110 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1111 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [7:0] xilinxmultiregimpl1120 = 8'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [7:0] xilinxmultiregimpl1121 = 8'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1130 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1131 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl1140 = 16'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl1141 = 16'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl1150 = 16'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl1151 = 16'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl116_xilinxmultiregimpl1160 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl116_xilinxmultiregimpl1161 = 1'd0;
wire xilinxmultiregimpl116_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1170 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1171 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1180 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1181 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1190 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl1191 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl1200 = 16'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl1201 = 16'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl1210 = 16'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl1211 = 16'd0;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign net_clk = eth_tx_clk;
assign net_rst = eth_tx_rst;
assign top_source_ready = 1'd1;
assign top_sink_first = top_first;
assign top_sink_payload_be = 1'd1;
assign top_sys_ref = top_tdc_frontend_sys_reference;
assign top_pma_k7_gtx_basex_reset = ((top_startup != 1'd0) | top_phy_request);
assign EVNT = top_registers_ev;
assign top_registers_link = top_link;
assign top_registers_locked = top_lock;
assign top_jtag_report = {{top_command, top_net_tick, top_ipb_count, 16'd0, top_rx_errors, top_tx_bytes, top_rx_bytes, top_tx_frames, top_rx_frames, 20'd0, (top_startup != 1'd0), top_phy_request, top_pma_k7_gtx_basex_rx_mmcm_locked1, top_pma_k7_gtx_basex_tx_mmcm_locked1, top_pma_k7_gtx_basex_gtxrxinit_done, top_pma_k7_gtx_basex_gtxtxinit_done, top_pma_k7_gtx_basex_pll_lock, net_rst, top_got_ip, top_netlock, top_lock, top_link, 32'd1347241026}, top_analyzer_report[207:0]};
assign top_s7mmcm0_clkin_signal = top_fixed100;
assign sys_clk = top_s7mmcm0_clkout_buf;
assign top_s7mmcm1_clkin_signal = sys_clk;
assign cap_clk = top_s7mmcm1_clkout_buf;
assign top_pma_k7_gtx_basex_tx_data1 = top_pcstx_encoder2;
assign top_pcsrx_decoder_input = top_pma_k7_gtx_basex_rx_data1;
assign top_pcsrx_decoder_ce = top_pma_k7_gtx_basex_rx_valid;
assign top_pma_k7_gtx_basex_align = top_align;
assign top_pma_k7_gtx_basex_restart = top_restart;
assign top_source_source_payload_be = 1'd1;
assign top_pcstx_sink_valid = top_sink_sink_valid;
assign top_sink_sink_ready = top_pcstx_sink_ready;
assign top_pcstx_sink_first = top_sink_sink_first;
assign top_pcstx_sink_last = top_sink_sink_last;
assign top_pcstx_sink_payload_data = top_sink_sink_payload_data;
assign top_source_source_valid = top_pcsrx_source_valid;
assign top_pcsrx_source_ready = top_source_source_ready;
assign top_source_source_first = top_pcsrx_source_first;
assign top_source_source_last = top_pcsrx_source_last;
assign top_source_source_payload_data = top_pcsrx_source_payload_data;
assign top_source_source_payload_error = top_pcsrx_source_payload_error;
assign top_seen_valid_ci_i = top_pcsrx_seen_valid_ci;
assign top_is_sgmii = 1'd0;
assign top_sgmii_speed_valid = ((top_lp_abi_o[11:10] != 2'd3) & (top_lp_abi_o != 1'd0));
assign top_sgmii_tx_speed = (top_sgmii_speed_valid ? top_lp_abi_o[11:10] : 2'd2);
assign top_sgmii_rx_speed = (((top_lp_abi_i[11:10] != 2'd3) & (top_lp_abi_i != 1'd0)) ? top_lp_abi_i[11:10] : 2'd2);

// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	top_pcstx_sgmii_speed <= 2'd0;
	top_pcsrx_sgmii_speed <= 2'd0;
	top_linkdown <= 1'd0;
	if ((~top_is_sgmii)) begin
		top_linkdown <= (top_lp_abi_o == 1'd0);
		top_pcstx_sgmii_speed <= 2'd2;
		top_pcsrx_sgmii_speed <= 2'd2;
	end else begin
		top_linkdown <= ((~top_lp_abi_o[15]) | (~top_sgmii_speed_valid));
		top_pcstx_sgmii_speed <= top_sgmii_tx_speed;
		top_pcsrx_sgmii_speed <= top_sgmii_rx_speed;
	end
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_1;
// synthesis translate_on
always @(*) begin
	top_pcstx_config_reg <= 16'd0;
	if ((~top_config_empty)) begin
		top_pcstx_config_reg[0] <= top_is_sgmii;
		top_pcstx_config_reg[5] <= (~top_is_sgmii);
		if (top_is_sgmii) begin
			top_pcstx_config_reg[11:10] <= top_sgmii_tx_speed;
			top_pcstx_config_reg[12] <= 1'd1;
			top_pcstx_config_reg[15] <= top_link_up;
		end
		top_pcstx_config_reg[14] <= top_autoneg_ack;
	end
// synthesis translate_off
	dummy_d_1 <= dummy_s;
// synthesis translate_on
end
assign top_align = 1'd1;
assign top_pcstx_encoder_ce1 = top_pcstx_encoder_ce0;
assign top_pcstx_encoder_d = top_pcstx_encoder0;
assign top_pcstx_encoder_k = top_pcstx_encoder1;
assign top_pcstx_encoder_disp_inter = (top_pcstx_encoder_disp_in ^ top_pcstx_encoder_code6b_unbalanced);

// synthesis translate_off
reg dummy_d_2;
// synthesis translate_on
always @(*) begin
	top_pcstx_encoder_output_6b <= 6'd0;
	if (((~top_pcstx_encoder_disp_in) & top_pcstx_encoder_code6b_flip)) begin
		top_pcstx_encoder_output_6b <= (~top_pcstx_encoder_code6b);
	end else begin
		top_pcstx_encoder_output_6b <= top_pcstx_encoder_code6b;
	end
// synthesis translate_off
	dummy_d_2 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_3;
// synthesis translate_on
always @(*) begin
	top_pcstx_encoder_disp_out <= 1'd0;
	top_pcstx_encoder_output_4b <= 4'd0;
	if (((~top_pcstx_encoder_disp_inter) & top_pcstx_encoder_alt7_rd0)) begin
		top_pcstx_encoder_disp_out <= (~top_pcstx_encoder_disp_inter);
		top_pcstx_encoder_output_4b <= 3'd7;
	end else begin
		if ((top_pcstx_encoder_disp_inter & top_pcstx_encoder_alt7_rd1)) begin
			top_pcstx_encoder_disp_out <= (~top_pcstx_encoder_disp_inter);
			top_pcstx_encoder_output_4b <= 4'd8;
		end else begin
			top_pcstx_encoder_disp_out <= (top_pcstx_encoder_disp_inter ^ top_pcstx_encoder_code4b_unbalanced);
			if (((~top_pcstx_encoder_disp_inter) & top_pcstx_encoder_code4b_flip)) begin
				top_pcstx_encoder_output_4b <= (~top_pcstx_encoder_code4b);
			end else begin
				top_pcstx_encoder_output_4b <= top_pcstx_encoder_code4b;
			end
		end
	end
// synthesis translate_off
	dummy_d_3 <= dummy_s;
// synthesis translate_on
end
assign top_pcstx_encoder_output_msb_first = {top_pcstx_encoder_output_6b, top_pcstx_encoder_output_4b};

// synthesis translate_off
reg dummy_d_4;
// synthesis translate_on
always @(*) begin
	top_pcstx_encoder_output <= 10'd0;
	top_pcstx_encoder_output[0] <= top_pcstx_encoder_output_msb_first[9];
	top_pcstx_encoder_output[1] <= top_pcstx_encoder_output_msb_first[8];
	top_pcstx_encoder_output[2] <= top_pcstx_encoder_output_msb_first[7];
	top_pcstx_encoder_output[3] <= top_pcstx_encoder_output_msb_first[6];
	top_pcstx_encoder_output[4] <= top_pcstx_encoder_output_msb_first[5];
	top_pcstx_encoder_output[5] <= top_pcstx_encoder_output_msb_first[4];
	top_pcstx_encoder_output[6] <= top_pcstx_encoder_output_msb_first[3];
	top_pcstx_encoder_output[7] <= top_pcstx_encoder_output_msb_first[2];
	top_pcstx_encoder_output[8] <= top_pcstx_encoder_output_msb_first[1];
	top_pcstx_encoder_output[9] <= top_pcstx_encoder_output_msb_first[0];
// synthesis translate_off
	dummy_d_4 <= dummy_s;
// synthesis translate_on
end
assign top_pcstx_done = (top_pcstx_count1 == 1'd0);

// synthesis translate_off
reg dummy_d_5;
// synthesis translate_on
always @(*) begin
	top_pcstx_sink_ready <= 1'd0;
	top_pcstx_encoder0 <= 8'd0;
	top_pcstx_encoder1 <= 1'd0;
	top_pcstx_enable <= 1'd0;
	clockdomainsrenamer0_next_state <= 3'd0;
	top_pcstx_count0_clockdomainsrenamer0_next_value0 <= 1'd0;
	top_pcstx_count0_clockdomainsrenamer0_next_value_ce0 <= 1'd0;
	top_pcstx_ctype_clockdomainsrenamer0_next_value1 <= 1'd0;
	top_pcstx_ctype_clockdomainsrenamer0_next_value_ce1 <= 1'd0;
	clockdomainsrenamer0_next_state <= clockdomainsrenamer0_state;
	case (clockdomainsrenamer0_state)
		1'd1: begin
			case (top_pcstx_ctype)
				1'd0: begin
					top_pcstx_encoder0 <= 8'd181;
				end
				1'd1: begin
					top_pcstx_encoder0 <= 7'd66;
				end
			endcase
			top_pcstx_ctype_clockdomainsrenamer0_next_value1 <= (~top_pcstx_ctype);
			top_pcstx_ctype_clockdomainsrenamer0_next_value_ce1 <= 1'd1;
			clockdomainsrenamer0_next_state <= 2'd2;
		end
		2'd2: begin
			top_pcstx_count0_clockdomainsrenamer0_next_value0 <= (top_pcstx_count0 + 1'd1);
			top_pcstx_count0_clockdomainsrenamer0_next_value_ce0 <= 1'd1;
			case (top_pcstx_count0)
				1'd0: begin
					top_pcstx_encoder0 <= top_pcstx_config_reg[7:0];
				end
				1'd1: begin
					top_pcstx_encoder0 <= top_pcstx_config_reg[15:8];
				end
			endcase
			if ((top_pcstx_count0 == 1'd1)) begin
				clockdomainsrenamer0_next_state <= 1'd0;
			end
		end
		2'd3: begin
			case (top_pcstx_encoder3)
				1'd0: begin
					top_pcstx_encoder0 <= 8'd197;
				end
				1'd1: begin
					top_pcstx_encoder0 <= 7'd80;
				end
			endcase
			clockdomainsrenamer0_next_state <= 1'd0;
		end
		3'd4: begin
			top_pcstx_enable <= 1'd1;
			top_pcstx_sink_ready <= top_pcstx_done;
			if (top_pcstx_sink_valid) begin
				top_pcstx_encoder0 <= top_pcstx_sink_payload_data;
			end else begin
				top_pcstx_encoder1 <= 1'd1;
				top_pcstx_encoder0 <= 8'd253;
				clockdomainsrenamer0_next_state <= 3'd5;
			end
		end
		3'd5: begin
			top_pcstx_encoder1 <= 1'd1;
			top_pcstx_encoder0 <= 8'd247;
			if (top_pcstx_parity) begin
				clockdomainsrenamer0_next_state <= 1'd0;
			end
		end
		default: begin
			top_pcstx_encoder1 <= 1'd1;
			top_pcstx_encoder0 <= 8'd188;
			if (top_pcstx_config_valid) begin
				top_pcstx_count0_clockdomainsrenamer0_next_value0 <= 1'd0;
				top_pcstx_count0_clockdomainsrenamer0_next_value_ce0 <= 1'd1;
				clockdomainsrenamer0_next_state <= 1'd1;
			end else begin
				if (top_pcstx_sink_valid) begin
					top_pcstx_sink_ready <= top_pcstx_done;
					top_pcstx_encoder0 <= 8'd251;
					clockdomainsrenamer0_next_state <= 3'd4;
				end else begin
					clockdomainsrenamer0_next_state <= 2'd3;
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_5 <= dummy_s;
// synthesis translate_on
end
assign top_pcsrx_timer_ce = top_pcsrx_decoder_ce;

// synthesis translate_off
reg dummy_d_6;
// synthesis translate_on
always @(*) begin
	top_pcsrx_decoder_input_msb_first <= 10'd0;
	top_pcsrx_decoder_input_msb_first[0] <= top_pcsrx_decoder_input[9];
	top_pcsrx_decoder_input_msb_first[1] <= top_pcsrx_decoder_input[8];
	top_pcsrx_decoder_input_msb_first[2] <= top_pcsrx_decoder_input[7];
	top_pcsrx_decoder_input_msb_first[3] <= top_pcsrx_decoder_input[6];
	top_pcsrx_decoder_input_msb_first[4] <= top_pcsrx_decoder_input[5];
	top_pcsrx_decoder_input_msb_first[5] <= top_pcsrx_decoder_input[4];
	top_pcsrx_decoder_input_msb_first[6] <= top_pcsrx_decoder_input[3];
	top_pcsrx_decoder_input_msb_first[7] <= top_pcsrx_decoder_input[2];
	top_pcsrx_decoder_input_msb_first[8] <= top_pcsrx_decoder_input[1];
	top_pcsrx_decoder_input_msb_first[9] <= top_pcsrx_decoder_input[0];
// synthesis translate_off
	dummy_d_6 <= dummy_s;
// synthesis translate_on
end
assign top_pcsrx_decoder_adr = top_pcsrx_decoder_input_msb_first[9:4];
assign top_pcsrx_decoder_re = top_pcsrx_decoder_ce;
assign top_pcsrx_decoder_code5b = top_pcsrx_decoder_dat_r;
assign top_pcsrx_decoder_d = {top_pcsrx_decoder_code3b, top_pcsrx_decoder_code5b};
assign top_pcsrx_decoder_invalid = (((top_pcsrx_decoder_ones != 3'd4) & (top_pcsrx_decoder_ones != 3'd5)) & (top_pcsrx_decoder_ones != 3'd6));
assign top_pcsrx_done = (top_pcsrx_count1 == 1'd0);
assign top_pcsrx_pipe_valid_sink_ready = ((~top_pcsrx_pipe_valid_source_valid) | top_pcsrx_pipe_valid_source_ready);
assign top_pcsrx_pipe_valid_sink_valid = top_pcsrx_sink_sink_valid;
assign top_pcsrx_sink_sink_ready = top_pcsrx_pipe_valid_sink_ready;
assign top_pcsrx_pipe_valid_sink_first = top_pcsrx_sink_sink_first;
assign top_pcsrx_pipe_valid_sink_last = top_pcsrx_sink_sink_last;
assign top_pcsrx_pipe_valid_sink_payload_data = top_pcsrx_sink_sink_payload_data;
assign top_pcsrx_source_source_valid = top_pcsrx_pipe_valid_source_valid;
assign top_pcsrx_pipe_valid_source_ready = top_pcsrx_source_source_ready;
assign top_pcsrx_source_source_first = top_pcsrx_pipe_valid_source_first;
assign top_pcsrx_source_source_last = top_pcsrx_pipe_valid_source_last;
assign top_pcsrx_source_source_payload_data = top_pcsrx_pipe_valid_source_payload_data;

// synthesis translate_off
reg dummy_d_7;
// synthesis translate_on
always @(*) begin
	top_pcsrx_seen_valid_ci <= 1'd0;
	top_pcsrx_seen_config_reg <= 1'd0;
	top_pcsrx_source_valid <= 1'd0;
	top_pcsrx_source_first <= 1'd0;
	top_pcsrx_source_last <= 1'd0;
	top_pcsrx_source_payload_data <= 8'd0;
	top_pcsrx_source_payload_error <= 1'd0;
	top_pcsrx_enable <= 1'd0;
	top_pcsrx_sink_sink_valid <= 1'd0;
	top_pcsrx_sink_sink_payload_data <= 8'd0;
	top_pcsrx_source_source_ready <= 1'd0;
	clockdomainsrenamer1_next_state <= 3'd0;
	top_pcsrx_count0_clockdomainsrenamer1_next_value <= 1'd0;
	top_pcsrx_count0_clockdomainsrenamer1_next_value_ce <= 1'd0;
	clockdomainsrenamer1_next_value0 <= 8'd0;
	clockdomainsrenamer1_next_value_ce0 <= 1'd0;
	clockdomainsrenamer1_next_value1 <= 8'd0;
	clockdomainsrenamer1_next_value_ce1 <= 1'd0;
	if ((top_pcsrx_timer_ce & top_pcsrx_done)) begin
		top_pcsrx_source_valid <= top_pcsrx_source_source_valid;
		top_pcsrx_source_source_ready <= top_pcsrx_source_ready;
		top_pcsrx_source_first <= top_pcsrx_source_source_first;
		top_pcsrx_source_payload_data <= top_pcsrx_source_source_payload_data;
		top_pcsrx_source_last <= (top_pcsrx_source_source_valid & (~top_pcsrx_sink_sink_valid));
	end
	clockdomainsrenamer1_next_state <= clockdomainsrenamer1_state;
	case (clockdomainsrenamer1_state)
		1'd1: begin
			if (top_pcsrx_decoder_ce) begin
				if (((~top_pcsrx_decoder_k) & (~top_pcsrx_decoder_invalid))) begin
					if (((top_pcsrx_decoder_d == 8'd181) | (top_pcsrx_decoder_d == 7'd66))) begin
						top_pcsrx_seen_valid_ci <= 1'd1;
						clockdomainsrenamer1_next_state <= 2'd2;
					end
					if (((top_pcsrx_decoder_d == 8'd197) | (top_pcsrx_decoder_d == 7'd80))) begin
						top_pcsrx_seen_valid_ci <= 1'd1;
						clockdomainsrenamer1_next_state <= 1'd0;
					end
				end else begin
					clockdomainsrenamer1_next_state <= 3'd4;
				end
			end
		end
		2'd2: begin
			if (top_pcsrx_decoder_ce) begin
				if (((~top_pcsrx_decoder_k) & (~top_pcsrx_decoder_invalid))) begin
					top_pcsrx_count0_clockdomainsrenamer1_next_value <= (top_pcsrx_count0 + 1'd1);
					top_pcsrx_count0_clockdomainsrenamer1_next_value_ce <= 1'd1;
					case (top_pcsrx_count0)
						1'd0: begin
							clockdomainsrenamer1_next_value0 <= top_pcsrx_decoder_d;
							clockdomainsrenamer1_next_value_ce0 <= 1'd1;
						end
						1'd1: begin
							clockdomainsrenamer1_next_value1 <= top_pcsrx_decoder_d;
							clockdomainsrenamer1_next_value_ce1 <= 1'd1;
						end
					endcase
					if ((top_pcsrx_count0 == 1'd1)) begin
						top_pcsrx_seen_config_reg <= 1'd1;
						clockdomainsrenamer1_next_state <= 1'd0;
					end
				end else begin
					clockdomainsrenamer1_next_state <= 3'd4;
				end
			end
		end
		2'd3: begin
			if (top_pcsrx_decoder_ce) begin
				if (((~top_pcsrx_decoder_k) & (~top_pcsrx_decoder_invalid))) begin
					top_pcsrx_enable <= 1'd1;
					top_pcsrx_sink_sink_valid <= top_pcsrx_done;
					top_pcsrx_sink_sink_payload_data <= top_pcsrx_decoder_d;
				end else begin
					if (((top_pcsrx_decoder_k & (top_pcsrx_decoder_d == 8'd253)) & (~top_pcsrx_decoder_invalid))) begin
						clockdomainsrenamer1_next_state <= 1'd0;
					end else begin
						top_pcsrx_source_payload_error <= 1'd1;
						top_pcsrx_source_last <= 1'd1;
						top_pcsrx_source_valid <= 1'd1;
						if (top_pcsrx_source_ready) begin
							clockdomainsrenamer1_next_state <= 3'd4;
						end
					end
				end
			end
		end
		3'd4: begin
			clockdomainsrenamer1_next_state <= 1'd0;
		end
		default: begin
			if (top_pcsrx_decoder_ce) begin
				if (top_pcsrx_decoder_k) begin
					if ((top_pcsrx_decoder_d == 8'd188)) begin
						top_pcsrx_count0_clockdomainsrenamer1_next_value <= 1'd0;
						top_pcsrx_count0_clockdomainsrenamer1_next_value_ce <= 1'd1;
						clockdomainsrenamer1_next_state <= 1'd1;
					end
					if ((top_pcsrx_decoder_d == 8'd251)) begin
						top_pcsrx_enable <= 1'd1;
						top_pcsrx_sink_sink_valid <= 1'd1;
						top_pcsrx_sink_sink_payload_data <= 7'd85;
						clockdomainsrenamer1_next_state <= 2'd3;
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_7 <= dummy_s;
// synthesis translate_on
end
assign top_lp_abi_wait = (~top_lp_abi_ping_i);
assign top_lp_abi_ping_i = ((top_lp_abi_starter | top_lp_abi_pong_o) | top_lp_abi_done);
assign top_lp_abi_pong_i = top_lp_abi_ping_o1;
assign top_lp_abi_ping_o0 = (top_lp_abi_ping_toggle_o ^ top_lp_abi_ping_toggle_o_r);
assign top_lp_abi_pong_o = (top_lp_abi_pong_toggle_o ^ top_lp_abi_pong_toggle_o_r);
assign top_lp_abi_done = (top_lp_abi_count == 1'd0);
assign top_seen_valid_ci_o = (top_seen_valid_ci_toggle_o ^ top_seen_valid_ci_toggle_o_r);
assign top_rx_config_reg_abi_o = (top_rx_config_reg_abi_toggle_o ^ top_rx_config_reg_abi_toggle_o_r);
assign top_rx_config_reg_ack_o = (top_rx_config_reg_ack_toggle_o ^ top_rx_config_reg_ack_toggle_o_r);
assign top_waittimer0_done = (top_waittimer0_count == 1'd0);
assign top_waittimer1_done = (top_waittimer1_count == 1'd0);
assign top_waittimer2_done = (top_waittimer2_count == 1'd0);
assign top_pma_k7_gtx_basex_rx_valid = 1'd1;
assign top_pma_k7_gtx_basex_tx_mmcm_reset1 = top_pma_k7_gtx_basex_tx_mmcm_reset0;
assign top_pma_k7_gtx_basex_tx_mmcm_locked0 = top_pma_k7_gtx_basex_tx_mmcm_locked1;
assign top_pma_k7_gtx_basex_rx_mmcm_reset1 = top_pma_k7_gtx_basex_rx_mmcm_reset0;
assign top_pma_k7_gtx_basex_rx_mmcm_locked0 = top_pma_k7_gtx_basex_rx_mmcm_locked1;
assign top_pma_k7_gtx_basex_tx_init_reset = top_pma_k7_gtx_basex_reset;
assign top_pma_k7_gtx_basex_pll_reset = top_pma_k7_gtx_basex_gtxtxinit_pllreset0;
assign top_pma_k7_gtx_basex_gtxtxinit_plllock0 = top_pma_k7_gtx_basex_pll_lock;
assign top_pma_k7_gtx_basex_tx_reset = top_pma_k7_gtx_basex_gtxtxinit_gtXxreset0;
assign top_pma_k7_gtx_basex_gtxtxinit_Xxresetdone0 = top_pma_k7_gtx_basex_tx_reset_done;
assign top_pma_k7_gtx_basex_rx_init_reset = ((~top_pma_k7_gtx_basex_gtxtxinit_done) | top_pma_k7_gtx_basex_reset);
assign top_pma_k7_gtx_basex_gtxrxinit_plllock0 = top_pma_k7_gtx_basex_pll_lock;
assign top_pma_k7_gtx_basex_rx_reset = top_pma_k7_gtx_basex_gtxrxinit_gtXxreset0;
assign top_pma_k7_gtx_basex_gtxrxinit_Xxresetdone0 = top_pma_k7_gtx_basex_rx_reset_done;
assign top_pma_k7_gtx_basex_i = top_pma_k7_gtx_basex_restart;
assign top_pma_k7_gtx_basex_gtxrxinit_restart = top_pma_k7_gtx_basex_o;
assign top_pma_k7_gtx_basex_tx_data0 = top_pma_k7_gtx_basex_tx_data_half;
assign top_pma_k7_gtx_basex_rx_data_half = top_pma_k7_gtx_basex_rx_data0;
assign top_pma_k7_gtx_basex_s7mmcm0_clkin_signal = top_pma_k7_gtx_basex_txoutclk_rebuffer;
assign eth_tx_half_clk = top_pma_k7_gtx_basex_s7mmcm0_clkout_buf0;
assign eth_tx_clk = top_pma_k7_gtx_basex_s7mmcm0_clkout_buf1;
assign top_pma_k7_gtx_basex_s7mmcm1_clkin_signal = top_pma_k7_gtx_basex_rxoutclk_rebuffer;
assign eth_rx_half_clk = top_pma_k7_gtx_basex_s7mmcm1_clkout_buf0;
assign eth_rx_clk = top_pma_k7_gtx_basex_s7mmcm1_clkout_buf1;
assign top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone_rising = (top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone1 & (~top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone_r));
assign top_pma_k7_gtx_basex_gtxtxinit_init_delay_wait = 1'd1;
assign top_pma_k7_gtx_basex_gtxtxinit_watchdog_wait = ((~top_pma_k7_gtx_basex_gtxtxinit_reset) & (~top_pma_k7_gtx_basex_gtxtxinit_done));
assign top_pma_k7_gtx_basex_gtxtxinit_reset = (top_pma_k7_gtx_basex_gtxtxinit_restart | top_pma_k7_gtx_basex_gtxtxinit_watchdog_done);

// synthesis translate_off
reg dummy_d_8;
// synthesis translate_on
always @(*) begin
	top_pma_k7_gtx_basex_gtxtxinit_done <= 1'd0;
	top_pma_k7_gtx_basex_gtxtxinit_drp_start <= 1'd0;
	top_pma_k7_gtx_basex_gtxtxinit_pllreset1 <= 1'd0;
	top_pma_k7_gtx_basex_gtxtxinit_gtXxreset1 <= 1'd0;
	top_pma_k7_gtx_basex_gtxtxinit_gtXxpd1 <= 1'd0;
	top_pma_k7_gtx_basex_gtxtxinit_Xxdlysreset1 <= 1'd0;
	top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy1 <= 1'd0;
	top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_wait <= 1'd0;
	gtxtxinit_next_state <= 4'd0;
	gtxtxinit_next_state <= gtxtxinit_state;
	case (gtxtxinit_state)
		1'd1: begin
			top_pma_k7_gtx_basex_gtxtxinit_gtXxreset1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxtxinit_pllreset1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxtxinit_drp_start <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxtxinit_drp_done) begin
				gtxtxinit_next_state <= 2'd2;
			end
		end
		2'd2: begin
			top_pma_k7_gtx_basex_gtxtxinit_gtXxreset1 <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxtxinit_plllock1) begin
				gtxtxinit_next_state <= 2'd3;
			end
		end
		2'd3: begin
			top_pma_k7_gtx_basex_gtxtxinit_gtXxreset1 <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxtxinit_init_delay_done) begin
				gtxtxinit_next_state <= 3'd4;
			end
		end
		3'd4: begin
			top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy1 <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxtxinit_Xxresetdone1) begin
				gtxtxinit_next_state <= 3'd5;
			end
		end
		3'd5: begin
			top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_wait <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_done) begin
				if (1'd1) begin
					gtxtxinit_next_state <= 4'd10;
				end else begin
					gtxtxinit_next_state <= 3'd6;
				end
			end
		end
		3'd6: begin
			top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxtxinit_Xxdlysreset1 <= 1'd1;
			gtxtxinit_next_state <= 3'd7;
		end
		3'd7: begin
			top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy1 <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxtxinit_Xxdlysresetdone1) begin
				gtxtxinit_next_state <= 4'd8;
			end
		end
		4'd8: begin
			top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy1 <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone_rising) begin
				gtxtxinit_next_state <= 4'd9;
			end
		end
		4'd9: begin
			top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy1 <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone_rising) begin
				gtxtxinit_next_state <= 4'd10;
			end
		end
		4'd10: begin
			top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxtxinit_done <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxtxinit_restart) begin
				gtxtxinit_next_state <= 1'd0;
			end
		end
		default: begin
			top_pma_k7_gtx_basex_gtxtxinit_gtXxreset1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxtxinit_gtXxpd1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxtxinit_pllreset1 <= 1'd1;
			gtxtxinit_next_state <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_8 <= dummy_s;
// synthesis translate_on
end
assign top_pma_k7_gtx_basex_gtxtxinit_init_delay_done = (top_pma_k7_gtx_basex_gtxtxinit_init_delay_count == 1'd0);
assign top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_done = (top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_count == 1'd0);
assign top_pma_k7_gtx_basex_gtxtxinit_watchdog_done = (top_pma_k7_gtx_basex_gtxtxinit_watchdog_count == 1'd0);
assign top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone_rising = (top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone1 & (~top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone_r));
assign top_pma_k7_gtx_basex_gtxrxinit_init_delay_wait = 1'd1;
assign top_pma_k7_gtx_basex_gtxrxinit_watchdog_wait = ((~top_pma_k7_gtx_basex_gtxrxinit_reset) & (~top_pma_k7_gtx_basex_gtxrxinit_done));
assign top_pma_k7_gtx_basex_gtxrxinit_reset = (top_pma_k7_gtx_basex_gtxrxinit_restart | top_pma_k7_gtx_basex_gtxrxinit_watchdog_done);

// synthesis translate_off
reg dummy_d_9;
// synthesis translate_on
always @(*) begin
	top_pma_k7_gtx_basex_gtxrxinit_done <= 1'd0;
	top_pma_k7_gtx_basex_gtxrxinit_drp_start <= 1'd0;
	top_pma_k7_gtx_basex_gtxrxinit_pllreset1 <= 1'd0;
	top_pma_k7_gtx_basex_gtxrxinit_gtXxreset1 <= 1'd0;
	top_pma_k7_gtx_basex_gtxrxinit_gtXxpd1 <= 1'd0;
	top_pma_k7_gtx_basex_gtxrxinit_Xxdlysreset1 <= 1'd0;
	top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy1 <= 1'd0;
	top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_wait <= 1'd0;
	gtxrxinit_next_state <= 4'd0;
	gtxrxinit_next_state <= gtxrxinit_state;
	case (gtxrxinit_state)
		1'd1: begin
			top_pma_k7_gtx_basex_gtxrxinit_gtXxreset1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxrxinit_pllreset1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxrxinit_drp_start <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxrxinit_drp_done) begin
				gtxrxinit_next_state <= 2'd2;
			end
		end
		2'd2: begin
			top_pma_k7_gtx_basex_gtxrxinit_gtXxreset1 <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxrxinit_plllock1) begin
				gtxrxinit_next_state <= 2'd3;
			end
		end
		2'd3: begin
			top_pma_k7_gtx_basex_gtxrxinit_gtXxreset1 <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxrxinit_init_delay_done) begin
				gtxrxinit_next_state <= 3'd4;
			end
		end
		3'd4: begin
			top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy1 <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxrxinit_Xxresetdone1) begin
				gtxrxinit_next_state <= 3'd5;
			end
		end
		3'd5: begin
			top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_wait <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_done) begin
				if (1'd1) begin
					gtxrxinit_next_state <= 4'd10;
				end else begin
					gtxrxinit_next_state <= 3'd6;
				end
			end
		end
		3'd6: begin
			top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxrxinit_Xxdlysreset1 <= 1'd1;
			gtxrxinit_next_state <= 3'd7;
		end
		3'd7: begin
			top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy1 <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxrxinit_Xxdlysresetdone1) begin
				gtxrxinit_next_state <= 4'd8;
			end
		end
		4'd8: begin
			top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy1 <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone_rising) begin
				gtxrxinit_next_state <= 4'd9;
			end
		end
		4'd9: begin
			top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy1 <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone_rising) begin
				gtxrxinit_next_state <= 4'd10;
			end
		end
		4'd10: begin
			top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxrxinit_done <= 1'd1;
			if (top_pma_k7_gtx_basex_gtxrxinit_restart) begin
				gtxrxinit_next_state <= 1'd0;
			end
		end
		default: begin
			top_pma_k7_gtx_basex_gtxrxinit_gtXxreset1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxrxinit_gtXxpd1 <= 1'd1;
			top_pma_k7_gtx_basex_gtxrxinit_pllreset1 <= 1'd1;
			gtxrxinit_next_state <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_9 <= dummy_s;
// synthesis translate_on
end
assign top_pma_k7_gtx_basex_gtxrxinit_init_delay_done = (top_pma_k7_gtx_basex_gtxrxinit_init_delay_count == 1'd0);
assign top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_done = (top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_count == 1'd0);
assign top_pma_k7_gtx_basex_gtxrxinit_watchdog_done = (top_pma_k7_gtx_basex_gtxrxinit_watchdog_count == 1'd0);
assign top_pma_k7_gtx_basex_o = (top_pma_k7_gtx_basex_toggle_o ^ top_pma_k7_gtx_basex_toggle_o_r);
assign top_tx_padding_counter_done = (top_tx_padding_counter >= 6'd59);

// synthesis translate_off
reg dummy_d_10;
// synthesis translate_on
always @(*) begin
	top_tx_padding_sink_ready <= 1'd0;
	top_tx_padding_source_valid <= 1'd0;
	top_tx_padding_source_first <= 1'd0;
	top_tx_padding_source_last <= 1'd0;
	top_tx_padding_source_payload_data <= 8'd0;
	top_tx_padding_source_payload_be <= 1'd0;
	top_tx_padding_source_payload_error <= 1'd0;
	txdatapath_liteethmacpaddinginserter_next_state <= 1'd0;
	top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value <= 16'd0;
	top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value_ce <= 1'd0;
	txdatapath_liteethmacpaddinginserter_next_state <= txdatapath_liteethmacpaddinginserter_state;
	case (txdatapath_liteethmacpaddinginserter_state)
		1'd1: begin
			top_tx_padding_source_valid <= 1'd1;
			top_tx_padding_source_payload_be <= 1'd1;
			if (top_tx_padding_counter_done) begin
				top_tx_padding_source_payload_be <= 1'd1;
				top_tx_padding_source_last <= 1'd1;
			end
			top_tx_padding_source_payload_data <= 1'd0;
			if ((top_tx_padding_source_valid & top_tx_padding_source_ready)) begin
				top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value <= (top_tx_padding_counter + 1'd1);
				top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value_ce <= 1'd1;
				if (top_tx_padding_counter_done) begin
					top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value <= 1'd0;
					top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value_ce <= 1'd1;
					txdatapath_liteethmacpaddinginserter_next_state <= 1'd0;
				end
			end
		end
		default: begin
			top_tx_padding_source_valid <= top_tx_padding_sink_valid;
			top_tx_padding_sink_ready <= top_tx_padding_source_ready;
			top_tx_padding_source_first <= top_tx_padding_sink_first;
			top_tx_padding_source_last <= top_tx_padding_sink_last;
			top_tx_padding_source_payload_data <= top_tx_padding_sink_payload_data;
			top_tx_padding_source_payload_be <= top_tx_padding_sink_payload_be;
			top_tx_padding_source_payload_error <= top_tx_padding_sink_payload_error;
			if (top_tx_padding_sink_last) begin
				if ((~top_tx_padding_sink_payload_be)) begin
					top_tx_padding_source_payload_data[7:0] <= 1'd0;
				end
				if ((~top_tx_padding_counter_done)) begin
					top_tx_padding_source_last <= 1'd0;
					top_tx_padding_source_payload_be <= 1'd1;
				end else begin
					if (((top_tx_padding_counter == 6'd59) & (top_tx_padding_sink_payload_be < 1'd1))) begin
						top_tx_padding_source_payload_be <= 1'd1;
					end
				end
			end
			if ((top_tx_padding_source_valid & top_tx_padding_source_ready)) begin
				top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value <= (top_tx_padding_counter + 1'd1);
				top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value_ce <= 1'd1;
				if (top_tx_padding_sink_last) begin
					if ((~top_tx_padding_counter_done)) begin
						txdatapath_liteethmacpaddinginserter_next_state <= 1'd1;
					end else begin
						top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value <= 1'd0;
						top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value_ce <= 1'd1;
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_10 <= dummy_s;
// synthesis translate_on
end
assign top_tx_crc_data0 = top_tx_crc_sink_payload_data;
assign top_tx_crc_be1 = top_tx_crc_sink_payload_be;
assign top_tx_crc_cnt_done = (top_tx_crc_cnt == 1'd0);
assign top_tx_crc_sink_valid = top_tx_crc_source_source_valid;
assign top_tx_crc_source_source_ready = top_tx_crc_sink_ready;
assign top_tx_crc_sink_first = top_tx_crc_source_source_first;
assign top_tx_crc_sink_last = top_tx_crc_source_source_last;
assign top_tx_crc_sink_payload_data = top_tx_crc_source_source_payload_data;
assign top_tx_crc_sink_payload_be = top_tx_crc_source_source_payload_be;
assign top_tx_crc_sink_payload_error = top_tx_crc_source_source_payload_error;
assign top_tx_crc_data1 = top_tx_crc_data0;
assign top_tx_crc_crc_prev = top_tx_crc_reg;

// synthesis translate_off
reg dummy_d_11;
// synthesis translate_on
always @(*) begin
	top_tx_crc_value <= 32'd0;
	top_tx_crc_error <= 1'd0;
	if (top_tx_crc_be1) begin
		top_tx_crc_value <= ({top_tx_crc_crc_next[0], top_tx_crc_crc_next[1], top_tx_crc_crc_next[2], top_tx_crc_crc_next[3], top_tx_crc_crc_next[4], top_tx_crc_crc_next[5], top_tx_crc_crc_next[6], top_tx_crc_crc_next[7], top_tx_crc_crc_next[8], top_tx_crc_crc_next[9], top_tx_crc_crc_next[10], top_tx_crc_crc_next[11], top_tx_crc_crc_next[12], top_tx_crc_crc_next[13], top_tx_crc_crc_next[14], top_tx_crc_crc_next[15], top_tx_crc_crc_next[16], top_tx_crc_crc_next[17], top_tx_crc_crc_next[18], top_tx_crc_crc_next[19], top_tx_crc_crc_next[20], top_tx_crc_crc_next[21], top_tx_crc_crc_next[22], top_tx_crc_crc_next[23], top_tx_crc_crc_next[24], top_tx_crc_crc_next[25], top_tx_crc_crc_next[26], top_tx_crc_crc_next[27], top_tx_crc_crc_next[28], top_tx_crc_crc_next[29], top_tx_crc_crc_next[30], top_tx_crc_crc_next[31]} ^ 32'd4294967295);
		top_tx_crc_error <= (top_tx_crc_crc_next != 32'd3338984827);
	end
// synthesis translate_off
	dummy_d_11 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_12;
// synthesis translate_on
always @(*) begin
	top_tx_crc_crc_next <= 32'd0;
	top_tx_crc_crc_next[0] <= (((top_tx_crc_crc_prev[24] ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[1] <= (((((((top_tx_crc_crc_prev[25] ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_data1[6]) ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[2] <= (((((((((top_tx_crc_crc_prev[26] ^ top_tx_crc_data1[5]) ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_data1[6]) ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[3] <= (((((((top_tx_crc_crc_prev[27] ^ top_tx_crc_data1[4]) ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]) ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_data1[6]);
	top_tx_crc_crc_next[4] <= (((((((((top_tx_crc_crc_prev[28] ^ top_tx_crc_data1[3]) ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]) ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]) ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[5] <= (((((((((((((top_tx_crc_crc_prev[29] ^ top_tx_crc_data1[2]) ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]) ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]) ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_data1[6]) ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[6] <= (((((((((((top_tx_crc_crc_prev[30] ^ top_tx_crc_data1[1]) ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]) ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]) ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]) ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_data1[6]);
	top_tx_crc_crc_next[7] <= (((((((((top_tx_crc_crc_prev[31] ^ top_tx_crc_data1[0]) ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]) ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]) ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]) ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[8] <= ((((((((top_tx_crc_crc_prev[0] ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]) ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]) ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_data1[6]) ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[9] <= ((((((((top_tx_crc_crc_prev[1] ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]) ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]) ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]) ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_data1[6]);
	top_tx_crc_crc_next[10] <= ((((((((top_tx_crc_crc_prev[2] ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]) ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]) ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]) ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[11] <= ((((((((top_tx_crc_crc_prev[3] ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]) ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]) ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_data1[6]) ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[12] <= ((((((((((((top_tx_crc_crc_prev[4] ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]) ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]) ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]) ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_data1[6]) ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[13] <= ((((((((((((top_tx_crc_crc_prev[5] ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]) ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]) ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]) ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_data1[6]);
	top_tx_crc_crc_next[14] <= ((((((((((top_tx_crc_crc_prev[6] ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]) ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]) ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]);
	top_tx_crc_crc_next[15] <= ((((((((top_tx_crc_crc_prev[7] ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]) ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]) ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]);
	top_tx_crc_crc_next[16] <= ((((((top_tx_crc_crc_prev[8] ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]) ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]) ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[17] <= ((((((top_tx_crc_crc_prev[9] ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]) ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_data1[6]);
	top_tx_crc_crc_next[18] <= ((((((top_tx_crc_crc_prev[10] ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]);
	top_tx_crc_crc_next[19] <= ((((top_tx_crc_crc_prev[11] ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]);
	top_tx_crc_crc_next[20] <= ((top_tx_crc_crc_prev[12] ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]);
	top_tx_crc_crc_next[21] <= ((top_tx_crc_crc_prev[13] ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]);
	top_tx_crc_crc_next[22] <= ((top_tx_crc_crc_prev[14] ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[23] <= ((((((top_tx_crc_crc_prev[15] ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_data1[6]) ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[24] <= ((((((top_tx_crc_crc_prev[16] ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]) ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_data1[6]);
	top_tx_crc_crc_next[25] <= ((((top_tx_crc_crc_prev[17] ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]) ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]);
	top_tx_crc_crc_next[26] <= ((((((((top_tx_crc_crc_prev[18] ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]) ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]) ^ top_tx_crc_crc_prev[24]) ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_data1[7]);
	top_tx_crc_crc_next[27] <= ((((((((top_tx_crc_crc_prev[19] ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]) ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]) ^ top_tx_crc_crc_prev[25]) ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_data1[6]);
	top_tx_crc_crc_next[28] <= ((((((top_tx_crc_crc_prev[20] ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]) ^ top_tx_crc_crc_prev[26]) ^ top_tx_crc_data1[5]);
	top_tx_crc_crc_next[29] <= ((((((top_tx_crc_crc_prev[21] ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_crc_prev[30]) ^ top_tx_crc_data1[1]) ^ top_tx_crc_crc_prev[27]) ^ top_tx_crc_data1[4]);
	top_tx_crc_crc_next[30] <= ((((top_tx_crc_crc_prev[22] ^ top_tx_crc_crc_prev[31]) ^ top_tx_crc_data1[0]) ^ top_tx_crc_crc_prev[28]) ^ top_tx_crc_data1[3]);
	top_tx_crc_crc_next[31] <= ((top_tx_crc_crc_prev[23] ^ top_tx_crc_crc_prev[29]) ^ top_tx_crc_data1[2]);
// synthesis translate_off
	dummy_d_12 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_13;
// synthesis translate_on
always @(*) begin
	top_tx_crc_sink_ready <= 1'd0;
	top_tx_crc_source_valid <= 1'd0;
	top_tx_crc_source_first <= 1'd0;
	top_tx_crc_source_last <= 1'd0;
	top_tx_crc_source_payload_data <= 8'd0;
	top_tx_crc_source_payload_be <= 1'd0;
	top_tx_crc_source_payload_error <= 1'd0;
	top_tx_crc_ce <= 1'd0;
	top_tx_crc_reset <= 1'd0;
	top_tx_crc_is_ongoing0 <= 1'd0;
	top_tx_crc_is_ongoing1 <= 1'd0;
	txdatapath_bufferizeendpoints_next_state <= 2'd0;
	top_tx_crc_crc_packet_clockdomainsrenamer_clockdomainsrenamer1_next_value0 <= 32'd0;
	top_tx_crc_crc_packet_clockdomainsrenamer_clockdomainsrenamer1_next_value_ce0 <= 1'd0;
	top_tx_crc_be0_clockdomainsrenamer_clockdomainsrenamer1_next_value1 <= 1'd0;
	top_tx_crc_be0_clockdomainsrenamer_clockdomainsrenamer1_next_value_ce1 <= 1'd0;
	txdatapath_bufferizeendpoints_next_state <= txdatapath_bufferizeendpoints_state;
	case (txdatapath_bufferizeendpoints_state)
		1'd1: begin
			top_tx_crc_ce <= (top_tx_crc_sink_valid & top_tx_crc_source_ready);
			top_tx_crc_source_valid <= top_tx_crc_sink_valid;
			top_tx_crc_sink_ready <= top_tx_crc_source_ready;
			top_tx_crc_source_first <= top_tx_crc_sink_first;
			top_tx_crc_source_last <= top_tx_crc_sink_last;
			top_tx_crc_source_payload_data <= top_tx_crc_sink_payload_data;
			top_tx_crc_source_payload_be <= top_tx_crc_sink_payload_be;
			top_tx_crc_source_payload_error <= top_tx_crc_sink_payload_error;
			top_tx_crc_source_last <= 1'd0;
			top_tx_crc_source_payload_be <= 1'd1;
			if (top_tx_crc_sink_last) begin
				if (top_tx_crc_sink_payload_be) begin
					top_tx_crc_source_payload_data <= slice_proxy[7:0];
				end
				if ((1'd0 & (top_tx_crc_sink_payload_be <= 4'd15))) begin
					top_tx_crc_source_last <= 1'd1;
					top_tx_crc_source_payload_be <= ((top_tx_crc_sink_payload_be <<< 3'd4) | 4'd15);
				end
			end
			if (((top_tx_crc_sink_valid & top_tx_crc_sink_last) & top_tx_crc_source_ready)) begin
				if ((1'd0 & (top_tx_crc_sink_payload_be <= 4'd15))) begin
					txdatapath_bufferizeendpoints_next_state <= 1'd0;
				end else begin
					top_tx_crc_crc_packet_clockdomainsrenamer_clockdomainsrenamer1_next_value0 <= top_tx_crc_value;
					top_tx_crc_crc_packet_clockdomainsrenamer_clockdomainsrenamer1_next_value_ce0 <= 1'd1;
					if (1'd0) begin
						top_tx_crc_be0_clockdomainsrenamer_clockdomainsrenamer1_next_value1 <= (top_tx_crc_sink_payload_be >>> 3'd4);
						top_tx_crc_be0_clockdomainsrenamer_clockdomainsrenamer1_next_value_ce1 <= 1'd1;
					end else begin
						top_tx_crc_be0_clockdomainsrenamer_clockdomainsrenamer1_next_value1 <= top_tx_crc_sink_payload_be;
						top_tx_crc_be0_clockdomainsrenamer_clockdomainsrenamer1_next_value_ce1 <= 1'd1;
					end
					txdatapath_bufferizeendpoints_next_state <= 2'd2;
				end
			end
		end
		2'd2: begin
			top_tx_crc_source_valid <= 1'd1;
			top_tx_crc_source_payload_be <= 1'd1;
			case (top_tx_crc_cnt)
				1'd0: begin
					top_tx_crc_source_payload_data <= top_tx_crc_crc_packet[31:24];
				end
				1'd1: begin
					top_tx_crc_source_payload_data <= top_tx_crc_crc_packet[23:16];
				end
				2'd2: begin
					top_tx_crc_source_payload_data <= top_tx_crc_crc_packet[15:8];
				end
				default: begin
					top_tx_crc_source_payload_data <= top_tx_crc_crc_packet[7:0];
				end
			endcase
			if (top_tx_crc_cnt_done) begin
				top_tx_crc_source_last <= 1'd1;
				if (top_tx_crc_source_ready) begin
					txdatapath_bufferizeendpoints_next_state <= 1'd0;
				end
			end
			top_tx_crc_is_ongoing1 <= 1'd1;
		end
		default: begin
			top_tx_crc_reset <= 1'd1;
			top_tx_crc_sink_ready <= 1'd1;
			if (top_tx_crc_sink_valid) begin
				top_tx_crc_sink_ready <= 1'd0;
				txdatapath_bufferizeendpoints_next_state <= 1'd1;
			end
			top_tx_crc_is_ongoing0 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_13 <= dummy_s;
// synthesis translate_on
end
assign top_tx_crc_pipe_valid_sink_ready = ((~top_tx_crc_pipe_valid_source_valid) | top_tx_crc_pipe_valid_source_ready);
assign top_tx_crc_pipe_valid_sink_valid = top_tx_crc_sink_sink_valid;
assign top_tx_crc_sink_sink_ready = top_tx_crc_pipe_valid_sink_ready;
assign top_tx_crc_pipe_valid_sink_first = top_tx_crc_sink_sink_first;
assign top_tx_crc_pipe_valid_sink_last = top_tx_crc_sink_sink_last;
assign top_tx_crc_pipe_valid_sink_payload_data = top_tx_crc_sink_sink_payload_data;
assign top_tx_crc_pipe_valid_sink_payload_be = top_tx_crc_sink_sink_payload_be;
assign top_tx_crc_pipe_valid_sink_payload_error = top_tx_crc_sink_sink_payload_error;
assign top_tx_crc_source_source_valid = top_tx_crc_pipe_valid_source_valid;
assign top_tx_crc_pipe_valid_source_ready = top_tx_crc_source_source_ready;
assign top_tx_crc_source_source_first = top_tx_crc_pipe_valid_source_first;
assign top_tx_crc_source_source_last = top_tx_crc_pipe_valid_source_last;
assign top_tx_crc_source_source_payload_data = top_tx_crc_pipe_valid_source_payload_data;
assign top_tx_crc_source_source_payload_be = top_tx_crc_pipe_valid_source_payload_be;
assign top_tx_crc_source_source_payload_error = top_tx_crc_pipe_valid_source_payload_error;

// synthesis translate_off
reg dummy_d_14;
// synthesis translate_on
always @(*) begin
	top_tx_preamble_sink_ready <= 1'd0;
	top_tx_preamble_source_valid <= 1'd0;
	top_tx_preamble_source_first <= 1'd0;
	top_tx_preamble_source_last <= 1'd0;
	top_tx_preamble_source_payload_data <= 8'd0;
	top_tx_preamble_source_payload_be <= 1'd0;
	top_tx_preamble_source_payload_error <= 1'd0;
	txdatapath_liteethmacpreambleinserter_next_state <= 2'd0;
	top_tx_preamble_count_clockdomainsrenamer_clockdomainsrenamer2_next_value <= 3'd0;
	top_tx_preamble_count_clockdomainsrenamer_clockdomainsrenamer2_next_value_ce <= 1'd0;
	top_tx_preamble_source_payload_data <= top_tx_preamble_sink_payload_data;
	top_tx_preamble_source_payload_be <= top_tx_preamble_sink_payload_be;
	txdatapath_liteethmacpreambleinserter_next_state <= txdatapath_liteethmacpreambleinserter_state;
	case (txdatapath_liteethmacpreambleinserter_state)
		1'd1: begin
			top_tx_preamble_source_valid <= 1'd1;
			top_tx_preamble_source_payload_be <= 1'd1;
			case (top_tx_preamble_count)
				1'd0: begin
					top_tx_preamble_source_payload_data <= top_tx_preamble_preamble[7:0];
				end
				1'd1: begin
					top_tx_preamble_source_payload_data <= top_tx_preamble_preamble[15:8];
				end
				2'd2: begin
					top_tx_preamble_source_payload_data <= top_tx_preamble_preamble[23:16];
				end
				2'd3: begin
					top_tx_preamble_source_payload_data <= top_tx_preamble_preamble[31:24];
				end
				3'd4: begin
					top_tx_preamble_source_payload_data <= top_tx_preamble_preamble[39:32];
				end
				3'd5: begin
					top_tx_preamble_source_payload_data <= top_tx_preamble_preamble[47:40];
				end
				3'd6: begin
					top_tx_preamble_source_payload_data <= top_tx_preamble_preamble[55:48];
				end
				default: begin
					top_tx_preamble_source_payload_data <= top_tx_preamble_preamble[63:56];
				end
			endcase
			if (top_tx_preamble_source_ready) begin
				if ((top_tx_preamble_count == 3'd7)) begin
					txdatapath_liteethmacpreambleinserter_next_state <= 2'd2;
				end else begin
					top_tx_preamble_count_clockdomainsrenamer_clockdomainsrenamer2_next_value <= (top_tx_preamble_count + 1'd1);
					top_tx_preamble_count_clockdomainsrenamer_clockdomainsrenamer2_next_value_ce <= 1'd1;
				end
			end
		end
		2'd2: begin
			top_tx_preamble_source_valid <= top_tx_preamble_sink_valid;
			top_tx_preamble_sink_ready <= top_tx_preamble_source_ready;
			top_tx_preamble_source_first <= top_tx_preamble_sink_first;
			top_tx_preamble_source_last <= top_tx_preamble_sink_last;
			top_tx_preamble_source_payload_error <= top_tx_preamble_sink_payload_error;
			if (((top_tx_preamble_sink_valid & top_tx_preamble_sink_last) & top_tx_preamble_source_ready)) begin
				txdatapath_liteethmacpreambleinserter_next_state <= 1'd0;
			end
		end
		default: begin
			top_tx_preamble_sink_ready <= 1'd1;
			top_tx_preamble_count_clockdomainsrenamer_clockdomainsrenamer2_next_value <= 1'd0;
			top_tx_preamble_count_clockdomainsrenamer_clockdomainsrenamer2_next_value_ce <= 1'd1;
			if (top_tx_preamble_sink_valid) begin
				top_tx_preamble_sink_ready <= 1'd0;
				txdatapath_liteethmacpreambleinserter_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_14 <= dummy_s;
// synthesis translate_on
end
assign top_txdatapath_cdc_sink_valid = top_txdatapath_sink_sink_valid;
assign top_txdatapath_sink_sink_ready = top_txdatapath_cdc_sink_ready;
assign top_txdatapath_cdc_sink_first = top_txdatapath_sink_sink_first;
assign top_txdatapath_cdc_sink_last = top_txdatapath_sink_sink_last;
assign top_txdatapath_cdc_sink_payload_data = top_txdatapath_sink_sink_payload_data;
assign top_txdatapath_cdc_sink_payload_be = top_txdatapath_sink_sink_payload_be;
assign top_txdatapath_cdc_sink_payload_error = top_txdatapath_sink_sink_payload_error;
assign top_txdatapath_source_source_valid = top_txdatapath_cdc_source_valid;
assign top_txdatapath_cdc_source_ready = top_txdatapath_source_source_ready;
assign top_txdatapath_source_source_first = top_txdatapath_cdc_source_first;
assign top_txdatapath_source_source_last = top_txdatapath_cdc_source_last;
assign top_txdatapath_source_source_payload_data = top_txdatapath_cdc_source_payload_data;
assign top_txdatapath_source_source_payload_be = top_txdatapath_cdc_source_payload_be;
assign top_txdatapath_source_source_payload_error = top_txdatapath_cdc_source_payload_error;
assign top_txdatapath_cdc_asyncfifo_din = {top_txdatapath_cdc_fifo_in_last, top_txdatapath_cdc_fifo_in_first, top_txdatapath_cdc_fifo_in_payload_error, top_txdatapath_cdc_fifo_in_payload_be, top_txdatapath_cdc_fifo_in_payload_data};
assign {top_txdatapath_cdc_fifo_out_last, top_txdatapath_cdc_fifo_out_first, top_txdatapath_cdc_fifo_out_payload_error, top_txdatapath_cdc_fifo_out_payload_be, top_txdatapath_cdc_fifo_out_payload_data} = top_txdatapath_cdc_asyncfifo_dout;
assign top_txdatapath_cdc_sink_ready = top_txdatapath_cdc_asyncfifo_writable;
assign top_txdatapath_cdc_asyncfifo_we = top_txdatapath_cdc_sink_valid;
assign top_txdatapath_cdc_fifo_in_first = top_txdatapath_cdc_sink_first;
assign top_txdatapath_cdc_fifo_in_last = top_txdatapath_cdc_sink_last;
assign top_txdatapath_cdc_fifo_in_payload_data = top_txdatapath_cdc_sink_payload_data;
assign top_txdatapath_cdc_fifo_in_payload_be = top_txdatapath_cdc_sink_payload_be;
assign top_txdatapath_cdc_fifo_in_payload_error = top_txdatapath_cdc_sink_payload_error;
assign top_txdatapath_cdc_source_valid = top_txdatapath_cdc_asyncfifo_readable;
assign top_txdatapath_cdc_source_first = top_txdatapath_cdc_fifo_out_first;
assign top_txdatapath_cdc_source_last = top_txdatapath_cdc_fifo_out_last;
assign top_txdatapath_cdc_source_payload_data = top_txdatapath_cdc_fifo_out_payload_data;
assign top_txdatapath_cdc_source_payload_be = top_txdatapath_cdc_fifo_out_payload_be;
assign top_txdatapath_cdc_source_payload_error = top_txdatapath_cdc_fifo_out_payload_error;
assign top_txdatapath_cdc_asyncfifo_re = top_txdatapath_cdc_source_ready;
assign top_txdatapath_cdc_graycounter0_ce = (top_txdatapath_cdc_asyncfifo_writable & top_txdatapath_cdc_asyncfifo_we);
assign top_txdatapath_cdc_graycounter1_ce = (top_txdatapath_cdc_asyncfifo_readable & top_txdatapath_cdc_asyncfifo_re);
assign top_txdatapath_cdc_asyncfifo_writable = (((top_txdatapath_cdc_graycounter0_q[5] == top_txdatapath_cdc_consume_wdomain[5]) | (top_txdatapath_cdc_graycounter0_q[4] == top_txdatapath_cdc_consume_wdomain[4])) | (top_txdatapath_cdc_graycounter0_q[3:0] != top_txdatapath_cdc_consume_wdomain[3:0]));
assign top_txdatapath_cdc_asyncfifo_readable = (top_txdatapath_cdc_graycounter1_q != top_txdatapath_cdc_produce_rdomain);
assign top_txdatapath_cdc_wrport_adr = top_txdatapath_cdc_graycounter0_q_binary[4:0];
assign top_txdatapath_cdc_wrport_dat_w = top_txdatapath_cdc_asyncfifo_din;
assign top_txdatapath_cdc_wrport_we = top_txdatapath_cdc_graycounter0_ce;
assign top_txdatapath_cdc_rdport_adr = top_txdatapath_cdc_graycounter1_q_next_binary[4:0];
assign top_txdatapath_cdc_asyncfifo_dout = top_txdatapath_cdc_rdport_dat_r;

// synthesis translate_off
reg dummy_d_15;
// synthesis translate_on
always @(*) begin
	top_txdatapath_cdc_graycounter0_q_next_binary <= 6'd0;
	if (top_txdatapath_cdc_graycounter0_ce) begin
		top_txdatapath_cdc_graycounter0_q_next_binary <= (top_txdatapath_cdc_graycounter0_q_binary + 1'd1);
	end else begin
		top_txdatapath_cdc_graycounter0_q_next_binary <= top_txdatapath_cdc_graycounter0_q_binary;
	end
// synthesis translate_off
	dummy_d_15 <= dummy_s;
// synthesis translate_on
end
assign top_txdatapath_cdc_graycounter0_q_next = (top_txdatapath_cdc_graycounter0_q_next_binary ^ top_txdatapath_cdc_graycounter0_q_next_binary[5:1]);

// synthesis translate_off
reg dummy_d_16;
// synthesis translate_on
always @(*) begin
	top_txdatapath_cdc_graycounter1_q_next_binary <= 6'd0;
	if (top_txdatapath_cdc_graycounter1_ce) begin
		top_txdatapath_cdc_graycounter1_q_next_binary <= (top_txdatapath_cdc_graycounter1_q_binary + 1'd1);
	end else begin
		top_txdatapath_cdc_graycounter1_q_next_binary <= top_txdatapath_cdc_graycounter1_q_binary;
	end
// synthesis translate_off
	dummy_d_16 <= dummy_s;
// synthesis translate_on
end
assign top_txdatapath_cdc_graycounter1_q_next = (top_txdatapath_cdc_graycounter1_q_next_binary ^ top_txdatapath_cdc_graycounter1_q_next_binary[5:1]);
assign top_tx_packet_fifo_payload_fifo_sink_first = top_tx_packet_fifo_sink_sink_first;
assign top_tx_packet_fifo_payload_fifo_sink_last = top_tx_packet_fifo_sink_sink_last;
assign top_tx_packet_fifo_payload_fifo_sink_payload_data = top_tx_packet_fifo_sink_sink_payload_data;
assign top_tx_packet_fifo_payload_fifo_sink_payload_be = top_tx_packet_fifo_sink_sink_payload_be;
assign top_tx_packet_fifo_payload_fifo_sink_payload_error = top_tx_packet_fifo_sink_sink_payload_error;
assign top_tx_packet_fifo_param_fifo_sink_valid = ((top_tx_packet_fifo_sink_sink_valid & top_tx_packet_fifo_sink_sink_last) & top_tx_packet_fifo_payload_fifo_sink_ready);
assign top_tx_packet_fifo_payload_fifo_sink_valid = (top_tx_packet_fifo_sink_sink_valid & top_tx_packet_fifo_param_fifo_sink_ready);
assign top_tx_packet_fifo_sink_sink_ready = (top_tx_packet_fifo_param_fifo_sink_ready & top_tx_packet_fifo_payload_fifo_sink_ready);
assign top_tx_packet_fifo_source_source_valid = top_tx_packet_fifo_param_fifo_source_valid;

// synthesis translate_off
reg dummy_d_17;
// synthesis translate_on
always @(*) begin
	top_tx_packet_fifo_source_source_first <= 1'd0;
	top_tx_packet_fifo_source_source_first <= top_tx_packet_fifo_param_fifo_source_first;
	top_tx_packet_fifo_source_source_first <= top_tx_packet_fifo_payload_fifo_source_first;
// synthesis translate_off
	dummy_d_17 <= dummy_s;
// synthesis translate_on
end
assign top_tx_packet_fifo_source_source_last = top_tx_packet_fifo_payload_fifo_source_last;
assign top_tx_packet_fifo_source_source_payload_data = top_tx_packet_fifo_payload_fifo_source_payload_data;
assign top_tx_packet_fifo_source_source_payload_be = top_tx_packet_fifo_payload_fifo_source_payload_be;
assign top_tx_packet_fifo_source_source_payload_error = top_tx_packet_fifo_payload_fifo_source_payload_error;
assign top_tx_packet_fifo_param_fifo_source_ready = ((top_tx_packet_fifo_source_source_valid & top_tx_packet_fifo_source_source_last) & top_tx_packet_fifo_source_source_ready);
assign top_tx_packet_fifo_payload_fifo_source_ready = (top_tx_packet_fifo_source_source_valid & top_tx_packet_fifo_source_source_ready);
assign top_tx_packet_fifo_payload_fifo_syncfifo_din = {top_tx_packet_fifo_payload_fifo_fifo_in_last, top_tx_packet_fifo_payload_fifo_fifo_in_first, top_tx_packet_fifo_payload_fifo_fifo_in_payload_error, top_tx_packet_fifo_payload_fifo_fifo_in_payload_be, top_tx_packet_fifo_payload_fifo_fifo_in_payload_data};
assign {top_tx_packet_fifo_payload_fifo_fifo_out_last, top_tx_packet_fifo_payload_fifo_fifo_out_first, top_tx_packet_fifo_payload_fifo_fifo_out_payload_error, top_tx_packet_fifo_payload_fifo_fifo_out_payload_be, top_tx_packet_fifo_payload_fifo_fifo_out_payload_data} = top_tx_packet_fifo_payload_fifo_syncfifo_dout;
assign top_tx_packet_fifo_payload_fifo_sink_ready = top_tx_packet_fifo_payload_fifo_syncfifo_writable;
assign top_tx_packet_fifo_payload_fifo_syncfifo_we = top_tx_packet_fifo_payload_fifo_sink_valid;
assign top_tx_packet_fifo_payload_fifo_fifo_in_first = top_tx_packet_fifo_payload_fifo_sink_first;
assign top_tx_packet_fifo_payload_fifo_fifo_in_last = top_tx_packet_fifo_payload_fifo_sink_last;
assign top_tx_packet_fifo_payload_fifo_fifo_in_payload_data = top_tx_packet_fifo_payload_fifo_sink_payload_data;
assign top_tx_packet_fifo_payload_fifo_fifo_in_payload_be = top_tx_packet_fifo_payload_fifo_sink_payload_be;
assign top_tx_packet_fifo_payload_fifo_fifo_in_payload_error = top_tx_packet_fifo_payload_fifo_sink_payload_error;
assign top_tx_packet_fifo_payload_fifo_source_valid = top_tx_packet_fifo_payload_fifo_readable;
assign top_tx_packet_fifo_payload_fifo_source_first = top_tx_packet_fifo_payload_fifo_fifo_out_first;
assign top_tx_packet_fifo_payload_fifo_source_last = top_tx_packet_fifo_payload_fifo_fifo_out_last;
assign top_tx_packet_fifo_payload_fifo_source_payload_data = top_tx_packet_fifo_payload_fifo_fifo_out_payload_data;
assign top_tx_packet_fifo_payload_fifo_source_payload_be = top_tx_packet_fifo_payload_fifo_fifo_out_payload_be;
assign top_tx_packet_fifo_payload_fifo_source_payload_error = top_tx_packet_fifo_payload_fifo_fifo_out_payload_error;
assign top_tx_packet_fifo_payload_fifo_re = top_tx_packet_fifo_payload_fifo_source_ready;
assign top_tx_packet_fifo_payload_fifo_syncfifo_re = (top_tx_packet_fifo_payload_fifo_syncfifo_readable & ((~top_tx_packet_fifo_payload_fifo_readable) | top_tx_packet_fifo_payload_fifo_re));
assign top_tx_packet_fifo_payload_fifo_level1 = (top_tx_packet_fifo_payload_fifo_level0 + top_tx_packet_fifo_payload_fifo_readable);

// synthesis translate_off
reg dummy_d_18;
// synthesis translate_on
always @(*) begin
	top_tx_packet_fifo_payload_fifo_wrport_adr <= 11'd0;
	if (top_tx_packet_fifo_payload_fifo_replace) begin
		top_tx_packet_fifo_payload_fifo_wrport_adr <= (top_tx_packet_fifo_payload_fifo_produce - 1'd1);
	end else begin
		top_tx_packet_fifo_payload_fifo_wrport_adr <= top_tx_packet_fifo_payload_fifo_produce;
	end
// synthesis translate_off
	dummy_d_18 <= dummy_s;
// synthesis translate_on
end
assign top_tx_packet_fifo_payload_fifo_wrport_dat_w = top_tx_packet_fifo_payload_fifo_syncfifo_din;
assign top_tx_packet_fifo_payload_fifo_wrport_we = (top_tx_packet_fifo_payload_fifo_syncfifo_we & (top_tx_packet_fifo_payload_fifo_syncfifo_writable | top_tx_packet_fifo_payload_fifo_replace));
assign top_tx_packet_fifo_payload_fifo_do_read = (top_tx_packet_fifo_payload_fifo_syncfifo_readable & top_tx_packet_fifo_payload_fifo_syncfifo_re);
assign top_tx_packet_fifo_payload_fifo_rdport_adr = top_tx_packet_fifo_payload_fifo_consume;
assign top_tx_packet_fifo_payload_fifo_syncfifo_dout = top_tx_packet_fifo_payload_fifo_rdport_dat_r;
assign top_tx_packet_fifo_payload_fifo_rdport_re = top_tx_packet_fifo_payload_fifo_do_read;
assign top_tx_packet_fifo_payload_fifo_syncfifo_writable = (top_tx_packet_fifo_payload_fifo_level0 != 12'd2048);
assign top_tx_packet_fifo_payload_fifo_syncfifo_readable = (top_tx_packet_fifo_payload_fifo_level0 != 1'd0);
assign top_tx_packet_fifo_param_fifo_syncfifo_din = {top_tx_packet_fifo_param_fifo_fifo_in_last, top_tx_packet_fifo_param_fifo_fifo_in_first, top_tx_packet_fifo_param_fifo_fifo_in_param_dummy};
assign {top_tx_packet_fifo_param_fifo_fifo_out_last, top_tx_packet_fifo_param_fifo_fifo_out_first, top_tx_packet_fifo_param_fifo_fifo_out_param_dummy} = top_tx_packet_fifo_param_fifo_syncfifo_dout;
assign top_tx_packet_fifo_param_fifo_sink_ready = top_tx_packet_fifo_param_fifo_syncfifo_writable;
assign top_tx_packet_fifo_param_fifo_syncfifo_we = top_tx_packet_fifo_param_fifo_sink_valid;
assign top_tx_packet_fifo_param_fifo_fifo_in_first = top_tx_packet_fifo_param_fifo_sink_first;
assign top_tx_packet_fifo_param_fifo_fifo_in_last = top_tx_packet_fifo_param_fifo_sink_last;
assign top_tx_packet_fifo_param_fifo_fifo_in_param_dummy = top_tx_packet_fifo_param_fifo_sink_param_dummy;
assign top_tx_packet_fifo_param_fifo_source_valid = top_tx_packet_fifo_param_fifo_readable;
assign top_tx_packet_fifo_param_fifo_source_first = top_tx_packet_fifo_param_fifo_fifo_out_first;
assign top_tx_packet_fifo_param_fifo_source_last = top_tx_packet_fifo_param_fifo_fifo_out_last;
assign top_tx_packet_fifo_param_fifo_source_param_dummy = top_tx_packet_fifo_param_fifo_fifo_out_param_dummy;
assign top_tx_packet_fifo_param_fifo_re = top_tx_packet_fifo_param_fifo_source_ready;
assign top_tx_packet_fifo_param_fifo_syncfifo_re = (top_tx_packet_fifo_param_fifo_syncfifo_readable & ((~top_tx_packet_fifo_param_fifo_readable) | top_tx_packet_fifo_param_fifo_re));
assign top_tx_packet_fifo_param_fifo_level1 = (top_tx_packet_fifo_param_fifo_level0 + top_tx_packet_fifo_param_fifo_readable);

// synthesis translate_off
reg dummy_d_19;
// synthesis translate_on
always @(*) begin
	top_tx_packet_fifo_param_fifo_wrport_adr <= 3'd0;
	if (top_tx_packet_fifo_param_fifo_replace) begin
		top_tx_packet_fifo_param_fifo_wrport_adr <= (top_tx_packet_fifo_param_fifo_produce - 1'd1);
	end else begin
		top_tx_packet_fifo_param_fifo_wrport_adr <= top_tx_packet_fifo_param_fifo_produce;
	end
// synthesis translate_off
	dummy_d_19 <= dummy_s;
// synthesis translate_on
end
assign top_tx_packet_fifo_param_fifo_wrport_dat_w = top_tx_packet_fifo_param_fifo_syncfifo_din;
assign top_tx_packet_fifo_param_fifo_wrport_we = (top_tx_packet_fifo_param_fifo_syncfifo_we & (top_tx_packet_fifo_param_fifo_syncfifo_writable | top_tx_packet_fifo_param_fifo_replace));
assign top_tx_packet_fifo_param_fifo_do_read = (top_tx_packet_fifo_param_fifo_syncfifo_readable & top_tx_packet_fifo_param_fifo_syncfifo_re);
assign top_tx_packet_fifo_param_fifo_rdport_adr = top_tx_packet_fifo_param_fifo_consume;
assign top_tx_packet_fifo_param_fifo_syncfifo_dout = top_tx_packet_fifo_param_fifo_rdport_dat_r;
assign top_tx_packet_fifo_param_fifo_rdport_re = top_tx_packet_fifo_param_fifo_do_read;
assign top_tx_packet_fifo_param_fifo_syncfifo_writable = (top_tx_packet_fifo_param_fifo_level0 != 3'd5);
assign top_tx_packet_fifo_param_fifo_syncfifo_readable = (top_tx_packet_fifo_param_fifo_level0 != 1'd0);

// synthesis translate_off
reg dummy_d_20;
// synthesis translate_on
always @(*) begin
	top_tx_gap_sink_ready <= 1'd0;
	top_tx_gap_source_valid <= 1'd0;
	top_tx_gap_source_first <= 1'd0;
	top_tx_gap_source_last <= 1'd0;
	top_tx_gap_source_payload_data <= 8'd0;
	top_tx_gap_source_payload_be <= 1'd0;
	top_tx_gap_source_payload_error <= 1'd0;
	txdatapath_liteethmacgap_next_state <= 1'd0;
	top_tx_gap_counter_clockdomainsrenamer_clockdomainsrenamer3_next_value <= 4'd0;
	top_tx_gap_counter_clockdomainsrenamer_clockdomainsrenamer3_next_value_ce <= 1'd0;
	txdatapath_liteethmacgap_next_state <= txdatapath_liteethmacgap_state;
	case (txdatapath_liteethmacgap_state)
		1'd1: begin
			top_tx_gap_counter_clockdomainsrenamer_clockdomainsrenamer3_next_value <= (top_tx_gap_counter - 1'd1);
			top_tx_gap_counter_clockdomainsrenamer_clockdomainsrenamer3_next_value_ce <= 1'd1;
			if ((top_tx_gap_counter == 1'd1)) begin
				txdatapath_liteethmacgap_next_state <= 1'd0;
			end
		end
		default: begin
			top_tx_gap_source_valid <= top_tx_gap_sink_valid;
			top_tx_gap_sink_ready <= top_tx_gap_source_ready;
			top_tx_gap_source_first <= top_tx_gap_sink_first;
			top_tx_gap_source_last <= top_tx_gap_sink_last;
			top_tx_gap_source_payload_data <= top_tx_gap_sink_payload_data;
			top_tx_gap_source_payload_be <= top_tx_gap_sink_payload_be;
			top_tx_gap_source_payload_error <= top_tx_gap_sink_payload_error;
			if (((top_tx_gap_sink_valid & top_tx_gap_sink_last) & top_tx_gap_sink_ready)) begin
				top_tx_gap_counter_clockdomainsrenamer_clockdomainsrenamer3_next_value <= 4'd12;
				top_tx_gap_counter_clockdomainsrenamer_clockdomainsrenamer3_next_value_ce <= 1'd1;
				txdatapath_liteethmacgap_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_20 <= dummy_s;
// synthesis translate_on
end
assign top_tx_padding_sink_valid = top_sink_valid;
assign top_sink_ready = top_tx_padding_sink_ready;
assign top_tx_padding_sink_first = top_sink_first;
assign top_tx_padding_sink_last = top_sink_last;
assign top_tx_padding_sink_payload_data = top_sink_payload_data;
assign top_tx_padding_sink_payload_be = top_sink_payload_be;
assign top_tx_padding_sink_payload_error = top_sink_payload_error;
assign top_tx_crc_sink_sink_valid = top_tx_padding_source_valid;
assign top_tx_padding_source_ready = top_tx_crc_sink_sink_ready;
assign top_tx_crc_sink_sink_first = top_tx_padding_source_first;
assign top_tx_crc_sink_sink_last = top_tx_padding_source_last;
assign top_tx_crc_sink_sink_payload_data = top_tx_padding_source_payload_data;
assign top_tx_crc_sink_sink_payload_be = top_tx_padding_source_payload_be;
assign top_tx_crc_sink_sink_payload_error = top_tx_padding_source_payload_error;
assign top_tx_preamble_sink_valid = top_tx_crc_source_valid;
assign top_tx_crc_source_ready = top_tx_preamble_sink_ready;
assign top_tx_preamble_sink_first = top_tx_crc_source_first;
assign top_tx_preamble_sink_last = top_tx_crc_source_last;
assign top_tx_preamble_sink_payload_data = top_tx_crc_source_payload_data;
assign top_tx_preamble_sink_payload_be = top_tx_crc_source_payload_be;
assign top_tx_preamble_sink_payload_error = top_tx_crc_source_payload_error;
assign top_txdatapath_sink_sink_valid = top_tx_preamble_source_valid;
assign top_tx_preamble_source_ready = top_txdatapath_sink_sink_ready;
assign top_txdatapath_sink_sink_first = top_tx_preamble_source_first;
assign top_txdatapath_sink_sink_last = top_tx_preamble_source_last;
assign top_txdatapath_sink_sink_payload_data = top_tx_preamble_source_payload_data;
assign top_txdatapath_sink_sink_payload_be = top_tx_preamble_source_payload_be;
assign top_txdatapath_sink_sink_payload_error = top_tx_preamble_source_payload_error;
assign top_tx_packet_fifo_sink_sink_valid = top_txdatapath_source_source_valid;
assign top_txdatapath_source_source_ready = top_tx_packet_fifo_sink_sink_ready;
assign top_tx_packet_fifo_sink_sink_first = top_txdatapath_source_source_first;
assign top_tx_packet_fifo_sink_sink_last = top_txdatapath_source_source_last;
assign top_tx_packet_fifo_sink_sink_payload_data = top_txdatapath_source_source_payload_data;
assign top_tx_packet_fifo_sink_sink_payload_be = top_txdatapath_source_source_payload_be;
assign top_tx_packet_fifo_sink_sink_payload_error = top_txdatapath_source_source_payload_error;
assign top_tx_gap_sink_valid = top_tx_packet_fifo_source_source_valid;
assign top_tx_packet_fifo_source_source_ready = top_tx_gap_sink_ready;
assign top_tx_gap_sink_first = top_tx_packet_fifo_source_source_first;
assign top_tx_gap_sink_last = top_tx_packet_fifo_source_source_last;
assign top_tx_gap_sink_payload_data = top_tx_packet_fifo_source_source_payload_data;
assign top_tx_gap_sink_payload_be = top_tx_packet_fifo_source_source_payload_be;
assign top_tx_gap_sink_payload_error = top_tx_packet_fifo_source_source_payload_error;
assign top_sink_sink_valid = top_tx_gap_source_valid;
assign top_tx_gap_source_ready = top_sink_sink_ready;
assign top_sink_sink_first = top_tx_gap_source_first;
assign top_sink_sink_last = top_tx_gap_source_last;
assign top_sink_sink_payload_data = top_tx_gap_source_payload_data;
assign top_sink_sink_payload_be = top_tx_gap_source_payload_be;
assign top_sink_sink_payload_error = top_tx_gap_source_payload_error;
assign top_i = top_rx_packet_fifo_drop;
assign top_pulsesynchronizer0_i = top_rx_preamble_error;
assign top_pulsesynchronizer1_i = top_liteethmaccrc32checker_error;
assign top_rx_packet_fifo_used = (top_rx_packet_fifo_wr_ptr - (top_rx_packet_fifo_rd_ptr - top_rx_packet_fifo_out_valid));
assign top_rx_packet_fifo_full = (top_rx_packet_fifo_used == 12'd2048);
assign top_rx_packet_fifo_sink_sink_ready = 1'd1;
assign top_rx_packet_fifo_wr_port_adr = top_rx_packet_fifo_wr_ptr[10:0];
assign top_rx_packet_fifo_wr_port_dat_w = {top_rx_packet_fifo_sink_sink_last, top_rx_packet_fifo_sink_sink_first, {top_rx_packet_fifo_sink_sink_payload_error, top_rx_packet_fifo_sink_sink_payload_be, top_rx_packet_fifo_sink_sink_payload_data}};
assign top_rx_packet_fifo_wr_port_we = ((top_rx_packet_fifo_sink_sink_valid & (~top_rx_packet_fifo_overflow)) & (~top_rx_packet_fifo_full));
assign top_rx_packet_fifo_commit = ((((((top_rx_packet_fifo_sink_sink_valid & top_rx_packet_fifo_sink_sink_last) & (~top_rx_packet_fifo_overflow)) & (~top_rx_packet_fifo_full)) & (~top_rx_packet_fifo_invalid)) & (~top_rx_packet_fifo_discard)) & top_rx_packet_fifo_param_fifo_sink_ready);
assign top_rx_packet_fifo_param_fifo_sink_valid = top_rx_packet_fifo_commit;
assign top_rx_packet_fifo_param_fifo_sink_last = 1'd1;
assign top_rx_packet_fifo_drop = ((top_rx_packet_fifo_sink_sink_valid & top_rx_packet_fifo_sink_sink_last) & (~top_rx_packet_fifo_commit));
assign top_rx_packet_fifo_fetch = ((top_rx_packet_fifo_rd_ptr != top_rx_packet_fifo_commit_ptr) & ((~top_rx_packet_fifo_out_valid) | (top_rx_packet_fifo_source_source_valid & top_rx_packet_fifo_source_source_ready)));
assign top_rx_packet_fifo_rd_port_adr = top_rx_packet_fifo_rd_ptr[10:0];
assign top_rx_packet_fifo_rd_port_re = top_rx_packet_fifo_fetch;
assign {top_rx_packet_fifo_source_source_payload_error, top_rx_packet_fifo_source_source_payload_be, top_rx_packet_fifo_source_source_payload_data} = top_rx_packet_fifo_rd_port_dat_r[9:0];
assign top_rx_packet_fifo_source_source_first = top_rx_packet_fifo_rd_port_dat_r[10];
assign top_rx_packet_fifo_source_source_last = top_rx_packet_fifo_rd_port_dat_r[11];
assign top_rx_packet_fifo_source_source_valid = (top_rx_packet_fifo_out_valid & top_rx_packet_fifo_param_fifo_source_valid);
assign top_rx_packet_fifo_param_fifo_source_ready = ((top_rx_packet_fifo_source_source_valid & top_rx_packet_fifo_source_source_last) & top_rx_packet_fifo_source_source_ready);
assign top_rx_packet_fifo_param_fifo_syncfifo_din = {top_rx_packet_fifo_param_fifo_fifo_in_last, top_rx_packet_fifo_param_fifo_fifo_in_first, top_rx_packet_fifo_param_fifo_fifo_in_param_dummy};
assign {top_rx_packet_fifo_param_fifo_fifo_out_last, top_rx_packet_fifo_param_fifo_fifo_out_first, top_rx_packet_fifo_param_fifo_fifo_out_param_dummy} = top_rx_packet_fifo_param_fifo_syncfifo_dout;
assign top_rx_packet_fifo_param_fifo_sink_ready = top_rx_packet_fifo_param_fifo_syncfifo_writable;
assign top_rx_packet_fifo_param_fifo_syncfifo_we = top_rx_packet_fifo_param_fifo_sink_valid;
assign top_rx_packet_fifo_param_fifo_fifo_in_first = top_rx_packet_fifo_param_fifo_sink_first;
assign top_rx_packet_fifo_param_fifo_fifo_in_last = top_rx_packet_fifo_param_fifo_sink_last;
assign top_rx_packet_fifo_param_fifo_fifo_in_param_dummy = top_rx_packet_fifo_param_fifo_sink_param_dummy;
assign top_rx_packet_fifo_param_fifo_source_valid = top_rx_packet_fifo_param_fifo_syncfifo_readable;
assign top_rx_packet_fifo_param_fifo_source_first = top_rx_packet_fifo_param_fifo_fifo_out_first;
assign top_rx_packet_fifo_param_fifo_source_last = top_rx_packet_fifo_param_fifo_fifo_out_last;
assign top_rx_packet_fifo_param_fifo_source_param_dummy = top_rx_packet_fifo_param_fifo_fifo_out_param_dummy;
assign top_rx_packet_fifo_param_fifo_syncfifo_re = top_rx_packet_fifo_param_fifo_source_ready;

// synthesis translate_off
reg dummy_d_21;
// synthesis translate_on
always @(*) begin
	top_rx_packet_fifo_param_fifo_wrport_adr <= 2'd0;
	if (top_rx_packet_fifo_param_fifo_replace) begin
		top_rx_packet_fifo_param_fifo_wrport_adr <= (top_rx_packet_fifo_param_fifo_produce - 1'd1);
	end else begin
		top_rx_packet_fifo_param_fifo_wrport_adr <= top_rx_packet_fifo_param_fifo_produce;
	end
// synthesis translate_off
	dummy_d_21 <= dummy_s;
// synthesis translate_on
end
assign top_rx_packet_fifo_param_fifo_wrport_dat_w = top_rx_packet_fifo_param_fifo_syncfifo_din;
assign top_rx_packet_fifo_param_fifo_wrport_we = (top_rx_packet_fifo_param_fifo_syncfifo_we & (top_rx_packet_fifo_param_fifo_syncfifo_writable | top_rx_packet_fifo_param_fifo_replace));
assign top_rx_packet_fifo_param_fifo_do_read = (top_rx_packet_fifo_param_fifo_syncfifo_readable & top_rx_packet_fifo_param_fifo_syncfifo_re);
assign top_rx_packet_fifo_param_fifo_rdport_adr = top_rx_packet_fifo_param_fifo_consume;
assign top_rx_packet_fifo_param_fifo_syncfifo_dout = top_rx_packet_fifo_param_fifo_rdport_dat_r;
assign top_rx_packet_fifo_param_fifo_syncfifo_writable = (top_rx_packet_fifo_param_fifo_level != 3'd4);
assign top_rx_packet_fifo_param_fifo_syncfifo_readable = (top_rx_packet_fifo_param_fifo_level != 1'd0);
assign top_o = (top_toggle_o ^ top_toggle_o_r);
assign top_rx_cdc_cdc_sink_valid = top_rx_cdc_sink_sink_valid;
assign top_rx_cdc_sink_sink_ready = top_rx_cdc_cdc_sink_ready;
assign top_rx_cdc_cdc_sink_first = top_rx_cdc_sink_sink_first;
assign top_rx_cdc_cdc_sink_last = top_rx_cdc_sink_sink_last;
assign top_rx_cdc_cdc_sink_payload_data = top_rx_cdc_sink_sink_payload_data;
assign top_rx_cdc_cdc_sink_payload_be = top_rx_cdc_sink_sink_payload_be;
assign top_rx_cdc_cdc_sink_payload_error = top_rx_cdc_sink_sink_payload_error;
assign top_rx_cdc_source_source_valid = top_rx_cdc_cdc_source_valid;
assign top_rx_cdc_cdc_source_ready = top_rx_cdc_source_source_ready;
assign top_rx_cdc_source_source_first = top_rx_cdc_cdc_source_first;
assign top_rx_cdc_source_source_last = top_rx_cdc_cdc_source_last;
assign top_rx_cdc_source_source_payload_data = top_rx_cdc_cdc_source_payload_data;
assign top_rx_cdc_source_source_payload_be = top_rx_cdc_cdc_source_payload_be;
assign top_rx_cdc_source_source_payload_error = top_rx_cdc_cdc_source_payload_error;
assign top_rx_cdc_cdc_asyncfifo_din = {top_rx_cdc_cdc_fifo_in_last, top_rx_cdc_cdc_fifo_in_first, top_rx_cdc_cdc_fifo_in_payload_error, top_rx_cdc_cdc_fifo_in_payload_be, top_rx_cdc_cdc_fifo_in_payload_data};
assign {top_rx_cdc_cdc_fifo_out_last, top_rx_cdc_cdc_fifo_out_first, top_rx_cdc_cdc_fifo_out_payload_error, top_rx_cdc_cdc_fifo_out_payload_be, top_rx_cdc_cdc_fifo_out_payload_data} = top_rx_cdc_cdc_asyncfifo_dout;
assign top_rx_cdc_cdc_sink_ready = top_rx_cdc_cdc_asyncfifo_writable;
assign top_rx_cdc_cdc_asyncfifo_we = top_rx_cdc_cdc_sink_valid;
assign top_rx_cdc_cdc_fifo_in_first = top_rx_cdc_cdc_sink_first;
assign top_rx_cdc_cdc_fifo_in_last = top_rx_cdc_cdc_sink_last;
assign top_rx_cdc_cdc_fifo_in_payload_data = top_rx_cdc_cdc_sink_payload_data;
assign top_rx_cdc_cdc_fifo_in_payload_be = top_rx_cdc_cdc_sink_payload_be;
assign top_rx_cdc_cdc_fifo_in_payload_error = top_rx_cdc_cdc_sink_payload_error;
assign top_rx_cdc_cdc_source_valid = top_rx_cdc_cdc_asyncfifo_readable;
assign top_rx_cdc_cdc_source_first = top_rx_cdc_cdc_fifo_out_first;
assign top_rx_cdc_cdc_source_last = top_rx_cdc_cdc_fifo_out_last;
assign top_rx_cdc_cdc_source_payload_data = top_rx_cdc_cdc_fifo_out_payload_data;
assign top_rx_cdc_cdc_source_payload_be = top_rx_cdc_cdc_fifo_out_payload_be;
assign top_rx_cdc_cdc_source_payload_error = top_rx_cdc_cdc_fifo_out_payload_error;
assign top_rx_cdc_cdc_asyncfifo_re = top_rx_cdc_cdc_source_ready;
assign top_rx_cdc_cdc_graycounter0_ce = (top_rx_cdc_cdc_asyncfifo_writable & top_rx_cdc_cdc_asyncfifo_we);
assign top_rx_cdc_cdc_graycounter1_ce = (top_rx_cdc_cdc_asyncfifo_readable & top_rx_cdc_cdc_asyncfifo_re);
assign top_rx_cdc_cdc_asyncfifo_writable = (((top_rx_cdc_cdc_graycounter0_q[5] == top_rx_cdc_cdc_consume_wdomain[5]) | (top_rx_cdc_cdc_graycounter0_q[4] == top_rx_cdc_cdc_consume_wdomain[4])) | (top_rx_cdc_cdc_graycounter0_q[3:0] != top_rx_cdc_cdc_consume_wdomain[3:0]));
assign top_rx_cdc_cdc_asyncfifo_readable = (top_rx_cdc_cdc_graycounter1_q != top_rx_cdc_cdc_produce_rdomain);
assign top_rx_cdc_cdc_wrport_adr = top_rx_cdc_cdc_graycounter0_q_binary[4:0];
assign top_rx_cdc_cdc_wrport_dat_w = top_rx_cdc_cdc_asyncfifo_din;
assign top_rx_cdc_cdc_wrport_we = top_rx_cdc_cdc_graycounter0_ce;
assign top_rx_cdc_cdc_rdport_adr = top_rx_cdc_cdc_graycounter1_q_next_binary[4:0];
assign top_rx_cdc_cdc_asyncfifo_dout = top_rx_cdc_cdc_rdport_dat_r;

// synthesis translate_off
reg dummy_d_22;
// synthesis translate_on
always @(*) begin
	top_rx_cdc_cdc_graycounter0_q_next_binary <= 6'd0;
	if (top_rx_cdc_cdc_graycounter0_ce) begin
		top_rx_cdc_cdc_graycounter0_q_next_binary <= (top_rx_cdc_cdc_graycounter0_q_binary + 1'd1);
	end else begin
		top_rx_cdc_cdc_graycounter0_q_next_binary <= top_rx_cdc_cdc_graycounter0_q_binary;
	end
// synthesis translate_off
	dummy_d_22 <= dummy_s;
// synthesis translate_on
end
assign top_rx_cdc_cdc_graycounter0_q_next = (top_rx_cdc_cdc_graycounter0_q_next_binary ^ top_rx_cdc_cdc_graycounter0_q_next_binary[5:1]);

// synthesis translate_off
reg dummy_d_23;
// synthesis translate_on
always @(*) begin
	top_rx_cdc_cdc_graycounter1_q_next_binary <= 6'd0;
	if (top_rx_cdc_cdc_graycounter1_ce) begin
		top_rx_cdc_cdc_graycounter1_q_next_binary <= (top_rx_cdc_cdc_graycounter1_q_binary + 1'd1);
	end else begin
		top_rx_cdc_cdc_graycounter1_q_next_binary <= top_rx_cdc_cdc_graycounter1_q_binary;
	end
// synthesis translate_off
	dummy_d_23 <= dummy_s;
// synthesis translate_on
end
assign top_rx_cdc_cdc_graycounter1_q_next = (top_rx_cdc_cdc_graycounter1_q_next_binary ^ top_rx_cdc_cdc_graycounter1_q_next_binary[5:1]);
assign top_rx_preamble_source_payload_data = top_rx_preamble_sink_payload_data;
assign top_rx_preamble_source_payload_be = top_rx_preamble_sink_payload_be;

// synthesis translate_off
reg dummy_d_24;
// synthesis translate_on
always @(*) begin
	top_rx_preamble_sink_ready <= 1'd0;
	top_rx_preamble_source_valid <= 1'd0;
	top_rx_preamble_source_first <= 1'd0;
	top_rx_preamble_source_last <= 1'd0;
	top_rx_preamble_source_payload_error <= 1'd0;
	top_rx_preamble_error <= 1'd0;
	rxdatapath_liteethmacpreamblechecker_next_state <= 1'd0;
	rxdatapath_liteethmacpreamblechecker_next_state <= rxdatapath_liteethmacpreamblechecker_state;
	case (rxdatapath_liteethmacpreamblechecker_state)
		1'd1: begin
			top_rx_preamble_source_valid <= top_rx_preamble_sink_valid;
			top_rx_preamble_sink_ready <= top_rx_preamble_source_ready;
			top_rx_preamble_source_first <= top_rx_preamble_sink_first;
			top_rx_preamble_source_last <= top_rx_preamble_sink_last;
			top_rx_preamble_source_payload_error <= top_rx_preamble_sink_payload_error;
			if (((top_rx_preamble_source_valid & top_rx_preamble_source_last) & top_rx_preamble_source_ready)) begin
				rxdatapath_liteethmacpreamblechecker_next_state <= 1'd0;
			end
		end
		default: begin
			top_rx_preamble_sink_ready <= 1'd1;
			if (((top_rx_preamble_sink_valid & (~top_rx_preamble_sink_last)) & (top_rx_preamble_sink_payload_data == top_rx_preamble_preamble[63:56]))) begin
				rxdatapath_liteethmacpreamblechecker_next_state <= 1'd1;
			end
			if ((top_rx_preamble_sink_valid & top_rx_preamble_sink_last)) begin
				top_rx_preamble_error <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_24 <= dummy_s;
// synthesis translate_on
end
assign top_pulsesynchronizer0_o = (top_pulsesynchronizer0_toggle_o ^ top_pulsesynchronizer0_toggle_o_r);
assign top_liteethmaccrc32checker_fifo_full = (top_liteethmaccrc32checker_syncfifo_level == 3'd4);
assign top_liteethmaccrc32checker_fifo_out = (top_liteethmaccrc32checker_source_source_valid & top_liteethmaccrc32checker_source_source_ready);
assign top_liteethmaccrc32checker_syncfifo_sink_first = top_liteethmaccrc32checker_sink_sink_first;
assign top_liteethmaccrc32checker_syncfifo_sink_last = top_liteethmaccrc32checker_sink_sink_last;
assign top_liteethmaccrc32checker_syncfifo_sink_payload_data = top_liteethmaccrc32checker_sink_sink_payload_data;
assign top_liteethmaccrc32checker_syncfifo_sink_payload_be = top_liteethmaccrc32checker_sink_sink_payload_be;
assign top_liteethmaccrc32checker_syncfifo_sink_payload_error = top_liteethmaccrc32checker_sink_sink_payload_error;

// synthesis translate_off
reg dummy_d_25;
// synthesis translate_on
always @(*) begin
	top_liteethmaccrc32checker_syncfifo_sink_valid <= 1'd0;
	top_liteethmaccrc32checker_syncfifo_sink_valid <= top_liteethmaccrc32checker_sink_sink_valid;
	top_liteethmaccrc32checker_syncfifo_sink_valid <= top_liteethmaccrc32checker_fifo_in;
// synthesis translate_off
	dummy_d_25 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_26;
// synthesis translate_on
always @(*) begin
	top_liteethmaccrc32checker_sink_sink_ready <= 1'd0;
	top_liteethmaccrc32checker_sink_sink_ready <= top_liteethmaccrc32checker_syncfifo_sink_ready;
	top_liteethmaccrc32checker_sink_sink_ready <= top_liteethmaccrc32checker_fifo_in;
// synthesis translate_off
	dummy_d_26 <= dummy_s;
// synthesis translate_on
end
assign top_liteethmaccrc32checker_fifo_in = (((top_liteethmaccrc32checker_sink_sink_valid & ((~top_liteethmaccrc32checker_fifo_full) | top_liteethmaccrc32checker_fifo_out)) & (~top_liteethmaccrc32checker_is_ongoing0)) & (~top_liteethmaccrc32checker_is_ongoing1));
assign top_liteethmaccrc32checker_crc_data0 = top_liteethmaccrc32checker_sink_sink_payload_data;
assign top_liteethmaccrc32checker_crc_be = top_liteethmaccrc32checker_sink_sink_payload_be;
assign top_liteethmaccrc32checker_last_word_error = ((top_liteethmaccrc32checker_crc_error | top_liteethmaccrc32checker_packet_error) | ((top_liteethmaccrc32checker_sink_sink_payload_error & top_liteethmaccrc32checker_sink_sink_payload_be) != 1'd0));
assign top_liteethmaccrc32checker_source_source_first = top_liteethmaccrc32checker_syncfifo_source_first;
assign top_liteethmaccrc32checker_source_source_payload_data = top_liteethmaccrc32checker_syncfifo_source_payload_data;
assign top_liteethmaccrc32checker_sink_sink_valid = top_bufferizeendpoints_source_source_valid;
assign top_bufferizeendpoints_source_source_ready = top_liteethmaccrc32checker_sink_sink_ready;
assign top_liteethmaccrc32checker_sink_sink_first = top_bufferizeendpoints_source_source_first;
assign top_liteethmaccrc32checker_sink_sink_last = top_bufferizeendpoints_source_source_last;
assign top_liteethmaccrc32checker_sink_sink_payload_data = top_bufferizeendpoints_source_source_payload_data;
assign top_liteethmaccrc32checker_sink_sink_payload_be = top_bufferizeendpoints_source_source_payload_be;
assign top_liteethmaccrc32checker_sink_sink_payload_error = top_bufferizeendpoints_source_source_payload_error;
assign top_liteethmaccrc32checker_crc_crc_prev = top_liteethmaccrc32checker_crc_reg;

// synthesis translate_off
reg dummy_d_27;
// synthesis translate_on
always @(*) begin
	top_liteethmaccrc32checker_crc_error <= 1'd0;
	top_liteethmaccrc32checker_crc_data1 <= 8'd0;
	top_liteethmaccrc32checker_crc_data1 <= top_liteethmaccrc32checker_crc_data0;
	if (top_liteethmaccrc32checker_crc_be) begin
		top_liteethmaccrc32checker_crc_data1 <= (top_liteethmaccrc32checker_crc_data0 & 8'd255);
		top_liteethmaccrc32checker_crc_error <= (top_liteethmaccrc32checker_crc_crc_next != 32'd3338984827);
	end
// synthesis translate_off
	dummy_d_27 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_28;
// synthesis translate_on
always @(*) begin
	top_liteethmaccrc32checker_crc_crc_next <= 32'd0;
	top_liteethmaccrc32checker_crc_crc_next[0] <= (((top_liteethmaccrc32checker_crc_crc_prev[24] ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[1] <= (((((((top_liteethmaccrc32checker_crc_crc_prev[25] ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_data1[6]) ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[2] <= (((((((((top_liteethmaccrc32checker_crc_crc_prev[26] ^ top_liteethmaccrc32checker_crc_data1[5]) ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_data1[6]) ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[3] <= (((((((top_liteethmaccrc32checker_crc_crc_prev[27] ^ top_liteethmaccrc32checker_crc_data1[4]) ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]) ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_data1[6]);
	top_liteethmaccrc32checker_crc_crc_next[4] <= (((((((((top_liteethmaccrc32checker_crc_crc_prev[28] ^ top_liteethmaccrc32checker_crc_data1[3]) ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]) ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]) ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[5] <= (((((((((((((top_liteethmaccrc32checker_crc_crc_prev[29] ^ top_liteethmaccrc32checker_crc_data1[2]) ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]) ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]) ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_data1[6]) ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[6] <= (((((((((((top_liteethmaccrc32checker_crc_crc_prev[30] ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]) ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]) ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]) ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_data1[6]);
	top_liteethmaccrc32checker_crc_crc_next[7] <= (((((((((top_liteethmaccrc32checker_crc_crc_prev[31] ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]) ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]) ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]) ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[8] <= ((((((((top_liteethmaccrc32checker_crc_crc_prev[0] ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]) ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]) ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_data1[6]) ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[9] <= ((((((((top_liteethmaccrc32checker_crc_crc_prev[1] ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]) ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]) ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]) ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_data1[6]);
	top_liteethmaccrc32checker_crc_crc_next[10] <= ((((((((top_liteethmaccrc32checker_crc_crc_prev[2] ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]) ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]) ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]) ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[11] <= ((((((((top_liteethmaccrc32checker_crc_crc_prev[3] ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]) ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]) ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_data1[6]) ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[12] <= ((((((((((((top_liteethmaccrc32checker_crc_crc_prev[4] ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]) ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]) ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]) ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_data1[6]) ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[13] <= ((((((((((((top_liteethmaccrc32checker_crc_crc_prev[5] ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]) ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]) ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]) ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_data1[6]);
	top_liteethmaccrc32checker_crc_crc_next[14] <= ((((((((((top_liteethmaccrc32checker_crc_crc_prev[6] ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]) ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]) ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]);
	top_liteethmaccrc32checker_crc_crc_next[15] <= ((((((((top_liteethmaccrc32checker_crc_crc_prev[7] ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]) ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]) ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]);
	top_liteethmaccrc32checker_crc_crc_next[16] <= ((((((top_liteethmaccrc32checker_crc_crc_prev[8] ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]) ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]) ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[17] <= ((((((top_liteethmaccrc32checker_crc_crc_prev[9] ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]) ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_data1[6]);
	top_liteethmaccrc32checker_crc_crc_next[18] <= ((((((top_liteethmaccrc32checker_crc_crc_prev[10] ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]);
	top_liteethmaccrc32checker_crc_crc_next[19] <= ((((top_liteethmaccrc32checker_crc_crc_prev[11] ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]);
	top_liteethmaccrc32checker_crc_crc_next[20] <= ((top_liteethmaccrc32checker_crc_crc_prev[12] ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]);
	top_liteethmaccrc32checker_crc_crc_next[21] <= ((top_liteethmaccrc32checker_crc_crc_prev[13] ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]);
	top_liteethmaccrc32checker_crc_crc_next[22] <= ((top_liteethmaccrc32checker_crc_crc_prev[14] ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[23] <= ((((((top_liteethmaccrc32checker_crc_crc_prev[15] ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_data1[6]) ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[24] <= ((((((top_liteethmaccrc32checker_crc_crc_prev[16] ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]) ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_data1[6]);
	top_liteethmaccrc32checker_crc_crc_next[25] <= ((((top_liteethmaccrc32checker_crc_crc_prev[17] ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]) ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]);
	top_liteethmaccrc32checker_crc_crc_next[26] <= ((((((((top_liteethmaccrc32checker_crc_crc_prev[18] ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]) ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]) ^ top_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_data1[7]);
	top_liteethmaccrc32checker_crc_crc_next[27] <= ((((((((top_liteethmaccrc32checker_crc_crc_prev[19] ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]) ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]) ^ top_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_data1[6]);
	top_liteethmaccrc32checker_crc_crc_next[28] <= ((((((top_liteethmaccrc32checker_crc_crc_prev[20] ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]) ^ top_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_liteethmaccrc32checker_crc_data1[5]);
	top_liteethmaccrc32checker_crc_crc_next[29] <= ((((((top_liteethmaccrc32checker_crc_crc_prev[21] ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_liteethmaccrc32checker_crc_data1[1]) ^ top_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_liteethmaccrc32checker_crc_data1[4]);
	top_liteethmaccrc32checker_crc_crc_next[30] <= ((((top_liteethmaccrc32checker_crc_crc_prev[22] ^ top_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_liteethmaccrc32checker_crc_data1[0]) ^ top_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_liteethmaccrc32checker_crc_data1[3]);
	top_liteethmaccrc32checker_crc_crc_next[31] <= ((top_liteethmaccrc32checker_crc_crc_prev[23] ^ top_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_liteethmaccrc32checker_crc_data1[2]);
// synthesis translate_off
	dummy_d_28 <= dummy_s;
// synthesis translate_on
end
assign top_liteethmaccrc32checker_syncfifo_syncfifo_din = {top_liteethmaccrc32checker_syncfifo_fifo_in_last, top_liteethmaccrc32checker_syncfifo_fifo_in_first, top_liteethmaccrc32checker_syncfifo_fifo_in_payload_error, top_liteethmaccrc32checker_syncfifo_fifo_in_payload_be, top_liteethmaccrc32checker_syncfifo_fifo_in_payload_data};
assign {top_liteethmaccrc32checker_syncfifo_fifo_out_last, top_liteethmaccrc32checker_syncfifo_fifo_out_first, top_liteethmaccrc32checker_syncfifo_fifo_out_payload_error, top_liteethmaccrc32checker_syncfifo_fifo_out_payload_be, top_liteethmaccrc32checker_syncfifo_fifo_out_payload_data} = top_liteethmaccrc32checker_syncfifo_syncfifo_dout;
assign top_liteethmaccrc32checker_syncfifo_sink_ready = top_liteethmaccrc32checker_syncfifo_syncfifo_writable;
assign top_liteethmaccrc32checker_syncfifo_syncfifo_we = top_liteethmaccrc32checker_syncfifo_sink_valid;
assign top_liteethmaccrc32checker_syncfifo_fifo_in_first = top_liteethmaccrc32checker_syncfifo_sink_first;
assign top_liteethmaccrc32checker_syncfifo_fifo_in_last = top_liteethmaccrc32checker_syncfifo_sink_last;
assign top_liteethmaccrc32checker_syncfifo_fifo_in_payload_data = top_liteethmaccrc32checker_syncfifo_sink_payload_data;
assign top_liteethmaccrc32checker_syncfifo_fifo_in_payload_be = top_liteethmaccrc32checker_syncfifo_sink_payload_be;
assign top_liteethmaccrc32checker_syncfifo_fifo_in_payload_error = top_liteethmaccrc32checker_syncfifo_sink_payload_error;
assign top_liteethmaccrc32checker_syncfifo_source_valid = top_liteethmaccrc32checker_syncfifo_syncfifo_readable;
assign top_liteethmaccrc32checker_syncfifo_source_first = top_liteethmaccrc32checker_syncfifo_fifo_out_first;
assign top_liteethmaccrc32checker_syncfifo_source_last = top_liteethmaccrc32checker_syncfifo_fifo_out_last;
assign top_liteethmaccrc32checker_syncfifo_source_payload_data = top_liteethmaccrc32checker_syncfifo_fifo_out_payload_data;
assign top_liteethmaccrc32checker_syncfifo_source_payload_be = top_liteethmaccrc32checker_syncfifo_fifo_out_payload_be;
assign top_liteethmaccrc32checker_syncfifo_source_payload_error = top_liteethmaccrc32checker_syncfifo_fifo_out_payload_error;
assign top_liteethmaccrc32checker_syncfifo_syncfifo_re = top_liteethmaccrc32checker_syncfifo_source_ready;

// synthesis translate_off
reg dummy_d_29;
// synthesis translate_on
always @(*) begin
	top_liteethmaccrc32checker_syncfifo_wrport_adr <= 3'd0;
	if (top_liteethmaccrc32checker_syncfifo_replace) begin
		top_liteethmaccrc32checker_syncfifo_wrport_adr <= (top_liteethmaccrc32checker_syncfifo_produce - 1'd1);
	end else begin
		top_liteethmaccrc32checker_syncfifo_wrport_adr <= top_liteethmaccrc32checker_syncfifo_produce;
	end
// synthesis translate_off
	dummy_d_29 <= dummy_s;
// synthesis translate_on
end
assign top_liteethmaccrc32checker_syncfifo_wrport_dat_w = top_liteethmaccrc32checker_syncfifo_syncfifo_din;
assign top_liteethmaccrc32checker_syncfifo_wrport_we = (top_liteethmaccrc32checker_syncfifo_syncfifo_we & (top_liteethmaccrc32checker_syncfifo_syncfifo_writable | top_liteethmaccrc32checker_syncfifo_replace));
assign top_liteethmaccrc32checker_syncfifo_do_read = (top_liteethmaccrc32checker_syncfifo_syncfifo_readable & top_liteethmaccrc32checker_syncfifo_syncfifo_re);
assign top_liteethmaccrc32checker_syncfifo_rdport_adr = top_liteethmaccrc32checker_syncfifo_consume;
assign top_liteethmaccrc32checker_syncfifo_syncfifo_dout = top_liteethmaccrc32checker_syncfifo_rdport_dat_r;
assign top_liteethmaccrc32checker_syncfifo_syncfifo_writable = (top_liteethmaccrc32checker_syncfifo_level != 3'd5);
assign top_liteethmaccrc32checker_syncfifo_syncfifo_readable = (top_liteethmaccrc32checker_syncfifo_level != 1'd0);

// synthesis translate_off
reg dummy_d_30;
// synthesis translate_on
always @(*) begin
	top_liteethmaccrc32checker_source_source_valid <= 1'd0;
	top_liteethmaccrc32checker_source_source_last <= 1'd0;
	top_liteethmaccrc32checker_source_source_payload_be <= 1'd0;
	top_liteethmaccrc32checker_source_source_payload_error <= 1'd0;
	top_liteethmaccrc32checker_error <= 1'd0;
	top_liteethmaccrc32checker_crc_ce <= 1'd0;
	top_liteethmaccrc32checker_crc_reset <= 1'd0;
	top_liteethmaccrc32checker_syncfifo_source_ready <= 1'd0;
	top_liteethmaccrc32checker_fifo_reset <= 1'd0;
	top_liteethmaccrc32checker_is_ongoing0 <= 1'd0;
	top_liteethmaccrc32checker_is_ongoing1 <= 1'd0;
	top_liteethmaccrc32checker_is_ongoing2 <= 1'd0;
	rxdatapath_bufferizeendpoints_next_state <= 2'd0;
	top_liteethmaccrc32checker_be_clockdomainsrenamer_next_value0 <= 1'd0;
	top_liteethmaccrc32checker_be_clockdomainsrenamer_next_value_ce0 <= 1'd0;
	top_liteethmaccrc32checker_last_error_clockdomainsrenamer_next_value1 <= 1'd0;
	top_liteethmaccrc32checker_last_error_clockdomainsrenamer_next_value_ce1 <= 1'd0;
	top_liteethmaccrc32checker_source_source_payload_error <= top_liteethmaccrc32checker_syncfifo_source_payload_error;
	rxdatapath_bufferizeendpoints_next_state <= rxdatapath_bufferizeendpoints_state;
	case (rxdatapath_bufferizeendpoints_state)
		1'd1: begin
			top_liteethmaccrc32checker_is_ongoing1 <= 1'd1;
			top_liteethmaccrc32checker_source_source_valid <= top_liteethmaccrc32checker_syncfifo_source_valid;
			top_liteethmaccrc32checker_syncfifo_source_ready <= top_liteethmaccrc32checker_source_source_ready;
			top_liteethmaccrc32checker_source_source_last <= top_liteethmaccrc32checker_syncfifo_source_last;
			top_liteethmaccrc32checker_source_source_payload_error <= (top_liteethmaccrc32checker_syncfifo_source_payload_error | {1{top_liteethmaccrc32checker_last_error}});
			top_liteethmaccrc32checker_source_source_payload_be <= top_liteethmaccrc32checker_be;
			if ((top_liteethmaccrc32checker_source_source_valid & top_liteethmaccrc32checker_source_source_ready)) begin
				rxdatapath_bufferizeendpoints_next_state <= 1'd0;
			end
		end
		2'd2: begin
			if ((top_liteethmaccrc32checker_sink_sink_valid & top_liteethmaccrc32checker_sink_sink_ready)) begin
				top_liteethmaccrc32checker_crc_ce <= 1'd1;
				rxdatapath_bufferizeendpoints_next_state <= 2'd3;
			end
		end
		2'd3: begin
			top_liteethmaccrc32checker_syncfifo_source_ready <= top_liteethmaccrc32checker_fifo_out;
			top_liteethmaccrc32checker_source_source_valid <= (top_liteethmaccrc32checker_sink_sink_valid & top_liteethmaccrc32checker_fifo_full);
			top_liteethmaccrc32checker_source_source_payload_be <= 1'd1;
			if (1'd1) begin
				top_liteethmaccrc32checker_source_source_last <= top_liteethmaccrc32checker_sink_sink_last;
				if (top_liteethmaccrc32checker_sink_sink_last) begin
					top_liteethmaccrc32checker_source_source_payload_be <= top_liteethmaccrc32checker_sink_sink_payload_be;
				end
			end else begin
				if ((top_liteethmaccrc32checker_sink_sink_payload_be <= 4'd15)) begin
					top_liteethmaccrc32checker_source_source_last <= top_liteethmaccrc32checker_sink_sink_last;
					top_liteethmaccrc32checker_source_source_payload_be <= ((top_liteethmaccrc32checker_sink_sink_payload_be <<< 3'd4) | 4'd15);
				end else begin
					top_liteethmaccrc32checker_be_clockdomainsrenamer_next_value0 <= (top_liteethmaccrc32checker_sink_sink_payload_be >>> 3'd4);
					top_liteethmaccrc32checker_be_clockdomainsrenamer_next_value_ce0 <= 1'd1;
					top_liteethmaccrc32checker_last_error_clockdomainsrenamer_next_value1 <= top_liteethmaccrc32checker_last_word_error;
					top_liteethmaccrc32checker_last_error_clockdomainsrenamer_next_value_ce1 <= 1'd1;
				end
			end
			top_liteethmaccrc32checker_source_source_payload_error <= (top_liteethmaccrc32checker_sink_sink_last ? {1{top_liteethmaccrc32checker_last_word_error}} : top_liteethmaccrc32checker_syncfifo_source_payload_error);
			top_liteethmaccrc32checker_error <= ((top_liteethmaccrc32checker_sink_sink_valid & top_liteethmaccrc32checker_sink_sink_last) & top_liteethmaccrc32checker_crc_error);
			if ((top_liteethmaccrc32checker_sink_sink_valid & top_liteethmaccrc32checker_sink_sink_ready)) begin
				top_liteethmaccrc32checker_crc_ce <= 1'd1;
				if ((top_liteethmaccrc32checker_sink_sink_last & (top_liteethmaccrc32checker_sink_sink_payload_be > 4'd15))) begin
					rxdatapath_bufferizeendpoints_next_state <= 1'd1;
				end else begin
					if (top_liteethmaccrc32checker_sink_sink_last) begin
						rxdatapath_bufferizeendpoints_next_state <= 1'd0;
					end
				end
			end
		end
		default: begin
			top_liteethmaccrc32checker_is_ongoing0 <= 1'd1;
			top_liteethmaccrc32checker_crc_reset <= 1'd1;
			top_liteethmaccrc32checker_fifo_reset <= 1'd1;
			rxdatapath_bufferizeendpoints_next_state <= 2'd2;
			top_liteethmaccrc32checker_is_ongoing2 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_30 <= dummy_s;
// synthesis translate_on
end
assign top_bufferizeendpoints_pipe_valid_sink_ready = ((~top_bufferizeendpoints_pipe_valid_source_valid) | top_bufferizeendpoints_pipe_valid_source_ready);
assign top_bufferizeendpoints_pipe_valid_sink_valid = top_bufferizeendpoints_sink_sink_valid;
assign top_bufferizeendpoints_sink_sink_ready = top_bufferizeendpoints_pipe_valid_sink_ready;
assign top_bufferizeendpoints_pipe_valid_sink_first = top_bufferizeendpoints_sink_sink_first;
assign top_bufferizeendpoints_pipe_valid_sink_last = top_bufferizeendpoints_sink_sink_last;
assign top_bufferizeendpoints_pipe_valid_sink_payload_data = top_bufferizeendpoints_sink_sink_payload_data;
assign top_bufferizeendpoints_pipe_valid_sink_payload_be = top_bufferizeendpoints_sink_sink_payload_be;
assign top_bufferizeendpoints_pipe_valid_sink_payload_error = top_bufferizeendpoints_sink_sink_payload_error;
assign top_bufferizeendpoints_source_source_valid = top_bufferizeendpoints_pipe_valid_source_valid;
assign top_bufferizeendpoints_pipe_valid_source_ready = top_bufferizeendpoints_source_source_ready;
assign top_bufferizeendpoints_source_source_first = top_bufferizeendpoints_pipe_valid_source_first;
assign top_bufferizeendpoints_source_source_last = top_bufferizeendpoints_pipe_valid_source_last;
assign top_bufferizeendpoints_source_source_payload_data = top_bufferizeendpoints_pipe_valid_source_payload_data;
assign top_bufferizeendpoints_source_source_payload_be = top_bufferizeendpoints_pipe_valid_source_payload_be;
assign top_bufferizeendpoints_source_source_payload_error = top_bufferizeendpoints_pipe_valid_source_payload_error;
assign top_pulsesynchronizer1_o = (top_pulsesynchronizer1_toggle_o ^ top_pulsesynchronizer1_toggle_o_r);
assign top_rx_padding_length_inc = (1'd0 + top_rx_padding_sink_payload_be);
assign top_rx_padding_source_valid = top_rx_padding_sink_valid;
assign top_rx_padding_sink_ready = top_rx_padding_source_ready;
assign top_rx_padding_source_first = top_rx_padding_sink_first;
assign top_rx_padding_source_last = top_rx_padding_sink_last;
assign top_rx_padding_source_payload_data = top_rx_padding_sink_payload_data;
assign top_rx_padding_source_payload_be = top_rx_padding_sink_payload_be;

// synthesis translate_off
reg dummy_d_31;
// synthesis translate_on
always @(*) begin
	top_rx_padding_source_payload_error <= 1'd0;
	if (((top_rx_padding_sink_valid & top_rx_padding_sink_last) & ((top_rx_padding_length + top_rx_padding_length_inc) < 6'd60))) begin
		top_rx_padding_source_payload_error <= {1{1'd1}};
	end else begin
		top_rx_padding_source_payload_error <= top_rx_padding_sink_payload_error;
	end
// synthesis translate_off
	dummy_d_31 <= dummy_s;
// synthesis translate_on
end
assign top_rx_packet_fifo_sink_sink_valid = top_source_source_valid;
assign top_source_source_ready = top_rx_packet_fifo_sink_sink_ready;
assign top_rx_packet_fifo_sink_sink_first = top_source_source_first;
assign top_rx_packet_fifo_sink_sink_last = top_source_source_last;
assign top_rx_packet_fifo_sink_sink_payload_data = top_source_source_payload_data;
assign top_rx_packet_fifo_sink_sink_payload_be = top_source_source_payload_be;
assign top_rx_packet_fifo_sink_sink_payload_error = top_source_source_payload_error;
assign top_rx_cdc_sink_sink_valid = top_rx_packet_fifo_source_source_valid;
assign top_rx_packet_fifo_source_source_ready = top_rx_cdc_sink_sink_ready;
assign top_rx_cdc_sink_sink_first = top_rx_packet_fifo_source_source_first;
assign top_rx_cdc_sink_sink_last = top_rx_packet_fifo_source_source_last;
assign top_rx_cdc_sink_sink_payload_data = top_rx_packet_fifo_source_source_payload_data;
assign top_rx_cdc_sink_sink_payload_be = top_rx_packet_fifo_source_source_payload_be;
assign top_rx_cdc_sink_sink_payload_error = top_rx_packet_fifo_source_source_payload_error;
assign top_rx_preamble_sink_valid = top_rx_cdc_source_source_valid;
assign top_rx_cdc_source_source_ready = top_rx_preamble_sink_ready;
assign top_rx_preamble_sink_first = top_rx_cdc_source_source_first;
assign top_rx_preamble_sink_last = top_rx_cdc_source_source_last;
assign top_rx_preamble_sink_payload_data = top_rx_cdc_source_source_payload_data;
assign top_rx_preamble_sink_payload_be = top_rx_cdc_source_source_payload_be;
assign top_rx_preamble_sink_payload_error = top_rx_cdc_source_source_payload_error;
assign top_bufferizeendpoints_sink_sink_valid = top_rx_preamble_source_valid;
assign top_rx_preamble_source_ready = top_bufferizeendpoints_sink_sink_ready;
assign top_bufferizeendpoints_sink_sink_first = top_rx_preamble_source_first;
assign top_bufferizeendpoints_sink_sink_last = top_rx_preamble_source_last;
assign top_bufferizeendpoints_sink_sink_payload_data = top_rx_preamble_source_payload_data;
assign top_bufferizeendpoints_sink_sink_payload_be = top_rx_preamble_source_payload_be;
assign top_bufferizeendpoints_sink_sink_payload_error = top_rx_preamble_source_payload_error;
assign top_rx_padding_sink_valid = top_liteethmaccrc32checker_source_source_valid;
assign top_liteethmaccrc32checker_source_source_ready = top_rx_padding_sink_ready;
assign top_rx_padding_sink_first = top_liteethmaccrc32checker_source_source_first;
assign top_rx_padding_sink_last = top_liteethmaccrc32checker_source_source_last;
assign top_rx_padding_sink_payload_data = top_liteethmaccrc32checker_source_source_payload_data;
assign top_rx_padding_sink_payload_be = top_liteethmaccrc32checker_source_source_payload_be;
assign top_rx_padding_sink_payload_error = top_liteethmaccrc32checker_source_source_payload_error;
assign top_source_valid = top_rx_padding_source_valid;
assign top_rx_padding_source_ready = top_source_ready;
assign top_source_first = top_rx_padding_source_first;
assign top_source_last = top_rx_padding_source_last;
assign top_source_payload_data = top_rx_padding_source_payload_data;
assign top_source_payload_be = top_rx_padding_source_payload_be;
assign top_source_payload_error = top_rx_padding_source_payload_error;
assign top_capture_arm_cdc_i = top_capture_arm;
assign top_capture_done = top_capture_done_cdc_o;
assign top_capture_done_cdc_i = (top_capture_active & (top_capture_index == 12'd4095));
assign top_capture_wp_memory0_adr = top_capture_index;
assign top_capture_wp_memory0_dat_w = (top_capture_pattern1 ? ((top_capture_index ^ 1'd0) ^ (top_capture_bank1 <<< 4'd15)) : top_capture_sampled0);
assign top_capture_wp_memory0_we = top_capture_active;
assign top_capture_rp_memory0_adr = top_capture_address;
assign top_capture_wp_memory1_adr = top_capture_index;
assign top_capture_wp_memory1_dat_w = (top_capture_pattern1 ? ((top_capture_index ^ 13'd4369) ^ (top_capture_bank1 <<< 4'd15)) : top_capture_sampled1);
assign top_capture_wp_memory1_we = top_capture_active;
assign top_capture_rp_memory1_adr = top_capture_address;
assign top_capture_wp_memory2_adr = top_capture_index;
assign top_capture_wp_memory2_dat_w = (top_capture_pattern1 ? ((top_capture_index ^ 14'd8738) ^ (top_capture_bank1 <<< 4'd15)) : top_capture_sampled2);
assign top_capture_wp_memory2_we = top_capture_active;
assign top_capture_rp_memory2_adr = top_capture_address;
assign top_capture_wp_memory3_adr = top_capture_index;
assign top_capture_wp_memory3_dat_w = (top_capture_pattern1 ? ((top_capture_index ^ 14'd13107) ^ (top_capture_bank1 <<< 4'd15)) : top_capture_sampled3);
assign top_capture_wp_memory3_we = top_capture_active;
assign top_capture_rp_memory3_adr = top_capture_address;
assign top_capture_wp_memory4_adr = top_capture_index;
assign top_capture_wp_memory4_dat_w = (top_capture_pattern1 ? ((top_capture_index ^ 15'd17476) ^ (top_capture_bank1 <<< 4'd15)) : top_capture_sampled4);
assign top_capture_wp_memory4_we = top_capture_active;
assign top_capture_rp_memory4_adr = top_capture_address;
assign top_capture_wp_memory5_adr = top_capture_index;
assign top_capture_wp_memory5_dat_w = (top_capture_pattern1 ? ((top_capture_index ^ 15'd21845) ^ (top_capture_bank1 <<< 4'd15)) : top_capture_sampled5);
assign top_capture_wp_memory5_we = top_capture_active;
assign top_capture_rp_memory5_adr = top_capture_address;
assign top_capture_wp_memory6_adr = top_capture_index;
assign top_capture_wp_memory6_dat_w = (top_capture_pattern1 ? ((top_capture_index ^ 15'd26214) ^ (top_capture_bank1 <<< 4'd15)) : top_capture_sampled6);
assign top_capture_wp_memory6_we = top_capture_active;
assign top_capture_rp_memory6_adr = top_capture_address;
assign top_capture_wp_memory7_adr = top_capture_index;
assign top_capture_wp_memory7_dat_w = (top_capture_pattern1 ? ((top_capture_index ^ 15'd30583) ^ (top_capture_bank1 <<< 4'd15)) : top_capture_sampled7);
assign top_capture_wp_memory7_we = top_capture_active;
assign top_capture_rp_memory7_adr = top_capture_address;
assign top_capture_wp_memory8_adr = top_capture_index;
assign top_capture_wp_memory8_dat_w = (top_capture_pattern1 ? ((top_capture_index ^ 16'd34952) ^ (top_capture_bank1 <<< 4'd15)) : top_capture_sampled8);
assign top_capture_wp_memory8_we = top_capture_active;
assign top_capture_rp_memory8_adr = top_capture_address;
assign top_capture_wp_memory9_adr = top_capture_index;
assign top_capture_wp_memory9_dat_w = (top_capture_pattern1 ? ((top_capture_index ^ 16'd39321) ^ (top_capture_bank1 <<< 4'd15)) : top_capture_sampled9);
assign top_capture_wp_memory9_we = top_capture_active;
assign top_capture_rp_memory9_adr = top_capture_address;
assign top_capture_wp_memory10_adr = top_capture_index;
assign top_capture_wp_memory10_dat_w = (top_capture_pattern1 ? ((top_capture_index ^ 16'd43690) ^ (top_capture_bank1 <<< 4'd15)) : top_capture_sampled10);
assign top_capture_wp_memory10_we = top_capture_active;
assign top_capture_rp_memory10_adr = top_capture_address;
assign top_capture_wp_memory11_adr = top_capture_index;
assign top_capture_wp_memory11_dat_w = (top_capture_pattern1 ? ((top_capture_index ^ 16'd48059) ^ (top_capture_bank1 <<< 4'd15)) : top_capture_sampled11);
assign top_capture_wp_memory11_we = top_capture_active;
assign top_capture_rp_memory11_adr = top_capture_address;
assign top_capture_arm_cdc_o = (top_capture_arm_cdc_toggle_o ^ top_capture_arm_cdc_toggle_o_r);
assign top_capture_done_cdc_o = (top_capture_done_cdc_toggle_o ^ top_capture_done_cdc_toggle_o_r);
assign top_analyzer_arming = top_analyzer_arm;
assign top_analyzer_storing = (top_analyzer_arming | (top_analyzer_active & (top_analyzer_lines != top_analyzer_prev)));
assign top_analyzer_index = (top_analyzer_arming ? 1'd0 : top_analyzer_count);
assign top_analyzer_stamp = (top_analyzer_elapsed + 1'd1);
assign top_analyzer_word = {top_analyzer_lines, (top_analyzer_arming ? 1'd0 : top_analyzer_stamp)};
assign top_analyzer_wp_memory0_adr = top_analyzer_index;
assign top_analyzer_wp_memory0_dat_w = top_analyzer_word;
assign top_analyzer_wp_memory0_we = top_analyzer_storing;
assign top_analyzer_rp_memory0_adr = top_analyzer_cmd[10:0];
assign top_analyzer_selected = top_analyzer_rp_memory0_dat_r;
assign top_analyzer_wp_memory1_adr = top_analyzer_index;
assign top_analyzer_wp_memory1_dat_w = top_analyzer_word;
assign top_analyzer_wp_memory1_we = top_analyzer_storing;
assign top_analyzer_rp_memory1_adr = top_analyzer_address;
assign top_analyzer_data = top_analyzer_rp_memory1_dat_r;
assign top_analyzer_report = {5'd0, top_analyzer_cmd[10:0], 29'd0, top_analyzer_selected, top_analyzer_elapsed, 7'd0, top_analyzer_active, 4'd0, top_analyzer_count, 5'd0, top_analyzer_lines, top_analyzer_tick, 32'd1347246596};
assign top_tdc_frontend_sys_reference = top_tdc_frontend_clock_in0;
assign top_tdc_frontend_clk300_0 = coarse1_clk;
assign top_tdc_frontend_cfd0 = top_tdc_frontend_frontend_v0;
assign top_tdc_frontend_rstr0 = top_tdc_frontend_frontend_v1;
assign top_tdc_frontend_rdata0 = top_tdc_frontend_frontend_v2;
assign top_tdc_frontend_cfd1 = top_tdc_frontend_frontend_v3;
assign top_tdc_frontend_rstr1 = top_tdc_frontend_frontend_v4;
assign top_tdc_frontend_rdata1 = top_tdc_frontend_frontend_v5;
assign top_tdc_frontend_cfd2 = top_tdc_frontend_frontend_v6;
assign top_tdc_frontend_rstr2 = top_tdc_frontend_frontend_v7;
assign top_tdc_frontend_rdata2 = top_tdc_frontend_frontend_v8;
assign top_tdc_frontend_cfd3 = top_tdc_frontend_frontend_v9;
assign top_tdc_frontend_rstr3 = top_tdc_frontend_frontend_v10;
assign top_tdc_frontend_rdata3 = top_tdc_frontend_frontend_v11;
assign top_tdc_frontend_clk300_1 = coarse2_clk;
assign top_tdc_frontend_cfd4 = top_tdc_frontend_frontend_v12;
assign top_tdc_frontend_rstr4 = top_tdc_frontend_frontend_v13;
assign top_tdc_frontend_rdata4 = top_tdc_frontend_frontend_v14;
assign top_tdc_frontend_cfd5 = top_tdc_frontend_frontend_v15;
assign top_tdc_frontend_rstr5 = top_tdc_frontend_frontend_v16;
assign top_tdc_frontend_rdata5 = top_tdc_frontend_frontend_v17;
assign top_tdc_frontend_cfd6 = top_tdc_frontend_frontend_v18;
assign top_tdc_frontend_rstr6 = top_tdc_frontend_frontend_v19;
assign top_tdc_frontend_rdata6 = top_tdc_frontend_frontend_v20;
assign top_tdc_frontend_cfd7 = top_tdc_frontend_frontend_v21;
assign top_tdc_frontend_rstr7 = top_tdc_frontend_frontend_v22;
assign top_tdc_frontend_rdata7 = top_tdc_frontend_frontend_v23;
assign top_tdc_frontend_clk300_2 = coarse3_clk;

// synthesis translate_off
reg dummy_d_32;
// synthesis translate_on
always @(*) begin
	top_tdc_frontend_receiver_reset <= 3'd0;
	top_tdc_frontend_receiver_reset[0] <= top_tdc_frontend_local_reset0;
	top_tdc_frontend_receiver_reset[1] <= top_tdc_frontend_local_reset1;
	top_tdc_frontend_receiver_reset[2] <= top_tdc_frontend_local_reset2;
// synthesis translate_off
	dummy_d_32 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_33;
// synthesis translate_on
always @(*) begin
	top_tdc_frontend_alive <= 3'd0;
	top_tdc_frontend_alive[0] <= (top_tdc_frontend_age0 < 12'd4000);
	top_tdc_frontend_alive[1] <= (top_tdc_frontend_age1 < 12'd4000);
	top_tdc_frontend_alive[2] <= (top_tdc_frontend_age2 < 12'd4000);
// synthesis translate_off
	dummy_d_33 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_34;
// synthesis translate_on
always @(*) begin
	top_tdc_frontend_ready <= 3'd0;
	top_tdc_frontend_ready[0] <= ((top_tdc_frontend_locks[0] & top_tdc_frontend_phased[0]) & top_tdc_frontend_alive[0]);
	top_tdc_frontend_ready[1] <= ((top_tdc_frontend_locks[1] & top_tdc_frontend_phased[1]) & top_tdc_frontend_alive[1]);
	top_tdc_frontend_ready[2] <= ((top_tdc_frontend_locks[2] & top_tdc_frontend_phased[2]) & top_tdc_frontend_alive[2]);
// synthesis translate_off
	dummy_d_34 <= dummy_s;
// synthesis translate_on
end
assign top_tdc_frontend_cfd8 = top_tdc_frontend_frontend_v24;
assign top_tdc_frontend_rstr8 = top_tdc_frontend_frontend_v25;
assign top_tdc_frontend_rdata8 = top_tdc_frontend_frontend_v26;
assign top_tdc_frontend_cfd9 = top_tdc_frontend_frontend_v27;
assign top_tdc_frontend_rstr9 = top_tdc_frontend_frontend_v28;
assign top_tdc_frontend_rdata9 = top_tdc_frontend_frontend_v29;
assign top_tdc_frontend_cfd10 = top_tdc_frontend_frontend_v30;
assign top_tdc_frontend_rstr10 = top_tdc_frontend_frontend_v31;
assign top_tdc_frontend_rdata10 = top_tdc_frontend_frontend_v32;
assign top_tdc_frontend_cfd11 = top_tdc_frontend_frontend_v33;
assign top_tdc_frontend_rstr11 = top_tdc_frontend_frontend_v34;
assign top_tdc_frontend_rdata11 = top_tdc_frontend_frontend_v35;
assign top_tdc_frontend_frontend_ready1 = (top_tdc_frontend_ready == 3'd7);
assign top_tdc_frontend_frontend_status = {top_tdc_frontend_ready, top_tdc_frontend_alive, top_tdc_frontend_phased, top_tdc_frontend_locks};
assign top_tdc_frontend_frontend_ready0 = top_tdc_frontend_frontend_ready1;
assign top_tdc_frontend_tdcbuffers_wp_memory0_adr = top_tdc_frontend_tdcbuffers_count0;
assign top_tdc_frontend_tdcbuffers_wp_memory0_dat_w = top_tdc_frontend_tdcbuffers_raw0;
assign top_tdc_frontend_tdcbuffers_wp_memory0_we = ((((top_tdc_frontend_tdcbuffers_active0 & (top_tdc_frontend_tdcbuffers_count0 < 13'd4096)) & top_tdc_frontend_tdcbuffers_event0) & (top_tdc_frontend_tdcbuffers_request0 == top_tdc_frontend_tdcbuffers_seen0)) & (top_tdc_frontend_tdcbuffers_stop_request0 == top_tdc_frontend_tdcbuffers_stop_seen0));
assign top_tdc_frontend_tdcbuffers_rp_memory0_adr = top_tdc_frontend_tdcbuffers_address;
assign top_tdc_frontend_tdcbuffers_wp_memory1_adr = top_tdc_frontend_tdcbuffers_count1;
assign top_tdc_frontend_tdcbuffers_wp_memory1_dat_w = top_tdc_frontend_tdcbuffers_raw1;
assign top_tdc_frontend_tdcbuffers_wp_memory1_we = ((((top_tdc_frontend_tdcbuffers_active1 & (top_tdc_frontend_tdcbuffers_count1 < 13'd4096)) & top_tdc_frontend_tdcbuffers_event1) & (top_tdc_frontend_tdcbuffers_request1 == top_tdc_frontend_tdcbuffers_seen1)) & (top_tdc_frontend_tdcbuffers_stop_request1 == top_tdc_frontend_tdcbuffers_stop_seen1));
assign top_tdc_frontend_tdcbuffers_rp_memory1_adr = top_tdc_frontend_tdcbuffers_address;
assign top_tdc_frontend_tdcbuffers_wp_memory2_adr = top_tdc_frontend_tdcbuffers_count2;
assign top_tdc_frontend_tdcbuffers_wp_memory2_dat_w = top_tdc_frontend_tdcbuffers_raw2;
assign top_tdc_frontend_tdcbuffers_wp_memory2_we = ((((top_tdc_frontend_tdcbuffers_active2 & (top_tdc_frontend_tdcbuffers_count2 < 13'd4096)) & top_tdc_frontend_tdcbuffers_event2) & (top_tdc_frontend_tdcbuffers_request2 == top_tdc_frontend_tdcbuffers_seen2)) & (top_tdc_frontend_tdcbuffers_stop_request2 == top_tdc_frontend_tdcbuffers_stop_seen2));
assign top_tdc_frontend_tdcbuffers_rp_memory2_adr = top_tdc_frontend_tdcbuffers_address;
assign top_tdc_frontend_tdcbuffers_wp_memory3_adr = top_tdc_frontend_tdcbuffers_count3;
assign top_tdc_frontend_tdcbuffers_wp_memory3_dat_w = top_tdc_frontend_tdcbuffers_raw3;
assign top_tdc_frontend_tdcbuffers_wp_memory3_we = ((((top_tdc_frontend_tdcbuffers_active3 & (top_tdc_frontend_tdcbuffers_count3 < 13'd4096)) & top_tdc_frontend_tdcbuffers_event3) & (top_tdc_frontend_tdcbuffers_request3 == top_tdc_frontend_tdcbuffers_seen3)) & (top_tdc_frontend_tdcbuffers_stop_request3 == top_tdc_frontend_tdcbuffers_stop_seen3));
assign top_tdc_frontend_tdcbuffers_rp_memory3_adr = top_tdc_frontend_tdcbuffers_address;
assign top_tdc_frontend_tdcbuffers_wp_memory4_adr = top_tdc_frontend_tdcbuffers_count4;
assign top_tdc_frontend_tdcbuffers_wp_memory4_dat_w = top_tdc_frontend_tdcbuffers_raw4;
assign top_tdc_frontend_tdcbuffers_wp_memory4_we = ((((top_tdc_frontend_tdcbuffers_active4 & (top_tdc_frontend_tdcbuffers_count4 < 13'd4096)) & top_tdc_frontend_tdcbuffers_event4) & (top_tdc_frontend_tdcbuffers_request4 == top_tdc_frontend_tdcbuffers_seen4)) & (top_tdc_frontend_tdcbuffers_stop_request4 == top_tdc_frontend_tdcbuffers_stop_seen4));
assign top_tdc_frontend_tdcbuffers_rp_memory4_adr = top_tdc_frontend_tdcbuffers_address;
assign top_tdc_frontend_tdcbuffers_wp_memory5_adr = top_tdc_frontend_tdcbuffers_count5;
assign top_tdc_frontend_tdcbuffers_wp_memory5_dat_w = top_tdc_frontend_tdcbuffers_raw5;
assign top_tdc_frontend_tdcbuffers_wp_memory5_we = ((((top_tdc_frontend_tdcbuffers_active5 & (top_tdc_frontend_tdcbuffers_count5 < 13'd4096)) & top_tdc_frontend_tdcbuffers_event5) & (top_tdc_frontend_tdcbuffers_request5 == top_tdc_frontend_tdcbuffers_seen5)) & (top_tdc_frontend_tdcbuffers_stop_request5 == top_tdc_frontend_tdcbuffers_stop_seen5));
assign top_tdc_frontend_tdcbuffers_rp_memory5_adr = top_tdc_frontend_tdcbuffers_address;
assign top_tdc_frontend_tdcbuffers_wp_memory6_adr = top_tdc_frontend_tdcbuffers_count6;
assign top_tdc_frontend_tdcbuffers_wp_memory6_dat_w = top_tdc_frontend_tdcbuffers_raw6;
assign top_tdc_frontend_tdcbuffers_wp_memory6_we = ((((top_tdc_frontend_tdcbuffers_active6 & (top_tdc_frontend_tdcbuffers_count6 < 13'd4096)) & top_tdc_frontend_tdcbuffers_event6) & (top_tdc_frontend_tdcbuffers_request6 == top_tdc_frontend_tdcbuffers_seen6)) & (top_tdc_frontend_tdcbuffers_stop_request6 == top_tdc_frontend_tdcbuffers_stop_seen6));
assign top_tdc_frontend_tdcbuffers_rp_memory6_adr = top_tdc_frontend_tdcbuffers_address;
assign top_tdc_frontend_tdcbuffers_wp_memory7_adr = top_tdc_frontend_tdcbuffers_count7;
assign top_tdc_frontend_tdcbuffers_wp_memory7_dat_w = top_tdc_frontend_tdcbuffers_raw7;
assign top_tdc_frontend_tdcbuffers_wp_memory7_we = ((((top_tdc_frontend_tdcbuffers_active7 & (top_tdc_frontend_tdcbuffers_count7 < 13'd4096)) & top_tdc_frontend_tdcbuffers_event7) & (top_tdc_frontend_tdcbuffers_request7 == top_tdc_frontend_tdcbuffers_seen7)) & (top_tdc_frontend_tdcbuffers_stop_request7 == top_tdc_frontend_tdcbuffers_stop_seen7));
assign top_tdc_frontend_tdcbuffers_rp_memory7_adr = top_tdc_frontend_tdcbuffers_address;
assign top_tdc_frontend_tdcbuffers_wp_memory8_adr = top_tdc_frontend_tdcbuffers_count8;
assign top_tdc_frontend_tdcbuffers_wp_memory8_dat_w = top_tdc_frontend_tdcbuffers_raw8;
assign top_tdc_frontend_tdcbuffers_wp_memory8_we = ((((top_tdc_frontend_tdcbuffers_active8 & (top_tdc_frontend_tdcbuffers_count8 < 13'd4096)) & top_tdc_frontend_tdcbuffers_event8) & (top_tdc_frontend_tdcbuffers_request8 == top_tdc_frontend_tdcbuffers_seen8)) & (top_tdc_frontend_tdcbuffers_stop_request8 == top_tdc_frontend_tdcbuffers_stop_seen8));
assign top_tdc_frontend_tdcbuffers_rp_memory8_adr = top_tdc_frontend_tdcbuffers_address;
assign top_tdc_frontend_tdcbuffers_wp_memory9_adr = top_tdc_frontend_tdcbuffers_count9;
assign top_tdc_frontend_tdcbuffers_wp_memory9_dat_w = top_tdc_frontend_tdcbuffers_raw9;
assign top_tdc_frontend_tdcbuffers_wp_memory9_we = ((((top_tdc_frontend_tdcbuffers_active9 & (top_tdc_frontend_tdcbuffers_count9 < 13'd4096)) & top_tdc_frontend_tdcbuffers_event9) & (top_tdc_frontend_tdcbuffers_request9 == top_tdc_frontend_tdcbuffers_seen9)) & (top_tdc_frontend_tdcbuffers_stop_request9 == top_tdc_frontend_tdcbuffers_stop_seen9));
assign top_tdc_frontend_tdcbuffers_rp_memory9_adr = top_tdc_frontend_tdcbuffers_address;
assign top_tdc_frontend_tdcbuffers_wp_memory10_adr = top_tdc_frontend_tdcbuffers_count10;
assign top_tdc_frontend_tdcbuffers_wp_memory10_dat_w = top_tdc_frontend_tdcbuffers_raw10;
assign top_tdc_frontend_tdcbuffers_wp_memory10_we = ((((top_tdc_frontend_tdcbuffers_active10 & (top_tdc_frontend_tdcbuffers_count10 < 13'd4096)) & top_tdc_frontend_tdcbuffers_event10) & (top_tdc_frontend_tdcbuffers_request10 == top_tdc_frontend_tdcbuffers_seen10)) & (top_tdc_frontend_tdcbuffers_stop_request10 == top_tdc_frontend_tdcbuffers_stop_seen10));
assign top_tdc_frontend_tdcbuffers_rp_memory10_adr = top_tdc_frontend_tdcbuffers_address;
assign top_tdc_frontend_tdcbuffers_wp_memory11_adr = top_tdc_frontend_tdcbuffers_count11;
assign top_tdc_frontend_tdcbuffers_wp_memory11_dat_w = top_tdc_frontend_tdcbuffers_raw11;
assign top_tdc_frontend_tdcbuffers_wp_memory11_we = ((((top_tdc_frontend_tdcbuffers_active11 & (top_tdc_frontend_tdcbuffers_count11 < 13'd4096)) & top_tdc_frontend_tdcbuffers_event11) & (top_tdc_frontend_tdcbuffers_request11 == top_tdc_frontend_tdcbuffers_seen11)) & (top_tdc_frontend_tdcbuffers_stop_request11 == top_tdc_frontend_tdcbuffers_stop_seen11));
assign top_tdc_frontend_tdcbuffers_rp_memory11_adr = top_tdc_frontend_tdcbuffers_address;
assign top_tdc_frontend_tdcbuffers_ready = ((~top_tdc_frontend_tdcbuffers_busy) & ((((((((((((top_tdc_frontend_tdcbuffers_ack_sys0 == top_tdc_frontend_tdcbuffers_epoch) & (top_tdc_frontend_tdcbuffers_ack_sys1 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys2 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys3 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys4 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys5 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys6 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys7 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys8 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys9 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys10 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys11 == top_tdc_frontend_tdcbuffers_epoch)));
assign top_tdc_frontend_tdcbuffers_started = (top_tdc_frontend_tdcbuffers_busy & ((((((((((((top_tdc_frontend_tdcbuffers_seen_sys0 == top_tdc_frontend_tdcbuffers_epoch) & (top_tdc_frontend_tdcbuffers_seen_sys1 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_seen_sys2 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_seen_sys3 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_seen_sys4 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_seen_sys5 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_seen_sys6 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_seen_sys7 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_seen_sys8 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_seen_sys9 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_seen_sys10 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_seen_sys11 == top_tdc_frontend_tdcbuffers_epoch)));
assign top_tdc_frontend_selected = ((((((((top_tdc_frontend_address == 10'd512) | (top_tdc_frontend_address == 10'd513)) | (top_tdc_frontend_address == 10'd514)) | (top_tdc_frontend_address == 10'd515)) | (top_tdc_frontend_address == 10'd516)) | (top_tdc_frontend_address == 10'd517)) | ((top_tdc_frontend_address >= 10'd544) & (top_tdc_frontend_address < 10'd556))) | ((top_tdc_frontend_address >= 18'd131072) & (top_tdc_frontend_address < 18'd180224)));
assign top_tdc_frontend_valid = (top_tdc_frontend_tdcbuffers_valid & (~top_tdc_frontend_fault));
assign top_tdc_frontend_error = ((top_tdc_frontend_write & ((~(top_tdc_frontend_address == 10'd512)) | (~(((top_tdc_frontend_wdata == 1'd1) & (((top_tdc_frontend_tdcbuffers_ready & top_tdc_frontend_frontend_ready0) & (~top_tdc_frontend_fault)) & (~top_tdc_frontend_pending))) | ((top_tdc_frontend_wdata == 2'd2) & ((top_tdc_frontend_tdcbuffers_started & (~top_tdc_frontend_fault)) & (~top_tdc_frontend_pending))))))) | (((~top_tdc_frontend_write) & ((top_tdc_frontend_address >= 18'd131072) & (top_tdc_frontend_address < 18'd180224))) & ((~top_tdc_frontend_valid) | (top_tdc_frontend_address[11:0] >= comb_rhs_self))));
assign top_tdc_frontend_tdcbuffers_address = top_tdc_frontend_address[11:0];
assign top_tdc_frontend_tdcbuffers_arm = top_tdc_frontend_arm;
assign top_tdc_frontend_tdcbuffers_stop = top_tdc_frontend_stop;

// synthesis translate_off
reg dummy_d_35;
// synthesis translate_on
always @(*) begin
	top_tdc_frontend_rdata <= 32'd0;
	top_tdc_frontend_rdata <= 1'd0;
	case (top_tdc_frontend_address)
		10'd513: begin
			top_tdc_frontend_rdata <= {top_tdc_frontend_fault, top_tdc_frontend_frontend_ready0, (((top_tdc_frontend_tdcbuffers_ready & top_tdc_frontend_frontend_ready0) & (~top_tdc_frontend_fault)) & (~top_tdc_frontend_pending)), top_tdc_frontend_tdcbuffers_started, top_tdc_frontend_tdcbuffers_busy, top_tdc_frontend_valid};
		end
		10'd514: begin
			top_tdc_frontend_rdata <= top_tdc_frontend_tdcbuffers_capture_id;
		end
		10'd515: begin
			top_tdc_frontend_rdata <= 13'd4096;
		end
		10'd516: begin
			top_tdc_frontend_rdata <= 4'd12;
		end
		10'd517: begin
			top_tdc_frontend_rdata <= top_tdc_frontend_frontend_status;
		end
	endcase
	if (((top_tdc_frontend_address >= 10'd544) & (top_tdc_frontend_address < 10'd556))) begin
		top_tdc_frontend_rdata <= (top_tdc_frontend_valid ? comb_t_self0 : 1'd0);
	end
	if (((top_tdc_frontend_address >= 18'd131072) & (top_tdc_frontend_address < 18'd180224))) begin
		top_tdc_frontend_rdata <= comb_t_self1;
	end
// synthesis translate_off
	dummy_d_35 <= dummy_s;
// synthesis translate_on
end
assign top_hdmi_data = ((top_hdmi_cmd[5:4] == 1'd0) ? top_hdmi_cmd[3:0] : ((top_hdmi_cmd[5:4] == 1'd1) ? top_hdmi_idle : {top_hdmi3[6], top_hdmi2[6], top_hdmi1[6], top_hdmi0[6]}));
assign top_hdmi_selected = ((top_hdmi_address >= 10'd768) & (top_hdmi_address <= 10'd772));
assign top_hdmi_error = ($signed({1'd0, top_hdmi_write}) & ($signed({1'd0, (top_hdmi_address != 10'd769)}) | (($signed({1'd0, top_hdmi_wdata}) & 9'sd320) != $signed({1'd0, 1'd0}))));

// synthesis translate_off
reg dummy_d_36;
// synthesis translate_on
always @(*) begin
	top_hdmi_rdata <= 32'd0;
	top_hdmi_rdata <= 1'd0;
	case (top_hdmi_address)
		10'd768: begin
			top_hdmi_rdata <= 31'd1212435761;
		end
		10'd769: begin
			top_hdmi_rdata <= top_hdmi_command;
		end
		10'd770: begin
			top_hdmi_rdata <= top_hdmi_locked;
		end
		10'd771: begin
			top_hdmi_rdata <= top_hdmi_scratch;
		end
		10'd772: begin
			top_hdmi_rdata <= top_hdmi_writes;
		end
	endcase
// synthesis translate_off
	dummy_d_36 <= dummy_s;
// synthesis translate_on
end
assign top_capture_arm = top_registers_arm;
assign top_capture_pattern0 = top_registers_pattern;
assign top_capture_bank0 = top_registers_bank;
assign top_analyzer_arm = top_registers_trace_arm;
assign top_capture_address = top_registers_adr[11:0];
assign top_analyzer_address = top_registers_adr[11:1];
assign top_tdc_frontend_address = top_registers_adr;
assign top_tdc_frontend_wdata = top_registers_wd;
assign top_tdc_frontend_write = top_registers_wr;
assign top_hdmi_address = top_registers_adr;
assign top_hdmi_wdata = top_registers_wd;
assign top_hdmi_write = top_registers_wr;

// synthesis translate_off
reg dummy_d_37;
// synthesis translate_on
always @(*) begin
	top_registers_valid_address <= 1'd0;
	top_registers_read_value <= 32'd0;
	top_registers_writable <= 1'd0;
	top_registers_bad_write <= 1'd0;
	top_registers_valid_address <= 1'd1;
	top_registers_read_value <= 1'd0;
	top_registers_writable <= 1'd0;
	top_registers_bad_write <= 1'd0;
	case (top_registers_adr)
		1'd0: begin
			top_registers_read_value <= 31'd1347228162;
		end
		1'd1: begin
			top_registers_read_value <= 17'd65537;
		end
		2'd2: begin
			top_registers_read_value <= 32'd3351522600;
		end
		2'd3: begin
			top_registers_read_value <= top_registers_scratch;
			top_registers_writable <= 1'd1;
		end
		3'd4: begin
			top_registers_read_value <= top_registers_writes;
		end
		3'd5: begin
			top_registers_read_value <= top_registers_uptime[31:0];
		end
		3'd6: begin
			top_registers_read_value <= top_registers_uptime[63:32];
		end
		3'd7: begin
			top_registers_read_value <= 26'd40000000;
		end
		4'd8: begin
			top_registers_read_value <= 29'd320000000;
		end
		4'd9: begin
			top_registers_read_value <= 4'd15;
		end
		5'd16: begin
			top_registers_read_value <= {top_registers_pattern, 6'd0, top_registers_bank, 1'd0};
			top_registers_writable <= 1'd1;
			top_registers_bad_write <= (($signed({1'd0, top_registers_wd}) & 10'sd764) != $signed({1'd0, 1'd0}));
		end
		5'd17: begin
			top_registers_read_value <= {top_registers_timed_out, top_registers_bank, top_registers_pattern, top_registers_locked, top_registers_link, top_registers_busy, top_registers_valid};
		end
		5'd18: begin
			top_registers_read_value <= top_registers_capture_id;
		end
		5'd19: begin
			top_registers_read_value <= 13'd4096;
		end
		5'd20: begin
			top_registers_read_value <= 4'd12;
		end
		6'd32: begin
			top_registers_read_value <= top_registers_mcu_scratch;
		end
		6'd33: begin
			top_registers_read_value <= top_registers_mcu_writes;
		end
		9'd256: begin
			top_registers_read_value <= 1'd0;
			top_registers_writable <= 1'd1;
			top_registers_bad_write <= (($signed({1'd0, top_registers_wd}) & 2'sd2) != $signed({1'd0, 1'd0}));
		end
		9'd257: begin
			top_registers_read_value <= top_analyzer_count;
		end
		9'd258: begin
			top_registers_read_value <= top_analyzer_active;
		end
		9'd259: begin
			top_registers_read_value <= top_analyzer_elapsed;
		end
		9'd260: begin
			top_registers_read_value <= top_analyzer_lines;
		end
		9'd261: begin
			top_registers_read_value <= top_analyzer_arm_count;
		end
		default: begin
			top_registers_valid_address <= 1'd0;
		end
	endcase
	if (((top_registers_adr >= 17'd65536) & (top_registers_adr < 17'd114688))) begin
		top_registers_valid_address <= (top_registers_valid & (~top_registers_busy));
		top_registers_read_value <= comb_t_self2;
	end else begin
		if (((top_registers_adr >= 14'd8192) & (top_registers_adr < 14'd12288))) begin
			top_registers_valid_address <= ((~top_analyzer_active) & (top_registers_adr[11:1] < top_analyzer_count));
			top_registers_read_value <= (top_registers_adr[0] ? top_analyzer_data[34:32] : top_analyzer_data[31:0]);
		end
	end
	if ((top_registers_adr == 1'd1)) begin
		top_registers_read_value <= 17'd65538;
	end
	if ((top_registers_adr == 4'd9)) begin
		top_registers_read_value <= 5'd31;
	end
	if (top_tdc_frontend_selected) begin
		top_registers_valid_address <= (~top_tdc_frontend_error);
		top_registers_read_value <= top_tdc_frontend_rdata;
		top_registers_writable <= 1'd1;
		top_registers_bad_write <= top_tdc_frontend_error;
	end
	if ((top_registers_adr == 4'd9)) begin
		top_registers_read_value <= 6'd63;
	end
	if (top_hdmi_selected) begin
		top_registers_valid_address <= (~top_hdmi_error);
		top_registers_read_value <= top_hdmi_rdata;
		top_registers_writable <= 1'd1;
		top_registers_bad_write <= top_hdmi_error;
	end
// synthesis translate_off
	dummy_d_37 <= dummy_s;
// synthesis translate_on
end
assign top_tdc_frontend_commit = (top_registers_is_ongoing0 & (~((~top_registers_valid_address) | (top_registers_wr & ((((~top_registers_writable) | top_registers_bad_write) | ((top_registers_adr == 5'd16) & (top_registers_busy | (~top_registers_locked)))) | ((top_registers_adr == 9'd256) & top_analyzer_active))))));
assign top_hdmi_commit = (top_registers_is_ongoing1 & (~((~top_registers_valid_address) | (top_registers_wr & ((((~top_registers_writable) | top_registers_bad_write) | ((top_registers_adr == 5'd16) & (top_registers_busy | (~top_registers_locked)))) | ((top_registers_adr == 9'd256) & top_analyzer_active))))));

// synthesis translate_off
reg dummy_d_38;
// synthesis translate_on
always @(*) begin
	top_registers_is_ongoing0 <= 1'd0;
	top_registers_is_ongoing1 <= 1'd0;
	next_state <= 2'd0;
	top_registers_adr_registers_next_value0 <= 32'd0;
	top_registers_adr_registers_next_value_ce0 <= 1'd0;
	top_registers_wd_registers_next_value1 <= 32'd0;
	top_registers_wd_registers_next_value_ce1 <= 1'd0;
	top_registers_wr_registers_next_value2 <= 1'd0;
	top_registers_wr_registers_next_value_ce2 <= 1'd0;
	top_registers_ack_registers_next_value3 <= 1'd0;
	top_registers_ack_registers_next_value_ce3 <= 1'd0;
	top_registers_err_registers_next_value4 <= 1'd0;
	top_registers_err_registers_next_value_ce4 <= 1'd0;
	top_registers_rdata_registers_next_value5 <= 32'd0;
	top_registers_rdata_registers_next_value_ce5 <= 1'd0;
	top_registers_writes_registers_next_value6 <= 32'd0;
	top_registers_writes_registers_next_value_ce6 <= 1'd0;
	top_registers_scratch_registers_next_value7 <= 32'd0;
	top_registers_scratch_registers_next_value_ce7 <= 1'd0;
	top_registers_valid_registers_t_next_value0 <= 1'd0;
	top_registers_valid_registers_t_next_value_ce0 <= 1'd0;
	top_registers_bank_registers_t_next_value1 <= 1'd0;
	top_registers_bank_registers_t_next_value_ce1 <= 1'd0;
	top_registers_pattern_registers_t_next_value2 <= 1'd0;
	top_registers_pattern_registers_t_next_value_ce2 <= 1'd0;
	top_registers_ev_registers_t_next_value3 <= 1'd0;
	top_registers_ev_registers_t_next_value_ce3 <= 1'd0;
	top_registers_busy_registers_t_next_value4 <= 1'd0;
	top_registers_busy_registers_t_next_value_ce4 <= 1'd0;
	top_registers_timed_out_registers_t_next_value5 <= 1'd0;
	top_registers_timed_out_registers_t_next_value_ce5 <= 1'd0;
	top_registers_settling_registers_t_next_value6 <= 1'd0;
	top_registers_settling_registers_t_next_value_ce6 <= 1'd0;
	top_registers_remaining_registers_t_next_value7 <= 16'd0;
	top_registers_remaining_registers_t_next_value_ce7 <= 1'd0;
	top_registers_trace_arm_registers_f_next_value <= 1'd0;
	top_registers_trace_arm_registers_f_next_value_ce <= 1'd0;
	next_state <= state;
	case (state)
		1'd1: begin
			next_state <= 2'd2;
		end
		2'd2: begin
			top_registers_ack_registers_next_value3 <= 1'd1;
			top_registers_ack_registers_next_value_ce3 <= 1'd1;
			top_registers_err_registers_next_value4 <= ((~top_registers_valid_address) | (top_registers_wr & ((((~top_registers_writable) | top_registers_bad_write) | ((top_registers_adr == 5'd16) & (top_registers_busy | (~top_registers_locked)))) | ((top_registers_adr == 9'd256) & top_analyzer_active))));
			top_registers_err_registers_next_value_ce4 <= 1'd1;
			top_registers_rdata_registers_next_value5 <= top_registers_read_value;
			top_registers_rdata_registers_next_value_ce5 <= 1'd1;
			if ((top_registers_wr & (~((~top_registers_valid_address) | (top_registers_wr & ((((~top_registers_writable) | top_registers_bad_write) | ((top_registers_adr == 5'd16) & (top_registers_busy | (~top_registers_locked)))) | ((top_registers_adr == 9'd256) & top_analyzer_active))))))) begin
				top_registers_writes_registers_next_value6 <= (top_registers_writes + 1'd1);
				top_registers_writes_registers_next_value_ce6 <= 1'd1;
				if ((top_registers_adr == 2'd3)) begin
					top_registers_scratch_registers_next_value7 <= top_registers_wd;
					top_registers_scratch_registers_next_value_ce7 <= 1'd1;
				end else begin
					if ((top_registers_adr == 5'd16)) begin
						top_registers_valid_registers_t_next_value0 <= 1'd0;
						top_registers_valid_registers_t_next_value_ce0 <= 1'd1;
						top_registers_bank_registers_t_next_value1 <= top_registers_wd[1];
						top_registers_bank_registers_t_next_value_ce1 <= 1'd1;
						top_registers_pattern_registers_t_next_value2 <= top_registers_wd[8];
						top_registers_pattern_registers_t_next_value_ce2 <= 1'd1;
						top_registers_ev_registers_t_next_value3 <= top_registers_wd[1];
						top_registers_ev_registers_t_next_value_ce3 <= 1'd1;
						if (top_registers_wd[0]) begin
							top_registers_busy_registers_t_next_value4 <= 1'd1;
							top_registers_busy_registers_t_next_value_ce4 <= 1'd1;
							top_registers_valid_registers_t_next_value0 <= 1'd0;
							top_registers_valid_registers_t_next_value_ce0 <= 1'd1;
							top_registers_timed_out_registers_t_next_value5 <= 1'd0;
							top_registers_timed_out_registers_t_next_value_ce5 <= 1'd1;
							top_registers_settling_registers_t_next_value6 <= 1'd1;
							top_registers_settling_registers_t_next_value_ce6 <= 1'd1;
							top_registers_remaining_registers_t_next_value7 <= 10'd1000;
							top_registers_remaining_registers_t_next_value_ce7 <= 1'd1;
						end
					end else begin
						if ((top_registers_adr == 9'd256)) begin
							top_registers_trace_arm_registers_f_next_value <= top_registers_wd[0];
							top_registers_trace_arm_registers_f_next_value_ce <= 1'd1;
						end
					end
				end
			end
			next_state <= 2'd3;
			top_registers_is_ongoing0 <= 1'd1;
			top_registers_is_ongoing1 <= 1'd1;
		end
		2'd3: begin
			top_registers_ack_registers_next_value3 <= 1'd0;
			top_registers_ack_registers_next_value_ce3 <= 1'd1;
			top_registers_err_registers_next_value4 <= 1'd0;
			top_registers_err_registers_next_value_ce4 <= 1'd1;
			next_state <= 1'd0;
		end
		default: begin
			if (top_registers_strobe) begin
				top_registers_adr_registers_next_value0 <= top_registers_address;
				top_registers_adr_registers_next_value_ce0 <= 1'd1;
				top_registers_wd_registers_next_value1 <= top_registers_wdata;
				top_registers_wd_registers_next_value_ce1 <= 1'd1;
				top_registers_wr_registers_next_value2 <= top_registers_write;
				top_registers_wr_registers_next_value_ce2 <= 1'd1;
				next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_38 <= dummy_s;
// synthesis translate_on
end
assign slice_proxy = {top_tx_crc_value, top_tx_crc_sink_payload_data[7:0]};

// synthesis translate_off
reg dummy_d_39;
// synthesis translate_on
always @(*) begin
	comb_rhs_self <= 13'd0;
	case (top_tdc_frontend_address[15:12])
		1'd0: begin
			comb_rhs_self <= top_tdc_frontend_tdcbuffers0;
		end
		1'd1: begin
			comb_rhs_self <= top_tdc_frontend_tdcbuffers1;
		end
		2'd2: begin
			comb_rhs_self <= top_tdc_frontend_tdcbuffers2;
		end
		2'd3: begin
			comb_rhs_self <= top_tdc_frontend_tdcbuffers3;
		end
		3'd4: begin
			comb_rhs_self <= top_tdc_frontend_tdcbuffers4;
		end
		3'd5: begin
			comb_rhs_self <= top_tdc_frontend_tdcbuffers5;
		end
		3'd6: begin
			comb_rhs_self <= top_tdc_frontend_tdcbuffers6;
		end
		3'd7: begin
			comb_rhs_self <= top_tdc_frontend_tdcbuffers7;
		end
		4'd8: begin
			comb_rhs_self <= top_tdc_frontend_tdcbuffers8;
		end
		4'd9: begin
			comb_rhs_self <= top_tdc_frontend_tdcbuffers9;
		end
		4'd10: begin
			comb_rhs_self <= top_tdc_frontend_tdcbuffers10;
		end
		default: begin
			comb_rhs_self <= top_tdc_frontend_tdcbuffers11;
		end
	endcase
// synthesis translate_off
	dummy_d_39 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_40;
// synthesis translate_on
always @(*) begin
	comb_t_self0 <= 13'd0;
	case (top_tdc_frontend_address[3:0])
		1'd0: begin
			comb_t_self0 <= top_tdc_frontend_tdcbuffers0;
		end
		1'd1: begin
			comb_t_self0 <= top_tdc_frontend_tdcbuffers1;
		end
		2'd2: begin
			comb_t_self0 <= top_tdc_frontend_tdcbuffers2;
		end
		2'd3: begin
			comb_t_self0 <= top_tdc_frontend_tdcbuffers3;
		end
		3'd4: begin
			comb_t_self0 <= top_tdc_frontend_tdcbuffers4;
		end
		3'd5: begin
			comb_t_self0 <= top_tdc_frontend_tdcbuffers5;
		end
		3'd6: begin
			comb_t_self0 <= top_tdc_frontend_tdcbuffers6;
		end
		3'd7: begin
			comb_t_self0 <= top_tdc_frontend_tdcbuffers7;
		end
		4'd8: begin
			comb_t_self0 <= top_tdc_frontend_tdcbuffers8;
		end
		4'd9: begin
			comb_t_self0 <= top_tdc_frontend_tdcbuffers9;
		end
		4'd10: begin
			comb_t_self0 <= top_tdc_frontend_tdcbuffers10;
		end
		default: begin
			comb_t_self0 <= top_tdc_frontend_tdcbuffers11;
		end
	endcase
// synthesis translate_off
	dummy_d_40 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_41;
// synthesis translate_on
always @(*) begin
	comb_t_self1 <= 16'd0;
	case (top_tdc_frontend_address[15:12])
		1'd0: begin
			comb_t_self1 <= top_tdc_frontend_tdcbuffers_rp_memory0_dat_r;
		end
		1'd1: begin
			comb_t_self1 <= top_tdc_frontend_tdcbuffers_rp_memory1_dat_r;
		end
		2'd2: begin
			comb_t_self1 <= top_tdc_frontend_tdcbuffers_rp_memory2_dat_r;
		end
		2'd3: begin
			comb_t_self1 <= top_tdc_frontend_tdcbuffers_rp_memory3_dat_r;
		end
		3'd4: begin
			comb_t_self1 <= top_tdc_frontend_tdcbuffers_rp_memory4_dat_r;
		end
		3'd5: begin
			comb_t_self1 <= top_tdc_frontend_tdcbuffers_rp_memory5_dat_r;
		end
		3'd6: begin
			comb_t_self1 <= top_tdc_frontend_tdcbuffers_rp_memory6_dat_r;
		end
		3'd7: begin
			comb_t_self1 <= top_tdc_frontend_tdcbuffers_rp_memory7_dat_r;
		end
		4'd8: begin
			comb_t_self1 <= top_tdc_frontend_tdcbuffers_rp_memory8_dat_r;
		end
		4'd9: begin
			comb_t_self1 <= top_tdc_frontend_tdcbuffers_rp_memory9_dat_r;
		end
		4'd10: begin
			comb_t_self1 <= top_tdc_frontend_tdcbuffers_rp_memory10_dat_r;
		end
		default: begin
			comb_t_self1 <= top_tdc_frontend_tdcbuffers_rp_memory11_dat_r;
		end
	endcase
// synthesis translate_off
	dummy_d_41 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_42;
// synthesis translate_on
always @(*) begin
	comb_t_self2 <= 16'd0;
	case (top_registers_adr[15:12])
		1'd0: begin
			comb_t_self2 <= top_capture_rp_memory0_dat_r;
		end
		1'd1: begin
			comb_t_self2 <= top_capture_rp_memory1_dat_r;
		end
		2'd2: begin
			comb_t_self2 <= top_capture_rp_memory2_dat_r;
		end
		2'd3: begin
			comb_t_self2 <= top_capture_rp_memory3_dat_r;
		end
		3'd4: begin
			comb_t_self2 <= top_capture_rp_memory4_dat_r;
		end
		3'd5: begin
			comb_t_self2 <= top_capture_rp_memory5_dat_r;
		end
		3'd6: begin
			comb_t_self2 <= top_capture_rp_memory6_dat_r;
		end
		3'd7: begin
			comb_t_self2 <= top_capture_rp_memory7_dat_r;
		end
		4'd8: begin
			comb_t_self2 <= top_capture_rp_memory8_dat_r;
		end
		4'd9: begin
			comb_t_self2 <= top_capture_rp_memory9_dat_r;
		end
		4'd10: begin
			comb_t_self2 <= top_capture_rp_memory10_dat_r;
		end
		default: begin
			comb_t_self2 <= top_capture_rp_memory11_dat_r;
		end
	endcase
// synthesis translate_off
	dummy_d_42 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_43;
// synthesis translate_on
always @(*) begin
	sync_t_self0 <= 3'd0;
	case (top_pcsrx_decoder_input_msb_first[3:0])
		1'd0: begin
			sync_t_self0 <= 1'd0;
		end
		1'd1: begin
			sync_t_self0 <= 1'd0;
		end
		2'd2: begin
			sync_t_self0 <= 3'd4;
		end
		2'd3: begin
			sync_t_self0 <= 2'd3;
		end
		3'd4: begin
			sync_t_self0 <= 1'd0;
		end
		3'd5: begin
			sync_t_self0 <= 2'd2;
		end
		3'd6: begin
			sync_t_self0 <= 3'd6;
		end
		3'd7: begin
			sync_t_self0 <= 1'd0;
		end
		4'd8: begin
			sync_t_self0 <= 3'd7;
		end
		4'd9: begin
			sync_t_self0 <= 1'd1;
		end
		4'd10: begin
			sync_t_self0 <= 3'd5;
		end
		4'd11: begin
			sync_t_self0 <= 1'd0;
		end
		4'd12: begin
			sync_t_self0 <= 1'd0;
		end
		4'd13: begin
			sync_t_self0 <= 1'd0;
		end
		4'd14: begin
			sync_t_self0 <= 1'd0;
		end
		default: begin
			sync_t_self0 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_43 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_44;
// synthesis translate_on
always @(*) begin
	sync_t_self1 <= 3'd0;
	case (top_pcsrx_decoder_input_msb_first[3:0])
		1'd0: begin
			sync_t_self1 <= 1'd0;
		end
		1'd1: begin
			sync_t_self1 <= 1'd0;
		end
		2'd2: begin
			sync_t_self1 <= 1'd0;
		end
		2'd3: begin
			sync_t_self1 <= 1'd0;
		end
		3'd4: begin
			sync_t_self1 <= 1'd0;
		end
		3'd5: begin
			sync_t_self1 <= 3'd5;
		end
		3'd6: begin
			sync_t_self1 <= 1'd1;
		end
		3'd7: begin
			sync_t_self1 <= 3'd7;
		end
		4'd8: begin
			sync_t_self1 <= 1'd0;
		end
		4'd9: begin
			sync_t_self1 <= 3'd6;
		end
		4'd10: begin
			sync_t_self1 <= 2'd2;
		end
		4'd11: begin
			sync_t_self1 <= 1'd0;
		end
		4'd12: begin
			sync_t_self1 <= 2'd3;
		end
		4'd13: begin
			sync_t_self1 <= 3'd4;
		end
		4'd14: begin
			sync_t_self1 <= 1'd0;
		end
		default: begin
			sync_t_self1 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_44 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_45;
// synthesis translate_on
always @(*) begin
	sync_f_self <= 3'd0;
	case (top_pcsrx_decoder_input_msb_first[3:0])
		1'd0: begin
			sync_f_self <= 1'd0;
		end
		1'd1: begin
			sync_f_self <= 3'd7;
		end
		2'd2: begin
			sync_f_self <= 3'd4;
		end
		2'd3: begin
			sync_f_self <= 2'd3;
		end
		3'd4: begin
			sync_f_self <= 1'd0;
		end
		3'd5: begin
			sync_f_self <= 2'd2;
		end
		3'd6: begin
			sync_f_self <= 3'd6;
		end
		3'd7: begin
			sync_f_self <= 3'd7;
		end
		4'd8: begin
			sync_f_self <= 3'd7;
		end
		4'd9: begin
			sync_f_self <= 1'd1;
		end
		4'd10: begin
			sync_f_self <= 3'd5;
		end
		4'd11: begin
			sync_f_self <= 1'd0;
		end
		4'd12: begin
			sync_f_self <= 2'd3;
		end
		4'd13: begin
			sync_f_self <= 3'd4;
		end
		4'd14: begin
			sync_f_self <= 3'd7;
		end
		default: begin
			sync_f_self <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_45 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_46;
// synthesis translate_on
always @(*) begin
	sync_rhs_self0 <= 6'd0;
	case (top_pcstx_encoder_d[4:0])
		1'd0: begin
			sync_rhs_self0 <= 5'd24;
		end
		1'd1: begin
			sync_rhs_self0 <= 6'd34;
		end
		2'd2: begin
			sync_rhs_self0 <= 5'd18;
		end
		2'd3: begin
			sync_rhs_self0 <= 6'd49;
		end
		3'd4: begin
			sync_rhs_self0 <= 4'd10;
		end
		3'd5: begin
			sync_rhs_self0 <= 6'd41;
		end
		3'd6: begin
			sync_rhs_self0 <= 5'd25;
		end
		3'd7: begin
			sync_rhs_self0 <= 3'd7;
		end
		4'd8: begin
			sync_rhs_self0 <= 3'd6;
		end
		4'd9: begin
			sync_rhs_self0 <= 6'd37;
		end
		4'd10: begin
			sync_rhs_self0 <= 5'd21;
		end
		4'd11: begin
			sync_rhs_self0 <= 6'd52;
		end
		4'd12: begin
			sync_rhs_self0 <= 4'd13;
		end
		4'd13: begin
			sync_rhs_self0 <= 6'd44;
		end
		4'd14: begin
			sync_rhs_self0 <= 5'd28;
		end
		4'd15: begin
			sync_rhs_self0 <= 6'd40;
		end
		5'd16: begin
			sync_rhs_self0 <= 6'd36;
		end
		5'd17: begin
			sync_rhs_self0 <= 6'd35;
		end
		5'd18: begin
			sync_rhs_self0 <= 5'd19;
		end
		5'd19: begin
			sync_rhs_self0 <= 6'd50;
		end
		5'd20: begin
			sync_rhs_self0 <= 4'd11;
		end
		5'd21: begin
			sync_rhs_self0 <= 6'd42;
		end
		5'd22: begin
			sync_rhs_self0 <= 5'd26;
		end
		5'd23: begin
			sync_rhs_self0 <= 3'd5;
		end
		5'd24: begin
			sync_rhs_self0 <= 4'd12;
		end
		5'd25: begin
			sync_rhs_self0 <= 6'd38;
		end
		5'd26: begin
			sync_rhs_self0 <= 5'd22;
		end
		5'd27: begin
			sync_rhs_self0 <= 4'd9;
		end
		5'd28: begin
			sync_rhs_self0 <= 4'd14;
		end
		5'd29: begin
			sync_rhs_self0 <= 5'd17;
		end
		5'd30: begin
			sync_rhs_self0 <= 6'd33;
		end
		default: begin
			sync_rhs_self0 <= 5'd20;
		end
	endcase
// synthesis translate_off
	dummy_d_46 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_47;
// synthesis translate_on
always @(*) begin
	sync_rhs_self1 <= 1'd0;
	case (top_pcstx_encoder_d[4:0])
		1'd0: begin
			sync_rhs_self1 <= 1'd1;
		end
		1'd1: begin
			sync_rhs_self1 <= 1'd1;
		end
		2'd2: begin
			sync_rhs_self1 <= 1'd1;
		end
		2'd3: begin
			sync_rhs_self1 <= 1'd0;
		end
		3'd4: begin
			sync_rhs_self1 <= 1'd1;
		end
		3'd5: begin
			sync_rhs_self1 <= 1'd0;
		end
		3'd6: begin
			sync_rhs_self1 <= 1'd0;
		end
		3'd7: begin
			sync_rhs_self1 <= 1'd0;
		end
		4'd8: begin
			sync_rhs_self1 <= 1'd1;
		end
		4'd9: begin
			sync_rhs_self1 <= 1'd0;
		end
		4'd10: begin
			sync_rhs_self1 <= 1'd0;
		end
		4'd11: begin
			sync_rhs_self1 <= 1'd0;
		end
		4'd12: begin
			sync_rhs_self1 <= 1'd0;
		end
		4'd13: begin
			sync_rhs_self1 <= 1'd0;
		end
		4'd14: begin
			sync_rhs_self1 <= 1'd0;
		end
		4'd15: begin
			sync_rhs_self1 <= 1'd1;
		end
		5'd16: begin
			sync_rhs_self1 <= 1'd1;
		end
		5'd17: begin
			sync_rhs_self1 <= 1'd0;
		end
		5'd18: begin
			sync_rhs_self1 <= 1'd0;
		end
		5'd19: begin
			sync_rhs_self1 <= 1'd0;
		end
		5'd20: begin
			sync_rhs_self1 <= 1'd0;
		end
		5'd21: begin
			sync_rhs_self1 <= 1'd0;
		end
		5'd22: begin
			sync_rhs_self1 <= 1'd0;
		end
		5'd23: begin
			sync_rhs_self1 <= 1'd1;
		end
		5'd24: begin
			sync_rhs_self1 <= 1'd1;
		end
		5'd25: begin
			sync_rhs_self1 <= 1'd0;
		end
		5'd26: begin
			sync_rhs_self1 <= 1'd0;
		end
		5'd27: begin
			sync_rhs_self1 <= 1'd1;
		end
		5'd28: begin
			sync_rhs_self1 <= 1'd0;
		end
		5'd29: begin
			sync_rhs_self1 <= 1'd1;
		end
		5'd30: begin
			sync_rhs_self1 <= 1'd1;
		end
		default: begin
			sync_rhs_self1 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_47 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_48;
// synthesis translate_on
always @(*) begin
	sync_rhs_self2 <= 1'd0;
	case (top_pcstx_encoder_d[4:0])
		1'd0: begin
			sync_rhs_self2 <= 1'd1;
		end
		1'd1: begin
			sync_rhs_self2 <= 1'd1;
		end
		2'd2: begin
			sync_rhs_self2 <= 1'd1;
		end
		2'd3: begin
			sync_rhs_self2 <= 1'd0;
		end
		3'd4: begin
			sync_rhs_self2 <= 1'd1;
		end
		3'd5: begin
			sync_rhs_self2 <= 1'd0;
		end
		3'd6: begin
			sync_rhs_self2 <= 1'd0;
		end
		3'd7: begin
			sync_rhs_self2 <= 1'd1;
		end
		4'd8: begin
			sync_rhs_self2 <= 1'd1;
		end
		4'd9: begin
			sync_rhs_self2 <= 1'd0;
		end
		4'd10: begin
			sync_rhs_self2 <= 1'd0;
		end
		4'd11: begin
			sync_rhs_self2 <= 1'd0;
		end
		4'd12: begin
			sync_rhs_self2 <= 1'd0;
		end
		4'd13: begin
			sync_rhs_self2 <= 1'd0;
		end
		4'd14: begin
			sync_rhs_self2 <= 1'd0;
		end
		4'd15: begin
			sync_rhs_self2 <= 1'd1;
		end
		5'd16: begin
			sync_rhs_self2 <= 1'd1;
		end
		5'd17: begin
			sync_rhs_self2 <= 1'd0;
		end
		5'd18: begin
			sync_rhs_self2 <= 1'd0;
		end
		5'd19: begin
			sync_rhs_self2 <= 1'd0;
		end
		5'd20: begin
			sync_rhs_self2 <= 1'd0;
		end
		5'd21: begin
			sync_rhs_self2 <= 1'd0;
		end
		5'd22: begin
			sync_rhs_self2 <= 1'd0;
		end
		5'd23: begin
			sync_rhs_self2 <= 1'd1;
		end
		5'd24: begin
			sync_rhs_self2 <= 1'd1;
		end
		5'd25: begin
			sync_rhs_self2 <= 1'd0;
		end
		5'd26: begin
			sync_rhs_self2 <= 1'd0;
		end
		5'd27: begin
			sync_rhs_self2 <= 1'd1;
		end
		5'd28: begin
			sync_rhs_self2 <= 1'd0;
		end
		5'd29: begin
			sync_rhs_self2 <= 1'd1;
		end
		5'd30: begin
			sync_rhs_self2 <= 1'd1;
		end
		default: begin
			sync_rhs_self2 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_48 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_49;
// synthesis translate_on
always @(*) begin
	sync_rhs_self3 <= 4'd0;
	case (top_pcstx_encoder_d[7:5])
		1'd0: begin
			sync_rhs_self3 <= 3'd4;
		end
		1'd1: begin
			sync_rhs_self3 <= 4'd9;
		end
		2'd2: begin
			sync_rhs_self3 <= 3'd5;
		end
		2'd3: begin
			sync_rhs_self3 <= 2'd3;
		end
		3'd4: begin
			sync_rhs_self3 <= 2'd2;
		end
		3'd5: begin
			sync_rhs_self3 <= 4'd10;
		end
		3'd6: begin
			sync_rhs_self3 <= 3'd6;
		end
		default: begin
			sync_rhs_self3 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_49 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_50;
// synthesis translate_on
always @(*) begin
	sync_rhs_self4 <= 1'd0;
	case (top_pcstx_encoder_d[7:5])
		1'd0: begin
			sync_rhs_self4 <= 1'd1;
		end
		1'd1: begin
			sync_rhs_self4 <= 1'd0;
		end
		2'd2: begin
			sync_rhs_self4 <= 1'd0;
		end
		2'd3: begin
			sync_rhs_self4 <= 1'd0;
		end
		3'd4: begin
			sync_rhs_self4 <= 1'd1;
		end
		3'd5: begin
			sync_rhs_self4 <= 1'd0;
		end
		3'd6: begin
			sync_rhs_self4 <= 1'd0;
		end
		default: begin
			sync_rhs_self4 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_50 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_51;
// synthesis translate_on
always @(*) begin
	sync_rhs_self5 <= 1'd0;
	case (top_pcstx_encoder_d[7:5])
		1'd0: begin
			sync_rhs_self5 <= 1'd1;
		end
		1'd1: begin
			sync_rhs_self5 <= 1'd0;
		end
		2'd2: begin
			sync_rhs_self5 <= 1'd0;
		end
		2'd3: begin
			sync_rhs_self5 <= 1'd1;
		end
		3'd4: begin
			sync_rhs_self5 <= 1'd1;
		end
		3'd5: begin
			sync_rhs_self5 <= 1'd0;
		end
		3'd6: begin
			sync_rhs_self5 <= 1'd0;
		end
		default: begin
			sync_rhs_self5 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_51 <= dummy_s;
// synthesis translate_on
end
assign xilinxasyncresetsynchronizerimpl0_async_reset = (~top_fixed_cm_locked);
assign xilinxasyncresetsynchronizerimpl1_async_reset = (~top_cap_cm_locked);
assign top_lp_abi_ping_toggle_o = xilinxmultiregimpl01;
assign top_lp_abi_pong_toggle_o = xilinxmultiregimpl11;
assign top_lp_abi_obuffer = xilinxmultiregimpl21;
assign top_seen_valid_ci_toggle_o = xilinxmultiregimpl31;
assign top_rx_config_reg_abi_toggle_o = xilinxmultiregimpl41;
assign top_rx_config_reg_ack_toggle_o = xilinxmultiregimpl51;
assign xilinxasyncresetsynchronizerimpl2_async_reset = (~top_pma_k7_gtx_basex_tx_mmcm_locked1);
assign xilinxasyncresetsynchronizerimpl3_async_reset = (~top_pma_k7_gtx_basex_rx_mmcm_locked1);
assign top_pma_k7_gtx_basex_gtxtxinit_plllock1 = xilinxmultiregimpl61;
assign top_pma_k7_gtx_basex_gtxtxinit_Xxresetdone1 = xilinxmultiregimpl71;
assign top_pma_k7_gtx_basex_gtxtxinit_Xxdlysresetdone1 = xilinxmultiregimpl81;
assign top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone1 = xilinxmultiregimpl91;
assign top_pma_k7_gtx_basex_gtxrxinit_plllock1 = xilinxmultiregimpl101;
assign top_pma_k7_gtx_basex_gtxrxinit_Xxresetdone1 = xilinxmultiregimpl111;
assign top_pma_k7_gtx_basex_gtxrxinit_Xxdlysresetdone1 = xilinxmultiregimpl121;
assign top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone1 = xilinxmultiregimpl131;
assign top_pma_k7_gtx_basex_toggle_o = xilinxmultiregimpl141;
assign top_txdatapath_cdc_produce_rdomain = xilinxmultiregimpl151;
assign top_txdatapath_cdc_consume_wdomain = xilinxmultiregimpl161;
assign top_toggle_o = xilinxmultiregimpl171;
assign top_rx_cdc_cdc_produce_rdomain = xilinxmultiregimpl181;
assign top_rx_cdc_cdc_consume_wdomain = xilinxmultiregimpl191;
assign top_pulsesynchronizer0_toggle_o = xilinxmultiregimpl201;
assign top_pulsesynchronizer1_toggle_o = xilinxmultiregimpl211;
assign top_capture_arm_cdc_toggle_o = xilinxmultiregimpl221;
assign top_capture_done_cdc_toggle_o = xilinxmultiregimpl231;
assign top_capture_pattern1 = xilinxmultiregimpl241;
assign top_capture_bank1 = xilinxmultiregimpl251;
assign top_capture_sampled0 = xilinxmultiregimpl26_xilinxmultiregimpl261;
assign xilinxmultiregimpl26_i = {STR1, DI1};
assign top_capture_sampled1 = xilinxmultiregimpl27_xilinxmultiregimpl271;
assign xilinxmultiregimpl27_i = {STR2, DI2};
assign top_capture_sampled2 = xilinxmultiregimpl28_xilinxmultiregimpl281;
assign xilinxmultiregimpl28_i = {STR3, DI3};
assign top_capture_sampled3 = xilinxmultiregimpl29_xilinxmultiregimpl291;
assign xilinxmultiregimpl29_i = {STR4, DI4};
assign top_capture_sampled4 = xilinxmultiregimpl30_xilinxmultiregimpl301;
assign xilinxmultiregimpl30_i = {STR5, DI5};
assign top_capture_sampled5 = xilinxmultiregimpl31_xilinxmultiregimpl311;
assign xilinxmultiregimpl31_i = {STR6, DI6};
assign top_capture_sampled6 = xilinxmultiregimpl32_xilinxmultiregimpl321;
assign xilinxmultiregimpl32_i = {STR7, DI7};
assign top_capture_sampled7 = xilinxmultiregimpl33_xilinxmultiregimpl331;
assign xilinxmultiregimpl33_i = {STR8, DI8};
assign top_capture_sampled8 = xilinxmultiregimpl34_xilinxmultiregimpl341;
assign xilinxmultiregimpl34_i = {STR9, DI9};
assign top_capture_sampled9 = xilinxmultiregimpl35_xilinxmultiregimpl351;
assign xilinxmultiregimpl35_i = {STR10, DI10};
assign top_capture_sampled10 = xilinxmultiregimpl36_xilinxmultiregimpl361;
assign xilinxmultiregimpl36_i = {STR11, DI11};
assign top_capture_sampled11 = xilinxmultiregimpl37_xilinxmultiregimpl371;
assign xilinxmultiregimpl37_i = {STR12, DI12};
assign top_analyzer_lines = xilinxmultiregimpl381;
assign top_analyzer_cmd = xilinxmultiregimpl391;
assign top_tdc_frontend_tdcbuffers_request0 = xilinxmultiregimpl402;
assign top_tdc_frontend_tdcbuffers_stop_request0 = xilinxmultiregimpl412;
assign top_tdc_frontend_tdcbuffers_ack_sys0 = xilinxmultiregimpl422;
assign top_tdc_frontend_tdcbuffers_seen_sys0 = xilinxmultiregimpl432;
assign top_tdc_frontend_tdcbuffers_snapshot0 = xilinxmultiregimpl441;
assign top_tdc_frontend_tdcbuffers_request1 = xilinxmultiregimpl452;
assign top_tdc_frontend_tdcbuffers_stop_request1 = xilinxmultiregimpl462;
assign top_tdc_frontend_tdcbuffers_ack_sys1 = xilinxmultiregimpl472;
assign top_tdc_frontend_tdcbuffers_seen_sys1 = xilinxmultiregimpl482;
assign top_tdc_frontend_tdcbuffers_snapshot1 = xilinxmultiregimpl491;
assign top_tdc_frontend_tdcbuffers_request2 = xilinxmultiregimpl502;
assign top_tdc_frontend_tdcbuffers_stop_request2 = xilinxmultiregimpl512;
assign top_tdc_frontend_tdcbuffers_ack_sys2 = xilinxmultiregimpl522;
assign top_tdc_frontend_tdcbuffers_seen_sys2 = xilinxmultiregimpl532;
assign top_tdc_frontend_tdcbuffers_snapshot2 = xilinxmultiregimpl541;
assign top_tdc_frontend_tdcbuffers_request3 = xilinxmultiregimpl552;
assign top_tdc_frontend_tdcbuffers_stop_request3 = xilinxmultiregimpl562;
assign top_tdc_frontend_tdcbuffers_ack_sys3 = xilinxmultiregimpl572;
assign top_tdc_frontend_tdcbuffers_seen_sys3 = xilinxmultiregimpl582;
assign top_tdc_frontend_tdcbuffers_snapshot3 = xilinxmultiregimpl591;
assign top_tdc_frontend_tdcbuffers_request4 = xilinxmultiregimpl602;
assign top_tdc_frontend_tdcbuffers_stop_request4 = xilinxmultiregimpl612;
assign top_tdc_frontend_tdcbuffers_ack_sys4 = xilinxmultiregimpl622;
assign top_tdc_frontend_tdcbuffers_seen_sys4 = xilinxmultiregimpl632;
assign top_tdc_frontend_tdcbuffers_snapshot4 = xilinxmultiregimpl641;
assign top_tdc_frontend_tdcbuffers_request5 = xilinxmultiregimpl652;
assign top_tdc_frontend_tdcbuffers_stop_request5 = xilinxmultiregimpl662;
assign top_tdc_frontend_tdcbuffers_ack_sys5 = xilinxmultiregimpl672;
assign top_tdc_frontend_tdcbuffers_seen_sys5 = xilinxmultiregimpl682;
assign top_tdc_frontend_tdcbuffers_snapshot5 = xilinxmultiregimpl691;
assign top_tdc_frontend_tdcbuffers_request6 = xilinxmultiregimpl702;
assign top_tdc_frontend_tdcbuffers_stop_request6 = xilinxmultiregimpl712;
assign top_tdc_frontend_tdcbuffers_ack_sys6 = xilinxmultiregimpl722;
assign top_tdc_frontend_tdcbuffers_seen_sys6 = xilinxmultiregimpl732;
assign top_tdc_frontend_tdcbuffers_snapshot6 = xilinxmultiregimpl741;
assign top_tdc_frontend_tdcbuffers_request7 = xilinxmultiregimpl752;
assign top_tdc_frontend_tdcbuffers_stop_request7 = xilinxmultiregimpl762;
assign top_tdc_frontend_tdcbuffers_ack_sys7 = xilinxmultiregimpl772;
assign top_tdc_frontend_tdcbuffers_seen_sys7 = xilinxmultiregimpl782;
assign top_tdc_frontend_tdcbuffers_snapshot7 = xilinxmultiregimpl791;
assign top_tdc_frontend_tdcbuffers_request8 = xilinxmultiregimpl802;
assign top_tdc_frontend_tdcbuffers_stop_request8 = xilinxmultiregimpl812;
assign top_tdc_frontend_tdcbuffers_ack_sys8 = xilinxmultiregimpl822;
assign top_tdc_frontend_tdcbuffers_seen_sys8 = xilinxmultiregimpl832;
assign top_tdc_frontend_tdcbuffers_snapshot8 = xilinxmultiregimpl841;
assign top_tdc_frontend_tdcbuffers_request9 = xilinxmultiregimpl852;
assign top_tdc_frontend_tdcbuffers_stop_request9 = xilinxmultiregimpl862;
assign top_tdc_frontend_tdcbuffers_ack_sys9 = xilinxmultiregimpl872;
assign top_tdc_frontend_tdcbuffers_seen_sys9 = xilinxmultiregimpl882;
assign top_tdc_frontend_tdcbuffers_snapshot9 = xilinxmultiregimpl891;
assign top_tdc_frontend_tdcbuffers_request10 = xilinxmultiregimpl902;
assign top_tdc_frontend_tdcbuffers_stop_request10 = xilinxmultiregimpl912;
assign top_tdc_frontend_tdcbuffers_ack_sys10 = xilinxmultiregimpl922;
assign top_tdc_frontend_tdcbuffers_seen_sys10 = xilinxmultiregimpl932;
assign top_tdc_frontend_tdcbuffers_snapshot10 = xilinxmultiregimpl941;
assign top_tdc_frontend_tdcbuffers_request11 = xilinxmultiregimpl952;
assign top_tdc_frontend_tdcbuffers_stop_request11 = xilinxmultiregimpl962;
assign top_tdc_frontend_tdcbuffers_ack_sys11 = xilinxmultiregimpl972;
assign top_tdc_frontend_tdcbuffers_seen_sys11 = xilinxmultiregimpl982;
assign top_tdc_frontend_tdcbuffers_snapshot11 = xilinxmultiregimpl991;
assign top_tdc_frontend_local_reset0 = xilinxmultiregimpl1001;
assign top_tdc_frontend_hb_sys0 = xilinxmultiregimpl101_xilinxmultiregimpl1011;
assign xilinxmultiregimpl101_i = top_tdc_frontend_heartbeat0[4];
assign top_tdc_frontend_local_reset1 = xilinxmultiregimpl1041;
assign top_tdc_frontend_hb_sys1 = xilinxmultiregimpl105_xilinxmultiregimpl1051;
assign xilinxmultiregimpl105_i = top_tdc_frontend_heartbeat1[4];
assign top_tdc_frontend_local_reset2 = xilinxmultiregimpl1081;
assign top_tdc_frontend_hb_sys2 = xilinxmultiregimpl109_xilinxmultiregimpl1091;
assign xilinxmultiregimpl109_i = top_tdc_frontend_heartbeat2[4];

// synthesis translate_off
reg dummy_d_52;
// synthesis translate_on
always @(*) begin
	top_tdc_frontend_locks <= 3'd0;
	top_tdc_frontend_locks[0] <= xilinxmultiregimpl1021;
	top_tdc_frontend_locks[1] <= xilinxmultiregimpl1061;
	top_tdc_frontend_locks[2] <= xilinxmultiregimpl1101;
// synthesis translate_off
	dummy_d_52 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_53;
// synthesis translate_on
always @(*) begin
	top_tdc_frontend_phased <= 3'd0;
	top_tdc_frontend_phased[0] <= xilinxmultiregimpl1031;
	top_tdc_frontend_phased[1] <= xilinxmultiregimpl1071;
	top_tdc_frontend_phased[2] <= xilinxmultiregimpl1111;
// synthesis translate_off
	dummy_d_53 <= dummy_s;
// synthesis translate_on
end
assign top_hdmi_cmd = xilinxmultiregimpl1121;
assign top_hdmi_locked = xilinxmultiregimpl1131;
assign top_hdmi_scratch = xilinxmultiregimpl1141;
assign top_hdmi_writes = xilinxmultiregimpl1151;
assign top_phy_request = xilinxmultiregimpl116_xilinxmultiregimpl1161;
assign xilinxmultiregimpl116_i = (top_command == 15'd27474);
assign top_link = xilinxmultiregimpl1171;
assign top_lock = xilinxmultiregimpl1181;
assign top_netlock = xilinxmultiregimpl1191;
assign top_registers_mcu_scratch = xilinxmultiregimpl1201;
assign top_registers_mcu_writes = xilinxmultiregimpl1211;

always @(posedge cap_clk) begin
	if (top_capture_arm_cdc_o) begin
		top_capture_active <= 1'd1;
		top_capture_index <= 1'd0;
	end else begin
		if (top_capture_active) begin
			if ((top_capture_index == 12'd4095)) begin
				top_capture_active <= 1'd0;
			end else begin
				top_capture_index <= (top_capture_index + 1'd1);
			end
		end
	end
	top_capture_arm_cdc_toggle_o_r <= top_capture_arm_cdc_toggle_o;
	if (top_capture_done_cdc_i) begin
		top_capture_done_cdc_toggle_i <= (~top_capture_done_cdc_toggle_i);
	end
	top_hdmi_phase <= (top_hdmi_phase + 1'd1);
	top_hdmi_div <= (top_hdmi_div + 1'd1);
	top_hdmi_oldmode <= top_hdmi_cmd[5:4];
	if (((top_hdmi_cmd[5:4] != top_hdmi_oldmode) | top_hdmi_cmd[7])) begin
		top_hdmi_div <= 1'd0;
		top_hdmi0 <= 1'd1;
		top_hdmi1 <= 5'd19;
		top_hdmi2 <= 6'd53;
		top_hdmi3 <= 7'd87;
	end else begin
		if (((top_hdmi_cmd[5:4] == 2'd2) | ((top_hdmi_cmd[5:4] == 2'd3) & (top_hdmi_div == 1'd0)))) begin
			top_hdmi0 <= {top_hdmi0[5:0], (top_hdmi0[6] ^ top_hdmi0[5])};
			top_hdmi1 <= {top_hdmi1[5:0], (top_hdmi1[6] ^ top_hdmi1[5])};
			top_hdmi2 <= {top_hdmi2[5:0], (top_hdmi2[6] ^ top_hdmi2[5])};
			top_hdmi3 <= {top_hdmi3[5:0], (top_hdmi3[6] ^ top_hdmi3[5])};
		end
	end
	if (cap_rst) begin
		top_capture_active <= 1'd0;
		top_capture_index <= 12'd0;
		top_hdmi_phase <= 3'd0;
		top_hdmi_div <= 8'd0;
		top_hdmi_oldmode <= 2'd0;
		top_hdmi0 <= 7'd1;
		top_hdmi1 <= 7'd19;
		top_hdmi2 <= 7'd53;
		top_hdmi3 <= 7'd87;
	end
	xilinxmultiregimpl220 <= top_capture_arm_cdc_toggle_i;
	xilinxmultiregimpl221 <= xilinxmultiregimpl220;
	xilinxmultiregimpl240 <= top_capture_pattern0;
	xilinxmultiregimpl241 <= xilinxmultiregimpl240;
	xilinxmultiregimpl250 <= top_capture_bank0;
	xilinxmultiregimpl251 <= xilinxmultiregimpl250;
	xilinxmultiregimpl26_xilinxmultiregimpl260 <= {STR1, DI1};
	xilinxmultiregimpl26_xilinxmultiregimpl261 <= xilinxmultiregimpl26_xilinxmultiregimpl260;
	xilinxmultiregimpl27_xilinxmultiregimpl270 <= {STR2, DI2};
	xilinxmultiregimpl27_xilinxmultiregimpl271 <= xilinxmultiregimpl27_xilinxmultiregimpl270;
	xilinxmultiregimpl28_xilinxmultiregimpl280 <= {STR3, DI3};
	xilinxmultiregimpl28_xilinxmultiregimpl281 <= xilinxmultiregimpl28_xilinxmultiregimpl280;
	xilinxmultiregimpl29_xilinxmultiregimpl290 <= {STR4, DI4};
	xilinxmultiregimpl29_xilinxmultiregimpl291 <= xilinxmultiregimpl29_xilinxmultiregimpl290;
	xilinxmultiregimpl30_xilinxmultiregimpl300 <= {STR5, DI5};
	xilinxmultiregimpl30_xilinxmultiregimpl301 <= xilinxmultiregimpl30_xilinxmultiregimpl300;
	xilinxmultiregimpl31_xilinxmultiregimpl310 <= {STR6, DI6};
	xilinxmultiregimpl31_xilinxmultiregimpl311 <= xilinxmultiregimpl31_xilinxmultiregimpl310;
	xilinxmultiregimpl32_xilinxmultiregimpl320 <= {STR7, DI7};
	xilinxmultiregimpl32_xilinxmultiregimpl321 <= xilinxmultiregimpl32_xilinxmultiregimpl320;
	xilinxmultiregimpl33_xilinxmultiregimpl330 <= {STR8, DI8};
	xilinxmultiregimpl33_xilinxmultiregimpl331 <= xilinxmultiregimpl33_xilinxmultiregimpl330;
	xilinxmultiregimpl34_xilinxmultiregimpl340 <= {STR9, DI9};
	xilinxmultiregimpl34_xilinxmultiregimpl341 <= xilinxmultiregimpl34_xilinxmultiregimpl340;
	xilinxmultiregimpl35_xilinxmultiregimpl350 <= {STR10, DI10};
	xilinxmultiregimpl35_xilinxmultiregimpl351 <= xilinxmultiregimpl35_xilinxmultiregimpl350;
	xilinxmultiregimpl36_xilinxmultiregimpl360 <= {STR11, DI11};
	xilinxmultiregimpl36_xilinxmultiregimpl361 <= xilinxmultiregimpl36_xilinxmultiregimpl360;
	xilinxmultiregimpl37_xilinxmultiregimpl370 <= {STR12, DI12};
	xilinxmultiregimpl37_xilinxmultiregimpl371 <= xilinxmultiregimpl37_xilinxmultiregimpl370;
	xilinxmultiregimpl1120 <= top_hdmi_command;
	xilinxmultiregimpl1121 <= xilinxmultiregimpl1120;
end

always @(posedge coarse1_clk) begin
	top_tdc_frontend_coarse_count0 <= (top_tdc_frontend_coarse_count0 + 1'd1);
	top_tdc_frontend_s10 <= top_tdc_frontend_st0;
	top_tdc_frontend_s20 <= top_tdc_frontend_s10;
	if ((top_tdc_frontend_st0 & (~top_tdc_frontend_s10))) begin
		top_tdc_frontend_bc_time0 <= {top_tdc_frontend_coarse_count0, top_tdc_frontend_bits0};
	end
	if ((top_tdc_frontend_s10 & (~top_tdc_frontend_s20))) begin
		top_tdc_frontend_old0 <= top_tdc_frontend_bc_time0[1:0];
	end
	top_tdc_frontend_jump0 <= ((top_tdc_frontend_s10 & (~top_tdc_frontend_s20)) & (top_tdc_frontend_old0 != top_tdc_frontend_bc_time0[1:0]));
	if (coarse1_rst) begin
		top_tdc_frontend_coarse_count0 <= 4'd0;
		top_tdc_frontend_bc_time0 <= 7'd0;
		top_tdc_frontend_jump0 <= 1'd0;
		top_tdc_frontend_old0 <= 2'd0;
		top_tdc_frontend_s10 <= 1'd0;
		top_tdc_frontend_s20 <= 1'd0;
	end
	xilinxmultiregimpl1000 <= sys_rst;
	xilinxmultiregimpl1001 <= xilinxmultiregimpl1000;
end

always @(posedge coarse2_clk) begin
	top_tdc_frontend_coarse_count1 <= (top_tdc_frontend_coarse_count1 + 1'd1);
	top_tdc_frontend_s11 <= top_tdc_frontend_st1;
	top_tdc_frontend_s21 <= top_tdc_frontend_s11;
	if ((top_tdc_frontend_st1 & (~top_tdc_frontend_s11))) begin
		top_tdc_frontend_bc_time1 <= {top_tdc_frontend_coarse_count1, top_tdc_frontend_bits1};
	end
	if ((top_tdc_frontend_s11 & (~top_tdc_frontend_s21))) begin
		top_tdc_frontend_old1 <= top_tdc_frontend_bc_time1[1:0];
	end
	top_tdc_frontend_jump1 <= ((top_tdc_frontend_s11 & (~top_tdc_frontend_s21)) & (top_tdc_frontend_old1 != top_tdc_frontend_bc_time1[1:0]));
	if (coarse2_rst) begin
		top_tdc_frontend_coarse_count1 <= 4'd0;
		top_tdc_frontend_bc_time1 <= 7'd0;
		top_tdc_frontend_jump1 <= 1'd0;
		top_tdc_frontend_old1 <= 2'd0;
		top_tdc_frontend_s11 <= 1'd0;
		top_tdc_frontend_s21 <= 1'd0;
	end
	xilinxmultiregimpl1040 <= sys_rst;
	xilinxmultiregimpl1041 <= xilinxmultiregimpl1040;
end

always @(posedge coarse3_clk) begin
	top_tdc_frontend_coarse_count2 <= (top_tdc_frontend_coarse_count2 + 1'd1);
	top_tdc_frontend_s12 <= top_tdc_frontend_st2;
	top_tdc_frontend_s22 <= top_tdc_frontend_s12;
	if ((top_tdc_frontend_st2 & (~top_tdc_frontend_s12))) begin
		top_tdc_frontend_bc_time2 <= {top_tdc_frontend_coarse_count2, top_tdc_frontend_bits2};
	end
	if ((top_tdc_frontend_s12 & (~top_tdc_frontend_s22))) begin
		top_tdc_frontend_old2 <= top_tdc_frontend_bc_time2[1:0];
	end
	top_tdc_frontend_jump2 <= ((top_tdc_frontend_s12 & (~top_tdc_frontend_s22)) & (top_tdc_frontend_old2 != top_tdc_frontend_bc_time2[1:0]));
	if (coarse3_rst) begin
		top_tdc_frontend_coarse_count2 <= 4'd0;
		top_tdc_frontend_bc_time2 <= 7'd0;
		top_tdc_frontend_jump2 <= 1'd0;
		top_tdc_frontend_old2 <= 2'd0;
		top_tdc_frontend_s12 <= 1'd0;
		top_tdc_frontend_s22 <= 1'd0;
	end
	xilinxmultiregimpl1080 <= sys_rst;
	xilinxmultiregimpl1081 <= xilinxmultiregimpl1080;
end

always @(posedge eth_rx_clk) begin
	if (top_pcsrx_decoder_ce) begin
		top_pcsrx_decoder_k <= 1'd0;
		if ((top_pcsrx_decoder_input_msb_first[9:4] == 4'd15)) begin
			top_pcsrx_decoder_k <= 1'd1;
			top_pcsrx_decoder_code3b <= sync_t_self0;
		end else begin
			if ((top_pcsrx_decoder_input_msb_first[9:4] == 6'd48)) begin
				top_pcsrx_decoder_k <= 1'd1;
				top_pcsrx_decoder_code3b <= sync_t_self1;
			end else begin
				if (((top_pcsrx_decoder_input_msb_first[3:0] == 3'd7) | (top_pcsrx_decoder_input_msb_first[3:0] == 4'd8))) begin
					if (((((((top_pcsrx_decoder_input_msb_first[9:4] != 6'd35) & (top_pcsrx_decoder_input_msb_first[9:4] != 5'd19)) & (top_pcsrx_decoder_input_msb_first[9:4] != 4'd11)) & (top_pcsrx_decoder_input_msb_first[9:4] != 6'd52)) & (top_pcsrx_decoder_input_msb_first[9:4] != 6'd44)) & (top_pcsrx_decoder_input_msb_first[9:4] != 5'd28))) begin
						top_pcsrx_decoder_k <= 1'd1;
					end
				end
				top_pcsrx_decoder_code3b <= sync_f_self;
			end
		end
	end
	if (top_pcsrx_decoder_ce) begin
		top_pcsrx_decoder_ones <= (((((((((top_pcsrx_decoder_input[0] + top_pcsrx_decoder_input[1]) + top_pcsrx_decoder_input[2]) + top_pcsrx_decoder_input[3]) + top_pcsrx_decoder_input[4]) + top_pcsrx_decoder_input[5]) + top_pcsrx_decoder_input[6]) + top_pcsrx_decoder_input[7]) + top_pcsrx_decoder_input[8]) + top_pcsrx_decoder_input[9]);
	end
	if (top_pcsrx_timer_ce) begin
		top_pcsrx_count1 <= (top_pcsrx_count1 - 1'd1);
		if (((~top_pcsrx_enable) | top_pcsrx_done)) begin
			case (top_pcsrx_sgmii_speed)
				1'd0: begin
					top_pcsrx_count1 <= 7'd99;
				end
				1'd1: begin
					top_pcsrx_count1 <= 4'd9;
				end
				2'd2: begin
					top_pcsrx_count1 <= 1'd0;
				end
			endcase
		end
	end
	if (((~top_pcsrx_pipe_valid_source_valid) | top_pcsrx_pipe_valid_source_ready)) begin
		top_pcsrx_pipe_valid_source_valid <= top_pcsrx_pipe_valid_sink_valid;
		top_pcsrx_pipe_valid_source_first <= top_pcsrx_pipe_valid_sink_first;
		top_pcsrx_pipe_valid_source_last <= top_pcsrx_pipe_valid_sink_last;
		top_pcsrx_pipe_valid_source_payload_data <= top_pcsrx_pipe_valid_sink_payload_data;
	end
	clockdomainsrenamer1_state <= clockdomainsrenamer1_next_state;
	if (top_pcsrx_count0_clockdomainsrenamer1_next_value_ce) begin
		top_pcsrx_count0 <= top_pcsrx_count0_clockdomainsrenamer1_next_value;
	end
	if (clockdomainsrenamer1_next_value_ce0) begin
		top_pcsrx_config_reg[7:0] <= clockdomainsrenamer1_next_value0;
	end
	if (clockdomainsrenamer1_next_value_ce1) begin
		top_pcsrx_config_reg[15:8] <= clockdomainsrenamer1_next_value1;
	end
	top_lp_abi_starter <= 1'd0;
	if (top_lp_abi_pong_o) begin
		top_lp_abi_ibuffer <= top_lp_abi_i;
	end
	if (top_lp_abi_ping_i) begin
		top_lp_abi_ping_toggle_i <= (~top_lp_abi_ping_toggle_i);
	end
	top_lp_abi_pong_toggle_o_r <= top_lp_abi_pong_toggle_o;
	if (top_lp_abi_wait) begin
		if ((~top_lp_abi_done)) begin
			top_lp_abi_count <= (top_lp_abi_count - 1'd1);
		end
	end else begin
		top_lp_abi_count <= 8'd128;
	end
	if (top_seen_valid_ci_i) begin
		top_seen_valid_ci_toggle_i <= (~top_seen_valid_ci_toggle_i);
	end
	if (top_rx_config_reg_abi_i) begin
		top_rx_config_reg_abi_toggle_i <= (~top_rx_config_reg_abi_toggle_i);
	end
	if (top_rx_config_reg_ack_i) begin
		top_rx_config_reg_ack_toggle_i <= (~top_rx_config_reg_ack_toggle_i);
	end
	if ((top_pma_k7_gtx_basex_phase_half == top_pma_k7_gtx_basex_phase_half_rereg)) begin
		top_pma_k7_gtx_basex_rx_data1 <= top_pma_k7_gtx_basex_rx_data_half[19:10];
	end else begin
		top_pma_k7_gtx_basex_rx_data1 <= top_pma_k7_gtx_basex_rx_data_half[9:0];
	end
	top_pma_k7_gtx_basex_phase_half <= (~top_pma_k7_gtx_basex_phase_half);
	if (top_rx_packet_fifo_sink_sink_valid) begin
		top_rx_packet_fifo_invalid <= (top_rx_packet_fifo_invalid | top_rx_packet_fifo_discard);
		if (((~top_rx_packet_fifo_overflow) & (~top_rx_packet_fifo_full))) begin
			top_rx_packet_fifo_wr_ptr <= (top_rx_packet_fifo_wr_ptr + 1'd1);
		end else begin
			top_rx_packet_fifo_overflow <= 1'd1;
		end
		if (top_rx_packet_fifo_sink_sink_last) begin
			top_rx_packet_fifo_overflow <= 1'd0;
			top_rx_packet_fifo_invalid <= 1'd0;
			if (top_rx_packet_fifo_commit) begin
				top_rx_packet_fifo_commit_ptr <= (top_rx_packet_fifo_wr_ptr + 1'd1);
			end else begin
				top_rx_packet_fifo_wr_ptr <= top_rx_packet_fifo_commit_ptr;
			end
		end
	end
	if (top_rx_packet_fifo_fetch) begin
		top_rx_packet_fifo_rd_ptr <= (top_rx_packet_fifo_rd_ptr + 1'd1);
		top_rx_packet_fifo_out_valid <= 1'd1;
	end else begin
		if ((top_rx_packet_fifo_source_source_valid & top_rx_packet_fifo_source_source_ready)) begin
			top_rx_packet_fifo_out_valid <= 1'd0;
		end
	end
	if (((top_rx_packet_fifo_param_fifo_syncfifo_we & top_rx_packet_fifo_param_fifo_syncfifo_writable) & (~top_rx_packet_fifo_param_fifo_replace))) begin
		top_rx_packet_fifo_param_fifo_produce <= (top_rx_packet_fifo_param_fifo_produce + 1'd1);
	end
	if (top_rx_packet_fifo_param_fifo_do_read) begin
		top_rx_packet_fifo_param_fifo_consume <= (top_rx_packet_fifo_param_fifo_consume + 1'd1);
	end
	if (((top_rx_packet_fifo_param_fifo_syncfifo_we & top_rx_packet_fifo_param_fifo_syncfifo_writable) & (~top_rx_packet_fifo_param_fifo_replace))) begin
		if ((~top_rx_packet_fifo_param_fifo_do_read)) begin
			top_rx_packet_fifo_param_fifo_level <= (top_rx_packet_fifo_param_fifo_level + 1'd1);
		end
	end else begin
		if (top_rx_packet_fifo_param_fifo_do_read) begin
			top_rx_packet_fifo_param_fifo_level <= (top_rx_packet_fifo_param_fifo_level - 1'd1);
		end
	end
	if (top_i) begin
		top_toggle_i <= (~top_toggle_i);
	end
	top_rx_cdc_cdc_graycounter0_q_binary <= top_rx_cdc_cdc_graycounter0_q_next_binary;
	top_rx_cdc_cdc_graycounter0_q <= top_rx_cdc_cdc_graycounter0_q_next;
	if (eth_rx_rst) begin
		top_pcsrx_config_reg <= 16'd0;
		top_pcsrx_decoder_k <= 1'd0;
		top_pcsrx_count0 <= 1'd0;
		top_pcsrx_count1 <= 7'd0;
		top_pcsrx_pipe_valid_source_valid <= 1'd0;
		top_lp_abi_starter <= 1'd1;
		top_lp_abi_count <= 8'd128;
		top_pma_k7_gtx_basex_rx_data1 <= 10'd0;
		top_pma_k7_gtx_basex_phase_half <= 1'd0;
		top_rx_packet_fifo_param_fifo_level <= 3'd0;
		top_rx_packet_fifo_param_fifo_produce <= 2'd0;
		top_rx_packet_fifo_param_fifo_consume <= 2'd0;
		top_rx_packet_fifo_wr_ptr <= 12'd0;
		top_rx_packet_fifo_commit_ptr <= 12'd0;
		top_rx_packet_fifo_rd_ptr <= 12'd0;
		top_rx_packet_fifo_out_valid <= 1'd0;
		top_rx_packet_fifo_overflow <= 1'd0;
		top_rx_packet_fifo_invalid <= 1'd0;
		top_rx_cdc_cdc_graycounter0_q <= 6'd0;
		top_rx_cdc_cdc_graycounter0_q_binary <= 6'd0;
		clockdomainsrenamer1_state <= 3'd0;
	end
	xilinxmultiregimpl10 <= top_lp_abi_pong_toggle_i;
	xilinxmultiregimpl11 <= xilinxmultiregimpl10;
	xilinxmultiregimpl190 <= top_rx_cdc_cdc_graycounter1_q;
	xilinxmultiregimpl191 <= xilinxmultiregimpl190;
end

always @(posedge eth_rx_half_clk) begin
	top_pma_k7_gtx_basex_phase_half_rereg <= top_pma_k7_gtx_basex_phase_half;
end

always @(posedge eth_tx_clk) begin
	top_checker_tick <= 1'd0;
	if ((top_checker_count == 1'd0)) begin
		top_checker_tick <= 1'd1;
		top_checker_count <= 20'd720000;
	end else begin
		top_checker_count <= (top_checker_count - 1'd1);
	end
	if (top_seen_valid_ci_o) begin
		top_checker_error <= 1'd0;
	end
	if (top_checker_tick) begin
		top_checker_error <= 1'd1;
	end
	top_restart <= (top_checker_tick & top_checker_error);
	if (top_checker_tick) begin
		top_link_up <= (~top_checker_error);
	end
	top_pcstx_parity <= (~top_pcstx_parity);
	if (top_pcstx_encoder_ce0) begin
		top_pcstx_encoder_disp_in <= top_pcstx_encoder_disp_out;
	end
	if (top_pcstx_encoder_ce0) begin
		top_pcstx_encoder2 <= top_pcstx_encoder_output;
		top_pcstx_encoder3 <= top_pcstx_encoder_disp_out;
	end
	if (top_pcstx_encoder_ce1) begin
		if ((top_pcstx_encoder_k & (top_pcstx_encoder_d[4:0] == 5'd28))) begin
			top_pcstx_encoder_code6b <= 6'd48;
			top_pcstx_encoder_code6b_unbalanced <= 1'd1;
			top_pcstx_encoder_code6b_flip <= 1'd1;
		end else begin
			top_pcstx_encoder_code6b <= sync_rhs_self0;
			top_pcstx_encoder_code6b_unbalanced <= sync_rhs_self1;
			top_pcstx_encoder_code6b_flip <= sync_rhs_self2;
		end
		top_pcstx_encoder_code4b <= sync_rhs_self3;
		top_pcstx_encoder_code4b_unbalanced <= sync_rhs_self4;
		if (top_pcstx_encoder_k) begin
			top_pcstx_encoder_code4b_flip <= 1'd1;
		end else begin
			top_pcstx_encoder_code4b_flip <= sync_rhs_self5;
		end
		top_pcstx_encoder_alt7_rd0 <= 1'd0;
		top_pcstx_encoder_alt7_rd1 <= 1'd0;
		if ((top_pcstx_encoder_d[7:5] == 3'd7)) begin
			if ((((top_pcstx_encoder_d[4:0] == 5'd17) | (top_pcstx_encoder_d[4:0] == 5'd18)) | (top_pcstx_encoder_d[4:0] == 5'd20))) begin
				top_pcstx_encoder_alt7_rd0 <= 1'd1;
			end
			if ((((top_pcstx_encoder_d[4:0] == 4'd11) | (top_pcstx_encoder_d[4:0] == 4'd13)) | (top_pcstx_encoder_d[4:0] == 4'd14))) begin
				top_pcstx_encoder_alt7_rd1 <= 1'd1;
			end
			if (top_pcstx_encoder_k) begin
				top_pcstx_encoder_alt7_rd0 <= 1'd1;
				top_pcstx_encoder_alt7_rd1 <= 1'd1;
			end
		end
	end
	top_pcstx_count1 <= (top_pcstx_count1 - 1'd1);
	if (((~top_pcstx_enable) | top_pcstx_done)) begin
		case (top_pcstx_sgmii_speed)
			1'd0: begin
				top_pcstx_count1 <= 7'd99;
			end
			1'd1: begin
				top_pcstx_count1 <= 4'd9;
			end
			2'd2: begin
				top_pcstx_count1 <= 1'd0;
			end
		endcase
	end
	clockdomainsrenamer0_state <= clockdomainsrenamer0_next_state;
	if (top_pcstx_count0_clockdomainsrenamer0_next_value_ce0) begin
		top_pcstx_count0 <= top_pcstx_count0_clockdomainsrenamer0_next_value0;
	end
	if (top_pcstx_ctype_clockdomainsrenamer0_next_value_ce1) begin
		top_pcstx_ctype <= top_pcstx_ctype_clockdomainsrenamer0_next_value1;
	end
	top_lp_abi_ping_o1 <= top_lp_abi_ping_o0;
	if (top_lp_abi_ping_o1) begin
		top_lp_abi_o <= top_lp_abi_obuffer;
	end
	top_lp_abi_ping_toggle_o_r <= top_lp_abi_ping_toggle_o;
	if (top_lp_abi_pong_i) begin
		top_lp_abi_pong_toggle_i <= (~top_lp_abi_pong_toggle_i);
	end
	top_seen_valid_ci_toggle_o_r <= top_seen_valid_ci_toggle_o;
	top_rx_config_reg_abi_toggle_o_r <= top_rx_config_reg_abi_toggle_o;
	top_rx_config_reg_ack_toggle_o_r <= top_rx_config_reg_ack_toggle_o;
	if (top_waittimer0_wait) begin
		if ((~top_waittimer0_done)) begin
			top_waittimer0_count <= (top_waittimer0_count - 1'd1);
		end
	end else begin
		top_waittimer0_count <= 21'd1200000;
	end
	if (top_waittimer1_wait) begin
		if ((~top_waittimer1_done)) begin
			top_waittimer1_count <= (top_waittimer1_count - 1'd1);
		end
	end else begin
		top_waittimer1_count <= 21'd1200000;
	end
	if (top_waittimer2_wait) begin
		if ((~top_waittimer2_done)) begin
			top_waittimer2_count <= (top_waittimer2_count - 1'd1);
		end
	end else begin
		top_waittimer2_count <= 18'd192000;
	end
	if (top_pma_k7_gtx_basex_i) begin
		top_pma_k7_gtx_basex_toggle_i <= (~top_pma_k7_gtx_basex_toggle_i);
	end
	top_pma_k7_gtx_basex_buf <= {top_pma_k7_gtx_basex_tx_data1, top_pma_k7_gtx_basex_buf[19:10]};
	top_txdatapath_cdc_graycounter1_q_binary <= top_txdatapath_cdc_graycounter1_q_next_binary;
	top_txdatapath_cdc_graycounter1_q <= top_txdatapath_cdc_graycounter1_q_next;
	if (top_tx_packet_fifo_payload_fifo_syncfifo_re) begin
		top_tx_packet_fifo_payload_fifo_readable <= 1'd1;
	end else begin
		if (top_tx_packet_fifo_payload_fifo_re) begin
			top_tx_packet_fifo_payload_fifo_readable <= 1'd0;
		end
	end
	if (((top_tx_packet_fifo_payload_fifo_syncfifo_we & top_tx_packet_fifo_payload_fifo_syncfifo_writable) & (~top_tx_packet_fifo_payload_fifo_replace))) begin
		top_tx_packet_fifo_payload_fifo_produce <= (top_tx_packet_fifo_payload_fifo_produce + 1'd1);
	end
	if (top_tx_packet_fifo_payload_fifo_do_read) begin
		top_tx_packet_fifo_payload_fifo_consume <= (top_tx_packet_fifo_payload_fifo_consume + 1'd1);
	end
	if (((top_tx_packet_fifo_payload_fifo_syncfifo_we & top_tx_packet_fifo_payload_fifo_syncfifo_writable) & (~top_tx_packet_fifo_payload_fifo_replace))) begin
		if ((~top_tx_packet_fifo_payload_fifo_do_read)) begin
			top_tx_packet_fifo_payload_fifo_level0 <= (top_tx_packet_fifo_payload_fifo_level0 + 1'd1);
		end
	end else begin
		if (top_tx_packet_fifo_payload_fifo_do_read) begin
			top_tx_packet_fifo_payload_fifo_level0 <= (top_tx_packet_fifo_payload_fifo_level0 - 1'd1);
		end
	end
	if (top_tx_packet_fifo_param_fifo_syncfifo_re) begin
		top_tx_packet_fifo_param_fifo_readable <= 1'd1;
	end else begin
		if (top_tx_packet_fifo_param_fifo_re) begin
			top_tx_packet_fifo_param_fifo_readable <= 1'd0;
		end
	end
	if (((top_tx_packet_fifo_param_fifo_syncfifo_we & top_tx_packet_fifo_param_fifo_syncfifo_writable) & (~top_tx_packet_fifo_param_fifo_replace))) begin
		if ((top_tx_packet_fifo_param_fifo_produce == 3'd4)) begin
			top_tx_packet_fifo_param_fifo_produce <= 1'd0;
		end else begin
			top_tx_packet_fifo_param_fifo_produce <= (top_tx_packet_fifo_param_fifo_produce + 1'd1);
		end
	end
	if (top_tx_packet_fifo_param_fifo_do_read) begin
		if ((top_tx_packet_fifo_param_fifo_consume == 3'd4)) begin
			top_tx_packet_fifo_param_fifo_consume <= 1'd0;
		end else begin
			top_tx_packet_fifo_param_fifo_consume <= (top_tx_packet_fifo_param_fifo_consume + 1'd1);
		end
	end
	if (((top_tx_packet_fifo_param_fifo_syncfifo_we & top_tx_packet_fifo_param_fifo_syncfifo_writable) & (~top_tx_packet_fifo_param_fifo_replace))) begin
		if ((~top_tx_packet_fifo_param_fifo_do_read)) begin
			top_tx_packet_fifo_param_fifo_level0 <= (top_tx_packet_fifo_param_fifo_level0 + 1'd1);
		end
	end else begin
		if (top_tx_packet_fifo_param_fifo_do_read) begin
			top_tx_packet_fifo_param_fifo_level0 <= (top_tx_packet_fifo_param_fifo_level0 - 1'd1);
		end
	end
	txdatapath_liteethmacgap_state <= txdatapath_liteethmacgap_next_state;
	if (top_tx_gap_counter_clockdomainsrenamer_clockdomainsrenamer3_next_value_ce) begin
		top_tx_gap_counter <= top_tx_gap_counter_clockdomainsrenamer_clockdomainsrenamer3_next_value;
	end
	if (eth_tx_rst) begin
		top_pcstx_encoder3 <= 1'd0;
		top_pcstx_encoder_disp_in <= 1'd0;
		top_pcstx_encoder_code6b_flip <= 1'd0;
		top_pcstx_encoder_code4b_flip <= 1'd0;
		top_pcstx_count0 <= 1'd0;
		top_pcstx_parity <= 1'd0;
		top_pcstx_ctype <= 1'd0;
		top_pcstx_count1 <= 7'd0;
		top_link_up <= 1'd0;
		top_restart <= 1'd0;
		top_lp_abi_ping_o1 <= 1'd0;
		top_waittimer0_count <= 21'd1200000;
		top_waittimer1_count <= 21'd1200000;
		top_waittimer2_count <= 18'd192000;
		top_checker_count <= 20'd0;
		top_checker_tick <= 1'd0;
		top_checker_error <= 1'd0;
		top_pma_k7_gtx_basex_buf <= 20'd0;
		top_txdatapath_cdc_graycounter1_q <= 6'd0;
		top_txdatapath_cdc_graycounter1_q_binary <= 6'd0;
		top_tx_packet_fifo_payload_fifo_readable <= 1'd0;
		top_tx_packet_fifo_payload_fifo_level0 <= 12'd0;
		top_tx_packet_fifo_payload_fifo_produce <= 11'd0;
		top_tx_packet_fifo_payload_fifo_consume <= 11'd0;
		top_tx_packet_fifo_param_fifo_readable <= 1'd0;
		top_tx_packet_fifo_param_fifo_level0 <= 3'd0;
		top_tx_packet_fifo_param_fifo_produce <= 3'd0;
		top_tx_packet_fifo_param_fifo_consume <= 3'd0;
		clockdomainsrenamer0_state <= 3'd0;
		txdatapath_liteethmacgap_state <= 1'd0;
	end
	xilinxmultiregimpl00 <= top_lp_abi_ping_toggle_i;
	xilinxmultiregimpl01 <= xilinxmultiregimpl00;
	xilinxmultiregimpl20 <= top_lp_abi_ibuffer;
	xilinxmultiregimpl21 <= xilinxmultiregimpl20;
	xilinxmultiregimpl30 <= top_seen_valid_ci_toggle_i;
	xilinxmultiregimpl31 <= xilinxmultiregimpl30;
	xilinxmultiregimpl40 <= top_rx_config_reg_abi_toggle_i;
	xilinxmultiregimpl41 <= xilinxmultiregimpl40;
	xilinxmultiregimpl50 <= top_rx_config_reg_ack_toggle_i;
	xilinxmultiregimpl51 <= xilinxmultiregimpl50;
	xilinxmultiregimpl150 <= top_txdatapath_cdc_graycounter0_q;
	xilinxmultiregimpl151 <= xilinxmultiregimpl150;
end

always @(posedge eth_tx_half_clk) begin
	top_pma_k7_gtx_basex_tx_data_half <= top_pma_k7_gtx_basex_buf;
end

always @(posedge net_clk) begin
	if ((top_sink_valid & top_sink_ready)) begin
		top_first <= top_sink_last;
	end
	top_net_tick <= (top_net_tick + 1'd1);
	if (top_source_valid) begin
		top_rx_bytes <= (top_rx_bytes + 1'd1);
		if (top_source_last) begin
			top_rx_frames <= (top_rx_frames + 1'd1);
		end
		if (top_source_payload_error) begin
			top_rx_errors <= (top_rx_errors + 1'd1);
		end
	end
	if ((top_sink_valid & top_sink_ready)) begin
		top_tx_bytes <= (top_tx_bytes + 1'd1);
		if (top_sink_last) begin
			top_tx_frames <= (top_tx_frames + 1'd1);
		end
	end
	txdatapath_liteethmacpaddinginserter_state <= txdatapath_liteethmacpaddinginserter_next_state;
	if (top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value_ce) begin
		top_tx_padding_counter <= top_tx_padding_counter_clockdomainsrenamer_clockdomainsrenamer0_next_value;
	end
	if (top_tx_crc_is_ongoing0) begin
		top_tx_crc_cnt <= 2'd3;
	end else begin
		if ((top_tx_crc_is_ongoing1 & (~top_tx_crc_cnt_done))) begin
			top_tx_crc_cnt <= (top_tx_crc_cnt - top_tx_crc_source_ready);
		end
	end
	if (top_tx_crc_ce) begin
		top_tx_crc_reg <= top_tx_crc_crc_next;
	end
	if (top_tx_crc_reset) begin
		top_tx_crc_reg <= 32'd4294967295;
	end
	txdatapath_bufferizeendpoints_state <= txdatapath_bufferizeendpoints_next_state;
	if (top_tx_crc_crc_packet_clockdomainsrenamer_clockdomainsrenamer1_next_value_ce0) begin
		top_tx_crc_crc_packet <= top_tx_crc_crc_packet_clockdomainsrenamer_clockdomainsrenamer1_next_value0;
	end
	if (top_tx_crc_be0_clockdomainsrenamer_clockdomainsrenamer1_next_value_ce1) begin
		top_tx_crc_be0 <= top_tx_crc_be0_clockdomainsrenamer_clockdomainsrenamer1_next_value1;
	end
	if (((~top_tx_crc_pipe_valid_source_valid) | top_tx_crc_pipe_valid_source_ready)) begin
		top_tx_crc_pipe_valid_source_valid <= top_tx_crc_pipe_valid_sink_valid;
		top_tx_crc_pipe_valid_source_first <= top_tx_crc_pipe_valid_sink_first;
		top_tx_crc_pipe_valid_source_last <= top_tx_crc_pipe_valid_sink_last;
		top_tx_crc_pipe_valid_source_payload_data <= top_tx_crc_pipe_valid_sink_payload_data;
		top_tx_crc_pipe_valid_source_payload_be <= top_tx_crc_pipe_valid_sink_payload_be;
		top_tx_crc_pipe_valid_source_payload_error <= top_tx_crc_pipe_valid_sink_payload_error;
	end
	txdatapath_liteethmacpreambleinserter_state <= txdatapath_liteethmacpreambleinserter_next_state;
	if (top_tx_preamble_count_clockdomainsrenamer_clockdomainsrenamer2_next_value_ce) begin
		top_tx_preamble_count <= top_tx_preamble_count_clockdomainsrenamer_clockdomainsrenamer2_next_value;
	end
	top_txdatapath_cdc_graycounter0_q_binary <= top_txdatapath_cdc_graycounter0_q_next_binary;
	top_txdatapath_cdc_graycounter0_q <= top_txdatapath_cdc_graycounter0_q_next;
	if (top_o) begin
		top_drops_status <= (top_drops_status + 1'd1);
	end
	if (top_pulsesynchronizer0_o) begin
		top_preamble_errors_status <= (top_preamble_errors_status + 1'd1);
	end
	if (top_pulsesynchronizer1_o) begin
		top_crc_errors_status <= (top_crc_errors_status + 1'd1);
	end
	top_toggle_o_r <= top_toggle_o;
	top_rx_cdc_cdc_graycounter1_q_binary <= top_rx_cdc_cdc_graycounter1_q_next_binary;
	top_rx_cdc_cdc_graycounter1_q <= top_rx_cdc_cdc_graycounter1_q_next;
	rxdatapath_liteethmacpreamblechecker_state <= rxdatapath_liteethmacpreamblechecker_next_state;
	if (top_pulsesynchronizer0_i) begin
		top_pulsesynchronizer0_toggle_i <= (~top_pulsesynchronizer0_toggle_i);
	end
	top_pulsesynchronizer0_toggle_o_r <= top_pulsesynchronizer0_toggle_o;
	if (top_liteethmaccrc32checker_is_ongoing2) begin
		top_liteethmaccrc32checker_packet_error <= 1'd0;
	end else begin
		if ((top_liteethmaccrc32checker_sink_sink_valid & top_liteethmaccrc32checker_sink_sink_ready)) begin
			top_liteethmaccrc32checker_packet_error <= (top_liteethmaccrc32checker_packet_error | ((top_liteethmaccrc32checker_sink_sink_payload_error & top_liteethmaccrc32checker_sink_sink_payload_be) != 1'd0));
		end
	end
	if (top_liteethmaccrc32checker_crc_ce) begin
		top_liteethmaccrc32checker_crc_reg <= top_liteethmaccrc32checker_crc_crc_next;
	end
	if (top_liteethmaccrc32checker_crc_reset) begin
		top_liteethmaccrc32checker_crc_reg <= 32'd4294967295;
	end
	if (((top_liteethmaccrc32checker_syncfifo_syncfifo_we & top_liteethmaccrc32checker_syncfifo_syncfifo_writable) & (~top_liteethmaccrc32checker_syncfifo_replace))) begin
		if ((top_liteethmaccrc32checker_syncfifo_produce == 3'd4)) begin
			top_liteethmaccrc32checker_syncfifo_produce <= 1'd0;
		end else begin
			top_liteethmaccrc32checker_syncfifo_produce <= (top_liteethmaccrc32checker_syncfifo_produce + 1'd1);
		end
	end
	if (top_liteethmaccrc32checker_syncfifo_do_read) begin
		if ((top_liteethmaccrc32checker_syncfifo_consume == 3'd4)) begin
			top_liteethmaccrc32checker_syncfifo_consume <= 1'd0;
		end else begin
			top_liteethmaccrc32checker_syncfifo_consume <= (top_liteethmaccrc32checker_syncfifo_consume + 1'd1);
		end
	end
	if (((top_liteethmaccrc32checker_syncfifo_syncfifo_we & top_liteethmaccrc32checker_syncfifo_syncfifo_writable) & (~top_liteethmaccrc32checker_syncfifo_replace))) begin
		if ((~top_liteethmaccrc32checker_syncfifo_do_read)) begin
			top_liteethmaccrc32checker_syncfifo_level <= (top_liteethmaccrc32checker_syncfifo_level + 1'd1);
		end
	end else begin
		if (top_liteethmaccrc32checker_syncfifo_do_read) begin
			top_liteethmaccrc32checker_syncfifo_level <= (top_liteethmaccrc32checker_syncfifo_level - 1'd1);
		end
	end
	if (top_liteethmaccrc32checker_fifo_reset) begin
		top_liteethmaccrc32checker_syncfifo_level <= 3'd0;
		top_liteethmaccrc32checker_syncfifo_produce <= 3'd0;
		top_liteethmaccrc32checker_syncfifo_consume <= 3'd0;
	end
	rxdatapath_bufferizeendpoints_state <= rxdatapath_bufferizeendpoints_next_state;
	if (top_liteethmaccrc32checker_be_clockdomainsrenamer_next_value_ce0) begin
		top_liteethmaccrc32checker_be <= top_liteethmaccrc32checker_be_clockdomainsrenamer_next_value0;
	end
	if (top_liteethmaccrc32checker_last_error_clockdomainsrenamer_next_value_ce1) begin
		top_liteethmaccrc32checker_last_error <= top_liteethmaccrc32checker_last_error_clockdomainsrenamer_next_value1;
	end
	if (((~top_bufferizeendpoints_pipe_valid_source_valid) | top_bufferizeendpoints_pipe_valid_source_ready)) begin
		top_bufferizeendpoints_pipe_valid_source_valid <= top_bufferizeendpoints_pipe_valid_sink_valid;
		top_bufferizeendpoints_pipe_valid_source_first <= top_bufferizeendpoints_pipe_valid_sink_first;
		top_bufferizeendpoints_pipe_valid_source_last <= top_bufferizeendpoints_pipe_valid_sink_last;
		top_bufferizeendpoints_pipe_valid_source_payload_data <= top_bufferizeendpoints_pipe_valid_sink_payload_data;
		top_bufferizeendpoints_pipe_valid_source_payload_be <= top_bufferizeendpoints_pipe_valid_sink_payload_be;
		top_bufferizeendpoints_pipe_valid_source_payload_error <= top_bufferizeendpoints_pipe_valid_sink_payload_error;
	end
	if (top_pulsesynchronizer1_i) begin
		top_pulsesynchronizer1_toggle_i <= (~top_pulsesynchronizer1_toggle_i);
	end
	top_pulsesynchronizer1_toggle_o_r <= top_pulsesynchronizer1_toggle_o;
	if ((top_rx_padding_sink_valid & top_rx_padding_sink_ready)) begin
		if (top_rx_padding_sink_last) begin
			top_rx_padding_length <= 1'd0;
		end else begin
			top_rx_padding_length <= (top_rx_padding_length + top_rx_padding_length_inc);
		end
	end
	if (net_rst) begin
		top_tx_padding_counter <= 16'd0;
		top_tx_crc_reg <= 32'd4294967295;
		top_tx_crc_cnt <= 2'd3;
		top_tx_crc_pipe_valid_source_valid <= 1'd0;
		top_txdatapath_cdc_graycounter0_q <= 6'd0;
		top_txdatapath_cdc_graycounter0_q_binary <= 6'd0;
		top_preamble_errors_status <= 32'd0;
		top_crc_errors_status <= 32'd0;
		top_drops_status <= 32'd0;
		top_rx_cdc_cdc_graycounter1_q <= 6'd0;
		top_rx_cdc_cdc_graycounter1_q_binary <= 6'd0;
		top_liteethmaccrc32checker_crc_reg <= 32'd4294967295;
		top_liteethmaccrc32checker_syncfifo_level <= 3'd0;
		top_liteethmaccrc32checker_syncfifo_produce <= 3'd0;
		top_liteethmaccrc32checker_syncfifo_consume <= 3'd0;
		top_liteethmaccrc32checker_last_error <= 1'd0;
		top_liteethmaccrc32checker_packet_error <= 1'd0;
		top_bufferizeendpoints_pipe_valid_source_valid <= 1'd0;
		top_rx_padding_length <= 11'd0;
		top_first <= 1'd1;
		top_rx_bytes <= 32'd0;
		top_rx_frames <= 32'd0;
		top_tx_bytes <= 32'd0;
		top_tx_frames <= 32'd0;
		top_rx_errors <= 16'd0;
		top_net_tick <= 32'd0;
		txdatapath_liteethmacpaddinginserter_state <= 1'd0;
		txdatapath_bufferizeendpoints_state <= 2'd0;
		txdatapath_liteethmacpreambleinserter_state <= 2'd0;
		rxdatapath_liteethmacpreamblechecker_state <= 1'd0;
		rxdatapath_bufferizeendpoints_state <= 2'd0;
	end
	xilinxmultiregimpl160 <= top_txdatapath_cdc_graycounter1_q;
	xilinxmultiregimpl161 <= xilinxmultiregimpl160;
	xilinxmultiregimpl170 <= top_toggle_i;
	xilinxmultiregimpl171 <= xilinxmultiregimpl170;
	xilinxmultiregimpl180 <= top_rx_cdc_cdc_graycounter0_q;
	xilinxmultiregimpl181 <= xilinxmultiregimpl180;
	xilinxmultiregimpl200 <= top_pulsesynchronizer0_toggle_i;
	xilinxmultiregimpl201 <= xilinxmultiregimpl200;
	xilinxmultiregimpl210 <= top_pulsesynchronizer1_toggle_i;
	xilinxmultiregimpl211 <= xilinxmultiregimpl210;
end

always @(posedge sys_clk) begin
	if ((top_startup != 1'd0)) begin
		top_startup <= (top_startup - 1'd1);
	end
	if (top_registers_strobe) begin
		top_ipb_count <= (top_ipb_count + 1'd1);
	end
	top_pma_k7_gtx_basex_tx_mmcm_reset0 <= (~top_pma_k7_gtx_basex_pll_lock);
	if (top_pma_k7_gtx_basex_rx_reset) begin
		top_pma_k7_gtx_basex_cdr_locked <= 1'd0;
		top_pma_k7_gtx_basex_cdr_lock_counter <= 1'd0;
	end else begin
		if ((top_pma_k7_gtx_basex_cdr_lock_counter != 11'd1600)) begin
			top_pma_k7_gtx_basex_cdr_lock_counter <= (top_pma_k7_gtx_basex_cdr_lock_counter + 1'd1);
		end else begin
			top_pma_k7_gtx_basex_cdr_locked <= 1'd1;
		end
	end
	top_pma_k7_gtx_basex_rx_mmcm_reset0 <= (~top_pma_k7_gtx_basex_cdr_locked);
	top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone_r <= top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone1;
	top_pma_k7_gtx_basex_gtxtxinit_pllreset0 <= top_pma_k7_gtx_basex_gtxtxinit_pllreset1;
	top_pma_k7_gtx_basex_gtxtxinit_gtXxreset0 <= top_pma_k7_gtx_basex_gtxtxinit_gtXxreset1;
	top_pma_k7_gtx_basex_gtxtxinit_gtXxpd0 <= top_pma_k7_gtx_basex_gtxtxinit_gtXxpd1;
	top_pma_k7_gtx_basex_gtxtxinit_Xxdlysreset0 <= top_pma_k7_gtx_basex_gtxtxinit_Xxdlysreset1;
	top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy0 <= top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy1;
	gtxtxinit_state <= gtxtxinit_next_state;
	if (top_pma_k7_gtx_basex_gtxtxinit_reset) begin
		gtxtxinit_state <= 4'd0;
	end
	if (top_pma_k7_gtx_basex_gtxtxinit_init_delay_wait) begin
		if ((~top_pma_k7_gtx_basex_gtxtxinit_init_delay_done)) begin
			top_pma_k7_gtx_basex_gtxtxinit_init_delay_count <= (top_pma_k7_gtx_basex_gtxtxinit_init_delay_count - 1'd1);
		end
	end else begin
		top_pma_k7_gtx_basex_gtxtxinit_init_delay_count <= 5'd20;
	end
	if (top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_wait) begin
		if ((~top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_done)) begin
			top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_count <= (top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_count - 1'd1);
		end
	end else begin
		top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_count <= 11'd1024;
	end
	if (top_pma_k7_gtx_basex_gtxtxinit_watchdog_wait) begin
		if ((~top_pma_k7_gtx_basex_gtxtxinit_watchdog_done)) begin
			top_pma_k7_gtx_basex_gtxtxinit_watchdog_count <= (top_pma_k7_gtx_basex_gtxtxinit_watchdog_count - 1'd1);
		end
	end else begin
		top_pma_k7_gtx_basex_gtxtxinit_watchdog_count <= 16'd40000;
	end
	if (top_pma_k7_gtx_basex_tx_init_reset) begin
		top_pma_k7_gtx_basex_gtxtxinit_pllreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_gtXxreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_gtXxpd0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_Xxdlysreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone_r <= 1'd1;
		top_pma_k7_gtx_basex_gtxtxinit_init_delay_count <= 5'd20;
		top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_count <= 11'd1024;
		top_pma_k7_gtx_basex_gtxtxinit_watchdog_count <= 16'd40000;
		gtxtxinit_state <= 4'd0;
	end
	top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone_r <= top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone1;
	top_pma_k7_gtx_basex_gtxrxinit_pllreset0 <= top_pma_k7_gtx_basex_gtxrxinit_pllreset1;
	top_pma_k7_gtx_basex_gtxrxinit_gtXxreset0 <= top_pma_k7_gtx_basex_gtxrxinit_gtXxreset1;
	top_pma_k7_gtx_basex_gtxrxinit_gtXxpd0 <= top_pma_k7_gtx_basex_gtxrxinit_gtXxpd1;
	top_pma_k7_gtx_basex_gtxrxinit_Xxdlysreset0 <= top_pma_k7_gtx_basex_gtxrxinit_Xxdlysreset1;
	top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy0 <= top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy1;
	gtxrxinit_state <= gtxrxinit_next_state;
	if (top_pma_k7_gtx_basex_gtxrxinit_reset) begin
		gtxrxinit_state <= 4'd0;
	end
	if (top_pma_k7_gtx_basex_gtxrxinit_init_delay_wait) begin
		if ((~top_pma_k7_gtx_basex_gtxrxinit_init_delay_done)) begin
			top_pma_k7_gtx_basex_gtxrxinit_init_delay_count <= (top_pma_k7_gtx_basex_gtxrxinit_init_delay_count - 1'd1);
		end
	end else begin
		top_pma_k7_gtx_basex_gtxrxinit_init_delay_count <= 5'd20;
	end
	if (top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_wait) begin
		if ((~top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_done)) begin
			top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_count <= (top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_count - 1'd1);
		end
	end else begin
		top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_count <= 11'd1024;
	end
	if (top_pma_k7_gtx_basex_gtxrxinit_watchdog_wait) begin
		if ((~top_pma_k7_gtx_basex_gtxrxinit_watchdog_done)) begin
			top_pma_k7_gtx_basex_gtxrxinit_watchdog_count <= (top_pma_k7_gtx_basex_gtxrxinit_watchdog_count - 1'd1);
		end
	end else begin
		top_pma_k7_gtx_basex_gtxrxinit_watchdog_count <= 16'd40000;
	end
	if (top_pma_k7_gtx_basex_rx_init_reset) begin
		top_pma_k7_gtx_basex_gtxrxinit_pllreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_gtXxreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_gtXxpd0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_Xxdlysreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone_r <= 1'd1;
		top_pma_k7_gtx_basex_gtxrxinit_init_delay_count <= 5'd20;
		top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_count <= 11'd1024;
		top_pma_k7_gtx_basex_gtxrxinit_watchdog_count <= 16'd40000;
		gtxrxinit_state <= 4'd0;
	end
	top_pma_k7_gtx_basex_toggle_o_r <= top_pma_k7_gtx_basex_toggle_o;
	if (top_capture_arm_cdc_i) begin
		top_capture_arm_cdc_toggle_i <= (~top_capture_arm_cdc_toggle_i);
	end
	top_capture_done_cdc_toggle_o_r <= top_capture_done_cdc_toggle_o;
	top_analyzer_tick <= (top_analyzer_tick + 1'd1);
	if (top_analyzer_arming) begin
		top_analyzer_arm_count <= (top_analyzer_arm_count + 1'd1);
		top_analyzer_active <= 1'd1;
		top_analyzer_elapsed <= 1'd0;
		top_analyzer_count <= 1'd1;
		top_analyzer_prev <= top_analyzer_lines;
	end else begin
		if (top_analyzer_active) begin
			top_analyzer_elapsed <= (top_analyzer_elapsed + 1'd1);
			if ((top_analyzer_lines != top_analyzer_prev)) begin
				top_analyzer_prev <= top_analyzer_lines;
				top_analyzer_count <= (top_analyzer_count + 1'd1);
				if ((top_analyzer_count == 11'd2047)) begin
					top_analyzer_active <= 1'd0;
				end
			end
			if ((top_analyzer_elapsed >= 27'd119999999)) begin
				top_analyzer_active <= 1'd0;
			end
		end
	end
	top_tdc_frontend_previous0 <= top_tdc_frontend_hb_sys0;
	if ((top_tdc_frontend_hb_sys0 != top_tdc_frontend_previous0)) begin
		top_tdc_frontend_age0 <= 1'd0;
	end else begin
		if ((top_tdc_frontend_age0 != 13'd8191)) begin
			top_tdc_frontend_age0 <= (top_tdc_frontend_age0 + 1'd1);
		end
	end
	top_tdc_frontend_previous1 <= top_tdc_frontend_hb_sys1;
	if ((top_tdc_frontend_hb_sys1 != top_tdc_frontend_previous1)) begin
		top_tdc_frontend_age1 <= 1'd0;
	end else begin
		if ((top_tdc_frontend_age1 != 13'd8191)) begin
			top_tdc_frontend_age1 <= (top_tdc_frontend_age1 + 1'd1);
		end
	end
	top_tdc_frontend_previous2 <= top_tdc_frontend_hb_sys2;
	if ((top_tdc_frontend_hb_sys2 != top_tdc_frontend_previous2)) begin
		top_tdc_frontend_age2 <= 1'd0;
	end else begin
		if ((top_tdc_frontend_age2 != 13'd8191)) begin
			top_tdc_frontend_age2 <= (top_tdc_frontend_age2 + 1'd1);
		end
	end
	top_tdc_frontend_tdcbuffers_done <= 1'd0;
	top_tdc_frontend_tdcbuffers_rejected <= 1'd0;
	if (top_tdc_frontend_tdcbuffers_arm) begin
		if ((top_tdc_frontend_tdcbuffers_ready & (~top_tdc_frontend_tdcbuffers_stop))) begin
			top_tdc_frontend_tdcbuffers_epoch <= (~top_tdc_frontend_tdcbuffers_epoch);
			top_tdc_frontend_tdcbuffers_busy <= 1'd1;
			top_tdc_frontend_tdcbuffers_valid <= 1'd0;
			top_tdc_frontend_tdcbuffers0 <= 1'd0;
			top_tdc_frontend_tdcbuffers1 <= 1'd0;
			top_tdc_frontend_tdcbuffers2 <= 1'd0;
			top_tdc_frontend_tdcbuffers3 <= 1'd0;
			top_tdc_frontend_tdcbuffers4 <= 1'd0;
			top_tdc_frontend_tdcbuffers5 <= 1'd0;
			top_tdc_frontend_tdcbuffers6 <= 1'd0;
			top_tdc_frontend_tdcbuffers7 <= 1'd0;
			top_tdc_frontend_tdcbuffers8 <= 1'd0;
			top_tdc_frontend_tdcbuffers9 <= 1'd0;
			top_tdc_frontend_tdcbuffers10 <= 1'd0;
			top_tdc_frontend_tdcbuffers11 <= 1'd0;
		end else begin
			top_tdc_frontend_tdcbuffers_rejected <= 1'd1;
		end
	end
	if (top_tdc_frontend_tdcbuffers_stop) begin
		if ((top_tdc_frontend_tdcbuffers_started & (~top_tdc_frontend_tdcbuffers_arm))) begin
			top_tdc_frontend_tdcbuffers_stop_epoch <= (~top_tdc_frontend_tdcbuffers_stop_epoch);
		end else begin
			top_tdc_frontend_tdcbuffers_rejected <= 1'd1;
		end
	end
	if ((top_tdc_frontend_tdcbuffers_busy & ((((((((((((top_tdc_frontend_tdcbuffers_ack_sys0 == top_tdc_frontend_tdcbuffers_epoch) & (top_tdc_frontend_tdcbuffers_ack_sys1 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys2 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys3 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys4 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys5 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys6 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys7 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys8 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys9 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys10 == top_tdc_frontend_tdcbuffers_epoch)) & (top_tdc_frontend_tdcbuffers_ack_sys11 == top_tdc_frontend_tdcbuffers_epoch)))) begin
		top_tdc_frontend_tdcbuffers_busy <= 1'd0;
		top_tdc_frontend_tdcbuffers_valid <= 1'd1;
		top_tdc_frontend_tdcbuffers_done <= 1'd1;
		top_tdc_frontend_tdcbuffers_capture_id <= (top_tdc_frontend_tdcbuffers_capture_id + 1'd1);
		top_tdc_frontend_tdcbuffers0 <= top_tdc_frontend_tdcbuffers_snapshot0;
		top_tdc_frontend_tdcbuffers1 <= top_tdc_frontend_tdcbuffers_snapshot1;
		top_tdc_frontend_tdcbuffers2 <= top_tdc_frontend_tdcbuffers_snapshot2;
		top_tdc_frontend_tdcbuffers3 <= top_tdc_frontend_tdcbuffers_snapshot3;
		top_tdc_frontend_tdcbuffers4 <= top_tdc_frontend_tdcbuffers_snapshot4;
		top_tdc_frontend_tdcbuffers5 <= top_tdc_frontend_tdcbuffers_snapshot5;
		top_tdc_frontend_tdcbuffers6 <= top_tdc_frontend_tdcbuffers_snapshot6;
		top_tdc_frontend_tdcbuffers7 <= top_tdc_frontend_tdcbuffers_snapshot7;
		top_tdc_frontend_tdcbuffers8 <= top_tdc_frontend_tdcbuffers_snapshot8;
		top_tdc_frontend_tdcbuffers9 <= top_tdc_frontend_tdcbuffers_snapshot9;
		top_tdc_frontend_tdcbuffers10 <= top_tdc_frontend_tdcbuffers_snapshot10;
		top_tdc_frontend_tdcbuffers11 <= top_tdc_frontend_tdcbuffers_snapshot11;
	end
	top_tdc_frontend_arm <= 1'd0;
	top_tdc_frontend_stop <= 1'd0;
	top_tdc_frontend_pending <= 1'd0;
	if (top_tdc_frontend_tdcbuffers_busy) begin
		if (((~top_tdc_frontend_frontend_ready0) | (top_tdc_frontend_elapsed == 26'd40000000))) begin
			top_tdc_frontend_fault <= 1'd1;
		end else begin
			top_tdc_frontend_elapsed <= (top_tdc_frontend_elapsed + 1'd1);
		end
	end else begin
		top_tdc_frontend_elapsed <= 1'd0;
	end
	if ((((top_tdc_frontend_commit & top_tdc_frontend_write) & top_tdc_frontend_selected) & (~top_tdc_frontend_error))) begin
		top_tdc_frontend_pending <= 1'd1;
		if ((top_tdc_frontend_wdata == 1'd1)) begin
			top_tdc_frontend_arm <= 1'd1;
		end else begin
			top_tdc_frontend_stop <= 1'd1;
		end
	end
	if ((((top_hdmi_commit & top_hdmi_selected) & top_hdmi_write) & (~top_hdmi_error))) begin
		top_hdmi_command <= top_hdmi_wdata;
	end
	top_registers_arm <= 1'd0;
	top_registers_trace_arm <= 1'd0;
	if (top_registers_busy) begin
		if (top_registers_settling) begin
			if ((top_registers_remaining == 1'd0)) begin
				top_registers_arm <= 1'd1;
				top_registers_settling <= 1'd0;
				top_registers_remaining <= 16'd40000;
			end else begin
				top_registers_remaining <= (top_registers_remaining - 1'd1);
			end
		end else begin
			if (((top_registers_remaining == 1'd0) | (~top_registers_locked))) begin
				top_registers_busy <= 1'd0;
				top_registers_valid <= 1'd0;
				top_registers_timed_out <= 1'd1;
			end else begin
				if (top_capture_done) begin
					top_registers_busy <= 1'd0;
					top_registers_valid <= 1'd1;
					top_registers_capture_id <= (top_registers_capture_id + 1'd1);
				end else begin
					top_registers_remaining <= (top_registers_remaining - 1'd1);
				end
			end
		end
	end
	top_registers_uptime <= (top_registers_uptime + 1'd1);
	state <= next_state;
	if (top_registers_adr_registers_next_value_ce0) begin
		top_registers_adr <= top_registers_adr_registers_next_value0;
	end
	if (top_registers_wd_registers_next_value_ce1) begin
		top_registers_wd <= top_registers_wd_registers_next_value1;
	end
	if (top_registers_wr_registers_next_value_ce2) begin
		top_registers_wr <= top_registers_wr_registers_next_value2;
	end
	if (top_registers_ack_registers_next_value_ce3) begin
		top_registers_ack <= top_registers_ack_registers_next_value3;
	end
	if (top_registers_err_registers_next_value_ce4) begin
		top_registers_err <= top_registers_err_registers_next_value4;
	end
	if (top_registers_rdata_registers_next_value_ce5) begin
		top_registers_rdata <= top_registers_rdata_registers_next_value5;
	end
	if (top_registers_writes_registers_next_value_ce6) begin
		top_registers_writes <= top_registers_writes_registers_next_value6;
	end
	if (top_registers_scratch_registers_next_value_ce7) begin
		top_registers_scratch <= top_registers_scratch_registers_next_value7;
	end
	if (top_registers_valid_registers_t_next_value_ce0) begin
		top_registers_valid <= top_registers_valid_registers_t_next_value0;
	end
	if (top_registers_bank_registers_t_next_value_ce1) begin
		top_registers_bank <= top_registers_bank_registers_t_next_value1;
	end
	if (top_registers_pattern_registers_t_next_value_ce2) begin
		top_registers_pattern <= top_registers_pattern_registers_t_next_value2;
	end
	if (top_registers_ev_registers_t_next_value_ce3) begin
		top_registers_ev <= top_registers_ev_registers_t_next_value3;
	end
	if (top_registers_busy_registers_t_next_value_ce4) begin
		top_registers_busy <= top_registers_busy_registers_t_next_value4;
	end
	if (top_registers_timed_out_registers_t_next_value_ce5) begin
		top_registers_timed_out <= top_registers_timed_out_registers_t_next_value5;
	end
	if (top_registers_settling_registers_t_next_value_ce6) begin
		top_registers_settling <= top_registers_settling_registers_t_next_value6;
	end
	if (top_registers_remaining_registers_t_next_value_ce7) begin
		top_registers_remaining <= top_registers_remaining_registers_t_next_value7;
	end
	if (top_registers_trace_arm_registers_f_next_value_ce) begin
		top_registers_trace_arm <= top_registers_trace_arm_registers_f_next_value;
	end
	if (sys_rst) begin
		top_pma_k7_gtx_basex_tx_mmcm_reset0 <= 1'd1;
		top_pma_k7_gtx_basex_rx_mmcm_reset0 <= 1'd1;
		top_pma_k7_gtx_basex_gtxtxinit_pllreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_gtXxreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_gtXxpd0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_Xxdlysreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone_r <= 1'd1;
		top_pma_k7_gtx_basex_gtxtxinit_init_delay_count <= 5'd20;
		top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_count <= 11'd1024;
		top_pma_k7_gtx_basex_gtxtxinit_watchdog_count <= 16'd40000;
		top_pma_k7_gtx_basex_gtxrxinit_pllreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_gtXxreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_gtXxpd0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_Xxdlysreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone_r <= 1'd1;
		top_pma_k7_gtx_basex_gtxrxinit_init_delay_count <= 5'd20;
		top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_count <= 11'd1024;
		top_pma_k7_gtx_basex_gtxrxinit_watchdog_count <= 16'd40000;
		top_pma_k7_gtx_basex_cdr_lock_counter <= 11'd0;
		top_pma_k7_gtx_basex_cdr_locked <= 1'd0;
		top_analyzer_arm_count <= 32'd0;
		top_analyzer_count <= 12'd0;
		top_analyzer_active <= 1'd0;
		top_analyzer_elapsed <= 32'd0;
		top_analyzer_tick <= 32'd0;
		top_analyzer_prev <= 3'd7;
		top_tdc_frontend_tdcbuffers_busy <= 1'd0;
		top_tdc_frontend_tdcbuffers_valid <= 1'd0;
		top_tdc_frontend_tdcbuffers_done <= 1'd0;
		top_tdc_frontend_tdcbuffers_rejected <= 1'd0;
		top_tdc_frontend_tdcbuffers_capture_id <= 32'd0;
		top_tdc_frontend_tdcbuffers0 <= 13'd0;
		top_tdc_frontend_tdcbuffers1 <= 13'd0;
		top_tdc_frontend_tdcbuffers2 <= 13'd0;
		top_tdc_frontend_tdcbuffers3 <= 13'd0;
		top_tdc_frontend_tdcbuffers4 <= 13'd0;
		top_tdc_frontend_tdcbuffers5 <= 13'd0;
		top_tdc_frontend_tdcbuffers6 <= 13'd0;
		top_tdc_frontend_tdcbuffers7 <= 13'd0;
		top_tdc_frontend_tdcbuffers8 <= 13'd0;
		top_tdc_frontend_tdcbuffers9 <= 13'd0;
		top_tdc_frontend_tdcbuffers10 <= 13'd0;
		top_tdc_frontend_tdcbuffers11 <= 13'd0;
		top_tdc_frontend_tdcbuffers_epoch <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_epoch <= 1'd0;
		top_tdc_frontend_fault <= 1'd0;
		top_tdc_frontend_arm <= 1'd0;
		top_tdc_frontend_stop <= 1'd0;
		top_tdc_frontend_elapsed <= 26'd0;
		top_tdc_frontend_pending <= 1'd0;
		top_tdc_frontend_previous0 <= 1'd0;
		top_tdc_frontend_age0 <= 13'd8191;
		top_tdc_frontend_previous1 <= 1'd0;
		top_tdc_frontend_age1 <= 13'd8191;
		top_tdc_frontend_previous2 <= 1'd0;
		top_tdc_frontend_age2 <= 13'd8191;
		top_hdmi_command <= 8'd0;
		top_registers_rdata <= 32'd0;
		top_registers_ack <= 1'd0;
		top_registers_err <= 1'd0;
		top_registers_ev <= 1'd0;
		top_registers_scratch <= 32'd0;
		top_registers_writes <= 32'd0;
		top_registers_valid <= 1'd0;
		top_registers_busy <= 1'd0;
		top_registers_capture_id <= 32'd0;
		top_registers_timed_out <= 1'd0;
		top_registers_pattern <= 1'd0;
		top_registers_bank <= 1'd0;
		top_registers_remaining <= 16'd0;
		top_registers_settling <= 1'd0;
		top_registers_arm <= 1'd0;
		top_registers_trace_arm <= 1'd0;
		top_registers_adr <= 32'd0;
		top_registers_wd <= 32'd0;
		top_registers_wr <= 1'd0;
		top_registers_uptime <= 64'd0;
		top_startup <= 21'd2000000;
		top_ipb_count <= 32'd0;
		gtxtxinit_state <= 4'd0;
		gtxrxinit_state <= 4'd0;
		state <= 2'd0;
	end
	xilinxmultiregimpl60 <= top_pma_k7_gtx_basex_gtxtxinit_plllock0;
	xilinxmultiregimpl61 <= xilinxmultiregimpl60;
	xilinxmultiregimpl70 <= top_pma_k7_gtx_basex_gtxtxinit_Xxresetdone0;
	xilinxmultiregimpl71 <= xilinxmultiregimpl70;
	xilinxmultiregimpl80 <= top_pma_k7_gtx_basex_gtxtxinit_Xxdlysresetdone0;
	xilinxmultiregimpl81 <= xilinxmultiregimpl80;
	xilinxmultiregimpl90 <= top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone0;
	xilinxmultiregimpl91 <= xilinxmultiregimpl90;
	xilinxmultiregimpl100 <= top_pma_k7_gtx_basex_gtxrxinit_plllock0;
	xilinxmultiregimpl101 <= xilinxmultiregimpl100;
	xilinxmultiregimpl110 <= top_pma_k7_gtx_basex_gtxrxinit_Xxresetdone0;
	xilinxmultiregimpl111 <= xilinxmultiregimpl110;
	xilinxmultiregimpl120 <= top_pma_k7_gtx_basex_gtxrxinit_Xxdlysresetdone0;
	xilinxmultiregimpl121 <= xilinxmultiregimpl120;
	xilinxmultiregimpl130 <= top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone0;
	xilinxmultiregimpl131 <= xilinxmultiregimpl130;
	xilinxmultiregimpl140 <= top_pma_k7_gtx_basex_toggle_i;
	xilinxmultiregimpl141 <= xilinxmultiregimpl140;
	xilinxmultiregimpl230 <= top_capture_done_cdc_toggle_i;
	xilinxmultiregimpl231 <= xilinxmultiregimpl230;
	xilinxmultiregimpl380 <= top_raw;
	xilinxmultiregimpl381 <= xilinxmultiregimpl380;
	xilinxmultiregimpl390 <= top_command;
	xilinxmultiregimpl391 <= xilinxmultiregimpl390;
	xilinxmultiregimpl420 <= top_tdc_frontend_tdcbuffers_acknowledged0;
	xilinxmultiregimpl421 <= xilinxmultiregimpl420;
	xilinxmultiregimpl422 <= xilinxmultiregimpl421;
	xilinxmultiregimpl430 <= top_tdc_frontend_tdcbuffers_seen0;
	xilinxmultiregimpl431 <= xilinxmultiregimpl430;
	xilinxmultiregimpl432 <= xilinxmultiregimpl431;
	xilinxmultiregimpl440 <= top_tdc_frontend_tdcbuffers_count0;
	xilinxmultiregimpl441 <= xilinxmultiregimpl440;
	xilinxmultiregimpl470 <= top_tdc_frontend_tdcbuffers_acknowledged1;
	xilinxmultiregimpl471 <= xilinxmultiregimpl470;
	xilinxmultiregimpl472 <= xilinxmultiregimpl471;
	xilinxmultiregimpl480 <= top_tdc_frontend_tdcbuffers_seen1;
	xilinxmultiregimpl481 <= xilinxmultiregimpl480;
	xilinxmultiregimpl482 <= xilinxmultiregimpl481;
	xilinxmultiregimpl490 <= top_tdc_frontend_tdcbuffers_count1;
	xilinxmultiregimpl491 <= xilinxmultiregimpl490;
	xilinxmultiregimpl520 <= top_tdc_frontend_tdcbuffers_acknowledged2;
	xilinxmultiregimpl521 <= xilinxmultiregimpl520;
	xilinxmultiregimpl522 <= xilinxmultiregimpl521;
	xilinxmultiregimpl530 <= top_tdc_frontend_tdcbuffers_seen2;
	xilinxmultiregimpl531 <= xilinxmultiregimpl530;
	xilinxmultiregimpl532 <= xilinxmultiregimpl531;
	xilinxmultiregimpl540 <= top_tdc_frontend_tdcbuffers_count2;
	xilinxmultiregimpl541 <= xilinxmultiregimpl540;
	xilinxmultiregimpl570 <= top_tdc_frontend_tdcbuffers_acknowledged3;
	xilinxmultiregimpl571 <= xilinxmultiregimpl570;
	xilinxmultiregimpl572 <= xilinxmultiregimpl571;
	xilinxmultiregimpl580 <= top_tdc_frontend_tdcbuffers_seen3;
	xilinxmultiregimpl581 <= xilinxmultiregimpl580;
	xilinxmultiregimpl582 <= xilinxmultiregimpl581;
	xilinxmultiregimpl590 <= top_tdc_frontend_tdcbuffers_count3;
	xilinxmultiregimpl591 <= xilinxmultiregimpl590;
	xilinxmultiregimpl620 <= top_tdc_frontend_tdcbuffers_acknowledged4;
	xilinxmultiregimpl621 <= xilinxmultiregimpl620;
	xilinxmultiregimpl622 <= xilinxmultiregimpl621;
	xilinxmultiregimpl630 <= top_tdc_frontend_tdcbuffers_seen4;
	xilinxmultiregimpl631 <= xilinxmultiregimpl630;
	xilinxmultiregimpl632 <= xilinxmultiregimpl631;
	xilinxmultiregimpl640 <= top_tdc_frontend_tdcbuffers_count4;
	xilinxmultiregimpl641 <= xilinxmultiregimpl640;
	xilinxmultiregimpl670 <= top_tdc_frontend_tdcbuffers_acknowledged5;
	xilinxmultiregimpl671 <= xilinxmultiregimpl670;
	xilinxmultiregimpl672 <= xilinxmultiregimpl671;
	xilinxmultiregimpl680 <= top_tdc_frontend_tdcbuffers_seen5;
	xilinxmultiregimpl681 <= xilinxmultiregimpl680;
	xilinxmultiregimpl682 <= xilinxmultiregimpl681;
	xilinxmultiregimpl690 <= top_tdc_frontend_tdcbuffers_count5;
	xilinxmultiregimpl691 <= xilinxmultiregimpl690;
	xilinxmultiregimpl720 <= top_tdc_frontend_tdcbuffers_acknowledged6;
	xilinxmultiregimpl721 <= xilinxmultiregimpl720;
	xilinxmultiregimpl722 <= xilinxmultiregimpl721;
	xilinxmultiregimpl730 <= top_tdc_frontend_tdcbuffers_seen6;
	xilinxmultiregimpl731 <= xilinxmultiregimpl730;
	xilinxmultiregimpl732 <= xilinxmultiregimpl731;
	xilinxmultiregimpl740 <= top_tdc_frontend_tdcbuffers_count6;
	xilinxmultiregimpl741 <= xilinxmultiregimpl740;
	xilinxmultiregimpl770 <= top_tdc_frontend_tdcbuffers_acknowledged7;
	xilinxmultiregimpl771 <= xilinxmultiregimpl770;
	xilinxmultiregimpl772 <= xilinxmultiregimpl771;
	xilinxmultiregimpl780 <= top_tdc_frontend_tdcbuffers_seen7;
	xilinxmultiregimpl781 <= xilinxmultiregimpl780;
	xilinxmultiregimpl782 <= xilinxmultiregimpl781;
	xilinxmultiregimpl790 <= top_tdc_frontend_tdcbuffers_count7;
	xilinxmultiregimpl791 <= xilinxmultiregimpl790;
	xilinxmultiregimpl820 <= top_tdc_frontend_tdcbuffers_acknowledged8;
	xilinxmultiregimpl821 <= xilinxmultiregimpl820;
	xilinxmultiregimpl822 <= xilinxmultiregimpl821;
	xilinxmultiregimpl830 <= top_tdc_frontend_tdcbuffers_seen8;
	xilinxmultiregimpl831 <= xilinxmultiregimpl830;
	xilinxmultiregimpl832 <= xilinxmultiregimpl831;
	xilinxmultiregimpl840 <= top_tdc_frontend_tdcbuffers_count8;
	xilinxmultiregimpl841 <= xilinxmultiregimpl840;
	xilinxmultiregimpl870 <= top_tdc_frontend_tdcbuffers_acknowledged9;
	xilinxmultiregimpl871 <= xilinxmultiregimpl870;
	xilinxmultiregimpl872 <= xilinxmultiregimpl871;
	xilinxmultiregimpl880 <= top_tdc_frontend_tdcbuffers_seen9;
	xilinxmultiregimpl881 <= xilinxmultiregimpl880;
	xilinxmultiregimpl882 <= xilinxmultiregimpl881;
	xilinxmultiregimpl890 <= top_tdc_frontend_tdcbuffers_count9;
	xilinxmultiregimpl891 <= xilinxmultiregimpl890;
	xilinxmultiregimpl920 <= top_tdc_frontend_tdcbuffers_acknowledged10;
	xilinxmultiregimpl921 <= xilinxmultiregimpl920;
	xilinxmultiregimpl922 <= xilinxmultiregimpl921;
	xilinxmultiregimpl930 <= top_tdc_frontend_tdcbuffers_seen10;
	xilinxmultiregimpl931 <= xilinxmultiregimpl930;
	xilinxmultiregimpl932 <= xilinxmultiregimpl931;
	xilinxmultiregimpl940 <= top_tdc_frontend_tdcbuffers_count10;
	xilinxmultiregimpl941 <= xilinxmultiregimpl940;
	xilinxmultiregimpl970 <= top_tdc_frontend_tdcbuffers_acknowledged11;
	xilinxmultiregimpl971 <= xilinxmultiregimpl970;
	xilinxmultiregimpl972 <= xilinxmultiregimpl971;
	xilinxmultiregimpl980 <= top_tdc_frontend_tdcbuffers_seen11;
	xilinxmultiregimpl981 <= xilinxmultiregimpl980;
	xilinxmultiregimpl982 <= xilinxmultiregimpl981;
	xilinxmultiregimpl990 <= top_tdc_frontend_tdcbuffers_count11;
	xilinxmultiregimpl991 <= xilinxmultiregimpl990;
	xilinxmultiregimpl101_xilinxmultiregimpl1010 <= top_tdc_frontend_heartbeat0[4];
	xilinxmultiregimpl101_xilinxmultiregimpl1011 <= xilinxmultiregimpl101_xilinxmultiregimpl1010;
	xilinxmultiregimpl1020 <= top_tdc_frontend_lock0;
	xilinxmultiregimpl1021 <= xilinxmultiregimpl1020;
	xilinxmultiregimpl1030 <= top_tdc_frontend_done0;
	xilinxmultiregimpl1031 <= xilinxmultiregimpl1030;
	xilinxmultiregimpl105_xilinxmultiregimpl1050 <= top_tdc_frontend_heartbeat1[4];
	xilinxmultiregimpl105_xilinxmultiregimpl1051 <= xilinxmultiregimpl105_xilinxmultiregimpl1050;
	xilinxmultiregimpl1060 <= top_tdc_frontend_lock1;
	xilinxmultiregimpl1061 <= xilinxmultiregimpl1060;
	xilinxmultiregimpl1070 <= top_tdc_frontend_done1;
	xilinxmultiregimpl1071 <= xilinxmultiregimpl1070;
	xilinxmultiregimpl109_xilinxmultiregimpl1090 <= top_tdc_frontend_heartbeat2[4];
	xilinxmultiregimpl109_xilinxmultiregimpl1091 <= xilinxmultiregimpl109_xilinxmultiregimpl1090;
	xilinxmultiregimpl1100 <= top_tdc_frontend_lock2;
	xilinxmultiregimpl1101 <= xilinxmultiregimpl1100;
	xilinxmultiregimpl1110 <= top_tdc_frontend_done2;
	xilinxmultiregimpl1111 <= xilinxmultiregimpl1110;
	xilinxmultiregimpl1130 <= top_cap_cm_locked;
	xilinxmultiregimpl1131 <= xilinxmultiregimpl1130;
	xilinxmultiregimpl1140 <= top_hdmi_hs;
	xilinxmultiregimpl1141 <= xilinxmultiregimpl1140;
	xilinxmultiregimpl1150 <= top_hdmi_hw;
	xilinxmultiregimpl1151 <= xilinxmultiregimpl1150;
	xilinxmultiregimpl116_xilinxmultiregimpl1160 <= (top_command == 15'd27474);
	xilinxmultiregimpl116_xilinxmultiregimpl1161 <= xilinxmultiregimpl116_xilinxmultiregimpl1160;
	xilinxmultiregimpl1170 <= top_link_up;
	xilinxmultiregimpl1171 <= xilinxmultiregimpl1170;
	xilinxmultiregimpl1180 <= top_cap_cm_locked;
	xilinxmultiregimpl1181 <= xilinxmultiregimpl1180;
	xilinxmultiregimpl1190 <= top_pma_k7_gtx_basex_tx_mmcm_locked1;
	xilinxmultiregimpl1191 <= xilinxmultiregimpl1190;
	xilinxmultiregimpl1200 <= top_scratch;
	xilinxmultiregimpl1201 <= xilinxmultiregimpl1200;
	xilinxmultiregimpl1210 <= top_writes;
	xilinxmultiregimpl1211 <= xilinxmultiregimpl1210;
end

always @(posedge tdc1_clk) begin
	top_tdc_frontend_heartbeat0 <= (top_tdc_frontend_heartbeat0 + 1'd1);
	if ((top_tdc_frontend_tdcbuffers_request0 != top_tdc_frontend_tdcbuffers_seen0)) begin
		top_tdc_frontend_tdcbuffers_seen0 <= top_tdc_frontend_tdcbuffers_request0;
		top_tdc_frontend_tdcbuffers_stop_seen0 <= top_tdc_frontend_tdcbuffers_stop_request0;
		top_tdc_frontend_tdcbuffers_count0 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active0 <= 1'd1;
	end else begin
		if ((top_tdc_frontend_tdcbuffers_stop_request0 != top_tdc_frontend_tdcbuffers_stop_seen0)) begin
			top_tdc_frontend_tdcbuffers_stop_seen0 <= top_tdc_frontend_tdcbuffers_stop_request0;
			if (top_tdc_frontend_tdcbuffers_active0) begin
				top_tdc_frontend_tdcbuffers_active0 <= 1'd0;
				top_tdc_frontend_tdcbuffers_acknowledged0 <= top_tdc_frontend_tdcbuffers_seen0;
			end
		end else begin
			if (top_tdc_frontend_tdcbuffers_active0) begin
				if ((top_tdc_frontend_tdcbuffers_count0 == 13'd4096)) begin
					top_tdc_frontend_tdcbuffers_active0 <= 1'd0;
					top_tdc_frontend_tdcbuffers_acknowledged0 <= top_tdc_frontend_tdcbuffers_seen0;
				end else begin
					if (top_tdc_frontend_tdcbuffers_event0) begin
						top_tdc_frontend_tdcbuffers_count0 <= (top_tdc_frontend_tdcbuffers_count0 + 1'd1);
					end
				end
			end
		end
	end
	if ((top_tdc_frontend_tdcbuffers_request1 != top_tdc_frontend_tdcbuffers_seen1)) begin
		top_tdc_frontend_tdcbuffers_seen1 <= top_tdc_frontend_tdcbuffers_request1;
		top_tdc_frontend_tdcbuffers_stop_seen1 <= top_tdc_frontend_tdcbuffers_stop_request1;
		top_tdc_frontend_tdcbuffers_count1 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active1 <= 1'd1;
	end else begin
		if ((top_tdc_frontend_tdcbuffers_stop_request1 != top_tdc_frontend_tdcbuffers_stop_seen1)) begin
			top_tdc_frontend_tdcbuffers_stop_seen1 <= top_tdc_frontend_tdcbuffers_stop_request1;
			if (top_tdc_frontend_tdcbuffers_active1) begin
				top_tdc_frontend_tdcbuffers_active1 <= 1'd0;
				top_tdc_frontend_tdcbuffers_acknowledged1 <= top_tdc_frontend_tdcbuffers_seen1;
			end
		end else begin
			if (top_tdc_frontend_tdcbuffers_active1) begin
				if ((top_tdc_frontend_tdcbuffers_count1 == 13'd4096)) begin
					top_tdc_frontend_tdcbuffers_active1 <= 1'd0;
					top_tdc_frontend_tdcbuffers_acknowledged1 <= top_tdc_frontend_tdcbuffers_seen1;
				end else begin
					if (top_tdc_frontend_tdcbuffers_event1) begin
						top_tdc_frontend_tdcbuffers_count1 <= (top_tdc_frontend_tdcbuffers_count1 + 1'd1);
					end
				end
			end
		end
	end
	if ((top_tdc_frontend_tdcbuffers_request2 != top_tdc_frontend_tdcbuffers_seen2)) begin
		top_tdc_frontend_tdcbuffers_seen2 <= top_tdc_frontend_tdcbuffers_request2;
		top_tdc_frontend_tdcbuffers_stop_seen2 <= top_tdc_frontend_tdcbuffers_stop_request2;
		top_tdc_frontend_tdcbuffers_count2 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active2 <= 1'd1;
	end else begin
		if ((top_tdc_frontend_tdcbuffers_stop_request2 != top_tdc_frontend_tdcbuffers_stop_seen2)) begin
			top_tdc_frontend_tdcbuffers_stop_seen2 <= top_tdc_frontend_tdcbuffers_stop_request2;
			if (top_tdc_frontend_tdcbuffers_active2) begin
				top_tdc_frontend_tdcbuffers_active2 <= 1'd0;
				top_tdc_frontend_tdcbuffers_acknowledged2 <= top_tdc_frontend_tdcbuffers_seen2;
			end
		end else begin
			if (top_tdc_frontend_tdcbuffers_active2) begin
				if ((top_tdc_frontend_tdcbuffers_count2 == 13'd4096)) begin
					top_tdc_frontend_tdcbuffers_active2 <= 1'd0;
					top_tdc_frontend_tdcbuffers_acknowledged2 <= top_tdc_frontend_tdcbuffers_seen2;
				end else begin
					if (top_tdc_frontend_tdcbuffers_event2) begin
						top_tdc_frontend_tdcbuffers_count2 <= (top_tdc_frontend_tdcbuffers_count2 + 1'd1);
					end
				end
			end
		end
	end
	if ((top_tdc_frontend_tdcbuffers_request3 != top_tdc_frontend_tdcbuffers_seen3)) begin
		top_tdc_frontend_tdcbuffers_seen3 <= top_tdc_frontend_tdcbuffers_request3;
		top_tdc_frontend_tdcbuffers_stop_seen3 <= top_tdc_frontend_tdcbuffers_stop_request3;
		top_tdc_frontend_tdcbuffers_count3 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active3 <= 1'd1;
	end else begin
		if ((top_tdc_frontend_tdcbuffers_stop_request3 != top_tdc_frontend_tdcbuffers_stop_seen3)) begin
			top_tdc_frontend_tdcbuffers_stop_seen3 <= top_tdc_frontend_tdcbuffers_stop_request3;
			if (top_tdc_frontend_tdcbuffers_active3) begin
				top_tdc_frontend_tdcbuffers_active3 <= 1'd0;
				top_tdc_frontend_tdcbuffers_acknowledged3 <= top_tdc_frontend_tdcbuffers_seen3;
			end
		end else begin
			if (top_tdc_frontend_tdcbuffers_active3) begin
				if ((top_tdc_frontend_tdcbuffers_count3 == 13'd4096)) begin
					top_tdc_frontend_tdcbuffers_active3 <= 1'd0;
					top_tdc_frontend_tdcbuffers_acknowledged3 <= top_tdc_frontend_tdcbuffers_seen3;
				end else begin
					if (top_tdc_frontend_tdcbuffers_event3) begin
						top_tdc_frontend_tdcbuffers_count3 <= (top_tdc_frontend_tdcbuffers_count3 + 1'd1);
					end
				end
			end
		end
	end
	if (tdc1_rst) begin
		top_tdc_frontend_tdcbuffers_seen0 <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_seen0 <= 1'd0;
		top_tdc_frontend_tdcbuffers_acknowledged0 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active0 <= 1'd0;
		top_tdc_frontend_tdcbuffers_count0 <= 13'd0;
		top_tdc_frontend_tdcbuffers_seen1 <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_seen1 <= 1'd0;
		top_tdc_frontend_tdcbuffers_acknowledged1 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active1 <= 1'd0;
		top_tdc_frontend_tdcbuffers_count1 <= 13'd0;
		top_tdc_frontend_tdcbuffers_seen2 <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_seen2 <= 1'd0;
		top_tdc_frontend_tdcbuffers_acknowledged2 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active2 <= 1'd0;
		top_tdc_frontend_tdcbuffers_count2 <= 13'd0;
		top_tdc_frontend_tdcbuffers_seen3 <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_seen3 <= 1'd0;
		top_tdc_frontend_tdcbuffers_acknowledged3 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active3 <= 1'd0;
		top_tdc_frontend_tdcbuffers_count3 <= 13'd0;
		top_tdc_frontend_heartbeat0 <= 5'd0;
	end
	xilinxmultiregimpl400 <= top_tdc_frontend_tdcbuffers_epoch;
	xilinxmultiregimpl401 <= xilinxmultiregimpl400;
	xilinxmultiregimpl402 <= xilinxmultiregimpl401;
	xilinxmultiregimpl410 <= top_tdc_frontend_tdcbuffers_stop_epoch;
	xilinxmultiregimpl411 <= xilinxmultiregimpl410;
	xilinxmultiregimpl412 <= xilinxmultiregimpl411;
	xilinxmultiregimpl450 <= top_tdc_frontend_tdcbuffers_epoch;
	xilinxmultiregimpl451 <= xilinxmultiregimpl450;
	xilinxmultiregimpl452 <= xilinxmultiregimpl451;
	xilinxmultiregimpl460 <= top_tdc_frontend_tdcbuffers_stop_epoch;
	xilinxmultiregimpl461 <= xilinxmultiregimpl460;
	xilinxmultiregimpl462 <= xilinxmultiregimpl461;
	xilinxmultiregimpl500 <= top_tdc_frontend_tdcbuffers_epoch;
	xilinxmultiregimpl501 <= xilinxmultiregimpl500;
	xilinxmultiregimpl502 <= xilinxmultiregimpl501;
	xilinxmultiregimpl510 <= top_tdc_frontend_tdcbuffers_stop_epoch;
	xilinxmultiregimpl511 <= xilinxmultiregimpl510;
	xilinxmultiregimpl512 <= xilinxmultiregimpl511;
	xilinxmultiregimpl550 <= top_tdc_frontend_tdcbuffers_epoch;
	xilinxmultiregimpl551 <= xilinxmultiregimpl550;
	xilinxmultiregimpl552 <= xilinxmultiregimpl551;
	xilinxmultiregimpl560 <= top_tdc_frontend_tdcbuffers_stop_epoch;
	xilinxmultiregimpl561 <= xilinxmultiregimpl560;
	xilinxmultiregimpl562 <= xilinxmultiregimpl561;
end

always @(posedge tdc2_clk) begin
	top_tdc_frontend_heartbeat1 <= (top_tdc_frontend_heartbeat1 + 1'd1);
	if ((top_tdc_frontend_tdcbuffers_request4 != top_tdc_frontend_tdcbuffers_seen4)) begin
		top_tdc_frontend_tdcbuffers_seen4 <= top_tdc_frontend_tdcbuffers_request4;
		top_tdc_frontend_tdcbuffers_stop_seen4 <= top_tdc_frontend_tdcbuffers_stop_request4;
		top_tdc_frontend_tdcbuffers_count4 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active4 <= 1'd1;
	end else begin
		if ((top_tdc_frontend_tdcbuffers_stop_request4 != top_tdc_frontend_tdcbuffers_stop_seen4)) begin
			top_tdc_frontend_tdcbuffers_stop_seen4 <= top_tdc_frontend_tdcbuffers_stop_request4;
			if (top_tdc_frontend_tdcbuffers_active4) begin
				top_tdc_frontend_tdcbuffers_active4 <= 1'd0;
				top_tdc_frontend_tdcbuffers_acknowledged4 <= top_tdc_frontend_tdcbuffers_seen4;
			end
		end else begin
			if (top_tdc_frontend_tdcbuffers_active4) begin
				if ((top_tdc_frontend_tdcbuffers_count4 == 13'd4096)) begin
					top_tdc_frontend_tdcbuffers_active4 <= 1'd0;
					top_tdc_frontend_tdcbuffers_acknowledged4 <= top_tdc_frontend_tdcbuffers_seen4;
				end else begin
					if (top_tdc_frontend_tdcbuffers_event4) begin
						top_tdc_frontend_tdcbuffers_count4 <= (top_tdc_frontend_tdcbuffers_count4 + 1'd1);
					end
				end
			end
		end
	end
	if ((top_tdc_frontend_tdcbuffers_request5 != top_tdc_frontend_tdcbuffers_seen5)) begin
		top_tdc_frontend_tdcbuffers_seen5 <= top_tdc_frontend_tdcbuffers_request5;
		top_tdc_frontend_tdcbuffers_stop_seen5 <= top_tdc_frontend_tdcbuffers_stop_request5;
		top_tdc_frontend_tdcbuffers_count5 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active5 <= 1'd1;
	end else begin
		if ((top_tdc_frontend_tdcbuffers_stop_request5 != top_tdc_frontend_tdcbuffers_stop_seen5)) begin
			top_tdc_frontend_tdcbuffers_stop_seen5 <= top_tdc_frontend_tdcbuffers_stop_request5;
			if (top_tdc_frontend_tdcbuffers_active5) begin
				top_tdc_frontend_tdcbuffers_active5 <= 1'd0;
				top_tdc_frontend_tdcbuffers_acknowledged5 <= top_tdc_frontend_tdcbuffers_seen5;
			end
		end else begin
			if (top_tdc_frontend_tdcbuffers_active5) begin
				if ((top_tdc_frontend_tdcbuffers_count5 == 13'd4096)) begin
					top_tdc_frontend_tdcbuffers_active5 <= 1'd0;
					top_tdc_frontend_tdcbuffers_acknowledged5 <= top_tdc_frontend_tdcbuffers_seen5;
				end else begin
					if (top_tdc_frontend_tdcbuffers_event5) begin
						top_tdc_frontend_tdcbuffers_count5 <= (top_tdc_frontend_tdcbuffers_count5 + 1'd1);
					end
				end
			end
		end
	end
	if ((top_tdc_frontend_tdcbuffers_request6 != top_tdc_frontend_tdcbuffers_seen6)) begin
		top_tdc_frontend_tdcbuffers_seen6 <= top_tdc_frontend_tdcbuffers_request6;
		top_tdc_frontend_tdcbuffers_stop_seen6 <= top_tdc_frontend_tdcbuffers_stop_request6;
		top_tdc_frontend_tdcbuffers_count6 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active6 <= 1'd1;
	end else begin
		if ((top_tdc_frontend_tdcbuffers_stop_request6 != top_tdc_frontend_tdcbuffers_stop_seen6)) begin
			top_tdc_frontend_tdcbuffers_stop_seen6 <= top_tdc_frontend_tdcbuffers_stop_request6;
			if (top_tdc_frontend_tdcbuffers_active6) begin
				top_tdc_frontend_tdcbuffers_active6 <= 1'd0;
				top_tdc_frontend_tdcbuffers_acknowledged6 <= top_tdc_frontend_tdcbuffers_seen6;
			end
		end else begin
			if (top_tdc_frontend_tdcbuffers_active6) begin
				if ((top_tdc_frontend_tdcbuffers_count6 == 13'd4096)) begin
					top_tdc_frontend_tdcbuffers_active6 <= 1'd0;
					top_tdc_frontend_tdcbuffers_acknowledged6 <= top_tdc_frontend_tdcbuffers_seen6;
				end else begin
					if (top_tdc_frontend_tdcbuffers_event6) begin
						top_tdc_frontend_tdcbuffers_count6 <= (top_tdc_frontend_tdcbuffers_count6 + 1'd1);
					end
				end
			end
		end
	end
	if ((top_tdc_frontend_tdcbuffers_request7 != top_tdc_frontend_tdcbuffers_seen7)) begin
		top_tdc_frontend_tdcbuffers_seen7 <= top_tdc_frontend_tdcbuffers_request7;
		top_tdc_frontend_tdcbuffers_stop_seen7 <= top_tdc_frontend_tdcbuffers_stop_request7;
		top_tdc_frontend_tdcbuffers_count7 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active7 <= 1'd1;
	end else begin
		if ((top_tdc_frontend_tdcbuffers_stop_request7 != top_tdc_frontend_tdcbuffers_stop_seen7)) begin
			top_tdc_frontend_tdcbuffers_stop_seen7 <= top_tdc_frontend_tdcbuffers_stop_request7;
			if (top_tdc_frontend_tdcbuffers_active7) begin
				top_tdc_frontend_tdcbuffers_active7 <= 1'd0;
				top_tdc_frontend_tdcbuffers_acknowledged7 <= top_tdc_frontend_tdcbuffers_seen7;
			end
		end else begin
			if (top_tdc_frontend_tdcbuffers_active7) begin
				if ((top_tdc_frontend_tdcbuffers_count7 == 13'd4096)) begin
					top_tdc_frontend_tdcbuffers_active7 <= 1'd0;
					top_tdc_frontend_tdcbuffers_acknowledged7 <= top_tdc_frontend_tdcbuffers_seen7;
				end else begin
					if (top_tdc_frontend_tdcbuffers_event7) begin
						top_tdc_frontend_tdcbuffers_count7 <= (top_tdc_frontend_tdcbuffers_count7 + 1'd1);
					end
				end
			end
		end
	end
	if (tdc2_rst) begin
		top_tdc_frontend_tdcbuffers_seen4 <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_seen4 <= 1'd0;
		top_tdc_frontend_tdcbuffers_acknowledged4 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active4 <= 1'd0;
		top_tdc_frontend_tdcbuffers_count4 <= 13'd0;
		top_tdc_frontend_tdcbuffers_seen5 <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_seen5 <= 1'd0;
		top_tdc_frontend_tdcbuffers_acknowledged5 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active5 <= 1'd0;
		top_tdc_frontend_tdcbuffers_count5 <= 13'd0;
		top_tdc_frontend_tdcbuffers_seen6 <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_seen6 <= 1'd0;
		top_tdc_frontend_tdcbuffers_acknowledged6 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active6 <= 1'd0;
		top_tdc_frontend_tdcbuffers_count6 <= 13'd0;
		top_tdc_frontend_tdcbuffers_seen7 <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_seen7 <= 1'd0;
		top_tdc_frontend_tdcbuffers_acknowledged7 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active7 <= 1'd0;
		top_tdc_frontend_tdcbuffers_count7 <= 13'd0;
		top_tdc_frontend_heartbeat1 <= 5'd0;
	end
	xilinxmultiregimpl600 <= top_tdc_frontend_tdcbuffers_epoch;
	xilinxmultiregimpl601 <= xilinxmultiregimpl600;
	xilinxmultiregimpl602 <= xilinxmultiregimpl601;
	xilinxmultiregimpl610 <= top_tdc_frontend_tdcbuffers_stop_epoch;
	xilinxmultiregimpl611 <= xilinxmultiregimpl610;
	xilinxmultiregimpl612 <= xilinxmultiregimpl611;
	xilinxmultiregimpl650 <= top_tdc_frontend_tdcbuffers_epoch;
	xilinxmultiregimpl651 <= xilinxmultiregimpl650;
	xilinxmultiregimpl652 <= xilinxmultiregimpl651;
	xilinxmultiregimpl660 <= top_tdc_frontend_tdcbuffers_stop_epoch;
	xilinxmultiregimpl661 <= xilinxmultiregimpl660;
	xilinxmultiregimpl662 <= xilinxmultiregimpl661;
	xilinxmultiregimpl700 <= top_tdc_frontend_tdcbuffers_epoch;
	xilinxmultiregimpl701 <= xilinxmultiregimpl700;
	xilinxmultiregimpl702 <= xilinxmultiregimpl701;
	xilinxmultiregimpl710 <= top_tdc_frontend_tdcbuffers_stop_epoch;
	xilinxmultiregimpl711 <= xilinxmultiregimpl710;
	xilinxmultiregimpl712 <= xilinxmultiregimpl711;
	xilinxmultiregimpl750 <= top_tdc_frontend_tdcbuffers_epoch;
	xilinxmultiregimpl751 <= xilinxmultiregimpl750;
	xilinxmultiregimpl752 <= xilinxmultiregimpl751;
	xilinxmultiregimpl760 <= top_tdc_frontend_tdcbuffers_stop_epoch;
	xilinxmultiregimpl761 <= xilinxmultiregimpl760;
	xilinxmultiregimpl762 <= xilinxmultiregimpl761;
end

always @(posedge tdc3_clk) begin
	top_tdc_frontend_heartbeat2 <= (top_tdc_frontend_heartbeat2 + 1'd1);
	if ((top_tdc_frontend_tdcbuffers_request8 != top_tdc_frontend_tdcbuffers_seen8)) begin
		top_tdc_frontend_tdcbuffers_seen8 <= top_tdc_frontend_tdcbuffers_request8;
		top_tdc_frontend_tdcbuffers_stop_seen8 <= top_tdc_frontend_tdcbuffers_stop_request8;
		top_tdc_frontend_tdcbuffers_count8 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active8 <= 1'd1;
	end else begin
		if ((top_tdc_frontend_tdcbuffers_stop_request8 != top_tdc_frontend_tdcbuffers_stop_seen8)) begin
			top_tdc_frontend_tdcbuffers_stop_seen8 <= top_tdc_frontend_tdcbuffers_stop_request8;
			if (top_tdc_frontend_tdcbuffers_active8) begin
				top_tdc_frontend_tdcbuffers_active8 <= 1'd0;
				top_tdc_frontend_tdcbuffers_acknowledged8 <= top_tdc_frontend_tdcbuffers_seen8;
			end
		end else begin
			if (top_tdc_frontend_tdcbuffers_active8) begin
				if ((top_tdc_frontend_tdcbuffers_count8 == 13'd4096)) begin
					top_tdc_frontend_tdcbuffers_active8 <= 1'd0;
					top_tdc_frontend_tdcbuffers_acknowledged8 <= top_tdc_frontend_tdcbuffers_seen8;
				end else begin
					if (top_tdc_frontend_tdcbuffers_event8) begin
						top_tdc_frontend_tdcbuffers_count8 <= (top_tdc_frontend_tdcbuffers_count8 + 1'd1);
					end
				end
			end
		end
	end
	if ((top_tdc_frontend_tdcbuffers_request9 != top_tdc_frontend_tdcbuffers_seen9)) begin
		top_tdc_frontend_tdcbuffers_seen9 <= top_tdc_frontend_tdcbuffers_request9;
		top_tdc_frontend_tdcbuffers_stop_seen9 <= top_tdc_frontend_tdcbuffers_stop_request9;
		top_tdc_frontend_tdcbuffers_count9 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active9 <= 1'd1;
	end else begin
		if ((top_tdc_frontend_tdcbuffers_stop_request9 != top_tdc_frontend_tdcbuffers_stop_seen9)) begin
			top_tdc_frontend_tdcbuffers_stop_seen9 <= top_tdc_frontend_tdcbuffers_stop_request9;
			if (top_tdc_frontend_tdcbuffers_active9) begin
				top_tdc_frontend_tdcbuffers_active9 <= 1'd0;
				top_tdc_frontend_tdcbuffers_acknowledged9 <= top_tdc_frontend_tdcbuffers_seen9;
			end
		end else begin
			if (top_tdc_frontend_tdcbuffers_active9) begin
				if ((top_tdc_frontend_tdcbuffers_count9 == 13'd4096)) begin
					top_tdc_frontend_tdcbuffers_active9 <= 1'd0;
					top_tdc_frontend_tdcbuffers_acknowledged9 <= top_tdc_frontend_tdcbuffers_seen9;
				end else begin
					if (top_tdc_frontend_tdcbuffers_event9) begin
						top_tdc_frontend_tdcbuffers_count9 <= (top_tdc_frontend_tdcbuffers_count9 + 1'd1);
					end
				end
			end
		end
	end
	if ((top_tdc_frontend_tdcbuffers_request10 != top_tdc_frontend_tdcbuffers_seen10)) begin
		top_tdc_frontend_tdcbuffers_seen10 <= top_tdc_frontend_tdcbuffers_request10;
		top_tdc_frontend_tdcbuffers_stop_seen10 <= top_tdc_frontend_tdcbuffers_stop_request10;
		top_tdc_frontend_tdcbuffers_count10 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active10 <= 1'd1;
	end else begin
		if ((top_tdc_frontend_tdcbuffers_stop_request10 != top_tdc_frontend_tdcbuffers_stop_seen10)) begin
			top_tdc_frontend_tdcbuffers_stop_seen10 <= top_tdc_frontend_tdcbuffers_stop_request10;
			if (top_tdc_frontend_tdcbuffers_active10) begin
				top_tdc_frontend_tdcbuffers_active10 <= 1'd0;
				top_tdc_frontend_tdcbuffers_acknowledged10 <= top_tdc_frontend_tdcbuffers_seen10;
			end
		end else begin
			if (top_tdc_frontend_tdcbuffers_active10) begin
				if ((top_tdc_frontend_tdcbuffers_count10 == 13'd4096)) begin
					top_tdc_frontend_tdcbuffers_active10 <= 1'd0;
					top_tdc_frontend_tdcbuffers_acknowledged10 <= top_tdc_frontend_tdcbuffers_seen10;
				end else begin
					if (top_tdc_frontend_tdcbuffers_event10) begin
						top_tdc_frontend_tdcbuffers_count10 <= (top_tdc_frontend_tdcbuffers_count10 + 1'd1);
					end
				end
			end
		end
	end
	if ((top_tdc_frontend_tdcbuffers_request11 != top_tdc_frontend_tdcbuffers_seen11)) begin
		top_tdc_frontend_tdcbuffers_seen11 <= top_tdc_frontend_tdcbuffers_request11;
		top_tdc_frontend_tdcbuffers_stop_seen11 <= top_tdc_frontend_tdcbuffers_stop_request11;
		top_tdc_frontend_tdcbuffers_count11 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active11 <= 1'd1;
	end else begin
		if ((top_tdc_frontend_tdcbuffers_stop_request11 != top_tdc_frontend_tdcbuffers_stop_seen11)) begin
			top_tdc_frontend_tdcbuffers_stop_seen11 <= top_tdc_frontend_tdcbuffers_stop_request11;
			if (top_tdc_frontend_tdcbuffers_active11) begin
				top_tdc_frontend_tdcbuffers_active11 <= 1'd0;
				top_tdc_frontend_tdcbuffers_acknowledged11 <= top_tdc_frontend_tdcbuffers_seen11;
			end
		end else begin
			if (top_tdc_frontend_tdcbuffers_active11) begin
				if ((top_tdc_frontend_tdcbuffers_count11 == 13'd4096)) begin
					top_tdc_frontend_tdcbuffers_active11 <= 1'd0;
					top_tdc_frontend_tdcbuffers_acknowledged11 <= top_tdc_frontend_tdcbuffers_seen11;
				end else begin
					if (top_tdc_frontend_tdcbuffers_event11) begin
						top_tdc_frontend_tdcbuffers_count11 <= (top_tdc_frontend_tdcbuffers_count11 + 1'd1);
					end
				end
			end
		end
	end
	if (tdc3_rst) begin
		top_tdc_frontend_tdcbuffers_seen8 <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_seen8 <= 1'd0;
		top_tdc_frontend_tdcbuffers_acknowledged8 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active8 <= 1'd0;
		top_tdc_frontend_tdcbuffers_count8 <= 13'd0;
		top_tdc_frontend_tdcbuffers_seen9 <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_seen9 <= 1'd0;
		top_tdc_frontend_tdcbuffers_acknowledged9 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active9 <= 1'd0;
		top_tdc_frontend_tdcbuffers_count9 <= 13'd0;
		top_tdc_frontend_tdcbuffers_seen10 <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_seen10 <= 1'd0;
		top_tdc_frontend_tdcbuffers_acknowledged10 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active10 <= 1'd0;
		top_tdc_frontend_tdcbuffers_count10 <= 13'd0;
		top_tdc_frontend_tdcbuffers_seen11 <= 1'd0;
		top_tdc_frontend_tdcbuffers_stop_seen11 <= 1'd0;
		top_tdc_frontend_tdcbuffers_acknowledged11 <= 1'd0;
		top_tdc_frontend_tdcbuffers_active11 <= 1'd0;
		top_tdc_frontend_tdcbuffers_count11 <= 13'd0;
		top_tdc_frontend_heartbeat2 <= 5'd0;
	end
	xilinxmultiregimpl800 <= top_tdc_frontend_tdcbuffers_epoch;
	xilinxmultiregimpl801 <= xilinxmultiregimpl800;
	xilinxmultiregimpl802 <= xilinxmultiregimpl801;
	xilinxmultiregimpl810 <= top_tdc_frontend_tdcbuffers_stop_epoch;
	xilinxmultiregimpl811 <= xilinxmultiregimpl810;
	xilinxmultiregimpl812 <= xilinxmultiregimpl811;
	xilinxmultiregimpl850 <= top_tdc_frontend_tdcbuffers_epoch;
	xilinxmultiregimpl851 <= xilinxmultiregimpl850;
	xilinxmultiregimpl852 <= xilinxmultiregimpl851;
	xilinxmultiregimpl860 <= top_tdc_frontend_tdcbuffers_stop_epoch;
	xilinxmultiregimpl861 <= xilinxmultiregimpl860;
	xilinxmultiregimpl862 <= xilinxmultiregimpl861;
	xilinxmultiregimpl900 <= top_tdc_frontend_tdcbuffers_epoch;
	xilinxmultiregimpl901 <= xilinxmultiregimpl900;
	xilinxmultiregimpl902 <= xilinxmultiregimpl901;
	xilinxmultiregimpl910 <= top_tdc_frontend_tdcbuffers_stop_epoch;
	xilinxmultiregimpl911 <= xilinxmultiregimpl910;
	xilinxmultiregimpl912 <= xilinxmultiregimpl911;
	xilinxmultiregimpl950 <= top_tdc_frontend_tdcbuffers_epoch;
	xilinxmultiregimpl951 <= xilinxmultiregimpl950;
	xilinxmultiregimpl952 <= xilinxmultiregimpl951;
	xilinxmultiregimpl960 <= top_tdc_frontend_tdcbuffers_stop_epoch;
	xilinxmultiregimpl961 <= xilinxmultiregimpl960;
	xilinxmultiregimpl962 <= xilinxmultiregimpl961;
end

IBUFDS #(
	.DIFF_TERM("TRUE")
) IBUFDS (
	.I(MCLK1_P),
	.IB(MCLK1_N),
	.O(top_m)
);

IBUFDS_GTE2 IBUFDS_GTE2(
	.CEB(1'd0),
	.I(MGTCLK_P),
	.IB(MGTCLK_N),
	.O(top_ref),
	.ODIV2(top_refdiv)
);

BUFG BUFG(
	.I(top_refdiv),
	.O(top_fixed100)
);

BUFG BUFG_1(
	.I(top_s7mmcm0_clkout),
	.O(top_s7mmcm0_clkout_buf)
);

BUFG BUFG_2(
	.I(top_s7mmcm1_clkout),
	.O(top_s7mmcm1_clkout_buf)
);

reg [4:0] mem_6b5b[0:63];
reg [5:0] memadr;
always @(posedge eth_rx_clk) begin : mem_write_block
	if (top_pcsrx_decoder_re)
		memadr <= top_pcsrx_decoder_adr;
end

assign top_pcsrx_decoder_dat_r = mem_6b5b[memadr];

initial begin
	$readmemh("mem_6b5b.init", mem_6b5b);
end

GTXE2_CHANNEL #(
	.ALIGN_COMMA_DOUBLE("FALSE"),
	.ALIGN_COMMA_ENABLE(10'd1023),
	.ALIGN_COMMA_WORD(2'd2),
	.ALIGN_MCOMMA_DET("TRUE"),
	.ALIGN_MCOMMA_VALUE(10'd643),
	.ALIGN_PCOMMA_DET("TRUE"),
	.ALIGN_PCOMMA_VALUE(9'd380),
	.CBCC_DATA_SOURCE_SEL("DECODED"),
	.CHAN_BOND_KEEP_ALIGN("FALSE"),
	.CHAN_BOND_MAX_SKEW(1'd1),
	.CHAN_BOND_SEQ_1_1(1'd0),
	.CHAN_BOND_SEQ_1_2(1'd0),
	.CHAN_BOND_SEQ_1_3(1'd0),
	.CHAN_BOND_SEQ_1_4(1'd0),
	.CHAN_BOND_SEQ_1_ENABLE(4'd15),
	.CHAN_BOND_SEQ_2_1(1'd0),
	.CHAN_BOND_SEQ_2_2(1'd0),
	.CHAN_BOND_SEQ_2_3(1'd0),
	.CHAN_BOND_SEQ_2_4(1'd0),
	.CHAN_BOND_SEQ_2_ENABLE(4'd15),
	.CHAN_BOND_SEQ_2_USE("FALSE"),
	.CHAN_BOND_SEQ_LEN(1'd1),
	.CLK_CORRECT_USE("FALSE"),
	.CLK_COR_KEEP_IDLE("FALSE"),
	.CLK_COR_MAX_LAT(4'd9),
	.CLK_COR_MIN_LAT(3'd7),
	.CLK_COR_PRECEDENCE("TRUE"),
	.CLK_COR_REPEAT_WAIT(1'd0),
	.CLK_COR_SEQ_1_1(9'd256),
	.CLK_COR_SEQ_1_2(1'd0),
	.CLK_COR_SEQ_1_3(1'd0),
	.CLK_COR_SEQ_1_4(1'd0),
	.CLK_COR_SEQ_1_ENABLE(4'd15),
	.CLK_COR_SEQ_2_1(9'd256),
	.CLK_COR_SEQ_2_2(1'd0),
	.CLK_COR_SEQ_2_3(1'd0),
	.CLK_COR_SEQ_2_4(1'd0),
	.CLK_COR_SEQ_2_ENABLE(4'd15),
	.CLK_COR_SEQ_2_USE("FALSE"),
	.CLK_COR_SEQ_LEN(1'd1),
	.CPLL_CFG(24'd12322780),
	.CPLL_FBDIV(2'd3),
	.CPLL_FBDIV_45(3'd4),
	.CPLL_INIT_CFG(5'd30),
	.CPLL_LOCK_CFG(9'd488),
	.CPLL_REFCLK_DIV(1'd1),
	.DEC_MCOMMA_DETECT("TRUE"),
	.DEC_PCOMMA_DETECT("TRUE"),
	.DEC_VALID_COMMA_ONLY("TRUE"),
	.DMONITOR_CFG(12'd2560),
	.ES_CONTROL(1'd0),
	.ES_ERRDET_EN("FALSE"),
	.ES_EYE_SCAN_EN("TRUE"),
	.ES_HORZ_OFFSET(1'd0),
	.ES_PMA_CFG(1'd0),
	.ES_PRESCALE(1'd0),
	.ES_QUALIFIER(1'd0),
	.ES_QUAL_MASK(1'd0),
	.ES_SDATA_MASK(1'd0),
	.ES_VERT_OFFSET(1'd0),
	.FTS_DESKEW_SEQ_ENABLE(4'd15),
	.FTS_LANE_DESKEW_CFG(4'd15),
	.FTS_LANE_DESKEW_EN("FALSE"),
	.GEARBOX_MODE(1'd0),
	.OUTREFCLK_SEL_INV(2'd3),
	.PCS_PCIE_EN("FALSE"),
	.PCS_RSVD_ATTR(1'd0),
	.PD_TRANS_TIME_FROM_P2(6'd60),
	.PD_TRANS_TIME_NONE_P2(6'd60),
	.PD_TRANS_TIME_TO_P2(7'd100),
	.PMA_RSV(21'd1994880),
	.PMA_RSV2(14'd8272),
	.PMA_RSV3(1'd0),
	.PMA_RSV4(1'd0),
	.RXBUFRESET_TIME(1'd1),
	.RXBUF_ADDR_MODE("FAST"),
	.RXBUF_EIDLE_HI_CNT(4'd8),
	.RXBUF_EIDLE_LO_CNT(1'd0),
	.RXBUF_EN("TRUE"),
	.RXBUF_RESET_ON_CB_CHANGE("TRUE"),
	.RXBUF_RESET_ON_COMMAALIGN("FALSE"),
	.RXBUF_RESET_ON_EIDLE("FALSE"),
	.RXBUF_RESET_ON_RATE_CHANGE("TRUE"),
	.RXBUF_THRESH_OVFLW(6'd61),
	.RXBUF_THRESH_OVRD("FALSE"),
	.RXBUF_THRESH_UNDFLW(3'd4),
	.RXCDRFREQRESET_TIME(1'd1),
	.RXCDRPHRESET_TIME(1'd1),
	.RXCDR_CFG(66'd55340271799521771552),
	.RXCDR_FR_RESET_ON_EIDLE(1'd0),
	.RXCDR_HOLD_DURING_EIDLE(1'd0),
	.RXCDR_LOCK_CFG(5'd21),
	.RXCDR_PH_RESET_ON_EIDLE(1'd0),
	.RXDFELPMRESET_TIME(4'd15),
	.RXDLY_CFG(5'd31),
	.RXDLY_LCFG(6'd48),
	.RXDLY_TAP_CFG(1'd0),
	.RXGEARBOX_EN("FALSE"),
	.RXISCANRESET_TIME(1'd1),
	.RXLPM_HF_CFG(8'd240),
	.RXLPM_LF_CFG(8'd240),
	.RXOOB_CFG(3'd6),
	.RXOUT_DIV(3'd4),
	.RXPCSRESET_TIME(1'd1),
	.RXPHDLY_CFG(20'd540704),
	.RXPH_CFG(1'd0),
	.RXPH_MONITOR_SEL(1'd0),
	.RXPMARESET_TIME(2'd3),
	.RXPRBS_ERR_LOOPBACK(1'd0),
	.RXSLIDE_AUTO_WAIT(3'd7),
	.RXSLIDE_MODE("OFF"),
	.RX_BIAS_CFG(3'd4),
	.RX_BUFFER_CFG(1'd0),
	.RX_CLK25_DIV(4'd8),
	.RX_CLKMUX_PD(1'd1),
	.RX_CM_SEL(2'd3),
	.RX_CM_TRIM(2'd2),
	.RX_DATA_WIDTH(5'd20),
	.RX_DDI_SEL(1'd0),
	.RX_DEBUG_CFG(1'd0),
	.RX_DEFER_RESET_BUF_EN("TRUE"),
	.RX_DFE_GAIN_CFG(18'd135146),
	.RX_DFE_H2_CFG(1'd0),
	.RX_DFE_H3_CFG(7'd64),
	.RX_DFE_H4_CFG(8'd240),
	.RX_DFE_H5_CFG(8'd224),
	.RX_DFE_KL_CFG(8'd254),
	.RX_DFE_KL_CFG2(30'd806439084),
	.RX_DFE_LPM_CFG(12'd2388),
	.RX_DFE_LPM_HOLD_DURING_EIDLE(1'd0),
	.RX_DFE_UT_CFG(17'd73216),
	.RX_DFE_VP_CFG(14'd16131),
	.RX_DFE_XYD_CFG(1'd0),
	.RX_DISPERR_SEQ_MATCH("TRUE"),
	.RX_INT_DATAWIDTH(1'd0),
	.RX_OS_CFG(8'd128),
	.RX_SIG_VALID_DLY(4'd10),
	.RX_XCLK_SEL("RXREC"),
	.SAS_MAX_COM(7'd64),
	.SAS_MIN_COM(6'd36),
	.SATA_BURST_SEQ_LEN(3'd5),
	.SATA_BURST_VAL(3'd4),
	.SATA_CPLL_CFG("VCO_3000MHZ"),
	.SATA_EIDLE_VAL(3'd4),
	.SATA_MAX_BURST(4'd8),
	.SATA_MAX_INIT(5'd21),
	.SATA_MAX_WAKE(3'd7),
	.SATA_MIN_BURST(3'd4),
	.SATA_MIN_INIT(4'd12),
	.SATA_MIN_WAKE(3'd4),
	.SHOW_REALIGN_COMMA("TRUE"),
	.SIM_CPLLREFCLK_SEL("FALSE"),
	.SIM_RECEIVER_DETECT_PASS("TRUE"),
	.SIM_RESET_SPEEDUP("FALSE"),
	.SIM_TX_EIDLE_DRIVE_LEVEL("X"),
	.SIM_VERSION("4.0"),
	.TERM_RCAL_CFG(5'd16),
	.TERM_RCAL_OVRD(1'd0),
	.TRANS_TIME_RATE(4'd14),
	.TST_RSV(1'd0),
	.TXBUF_EN("TRUE"),
	.TXBUF_RESET_ON_RATE_CHANGE("TRUE"),
	.TXDLY_CFG(5'd31),
	.TXDLY_LCFG(6'd48),
	.TXDLY_TAP_CFG(1'd0),
	.TXGEARBOX_EN("FALSE"),
	.TXOUT_DIV(3'd4),
	.TXPCSRESET_TIME(1'd1),
	.TXPHDLY_CFG(20'd540704),
	.TXPH_CFG(11'd1920),
	.TXPH_MONITOR_SEL(1'd0),
	.TXPMARESET_TIME(1'd1),
	.TX_CLK25_DIV(4'd8),
	.TX_CLKMUX_PD(1'd1),
	.TX_DATA_WIDTH(5'd20),
	.TX_DEEMPH0(1'd0),
	.TX_DEEMPH1(1'd0),
	.TX_DRIVE_MODE("DIRECT"),
	.TX_EIDLE_ASSERT_DELAY(3'd6),
	.TX_EIDLE_DEASSERT_DELAY(3'd4),
	.TX_INT_DATAWIDTH(1'd0),
	.TX_LOOPBACK_DRIVE_HIZ("FALSE"),
	.TX_MAINCURSOR_SEL(1'd0),
	.TX_MARGIN_FULL_0(7'd78),
	.TX_MARGIN_FULL_1(7'd73),
	.TX_MARGIN_FULL_2(7'd69),
	.TX_MARGIN_FULL_3(7'd66),
	.TX_MARGIN_FULL_4(7'd64),
	.TX_MARGIN_LOW_0(7'd70),
	.TX_MARGIN_LOW_1(7'd68),
	.TX_MARGIN_LOW_2(7'd66),
	.TX_MARGIN_LOW_3(7'd64),
	.TX_MARGIN_LOW_4(7'd64),
	.TX_PREDRIVER_MODE(1'd0),
	.TX_QPI_STATUS_EN(1'd0),
	.TX_RXDETECT_CFG(13'd6194),
	.TX_RXDETECT_REF(3'd4),
	.TX_XCLK_SEL("TXOUT"),
	.UCODEER_CLR(1'd0)
) GTXE2_CHANNEL (
	.CFGRESET(1'd0),
	.CLKRSVD(1'd0),
	.CPLLLOCKDETCLK(sys_clk),
	.CPLLLOCKEN(1'd1),
	.CPLLPD(1'd0),
	.CPLLREFCLKSEL(1'd1),
	.CPLLRESET(top_pma_k7_gtx_basex_pll_reset),
	.DRPADDR(1'd0),
	.DRPCLK(1'd0),
	.DRPDI(1'd0),
	.DRPEN(1'd0),
	.DRPWE(1'd0),
	.EYESCANMODE(1'd0),
	.EYESCANRESET(1'd0),
	.EYESCANTRIGGER(1'd0),
	.GTGREFCLK(1'd0),
	.GTNORTHREFCLK0(1'd0),
	.GTNORTHREFCLK1(1'd0),
	.GTREFCLK0(top_ref),
	.GTREFCLK1(1'd0),
	.GTRESETSEL(1'd0),
	.GTRSVD(1'd0),
	.GTRXRESET(top_pma_k7_gtx_basex_rx_reset),
	.GTSOUTHREFCLK0(1'd0),
	.GTSOUTHREFCLK1(1'd0),
	.GTTXRESET(top_pma_k7_gtx_basex_tx_reset),
	.GTXRXN(RX_N),
	.GTXRXP(RX_P),
	.LOOPBACK(1'd0),
	.PCSRSVDIN(1'd0),
	.PCSRSVDIN2(1'd0),
	.PMARSVDIN(1'd0),
	.PMARSVDIN2(1'd0),
	.QPLLCLK(1'd0),
	.QPLLREFCLK(1'd0),
	.RESETOVRD(1'd0),
	.RX8B10BEN(1'd0),
	.RXBUFRESET(1'd0),
	.RXCDRFREQRESET(1'd0),
	.RXCDRHOLD(1'd0),
	.RXCDROVRDEN(1'd0),
	.RXCDRRESET(1'd0),
	.RXCDRRESETRSV(1'd0),
	.RXCHBONDEN(1'd0),
	.RXCHBONDI(1'd0),
	.RXCHBONDLEVEL(1'd0),
	.RXCHBONDMASTER(1'd0),
	.RXCHBONDSLAVE(1'd0),
	.RXCOMMADETEN(1'd1),
	.RXDDIEN(1'd0),
	.RXDFEAGCHOLD(1'd0),
	.RXDFEAGCOVRDEN(1'd0),
	.RXDFECM1EN(1'd0),
	.RXDFELFHOLD(1'd0),
	.RXDFELFOVRDEN(1'd1),
	.RXDFELPMRESET(1'd0),
	.RXDFETAP2HOLD(1'd0),
	.RXDFETAP2OVRDEN(1'd0),
	.RXDFETAP3HOLD(1'd0),
	.RXDFETAP3OVRDEN(1'd0),
	.RXDFETAP4HOLD(1'd0),
	.RXDFETAP4OVRDEN(1'd0),
	.RXDFETAP5HOLD(1'd0),
	.RXDFETAP5OVRDEN(1'd0),
	.RXDFEUTHOLD(1'd0),
	.RXDFEUTOVRDEN(1'd0),
	.RXDFEVPHOLD(1'd0),
	.RXDFEVPOVRDEN(1'd0),
	.RXDFEVSEN(1'd0),
	.RXDFEXYDEN(1'd1),
	.RXDFEXYDHOLD(1'd0),
	.RXDFEXYDOVRDEN(1'd0),
	.RXDISPERR({top_pma_k7_gtx_basex_rx_data0[19], top_pma_k7_gtx_basex_rx_data0[9]}),
	.RXDLYBYPASS(1'd1),
	.RXDLYEN(1'd0),
	.RXDLYOVRDEN(1'd0),
	.RXDLYSRESET(1'd0),
	.RXELECIDLEMODE(2'd3),
	.RXGEARBOXSLIP(1'd0),
	.RXLPMEN(1'd0),
	.RXLPMHFHOLD(1'd0),
	.RXLPMHFOVRDEN(1'd0),
	.RXLPMLFHOLD(1'd0),
	.RXLPMLFKLOVRDEN(1'd0),
	.RXMCOMMAALIGNEN(top_pma_k7_gtx_basex_align),
	.RXMONITORSEL(1'd0),
	.RXOOBRESET(1'd0),
	.RXOSHOLD(1'd0),
	.RXOSOVRDEN(1'd0),
	.RXOUTCLKSEL(2'd2),
	.RXPCOMMAALIGNEN(top_pma_k7_gtx_basex_align),
	.RXPCSRESET(1'd0),
	.RXPD(1'd0),
	.RXPHALIGN(1'd0),
	.RXPHALIGNEN(1'd0),
	.RXPHDLYPD(1'd0),
	.RXPHDLYRESET(1'd0),
	.RXPHOVRDEN(1'd0),
	.RXPMARESET(1'd0),
	.RXPOLARITY(1'd0),
	.RXPRBSCNTRESET(1'd0),
	.RXPRBSSEL(1'd0),
	.RXQPIEN(1'd0),
	.RXRATE(1'd0),
	.RXSLIDE(1'd0),
	.RXSYSCLKSEL(1'd0),
	.RXUSERRDY(top_pma_k7_gtx_basex_rx_mmcm_locked0),
	.RXUSRCLK(eth_rx_half_clk),
	.RXUSRCLK2(eth_rx_half_clk),
	.SETERRSTATUS(1'd0),
	.TSTIN(20'd1048575),
	.TX8B10BBYPASS(1'd0),
	.TX8B10BEN(1'd0),
	.TXBUFDIFFCTRL(3'd4),
	.TXCHARDISPMODE({top_pma_k7_gtx_basex_tx_data0[19], top_pma_k7_gtx_basex_tx_data0[9]}),
	.TXCHARDISPVAL({top_pma_k7_gtx_basex_tx_data0[18], top_pma_k7_gtx_basex_tx_data0[8]}),
	.TXCHARISK(1'd0),
	.TXCOMINIT(1'd0),
	.TXCOMSAS(1'd0),
	.TXCOMWAKE(1'd0),
	.TXDATA({top_pma_k7_gtx_basex_tx_data0[17:10], top_pma_k7_gtx_basex_tx_data0[7:0]}),
	.TXDEEMPH(1'd0),
	.TXDETECTRX(1'd0),
	.TXDIFFCTRL(4'd8),
	.TXDIFFPD(1'd0),
	.TXDLYBYPASS(1'd1),
	.TXDLYEN(1'd0),
	.TXDLYHOLD(1'd0),
	.TXDLYOVRDEN(1'd0),
	.TXDLYSRESET(1'd0),
	.TXDLYUPDOWN(1'd0),
	.TXELECIDLE(1'd0),
	.TXHEADER(1'd0),
	.TXINHIBIT(1'd0),
	.TXMAINCURSOR(1'd0),
	.TXMARGIN(1'd0),
	.TXOUTCLKSEL(2'd2),
	.TXPCSRESET(1'd0),
	.TXPD(1'd0),
	.TXPDELECIDLEMODE(1'd0),
	.TXPHALIGN(1'd0),
	.TXPHALIGNEN(1'd0),
	.TXPHDLYPD(1'd0),
	.TXPHDLYRESET(1'd0),
	.TXPHDLYTSTCLK(1'd0),
	.TXPHINIT(1'd0),
	.TXPHOVRDEN(1'd0),
	.TXPISOPD(1'd0),
	.TXPMARESET(1'd0),
	.TXPOLARITY(1'd0),
	.TXPOSTCURSOR(1'd0),
	.TXPOSTCURSORINV(1'd0),
	.TXPRBSFORCEERR(1'd0),
	.TXPRBSSEL(1'd0),
	.TXPRECURSOR(1'd0),
	.TXPRECURSORINV(1'd0),
	.TXQPIBIASEN(1'd0),
	.TXQPISTRONGPDOWN(1'd0),
	.TXQPIWEAKPUP(1'd0),
	.TXRATE(1'd0),
	.TXSEQUENCE(1'd0),
	.TXSTARTSEQ(1'd0),
	.TXSWING(1'd0),
	.TXSYSCLKSEL(1'd0),
	.TXUSERRDY(top_pma_k7_gtx_basex_tx_mmcm_locked0),
	.TXUSRCLK(eth_tx_half_clk),
	.TXUSRCLK2(eth_tx_half_clk),
	.CPLLFBCLKLOST(top_pma_k7_gtx_basex0),
	.CPLLLOCK(top_pma_k7_gtx_basex_pll_lock),
	.CPLLREFCLKLOST(top_pma_k7_gtx_basex1),
	.DMONITOROUT(top_pma_k7_gtx_basex6),
	.DRPDO(top_pma_k7_gtx_basex3),
	.DRPRDY(top_pma_k7_gtx_basex4),
	.EYESCANDATAERROR(top_pma_k7_gtx_basex9),
	.GTREFCLKMONITOR(top_pma_k7_gtx_basex5),
	.GTXTXN(TX_N),
	.GTXTXP(TX_P),
	.PCSRSVDOUT(top_pma_k7_gtx_basex42),
	.PHYSTATUS(top_pma_k7_gtx_basex7),
	.RXBUFSTATUS(top_pma_k7_gtx_basex14),
	.RXBYTEISALIGNED(top_pma_k7_gtx_basex20),
	.RXBYTEREALIGN(top_pma_k7_gtx_basex21),
	.RXCDRLOCK(top_pma_k7_gtx_basex10),
	.RXCHANBONDSEQ(top_pma_k7_gtx_basex23),
	.RXCHANISALIGNED(top_pma_k7_gtx_basex25),
	.RXCHANREALIGN(top_pma_k7_gtx_basex26),
	.RXCHARISCOMMA(top_pma_k7_gtx_basex39),
	.RXCHARISK({top_pma_k7_gtx_basex_rx_data0[18], top_pma_k7_gtx_basex_rx_data0[8]}),
	.RXCHBONDO(top_pma_k7_gtx_basex24),
	.RXCLKCORCNT(top_pma_k7_gtx_basex11),
	.RXCOMINITDET(top_pma_k7_gtx_basex37),
	.RXCOMMADET(top_pma_k7_gtx_basex22),
	.RXCOMSASDET(top_pma_k7_gtx_basex35),
	.RXCOMWAKEDET(top_pma_k7_gtx_basex36),
	.RXDATA({top_pma_k7_gtx_basex_rx_data0[17:10], top_pma_k7_gtx_basex_rx_data0[7:0]}),
	.RXDATAVALID(top_pma_k7_gtx_basex31),
	.RXDLYSRESETDONE(top_pma_k7_gtx_basex15),
	.RXELECIDLE(top_pma_k7_gtx_basex38),
	.RXHEADER(top_pma_k7_gtx_basex32),
	.RXHEADERVALID(top_pma_k7_gtx_basex33),
	.RXMONITOROUT(top_pma_k7_gtx_basex27),
	.RXNOTINTABLE(top_pma_k7_gtx_basex13),
	.RXOUTCLK(top_pma_k7_gtx_basex_rxoutclk),
	.RXOUTCLKFABRIC(top_pma_k7_gtx_basex29),
	.RXOUTCLKPCS(top_pma_k7_gtx_basex30),
	.RXPHALIGNDONE(top_pma_k7_gtx_basex16),
	.RXPHMONITOR(top_pma_k7_gtx_basex17),
	.RXPHSLIPMONITOR(top_pma_k7_gtx_basex18),
	.RXPRBSERR(top_pma_k7_gtx_basex12),
	.RXQPISENN(top_pma_k7_gtx_basex40),
	.RXQPISENP(top_pma_k7_gtx_basex41),
	.RXRATEDONE(top_pma_k7_gtx_basex28),
	.RXRESETDONE(top_pma_k7_gtx_basex_rx_reset_done),
	.RXSTARTOFSEQ(top_pma_k7_gtx_basex34),
	.RXSTATUS(top_pma_k7_gtx_basex19),
	.RXVALID(top_pma_k7_gtx_basex8),
	.TSTOUT(top_pma_k7_gtx_basex2),
	.TXBUFSTATUS(top_pma_k7_gtx_basex46),
	.TXCOMFINISH(top_pma_k7_gtx_basex51),
	.TXDLYSRESETDONE(top_pma_k7_gtx_basex43),
	.TXGEARBOXREADY(top_pma_k7_gtx_basex50),
	.TXOUTCLK(top_pma_k7_gtx_basex_txoutclk),
	.TXOUTCLKFABRIC(top_pma_k7_gtx_basex47),
	.TXOUTCLKPCS(top_pma_k7_gtx_basex48),
	.TXPHALIGNDONE(top_pma_k7_gtx_basex44),
	.TXPHINITDONE(top_pma_k7_gtx_basex45),
	.TXQPISENN(top_pma_k7_gtx_basex52),
	.TXQPISENP(top_pma_k7_gtx_basex53),
	.TXRATEDONE(top_pma_k7_gtx_basex49),
	.TXRESETDONE(top_pma_k7_gtx_basex_tx_reset_done)
);

BUFH BUFH(
	.I(top_pma_k7_gtx_basex_txoutclk),
	.O(top_pma_k7_gtx_basex_txoutclk_rebuffer)
);

BUFG BUFG_3(
	.I(top_pma_k7_gtx_basex_rxoutclk),
	.O(top_pma_k7_gtx_basex_rxoutclk_rebuffer)
);

BUFH BUFH_1(
	.I(top_pma_k7_gtx_basex_s7mmcm0_clkout0),
	.O(top_pma_k7_gtx_basex_s7mmcm0_clkout_buf0)
);

BUFH BUFH_2(
	.I(top_pma_k7_gtx_basex_s7mmcm0_clkout1),
	.O(top_pma_k7_gtx_basex_s7mmcm0_clkout_buf1)
);

BUFG BUFG_4(
	.I(top_pma_k7_gtx_basex_s7mmcm1_clkout0),
	.O(top_pma_k7_gtx_basex_s7mmcm1_clkout_buf0)
);

BUFG BUFG_5(
	.I(top_pma_k7_gtx_basex_s7mmcm1_clkout1),
	.O(top_pma_k7_gtx_basex_s7mmcm1_clkout_buf1)
);

reg [11:0] storage[0:31];
reg [4:0] memadr_1;
reg [4:0] memadr_2;
always @(posedge net_clk) begin : mem_write_block_1
	if (top_txdatapath_cdc_wrport_we)
		storage[top_txdatapath_cdc_wrport_adr] <= top_txdatapath_cdc_wrport_dat_w;
	memadr_1 <= top_txdatapath_cdc_wrport_adr;
end

always @(posedge eth_tx_clk) begin : mem_write_block_2
	memadr_2 <= top_txdatapath_cdc_rdport_adr;
end

assign top_txdatapath_cdc_wrport_dat_r = storage[memadr_1];
assign top_txdatapath_cdc_rdport_dat_r = storage[memadr_2];

reg [11:0] storage_1[0:2047];
reg [11:0] memdat;
reg [11:0] memdat_1;
always @(posedge eth_tx_clk) begin : mem_write_block_3
	if (top_tx_packet_fifo_payload_fifo_wrport_we)
		storage_1[top_tx_packet_fifo_payload_fifo_wrport_adr] <= top_tx_packet_fifo_payload_fifo_wrport_dat_w;
	memdat <= storage_1[top_tx_packet_fifo_payload_fifo_wrport_adr];
end

always @(posedge eth_tx_clk) begin : mem_write_block_4
	if (top_tx_packet_fifo_payload_fifo_rdport_re)
		memdat_1 <= storage_1[top_tx_packet_fifo_payload_fifo_rdport_adr];
end

assign top_tx_packet_fifo_payload_fifo_wrport_dat_r = memdat;
assign top_tx_packet_fifo_payload_fifo_rdport_dat_r = memdat_1;

reg [2:0] storage_2[0:4];
reg [2:0] memdat_2;
reg [2:0] memdat_3;
always @(posedge eth_tx_clk) begin : mem_write_block_5
	if (top_tx_packet_fifo_param_fifo_wrport_we)
		storage_2[top_tx_packet_fifo_param_fifo_wrport_adr] <= top_tx_packet_fifo_param_fifo_wrport_dat_w;
	memdat_2 <= storage_2[top_tx_packet_fifo_param_fifo_wrport_adr];
end

always @(posedge eth_tx_clk) begin : mem_write_block_6
	if (top_tx_packet_fifo_param_fifo_rdport_re)
		memdat_3 <= storage_2[top_tx_packet_fifo_param_fifo_rdport_adr];
end

assign top_tx_packet_fifo_param_fifo_wrport_dat_r = memdat_2;
assign top_tx_packet_fifo_param_fifo_rdport_dat_r = memdat_3;

reg [2:0] storage_3[0:3];
reg [2:0] memdat_4;
always @(posedge eth_rx_clk) begin : mem_write_block_7
	if (top_rx_packet_fifo_param_fifo_wrport_we)
		storage_3[top_rx_packet_fifo_param_fifo_wrport_adr] <= top_rx_packet_fifo_param_fifo_wrport_dat_w;
	memdat_4 <= storage_3[top_rx_packet_fifo_param_fifo_wrport_adr];
end

always @(posedge eth_rx_clk) begin : mem_write_block_8
end

assign top_rx_packet_fifo_param_fifo_wrport_dat_r = memdat_4;
assign top_rx_packet_fifo_param_fifo_rdport_dat_r = storage_3[top_rx_packet_fifo_param_fifo_rdport_adr];

reg [11:0] mem[0:2047];
reg [10:0] memadr_3;
reg [10:0] memadr_4;
always @(posedge eth_rx_clk) begin : mem_write_block_9
	if (top_rx_packet_fifo_wr_port_we)
		mem[top_rx_packet_fifo_wr_port_adr] <= top_rx_packet_fifo_wr_port_dat_w;
	memadr_3 <= top_rx_packet_fifo_wr_port_adr;
end

always @(posedge eth_rx_clk) begin : mem_write_block_10
	if (top_rx_packet_fifo_rd_port_re)
		memadr_4 <= top_rx_packet_fifo_rd_port_adr;
end

assign top_rx_packet_fifo_wr_port_dat_r = mem[memadr_3];
assign top_rx_packet_fifo_rd_port_dat_r = mem[memadr_4];

reg [11:0] storage_4[0:31];
reg [4:0] memadr_5;
reg [4:0] memadr_6;
always @(posedge eth_rx_clk) begin : mem_write_block_11
	if (top_rx_cdc_cdc_wrport_we)
		storage_4[top_rx_cdc_cdc_wrport_adr] <= top_rx_cdc_cdc_wrport_dat_w;
	memadr_5 <= top_rx_cdc_cdc_wrport_adr;
end

always @(posedge net_clk) begin : mem_write_block_12
	memadr_6 <= top_rx_cdc_cdc_rdport_adr;
end

assign top_rx_cdc_cdc_wrport_dat_r = storage_4[memadr_5];
assign top_rx_cdc_cdc_rdport_dat_r = storage_4[memadr_6];

reg [11:0] storage_5[0:4];
reg [11:0] memdat_5;
always @(posedge net_clk) begin : mem_write_block_13
	if (top_liteethmaccrc32checker_syncfifo_wrport_we)
		storage_5[top_liteethmaccrc32checker_syncfifo_wrport_adr] <= top_liteethmaccrc32checker_syncfifo_wrport_dat_w;
	memdat_5 <= storage_5[top_liteethmaccrc32checker_syncfifo_wrport_adr];
end

always @(posedge net_clk) begin : mem_write_block_14
end

assign top_liteethmaccrc32checker_syncfifo_wrport_dat_r = memdat_5;
assign top_liteethmaccrc32checker_syncfifo_rdport_dat_r = storage_5[top_liteethmaccrc32checker_syncfifo_rdport_adr];

(* ram_style = "block" *) reg [15:0] adc_trace0[0:4095];
reg [11:0] memadr_7;
reg [15:0] memdat_6;
always @(posedge cap_clk) begin : mem_write_block_15
	if (top_capture_wp_memory0_we)
		adc_trace0[top_capture_wp_memory0_adr] <= top_capture_wp_memory0_dat_w;
	memadr_7 <= top_capture_wp_memory0_adr;
end

always @(posedge sys_clk) begin : mem_write_block_16
	memdat_6 <= adc_trace0[top_capture_rp_memory0_adr];
end

assign top_capture_wp_memory0_dat_r = adc_trace0[memadr_7];
assign top_capture_rp_memory0_dat_r = memdat_6;

(* ram_style = "block" *) reg [15:0] adc_trace1[0:4095];
reg [11:0] memadr_8;
reg [15:0] memdat_7;
always @(posedge cap_clk) begin : mem_write_block_17
	if (top_capture_wp_memory1_we)
		adc_trace1[top_capture_wp_memory1_adr] <= top_capture_wp_memory1_dat_w;
	memadr_8 <= top_capture_wp_memory1_adr;
end

always @(posedge sys_clk) begin : mem_write_block_18
	memdat_7 <= adc_trace1[top_capture_rp_memory1_adr];
end

assign top_capture_wp_memory1_dat_r = adc_trace1[memadr_8];
assign top_capture_rp_memory1_dat_r = memdat_7;

(* ram_style = "block" *) reg [15:0] adc_trace2[0:4095];
reg [11:0] memadr_9;
reg [15:0] memdat_8;
always @(posedge cap_clk) begin : mem_write_block_19
	if (top_capture_wp_memory2_we)
		adc_trace2[top_capture_wp_memory2_adr] <= top_capture_wp_memory2_dat_w;
	memadr_9 <= top_capture_wp_memory2_adr;
end

always @(posedge sys_clk) begin : mem_write_block_20
	memdat_8 <= adc_trace2[top_capture_rp_memory2_adr];
end

assign top_capture_wp_memory2_dat_r = adc_trace2[memadr_9];
assign top_capture_rp_memory2_dat_r = memdat_8;

(* ram_style = "block" *) reg [15:0] adc_trace3[0:4095];
reg [11:0] memadr_10;
reg [15:0] memdat_9;
always @(posedge cap_clk) begin : mem_write_block_21
	if (top_capture_wp_memory3_we)
		adc_trace3[top_capture_wp_memory3_adr] <= top_capture_wp_memory3_dat_w;
	memadr_10 <= top_capture_wp_memory3_adr;
end

always @(posedge sys_clk) begin : mem_write_block_22
	memdat_9 <= adc_trace3[top_capture_rp_memory3_adr];
end

assign top_capture_wp_memory3_dat_r = adc_trace3[memadr_10];
assign top_capture_rp_memory3_dat_r = memdat_9;

(* ram_style = "block" *) reg [15:0] adc_trace4[0:4095];
reg [11:0] memadr_11;
reg [15:0] memdat_10;
always @(posedge cap_clk) begin : mem_write_block_23
	if (top_capture_wp_memory4_we)
		adc_trace4[top_capture_wp_memory4_adr] <= top_capture_wp_memory4_dat_w;
	memadr_11 <= top_capture_wp_memory4_adr;
end

always @(posedge sys_clk) begin : mem_write_block_24
	memdat_10 <= adc_trace4[top_capture_rp_memory4_adr];
end

assign top_capture_wp_memory4_dat_r = adc_trace4[memadr_11];
assign top_capture_rp_memory4_dat_r = memdat_10;

(* ram_style = "block" *) reg [15:0] adc_trace5[0:4095];
reg [11:0] memadr_12;
reg [15:0] memdat_11;
always @(posedge cap_clk) begin : mem_write_block_25
	if (top_capture_wp_memory5_we)
		adc_trace5[top_capture_wp_memory5_adr] <= top_capture_wp_memory5_dat_w;
	memadr_12 <= top_capture_wp_memory5_adr;
end

always @(posedge sys_clk) begin : mem_write_block_26
	memdat_11 <= adc_trace5[top_capture_rp_memory5_adr];
end

assign top_capture_wp_memory5_dat_r = adc_trace5[memadr_12];
assign top_capture_rp_memory5_dat_r = memdat_11;

(* ram_style = "block" *) reg [15:0] adc_trace6[0:4095];
reg [11:0] memadr_13;
reg [15:0] memdat_12;
always @(posedge cap_clk) begin : mem_write_block_27
	if (top_capture_wp_memory6_we)
		adc_trace6[top_capture_wp_memory6_adr] <= top_capture_wp_memory6_dat_w;
	memadr_13 <= top_capture_wp_memory6_adr;
end

always @(posedge sys_clk) begin : mem_write_block_28
	memdat_12 <= adc_trace6[top_capture_rp_memory6_adr];
end

assign top_capture_wp_memory6_dat_r = adc_trace6[memadr_13];
assign top_capture_rp_memory6_dat_r = memdat_12;

(* ram_style = "block" *) reg [15:0] adc_trace7[0:4095];
reg [11:0] memadr_14;
reg [15:0] memdat_13;
always @(posedge cap_clk) begin : mem_write_block_29
	if (top_capture_wp_memory7_we)
		adc_trace7[top_capture_wp_memory7_adr] <= top_capture_wp_memory7_dat_w;
	memadr_14 <= top_capture_wp_memory7_adr;
end

always @(posedge sys_clk) begin : mem_write_block_30
	memdat_13 <= adc_trace7[top_capture_rp_memory7_adr];
end

assign top_capture_wp_memory7_dat_r = adc_trace7[memadr_14];
assign top_capture_rp_memory7_dat_r = memdat_13;

(* ram_style = "block" *) reg [15:0] adc_trace8[0:4095];
reg [11:0] memadr_15;
reg [15:0] memdat_14;
always @(posedge cap_clk) begin : mem_write_block_31
	if (top_capture_wp_memory8_we)
		adc_trace8[top_capture_wp_memory8_adr] <= top_capture_wp_memory8_dat_w;
	memadr_15 <= top_capture_wp_memory8_adr;
end

always @(posedge sys_clk) begin : mem_write_block_32
	memdat_14 <= adc_trace8[top_capture_rp_memory8_adr];
end

assign top_capture_wp_memory8_dat_r = adc_trace8[memadr_15];
assign top_capture_rp_memory8_dat_r = memdat_14;

(* ram_style = "block" *) reg [15:0] adc_trace9[0:4095];
reg [11:0] memadr_16;
reg [15:0] memdat_15;
always @(posedge cap_clk) begin : mem_write_block_33
	if (top_capture_wp_memory9_we)
		adc_trace9[top_capture_wp_memory9_adr] <= top_capture_wp_memory9_dat_w;
	memadr_16 <= top_capture_wp_memory9_adr;
end

always @(posedge sys_clk) begin : mem_write_block_34
	memdat_15 <= adc_trace9[top_capture_rp_memory9_adr];
end

assign top_capture_wp_memory9_dat_r = adc_trace9[memadr_16];
assign top_capture_rp_memory9_dat_r = memdat_15;

(* ram_style = "block" *) reg [15:0] adc_trace10[0:4095];
reg [11:0] memadr_17;
reg [15:0] memdat_16;
always @(posedge cap_clk) begin : mem_write_block_35
	if (top_capture_wp_memory10_we)
		adc_trace10[top_capture_wp_memory10_adr] <= top_capture_wp_memory10_dat_w;
	memadr_17 <= top_capture_wp_memory10_adr;
end

always @(posedge sys_clk) begin : mem_write_block_36
	memdat_16 <= adc_trace10[top_capture_rp_memory10_adr];
end

assign top_capture_wp_memory10_dat_r = adc_trace10[memadr_17];
assign top_capture_rp_memory10_dat_r = memdat_16;

(* ram_style = "block" *) reg [15:0] adc_trace11[0:4095];
reg [11:0] memadr_18;
reg [15:0] memdat_17;
always @(posedge cap_clk) begin : mem_write_block_37
	if (top_capture_wp_memory11_we)
		adc_trace11[top_capture_wp_memory11_adr] <= top_capture_wp_memory11_dat_w;
	memadr_18 <= top_capture_wp_memory11_adr;
end

always @(posedge sys_clk) begin : mem_write_block_38
	memdat_17 <= adc_trace11[top_capture_rp_memory11_adr];
end

assign top_capture_wp_memory11_dat_r = adc_trace11[memadr_18];
assign top_capture_rp_memory11_dat_r = memdat_17;

IBUF IBUF(
	.I(I2C_SDA),
	.O(top_raw[0])
);

IBUF IBUF_1(
	.I(I2C_SCL),
	.O(top_raw[1])
);

IBUF IBUF_2(
	.I(I2C_RESET_N),
	.O(top_raw[2])
);

reg [34:0] i2c_events0[0:2047];
reg [10:0] memadr_19;
reg [10:0] memadr_20;
always @(posedge sys_clk) begin : mem_write_block_39
	if (top_analyzer_wp_memory0_we)
		i2c_events0[top_analyzer_wp_memory0_adr] <= top_analyzer_wp_memory0_dat_w;
	memadr_19 <= top_analyzer_wp_memory0_adr;
end

always @(posedge sys_clk) begin : mem_write_block_40
	memadr_20 <= top_analyzer_rp_memory0_adr;
end

assign top_analyzer_wp_memory0_dat_r = i2c_events0[memadr_19];
assign top_analyzer_rp_memory0_dat_r = i2c_events0[memadr_20];

reg [34:0] i2c_events1[0:2047];
reg [10:0] memadr_21;
reg [10:0] memadr_22;
always @(posedge sys_clk) begin : mem_write_block_41
	if (top_analyzer_wp_memory1_we)
		i2c_events1[top_analyzer_wp_memory1_adr] <= top_analyzer_wp_memory1_dat_w;
	memadr_21 <= top_analyzer_wp_memory1_adr;
end

always @(posedge sys_clk) begin : mem_write_block_42
	memadr_22 <= top_analyzer_rp_memory1_adr;
end

assign top_analyzer_wp_memory1_dat_r = i2c_events1[memadr_21];
assign top_analyzer_rp_memory1_dat_r = i2c_events1[memadr_22];

eth_jtag eth_jtag(
	.report(top_jtag_report),
	.command(top_command)
);

reg [15:0] tdc_events0[0:4095];
reg [11:0] memadr_23;
reg [15:0] memdat_18;
always @(posedge tdc1_clk) begin : mem_write_block_43
	if (top_tdc_frontend_tdcbuffers_wp_memory0_we)
		tdc_events0[top_tdc_frontend_tdcbuffers_wp_memory0_adr] <= top_tdc_frontend_tdcbuffers_wp_memory0_dat_w;
	memadr_23 <= top_tdc_frontend_tdcbuffers_wp_memory0_adr;
end

always @(posedge sys_clk) begin : mem_write_block_44
	memdat_18 <= tdc_events0[top_tdc_frontend_tdcbuffers_rp_memory0_adr];
end

assign top_tdc_frontend_tdcbuffers_wp_memory0_dat_r = tdc_events0[memadr_23];
assign top_tdc_frontend_tdcbuffers_rp_memory0_dat_r = memdat_18;

reg [15:0] tdc_events1[0:4095];
reg [11:0] memadr_24;
reg [15:0] memdat_19;
always @(posedge tdc1_clk) begin : mem_write_block_45
	if (top_tdc_frontend_tdcbuffers_wp_memory1_we)
		tdc_events1[top_tdc_frontend_tdcbuffers_wp_memory1_adr] <= top_tdc_frontend_tdcbuffers_wp_memory1_dat_w;
	memadr_24 <= top_tdc_frontend_tdcbuffers_wp_memory1_adr;
end

always @(posedge sys_clk) begin : mem_write_block_46
	memdat_19 <= tdc_events1[top_tdc_frontend_tdcbuffers_rp_memory1_adr];
end

assign top_tdc_frontend_tdcbuffers_wp_memory1_dat_r = tdc_events1[memadr_24];
assign top_tdc_frontend_tdcbuffers_rp_memory1_dat_r = memdat_19;

reg [15:0] tdc_events2[0:4095];
reg [11:0] memadr_25;
reg [15:0] memdat_20;
always @(posedge tdc1_clk) begin : mem_write_block_47
	if (top_tdc_frontend_tdcbuffers_wp_memory2_we)
		tdc_events2[top_tdc_frontend_tdcbuffers_wp_memory2_adr] <= top_tdc_frontend_tdcbuffers_wp_memory2_dat_w;
	memadr_25 <= top_tdc_frontend_tdcbuffers_wp_memory2_adr;
end

always @(posedge sys_clk) begin : mem_write_block_48
	memdat_20 <= tdc_events2[top_tdc_frontend_tdcbuffers_rp_memory2_adr];
end

assign top_tdc_frontend_tdcbuffers_wp_memory2_dat_r = tdc_events2[memadr_25];
assign top_tdc_frontend_tdcbuffers_rp_memory2_dat_r = memdat_20;

reg [15:0] tdc_events3[0:4095];
reg [11:0] memadr_26;
reg [15:0] memdat_21;
always @(posedge tdc1_clk) begin : mem_write_block_49
	if (top_tdc_frontend_tdcbuffers_wp_memory3_we)
		tdc_events3[top_tdc_frontend_tdcbuffers_wp_memory3_adr] <= top_tdc_frontend_tdcbuffers_wp_memory3_dat_w;
	memadr_26 <= top_tdc_frontend_tdcbuffers_wp_memory3_adr;
end

always @(posedge sys_clk) begin : mem_write_block_50
	memdat_21 <= tdc_events3[top_tdc_frontend_tdcbuffers_rp_memory3_adr];
end

assign top_tdc_frontend_tdcbuffers_wp_memory3_dat_r = tdc_events3[memadr_26];
assign top_tdc_frontend_tdcbuffers_rp_memory3_dat_r = memdat_21;

reg [15:0] tdc_events4[0:4095];
reg [11:0] memadr_27;
reg [15:0] memdat_22;
always @(posedge tdc2_clk) begin : mem_write_block_51
	if (top_tdc_frontend_tdcbuffers_wp_memory4_we)
		tdc_events4[top_tdc_frontend_tdcbuffers_wp_memory4_adr] <= top_tdc_frontend_tdcbuffers_wp_memory4_dat_w;
	memadr_27 <= top_tdc_frontend_tdcbuffers_wp_memory4_adr;
end

always @(posedge sys_clk) begin : mem_write_block_52
	memdat_22 <= tdc_events4[top_tdc_frontend_tdcbuffers_rp_memory4_adr];
end

assign top_tdc_frontend_tdcbuffers_wp_memory4_dat_r = tdc_events4[memadr_27];
assign top_tdc_frontend_tdcbuffers_rp_memory4_dat_r = memdat_22;

reg [15:0] tdc_events5[0:4095];
reg [11:0] memadr_28;
reg [15:0] memdat_23;
always @(posedge tdc2_clk) begin : mem_write_block_53
	if (top_tdc_frontend_tdcbuffers_wp_memory5_we)
		tdc_events5[top_tdc_frontend_tdcbuffers_wp_memory5_adr] <= top_tdc_frontend_tdcbuffers_wp_memory5_dat_w;
	memadr_28 <= top_tdc_frontend_tdcbuffers_wp_memory5_adr;
end

always @(posedge sys_clk) begin : mem_write_block_54
	memdat_23 <= tdc_events5[top_tdc_frontend_tdcbuffers_rp_memory5_adr];
end

assign top_tdc_frontend_tdcbuffers_wp_memory5_dat_r = tdc_events5[memadr_28];
assign top_tdc_frontend_tdcbuffers_rp_memory5_dat_r = memdat_23;

reg [15:0] tdc_events6[0:4095];
reg [11:0] memadr_29;
reg [15:0] memdat_24;
always @(posedge tdc2_clk) begin : mem_write_block_55
	if (top_tdc_frontend_tdcbuffers_wp_memory6_we)
		tdc_events6[top_tdc_frontend_tdcbuffers_wp_memory6_adr] <= top_tdc_frontend_tdcbuffers_wp_memory6_dat_w;
	memadr_29 <= top_tdc_frontend_tdcbuffers_wp_memory6_adr;
end

always @(posedge sys_clk) begin : mem_write_block_56
	memdat_24 <= tdc_events6[top_tdc_frontend_tdcbuffers_rp_memory6_adr];
end

assign top_tdc_frontend_tdcbuffers_wp_memory6_dat_r = tdc_events6[memadr_29];
assign top_tdc_frontend_tdcbuffers_rp_memory6_dat_r = memdat_24;

reg [15:0] tdc_events7[0:4095];
reg [11:0] memadr_30;
reg [15:0] memdat_25;
always @(posedge tdc2_clk) begin : mem_write_block_57
	if (top_tdc_frontend_tdcbuffers_wp_memory7_we)
		tdc_events7[top_tdc_frontend_tdcbuffers_wp_memory7_adr] <= top_tdc_frontend_tdcbuffers_wp_memory7_dat_w;
	memadr_30 <= top_tdc_frontend_tdcbuffers_wp_memory7_adr;
end

always @(posedge sys_clk) begin : mem_write_block_58
	memdat_25 <= tdc_events7[top_tdc_frontend_tdcbuffers_rp_memory7_adr];
end

assign top_tdc_frontend_tdcbuffers_wp_memory7_dat_r = tdc_events7[memadr_30];
assign top_tdc_frontend_tdcbuffers_rp_memory7_dat_r = memdat_25;

reg [15:0] tdc_events8[0:4095];
reg [11:0] memadr_31;
reg [15:0] memdat_26;
always @(posedge tdc3_clk) begin : mem_write_block_59
	if (top_tdc_frontend_tdcbuffers_wp_memory8_we)
		tdc_events8[top_tdc_frontend_tdcbuffers_wp_memory8_adr] <= top_tdc_frontend_tdcbuffers_wp_memory8_dat_w;
	memadr_31 <= top_tdc_frontend_tdcbuffers_wp_memory8_adr;
end

always @(posedge sys_clk) begin : mem_write_block_60
	memdat_26 <= tdc_events8[top_tdc_frontend_tdcbuffers_rp_memory8_adr];
end

assign top_tdc_frontend_tdcbuffers_wp_memory8_dat_r = tdc_events8[memadr_31];
assign top_tdc_frontend_tdcbuffers_rp_memory8_dat_r = memdat_26;

reg [15:0] tdc_events9[0:4095];
reg [11:0] memadr_32;
reg [15:0] memdat_27;
always @(posedge tdc3_clk) begin : mem_write_block_61
	if (top_tdc_frontend_tdcbuffers_wp_memory9_we)
		tdc_events9[top_tdc_frontend_tdcbuffers_wp_memory9_adr] <= top_tdc_frontend_tdcbuffers_wp_memory9_dat_w;
	memadr_32 <= top_tdc_frontend_tdcbuffers_wp_memory9_adr;
end

always @(posedge sys_clk) begin : mem_write_block_62
	memdat_27 <= tdc_events9[top_tdc_frontend_tdcbuffers_rp_memory9_adr];
end

assign top_tdc_frontend_tdcbuffers_wp_memory9_dat_r = tdc_events9[memadr_32];
assign top_tdc_frontend_tdcbuffers_rp_memory9_dat_r = memdat_27;

reg [15:0] tdc_events10[0:4095];
reg [11:0] memadr_33;
reg [15:0] memdat_28;
always @(posedge tdc3_clk) begin : mem_write_block_63
	if (top_tdc_frontend_tdcbuffers_wp_memory10_we)
		tdc_events10[top_tdc_frontend_tdcbuffers_wp_memory10_adr] <= top_tdc_frontend_tdcbuffers_wp_memory10_dat_w;
	memadr_33 <= top_tdc_frontend_tdcbuffers_wp_memory10_adr;
end

always @(posedge sys_clk) begin : mem_write_block_64
	memdat_28 <= tdc_events10[top_tdc_frontend_tdcbuffers_rp_memory10_adr];
end

assign top_tdc_frontend_tdcbuffers_wp_memory10_dat_r = tdc_events10[memadr_33];
assign top_tdc_frontend_tdcbuffers_rp_memory10_dat_r = memdat_28;

reg [15:0] tdc_events11[0:4095];
reg [11:0] memadr_34;
reg [15:0] memdat_29;
always @(posedge tdc3_clk) begin : mem_write_block_65
	if (top_tdc_frontend_tdcbuffers_wp_memory11_we)
		tdc_events11[top_tdc_frontend_tdcbuffers_wp_memory11_adr] <= top_tdc_frontend_tdcbuffers_wp_memory11_dat_w;
	memadr_34 <= top_tdc_frontend_tdcbuffers_wp_memory11_adr;
end

always @(posedge sys_clk) begin : mem_write_block_66
	memdat_29 <= tdc_events11[top_tdc_frontend_tdcbuffers_rp_memory11_adr];
end

assign top_tdc_frontend_tdcbuffers_wp_memory11_dat_r = tdc_events11[memadr_34];
assign top_tdc_frontend_tdcbuffers_rp_memory11_dat_r = memdat_29;

TDCCHAN TDC1_CHA(
	.bc_time(top_tdc_frontend_bc_time0),
	.clk300(top_tdc_frontend_clk300_0),
	.clk600(top_tdc_frontend_clk600_0),
	.clk600_90(top_tdc_frontend_clk600_90_0),
	.pin_in(top_tdc_frontend_cfd0),
	.rdata(top_tdc_frontend_rdata0),
	.reset(top_tdc_frontend_receiver_reset[0]),
	.rstr(top_tdc_frontend_rstr0),
	.tdc_count(top_tdc_frontend_coarse_count0),
	.tdc_raw_lock(1'd0),
	.tdcclk(tdc1_clk),
	.diag_raw_valid(top_tdc_frontend_tdcbuffers_event0),
	.tdc_raw(top_tdc_frontend_tdcbuffers_raw0)
);

TDCCHAN TDC1_CHB(
	.bc_time(top_tdc_frontend_bc_time0),
	.clk300(top_tdc_frontend_clk300_0),
	.clk600(top_tdc_frontend_clk600_0),
	.clk600_90(top_tdc_frontend_clk600_90_0),
	.pin_in(top_tdc_frontend_cfd1),
	.rdata(top_tdc_frontend_rdata1),
	.reset(top_tdc_frontend_receiver_reset[0]),
	.rstr(top_tdc_frontend_rstr1),
	.tdc_count(top_tdc_frontend_coarse_count0),
	.tdc_raw_lock(1'd0),
	.tdcclk(tdc1_clk),
	.diag_raw_valid(top_tdc_frontend_tdcbuffers_event1),
	.tdc_raw(top_tdc_frontend_tdcbuffers_raw1)
);

TDCCHAN TDC1_CHC(
	.bc_time(top_tdc_frontend_bc_time0),
	.clk300(top_tdc_frontend_clk300_0),
	.clk600(top_tdc_frontend_clk600_0),
	.clk600_90(top_tdc_frontend_clk600_90_0),
	.pin_in(top_tdc_frontend_cfd2),
	.rdata(top_tdc_frontend_rdata2),
	.reset(top_tdc_frontend_receiver_reset[0]),
	.rstr(top_tdc_frontend_rstr2),
	.tdc_count(top_tdc_frontend_coarse_count0),
	.tdc_raw_lock(1'd0),
	.tdcclk(tdc1_clk),
	.diag_raw_valid(top_tdc_frontend_tdcbuffers_event2),
	.tdc_raw(top_tdc_frontend_tdcbuffers_raw2)
);

TDCCHAN TDC1_CHD(
	.bc_time(top_tdc_frontend_bc_time0),
	.clk300(top_tdc_frontend_clk300_0),
	.clk600(top_tdc_frontend_clk600_0),
	.clk600_90(top_tdc_frontend_clk600_90_0),
	.pin_in(top_tdc_frontend_cfd3),
	.rdata(top_tdc_frontend_rdata3),
	.reset(top_tdc_frontend_receiver_reset[0]),
	.rstr(top_tdc_frontend_rstr3),
	.tdc_count(top_tdc_frontend_coarse_count0),
	.tdc_raw_lock(1'd0),
	.tdcclk(tdc1_clk),
	.diag_raw_valid(top_tdc_frontend_tdcbuffers_event3),
	.tdc_raw(top_tdc_frontend_tdcbuffers_raw3)
);

TDCCHAN TDC2_CHA(
	.bc_time(top_tdc_frontend_bc_time1),
	.clk300(top_tdc_frontend_clk300_1),
	.clk600(top_tdc_frontend_clk600_1),
	.clk600_90(top_tdc_frontend_clk600_90_1),
	.pin_in(top_tdc_frontend_cfd4),
	.rdata(top_tdc_frontend_rdata4),
	.reset(top_tdc_frontend_receiver_reset[1]),
	.rstr(top_tdc_frontend_rstr4),
	.tdc_count(top_tdc_frontend_coarse_count1),
	.tdc_raw_lock(1'd0),
	.tdcclk(tdc2_clk),
	.diag_raw_valid(top_tdc_frontend_tdcbuffers_event4),
	.tdc_raw(top_tdc_frontend_tdcbuffers_raw4)
);

TDCCHAN TDC2_CHB(
	.bc_time(top_tdc_frontend_bc_time1),
	.clk300(top_tdc_frontend_clk300_1),
	.clk600(top_tdc_frontend_clk600_1),
	.clk600_90(top_tdc_frontend_clk600_90_1),
	.pin_in(top_tdc_frontend_cfd5),
	.rdata(top_tdc_frontend_rdata5),
	.reset(top_tdc_frontend_receiver_reset[1]),
	.rstr(top_tdc_frontend_rstr5),
	.tdc_count(top_tdc_frontend_coarse_count1),
	.tdc_raw_lock(1'd0),
	.tdcclk(tdc2_clk),
	.diag_raw_valid(top_tdc_frontend_tdcbuffers_event5),
	.tdc_raw(top_tdc_frontend_tdcbuffers_raw5)
);

TDCCHAN TDC2_CHC(
	.bc_time(top_tdc_frontend_bc_time1),
	.clk300(top_tdc_frontend_clk300_1),
	.clk600(top_tdc_frontend_clk600_1),
	.clk600_90(top_tdc_frontend_clk600_90_1),
	.pin_in(top_tdc_frontend_cfd6),
	.rdata(top_tdc_frontend_rdata6),
	.reset(top_tdc_frontend_receiver_reset[1]),
	.rstr(top_tdc_frontend_rstr6),
	.tdc_count(top_tdc_frontend_coarse_count1),
	.tdc_raw_lock(1'd0),
	.tdcclk(tdc2_clk),
	.diag_raw_valid(top_tdc_frontend_tdcbuffers_event6),
	.tdc_raw(top_tdc_frontend_tdcbuffers_raw6)
);

TDCCHAN TDC2_CHD(
	.bc_time(top_tdc_frontend_bc_time1),
	.clk300(top_tdc_frontend_clk300_1),
	.clk600(top_tdc_frontend_clk600_1),
	.clk600_90(top_tdc_frontend_clk600_90_1),
	.pin_in(top_tdc_frontend_cfd7),
	.rdata(top_tdc_frontend_rdata7),
	.reset(top_tdc_frontend_receiver_reset[1]),
	.rstr(top_tdc_frontend_rstr7),
	.tdc_count(top_tdc_frontend_coarse_count1),
	.tdc_raw_lock(1'd0),
	.tdcclk(tdc2_clk),
	.diag_raw_valid(top_tdc_frontend_tdcbuffers_event7),
	.tdc_raw(top_tdc_frontend_tdcbuffers_raw7)
);

TDCCHAN TDC3_CHA(
	.bc_time(top_tdc_frontend_bc_time2),
	.clk300(top_tdc_frontend_clk300_2),
	.clk600(top_tdc_frontend_clk600_2),
	.clk600_90(top_tdc_frontend_clk600_90_2),
	.pin_in(top_tdc_frontend_cfd8),
	.rdata(top_tdc_frontend_rdata8),
	.reset(top_tdc_frontend_receiver_reset[2]),
	.rstr(top_tdc_frontend_rstr8),
	.tdc_count(top_tdc_frontend_coarse_count2),
	.tdc_raw_lock(1'd0),
	.tdcclk(tdc3_clk),
	.diag_raw_valid(top_tdc_frontend_tdcbuffers_event8),
	.tdc_raw(top_tdc_frontend_tdcbuffers_raw8)
);

TDCCHAN TDC3_CHB(
	.bc_time(top_tdc_frontend_bc_time2),
	.clk300(top_tdc_frontend_clk300_2),
	.clk600(top_tdc_frontend_clk600_2),
	.clk600_90(top_tdc_frontend_clk600_90_2),
	.pin_in(top_tdc_frontend_cfd9),
	.rdata(top_tdc_frontend_rdata9),
	.reset(top_tdc_frontend_receiver_reset[2]),
	.rstr(top_tdc_frontend_rstr9),
	.tdc_count(top_tdc_frontend_coarse_count2),
	.tdc_raw_lock(1'd0),
	.tdcclk(tdc3_clk),
	.diag_raw_valid(top_tdc_frontend_tdcbuffers_event9),
	.tdc_raw(top_tdc_frontend_tdcbuffers_raw9)
);

TDCCHAN TDC3_CHC(
	.bc_time(top_tdc_frontend_bc_time2),
	.clk300(top_tdc_frontend_clk300_2),
	.clk600(top_tdc_frontend_clk600_2),
	.clk600_90(top_tdc_frontend_clk600_90_2),
	.pin_in(top_tdc_frontend_cfd10),
	.rdata(top_tdc_frontend_rdata10),
	.reset(top_tdc_frontend_receiver_reset[2]),
	.rstr(top_tdc_frontend_rstr10),
	.tdc_count(top_tdc_frontend_coarse_count2),
	.tdc_raw_lock(1'd0),
	.tdcclk(tdc3_clk),
	.diag_raw_valid(top_tdc_frontend_tdcbuffers_event10),
	.tdc_raw(top_tdc_frontend_tdcbuffers_raw10)
);

TDCCHAN TDC3_CHD(
	.bc_time(top_tdc_frontend_bc_time2),
	.clk300(top_tdc_frontend_clk300_2),
	.clk600(top_tdc_frontend_clk600_2),
	.clk600_90(top_tdc_frontend_clk600_90_2),
	.pin_in(top_tdc_frontend_cfd11),
	.rdata(top_tdc_frontend_rdata11),
	.reset(top_tdc_frontend_receiver_reset[2]),
	.rstr(top_tdc_frontend_rstr11),
	.tdc_count(top_tdc_frontend_coarse_count2),
	.tdc_raw_lock(1'd0),
	.tdcclk(tdc3_clk),
	.diag_raw_valid(top_tdc_frontend_tdcbuffers_event11),
	.tdc_raw(top_tdc_frontend_tdcbuffers_raw11)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_1 (
	.I(TDCCLK1_P),
	.IB(TDCCLK1_N),
	.O(top_tdc_frontend_result_v0)
);

BUFR #(
	.BUFR_DIVIDE("BYPASS")
) BUFR (
	.CE(1'd1),
	.CLR(1'd0),
	.I(top_tdc_frontend_result_v0),
	.O(tdc1_clk)
);

pin_capt reference_capture1(
	.clk300(coarse1_clk),
	.clk600(top_tdc_frontend_clk600_0),
	.clk600_90(top_tdc_frontend_clk600_90_0),
	.pin_in(top_m),
	.pin_out(top_tdc_frontend_clock_in0),
	.ptime(top_tdc_frontend_bits0),
	.str(top_tdc_frontend_st0)
);

MMCME2_ADV #(
	.BANDWIDTH("HIGH"),
	.CLKFBOUT_MULT_F(30.0),
	.CLKFBOUT_PHASE(3.0),
	.CLKFBOUT_USE_FINE_PS("TRUE"),
	.CLKIN1_PERIOD(8.333333333333334),
	.CLKOUT0_DIVIDE_F(2.0),
	.CLKOUT1_DIVIDE(2'd2),
	.CLKOUT1_PHASE(90.0),
	.CLKOUT2_DIVIDE(3'd4),
	.COMPENSATION("ZHOLD"),
	.DIVCLK_DIVIDE(2'd3)
) tdc_mmcm1 (
	.CLKFBIN(top_tdc_frontend_fb0),
	.CLKIN1(top_tdc_frontend_clock_in0),
	.CLKIN2(1'd0),
	.CLKINSEL(1'd1),
	.DADDR(1'd0),
	.DCLK(1'd0),
	.DEN(1'd0),
	.DI(1'd0),
	.DWE(1'd0),
	.PSCLK(coarse1_clk),
	.PSEN(top_tdc_frontend_ps_en0),
	.PSINCDEC(top_tdc_frontend_ps_dir0),
	.PWRDWN(1'd0),
	.RST(sys_rst),
	.CLKFBOUT(top_tdc_frontend_feedback0),
	.CLKOUT0(top_tdc_frontend_c6000),
	.CLKOUT1(top_tdc_frontend_c900),
	.CLKOUT2(top_tdc_frontend_c3000),
	.LOCKED(top_tdc_frontend_lock0)
);

BUFH BUFH_3(
	.I(top_tdc_frontend_feedback0),
	.O(top_tdc_frontend_fb0)
);

BUFH BUFH_4(
	.I(top_tdc_frontend_c6000),
	.O(top_tdc_frontend_clk600_0)
);

BUFH BUFH_5(
	.I(top_tdc_frontend_c900),
	.O(top_tdc_frontend_clk600_90_0)
);

BUFH BUFH_6(
	.I(top_tdc_frontend_c3000),
	.O(coarse1_clk)
);

autophase autophase1(
	.clk(coarse1_clk),
	.jump(top_tdc_frontend_jump0),
	.lock(top_tdc_frontend_lock0),
	.done(top_tdc_frontend_done0),
	.psen(top_tdc_frontend_ps_en0),
	.psincdec(top_tdc_frontend_ps_dir0)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_2 (
	.I(INA1_P),
	.IB(INA1_N),
	.O(top_tdc_frontend_frontend_v0)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_3 (
	.I(RSA1_P),
	.IB(RSA1_N),
	.O(top_tdc_frontend_frontend_v1)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_4 (
	.I(RDA1_P),
	.IB(RDA1_N),
	.O(top_tdc_frontend_frontend_v2)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_5 (
	.I(INB1_P),
	.IB(INB1_N),
	.O(top_tdc_frontend_frontend_v3)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_6 (
	.I(RSB1_P),
	.IB(RSB1_N),
	.O(top_tdc_frontend_frontend_v4)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_7 (
	.I(RDB1_P),
	.IB(RDB1_N),
	.O(top_tdc_frontend_frontend_v5)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_8 (
	.I(INC1_P),
	.IB(INC1_N),
	.O(top_tdc_frontend_frontend_v6)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_9 (
	.I(RSC1_P),
	.IB(RSC1_N),
	.O(top_tdc_frontend_frontend_v7)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_10 (
	.I(RDC1_P),
	.IB(RDC1_N),
	.O(top_tdc_frontend_frontend_v8)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_11 (
	.I(IND1_P),
	.IB(IND1_N),
	.O(top_tdc_frontend_frontend_v9)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_12 (
	.I(RSD1_P),
	.IB(RSD1_N),
	.O(top_tdc_frontend_frontend_v10)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_13 (
	.I(RDD1_P),
	.IB(RDD1_N),
	.O(top_tdc_frontend_frontend_v11)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_14 (
	.I(TDCCLK2_P),
	.IB(TDCCLK2_N),
	.O(top_tdc_frontend_result_v1)
);

BUFR #(
	.BUFR_DIVIDE("BYPASS")
) BUFR_1 (
	.CE(1'd1),
	.CLR(1'd0),
	.I(top_tdc_frontend_result_v1),
	.O(tdc2_clk)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_15 (
	.I(MCLK2_P),
	.IB(MCLK2_N),
	.O(top_tdc_frontend_reference_v0)
);

pin_capt reference_capture2(
	.clk300(coarse2_clk),
	.clk600(top_tdc_frontend_clk600_1),
	.clk600_90(top_tdc_frontend_clk600_90_1),
	.pin_in(top_tdc_frontend_reference_v0),
	.pin_out(top_tdc_frontend_clock_in1),
	.ptime(top_tdc_frontend_bits1),
	.str(top_tdc_frontend_st1)
);

MMCME2_ADV #(
	.BANDWIDTH("HIGH"),
	.CLKFBOUT_MULT_F(30.0),
	.CLKFBOUT_PHASE(3.0),
	.CLKFBOUT_USE_FINE_PS("TRUE"),
	.CLKIN1_PERIOD(8.333333333333334),
	.CLKOUT0_DIVIDE_F(2.0),
	.CLKOUT1_DIVIDE(2'd2),
	.CLKOUT1_PHASE(90.0),
	.CLKOUT2_DIVIDE(3'd4),
	.COMPENSATION("ZHOLD"),
	.DIVCLK_DIVIDE(2'd3)
) tdc_mmcm2 (
	.CLKFBIN(top_tdc_frontend_fb1),
	.CLKIN1(top_tdc_frontend_clock_in1),
	.CLKIN2(1'd0),
	.CLKINSEL(1'd1),
	.DADDR(1'd0),
	.DCLK(1'd0),
	.DEN(1'd0),
	.DI(1'd0),
	.DWE(1'd0),
	.PSCLK(coarse2_clk),
	.PSEN(top_tdc_frontend_ps_en1),
	.PSINCDEC(top_tdc_frontend_ps_dir1),
	.PWRDWN(1'd0),
	.RST(sys_rst),
	.CLKFBOUT(top_tdc_frontend_feedback1),
	.CLKOUT0(top_tdc_frontend_c6001),
	.CLKOUT1(top_tdc_frontend_c901),
	.CLKOUT2(top_tdc_frontend_c3001),
	.LOCKED(top_tdc_frontend_lock1)
);

BUFH BUFH_7(
	.I(top_tdc_frontend_feedback1),
	.O(top_tdc_frontend_fb1)
);

BUFH BUFH_8(
	.I(top_tdc_frontend_c6001),
	.O(top_tdc_frontend_clk600_1)
);

BUFH BUFH_9(
	.I(top_tdc_frontend_c901),
	.O(top_tdc_frontend_clk600_90_1)
);

BUFH BUFH_10(
	.I(top_tdc_frontend_c3001),
	.O(coarse2_clk)
);

autophase autophase2(
	.clk(coarse2_clk),
	.jump(top_tdc_frontend_jump1),
	.lock(top_tdc_frontend_lock1),
	.done(top_tdc_frontend_done1),
	.psen(top_tdc_frontend_ps_en1),
	.psincdec(top_tdc_frontend_ps_dir1)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_16 (
	.I(INA2_P),
	.IB(INA2_N),
	.O(top_tdc_frontend_frontend_v12)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_17 (
	.I(RSA2_P),
	.IB(RSA2_N),
	.O(top_tdc_frontend_frontend_v13)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_18 (
	.I(RDA2_P),
	.IB(RDA2_N),
	.O(top_tdc_frontend_frontend_v14)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_19 (
	.I(INB2_P),
	.IB(INB2_N),
	.O(top_tdc_frontend_frontend_v15)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_20 (
	.I(RSB2_P),
	.IB(RSB2_N),
	.O(top_tdc_frontend_frontend_v16)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_21 (
	.I(RDB2_P),
	.IB(RDB2_N),
	.O(top_tdc_frontend_frontend_v17)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_22 (
	.I(INC2_P),
	.IB(INC2_N),
	.O(top_tdc_frontend_frontend_v18)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_23 (
	.I(RSC2_P),
	.IB(RSC2_N),
	.O(top_tdc_frontend_frontend_v19)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_24 (
	.I(RDC2_P),
	.IB(RDC2_N),
	.O(top_tdc_frontend_frontend_v20)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_25 (
	.I(IND2_P),
	.IB(IND2_N),
	.O(top_tdc_frontend_frontend_v21)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_26 (
	.I(RSD2_P),
	.IB(RSD2_N),
	.O(top_tdc_frontend_frontend_v22)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_27 (
	.I(RDD2_P),
	.IB(RDD2_N),
	.O(top_tdc_frontend_frontend_v23)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_28 (
	.I(TDCCLK3_P),
	.IB(TDCCLK3_N),
	.O(top_tdc_frontend_result_v2)
);

BUFR #(
	.BUFR_DIVIDE("BYPASS")
) BUFR_2 (
	.CE(1'd1),
	.CLR(1'd0),
	.I(top_tdc_frontend_result_v2),
	.O(tdc3_clk)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_29 (
	.I(MCLK3_P),
	.IB(MCLK3_N),
	.O(top_tdc_frontend_reference_v1)
);

pin_capt reference_capture3(
	.clk300(coarse3_clk),
	.clk600(top_tdc_frontend_clk600_2),
	.clk600_90(top_tdc_frontend_clk600_90_2),
	.pin_in(top_tdc_frontend_reference_v1),
	.pin_out(top_tdc_frontend_clock_in2),
	.ptime(top_tdc_frontend_bits2),
	.str(top_tdc_frontend_st2)
);

MMCME2_ADV #(
	.BANDWIDTH("HIGH"),
	.CLKFBOUT_MULT_F(30.0),
	.CLKFBOUT_PHASE(3.0),
	.CLKFBOUT_USE_FINE_PS("TRUE"),
	.CLKIN1_PERIOD(8.333333333333334),
	.CLKOUT0_DIVIDE_F(2.0),
	.CLKOUT1_DIVIDE(2'd2),
	.CLKOUT1_PHASE(90.0),
	.CLKOUT2_DIVIDE(3'd4),
	.COMPENSATION("ZHOLD"),
	.DIVCLK_DIVIDE(2'd3)
) tdc_mmcm3 (
	.CLKFBIN(top_tdc_frontend_fb2),
	.CLKIN1(top_tdc_frontend_clock_in2),
	.CLKIN2(1'd0),
	.CLKINSEL(1'd1),
	.DADDR(1'd0),
	.DCLK(1'd0),
	.DEN(1'd0),
	.DI(1'd0),
	.DWE(1'd0),
	.PSCLK(coarse3_clk),
	.PSEN(top_tdc_frontend_ps_en2),
	.PSINCDEC(top_tdc_frontend_ps_dir2),
	.PWRDWN(1'd0),
	.RST(sys_rst),
	.CLKFBOUT(top_tdc_frontend_feedback2),
	.CLKOUT0(top_tdc_frontend_c6002),
	.CLKOUT1(top_tdc_frontend_c902),
	.CLKOUT2(top_tdc_frontend_c3002),
	.LOCKED(top_tdc_frontend_lock2)
);

BUFH BUFH_11(
	.I(top_tdc_frontend_feedback2),
	.O(top_tdc_frontend_fb2)
);

BUFH BUFH_12(
	.I(top_tdc_frontend_c6002),
	.O(top_tdc_frontend_clk600_2)
);

BUFH BUFH_13(
	.I(top_tdc_frontend_c902),
	.O(top_tdc_frontend_clk600_90_2)
);

BUFH BUFH_14(
	.I(top_tdc_frontend_c3002),
	.O(coarse3_clk)
);

autophase autophase3(
	.clk(coarse3_clk),
	.jump(top_tdc_frontend_jump2),
	.lock(top_tdc_frontend_lock2),
	.done(top_tdc_frontend_done2),
	.psen(top_tdc_frontend_ps_en2),
	.psincdec(top_tdc_frontend_ps_dir2)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_30 (
	.I(INA3_P),
	.IB(INA3_N),
	.O(top_tdc_frontend_frontend_v24)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_31 (
	.I(RSA3_P),
	.IB(RSA3_N),
	.O(top_tdc_frontend_frontend_v25)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_32 (
	.I(RDA3_P),
	.IB(RDA3_N),
	.O(top_tdc_frontend_frontend_v26)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_33 (
	.I(INB3_P),
	.IB(INB3_N),
	.O(top_tdc_frontend_frontend_v27)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_34 (
	.I(RSB3_P),
	.IB(RSB3_N),
	.O(top_tdc_frontend_frontend_v28)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_35 (
	.I(RDB3_P),
	.IB(RDB3_N),
	.O(top_tdc_frontend_frontend_v29)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_36 (
	.I(INC3_P),
	.IB(INC3_N),
	.O(top_tdc_frontend_frontend_v30)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_37 (
	.I(RSC3_P),
	.IB(RSC3_N),
	.O(top_tdc_frontend_frontend_v31)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_38 (
	.I(RDC3_P),
	.IB(RDC3_N),
	.O(top_tdc_frontend_frontend_v32)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_39 (
	.I(IND3_P),
	.IB(IND3_N),
	.O(top_tdc_frontend_frontend_v33)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_40 (
	.I(RSD3_P),
	.IB(RSD3_N),
	.O(top_tdc_frontend_frontend_v34)
);

IBUFDS #(
	.DIFF_TERM("TRUE"),
	.IBUF_LOW_PWR("FALSE")
) IBUFDS_41 (
	.I(RDD3_P),
	.IB(RDD3_N),
	.O(top_tdc_frontend_frontend_v35)
);

pm_hdmi_idle pm_hdmi_idle(
	.clk(cap_clk),
	.phase(top_hdmi_phase),
	.data(top_hdmi_idle)
);

OBUFDS #(
	.IOSTANDARD("LVDS"),
	.SLEW("FAST")
) OBUFDS (
	.I(top_hdmi_data[0]),
	.O(HDMI_P0),
	.OB(HDMI_N0)
);

OBUFDS #(
	.IOSTANDARD("LVDS"),
	.SLEW("FAST")
) OBUFDS_1 (
	.I(top_hdmi_data[1]),
	.O(HDMI_P1),
	.OB(HDMI_N1)
);

OBUFDS #(
	.IOSTANDARD("LVDS"),
	.SLEW("FAST")
) OBUFDS_2 (
	.I(top_hdmi_data[2]),
	.O(HDMI_P2),
	.OB(HDMI_N2)
);

OBUFDS #(
	.IOSTANDARD("LVDS"),
	.SLEW("FAST")
) OBUFDS_3 (
	.I(top_hdmi_data[3]),
	.O(HDMI_P3),
	.OB(HDMI_N3)
);

hdmi_slave hdmi_slave(
	.clk(HSCK),
	.locked(top_cap_cm_locked),
	.mosi(HMOSI),
	.sel(HSEL),
	.miso(top_hdmi_mi),
	.scratch_out(top_hdmi_hs),
	.writes_out(top_hdmi_hw)
);

OBUFT OBUFT(
	.I(top_hdmi_mi),
	.T((~HSEL)),
	.O(HMISO)
);

rng_ipbus_endpoint rng_ipbus_endpoint(
	.ip_addr(32'd3232236272),
	.ipb_ack(top_registers_ack),
	.ipb_clk(sys_clk),
	.ipb_err(top_registers_err),
	.ipb_rdata(top_registers_rdata),
	.mac_addr(42'd2199023260161),
	.mac_clk(net_clk),
	.mac_rx_data(top_source_payload_data),
	.mac_rx_error((top_source_payload_error & top_source_valid)),
	.mac_rx_last((top_source_last & top_source_valid)),
	.mac_rx_valid(top_source_valid),
	.mac_tx_ready(top_sink_ready),
	.rst_ipb((~top_netlock)),
	.rst_macclk(net_rst),
	.got_ip(top_got_ip),
	.ipb_addr(top_registers_address),
	.ipb_strobe(top_registers_strobe),
	.ipb_wdata(top_registers_wdata),
	.ipb_write(top_registers_write),
	.mac_tx_data(top_sink_payload_data),
	.mac_tx_error(top_sink_payload_error),
	.mac_tx_last(top_sink_last),
	.mac_tx_valid(top_sink_valid)
);

pm12_mcu_spi pm12_mcu_spi(
	.MOSII(MOSI),
	.SCKI(SCK),
	.SPI_CS(CS),
	.MISOI(top_mi),
	.scratch_out(top_scratch),
	.writes_out(top_writes)
);

OBUFT OBUFT_1(
	.I(top_mi),
	.T(CS),
	.O(MISO)
);

FDCE FDCE(
	.C(top_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(top_fixed_cm_reset),
	.Q(s7mmcm0_reset0)
);

FDCE FDCE_1(
	.C(top_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset0),
	.Q(s7mmcm0_reset1)
);

FDCE FDCE_2(
	.C(top_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset1),
	.Q(s7mmcm0_reset2)
);

FDCE FDCE_3(
	.C(top_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset2),
	.Q(s7mmcm0_reset3)
);

FDCE FDCE_4(
	.C(top_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset3),
	.Q(s7mmcm0_reset4)
);

FDCE FDCE_5(
	.C(top_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset4),
	.Q(s7mmcm0_reset5)
);

FDCE FDCE_6(
	.C(top_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset5),
	.Q(s7mmcm0_reset6)
);

FDCE FDCE_7(
	.C(top_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset6),
	.Q(s7mmcm0_reset7)
);

MMCME2_ADV #(
	.BANDWIDTH("OPTIMIZED"),
	.CLKFBOUT_MULT_F(4'd12),
	.CLKIN1_PERIOD(10.0),
	.CLKOUT0_DIVIDE_F(5'd30),
	.CLKOUT0_PHASE(1'd0),
	.DIVCLK_DIVIDE(1'd1),
	.REF_JITTER1(0.01)
) MMCME2_ADV (
	.CLKFBIN(s7mmcm0_mmcm_fb0),
	.CLKIN1(top_s7mmcm0_clkin_signal),
	.PWRDWN(top_fixed_cm_power_down),
	.RST(s7mmcm0_reset7),
	.CLKFBOUT(s7mmcm0_mmcm_fb0),
	.CLKOUT0(top_s7mmcm0_clkout),
	.LOCKED(top_fixed_cm_locked)
);

FDCE FDCE_8(
	.C(top_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(top_cap_cm_reset),
	.Q(s7mmcm1_reset0)
);

FDCE FDCE_9(
	.C(top_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset0),
	.Q(s7mmcm1_reset1)
);

FDCE FDCE_10(
	.C(top_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset1),
	.Q(s7mmcm1_reset2)
);

FDCE FDCE_11(
	.C(top_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset2),
	.Q(s7mmcm1_reset3)
);

FDCE FDCE_12(
	.C(top_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset3),
	.Q(s7mmcm1_reset4)
);

FDCE FDCE_13(
	.C(top_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset4),
	.Q(s7mmcm1_reset5)
);

FDCE FDCE_14(
	.C(top_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset5),
	.Q(s7mmcm1_reset6)
);

FDCE FDCE_15(
	.C(top_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset6),
	.Q(s7mmcm1_reset7)
);

MMCME2_ADV #(
	.BANDWIDTH("OPTIMIZED"),
	.CLKFBOUT_MULT_F(5'd24),
	.CLKIN1_PERIOD(25.0),
	.CLKOUT0_DIVIDE_F(2'd3),
	.CLKOUT0_PHASE(1'd0),
	.DIVCLK_DIVIDE(1'd1),
	.REF_JITTER1(0.01)
) MMCME2_ADV_1 (
	.CLKFBIN(s7mmcm1_mmcm_fb0),
	.CLKIN1(top_s7mmcm1_clkin_signal),
	.PWRDWN(top_cap_cm_power_down),
	.RST(s7mmcm1_reset7),
	.CLKFBOUT(s7mmcm1_mmcm_fb0),
	.CLKOUT0(top_s7mmcm1_clkout),
	.LOCKED(top_cap_cm_locked)
);

FDCE FDCE_16(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(top_pma_k7_gtx_basex_tx_mmcm_reset1),
	.Q(s7mmcm0_reset8)
);

FDCE FDCE_17(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset8),
	.Q(s7mmcm0_reset9)
);

FDCE FDCE_18(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset9),
	.Q(s7mmcm0_reset10)
);

FDCE FDCE_19(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset10),
	.Q(s7mmcm0_reset11)
);

FDCE FDCE_20(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset11),
	.Q(s7mmcm0_reset12)
);

FDCE FDCE_21(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset12),
	.Q(s7mmcm0_reset13)
);

FDCE FDCE_22(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset13),
	.Q(s7mmcm0_reset14)
);

FDCE FDCE_23(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset14),
	.Q(s7mmcm0_reset15)
);

MMCME2_ADV #(
	.BANDWIDTH("OPTIMIZED"),
	.CLKFBOUT_MULT_F(5'd20),
	.CLKIN1_PERIOD(16.666666666666668),
	.CLKOUT0_DIVIDE_F(5'd20),
	.CLKOUT0_PHASE(1'd0),
	.CLKOUT1_DIVIDE(4'd10),
	.CLKOUT1_PHASE(1'd0),
	.DIVCLK_DIVIDE(1'd1),
	.REF_JITTER1(0.01)
) MMCME2_ADV_2 (
	.CLKFBIN(s7mmcm0_mmcm_fb1),
	.CLKIN1(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.PWRDWN(top_pma_k7_gtx_basex_tx_mmcm_power_down),
	.RST(s7mmcm0_reset15),
	.CLKFBOUT(s7mmcm0_mmcm_fb1),
	.CLKOUT0(top_pma_k7_gtx_basex_s7mmcm0_clkout0),
	.CLKOUT1(top_pma_k7_gtx_basex_s7mmcm0_clkout1),
	.LOCKED(top_pma_k7_gtx_basex_tx_mmcm_locked1)
);

FDCE FDCE_24(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(top_pma_k7_gtx_basex_rx_mmcm_reset1),
	.Q(s7mmcm1_reset8)
);

FDCE FDCE_25(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset8),
	.Q(s7mmcm1_reset9)
);

FDCE FDCE_26(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset9),
	.Q(s7mmcm1_reset10)
);

FDCE FDCE_27(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset10),
	.Q(s7mmcm1_reset11)
);

FDCE FDCE_28(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset11),
	.Q(s7mmcm1_reset12)
);

FDCE FDCE_29(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset12),
	.Q(s7mmcm1_reset13)
);

FDCE FDCE_30(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset13),
	.Q(s7mmcm1_reset14)
);

FDCE FDCE_31(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset14),
	.Q(s7mmcm1_reset15)
);

MMCME2_ADV #(
	.BANDWIDTH("OPTIMIZED"),
	.CLKFBOUT_MULT_F(5'd20),
	.CLKIN1_PERIOD(16.666666666666668),
	.CLKOUT0_DIVIDE_F(5'd20),
	.CLKOUT0_PHASE(1'd0),
	.CLKOUT1_DIVIDE(4'd10),
	.CLKOUT1_PHASE(1'd0),
	.DIVCLK_DIVIDE(1'd1),
	.REF_JITTER1(0.01)
) MMCME2_ADV_3 (
	.CLKFBIN(s7mmcm1_mmcm_fb1),
	.CLKIN1(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.PWRDWN(top_pma_k7_gtx_basex_rx_mmcm_power_down),
	.RST(s7mmcm1_reset15),
	.CLKFBOUT(s7mmcm1_mmcm_fb1),
	.CLKOUT0(top_pma_k7_gtx_basex_s7mmcm1_clkout0),
	.CLKOUT1(top_pma_k7_gtx_basex_s7mmcm1_clkout1),
	.LOCKED(top_pma_k7_gtx_basex_rx_mmcm_locked1)
);

(* ars_ff1 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE (
	.C(sys_clk),
	.CE(1'd1),
	.D(1'd0),
	.PRE(xilinxasyncresetsynchronizerimpl0_async_reset),
	.Q(xilinxasyncresetsynchronizerimpl0_rst_meta)
);

(* ars_ff2 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_1 (
	.C(sys_clk),
	.CE(1'd1),
	.D(xilinxasyncresetsynchronizerimpl0_rst_meta),
	.PRE(xilinxasyncresetsynchronizerimpl0_async_reset),
	.Q(sys_rst)
);

(* ars_ff1 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_2 (
	.C(cap_clk),
	.CE(1'd1),
	.D(1'd0),
	.PRE(xilinxasyncresetsynchronizerimpl1_async_reset),
	.Q(xilinxasyncresetsynchronizerimpl1_rst_meta)
);

(* ars_ff2 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_3 (
	.C(cap_clk),
	.CE(1'd1),
	.D(xilinxasyncresetsynchronizerimpl1_rst_meta),
	.PRE(xilinxasyncresetsynchronizerimpl1_async_reset),
	.Q(cap_rst)
);

(* ars_ff1 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_4 (
	.C(eth_tx_clk),
	.CE(1'd1),
	.D(1'd0),
	.PRE(xilinxasyncresetsynchronizerimpl2_async_reset),
	.Q(xilinxasyncresetsynchronizerimpl2_rst_meta)
);

(* ars_ff2 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_5 (
	.C(eth_tx_clk),
	.CE(1'd1),
	.D(xilinxasyncresetsynchronizerimpl2_rst_meta),
	.PRE(xilinxasyncresetsynchronizerimpl2_async_reset),
	.Q(eth_tx_rst)
);

(* ars_ff1 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_6 (
	.C(eth_rx_clk),
	.CE(1'd1),
	.D(1'd0),
	.PRE(xilinxasyncresetsynchronizerimpl3_async_reset),
	.Q(xilinxasyncresetsynchronizerimpl3_rst_meta)
);

(* ars_ff2 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_7 (
	.C(eth_rx_clk),
	.CE(1'd1),
	.D(xilinxasyncresetsynchronizerimpl3_rst_meta),
	.PRE(xilinxasyncresetsynchronizerimpl3_async_reset),
	.Q(eth_rx_rst)
);

(* ars_ff1 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_8 (
	.C(tdc1_clk),
	.CE(1'd1),
	.D(1'd0),
	.PRE(sys_rst),
	.Q(xilinxasyncresetsynchronizerimpl4_rst_meta)
);

(* ars_ff2 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_9 (
	.C(tdc1_clk),
	.CE(1'd1),
	.D(xilinxasyncresetsynchronizerimpl4_rst_meta),
	.PRE(sys_rst),
	.Q(tdc1_rst)
);

(* ars_ff1 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_10 (
	.C(tdc2_clk),
	.CE(1'd1),
	.D(1'd0),
	.PRE(sys_rst),
	.Q(xilinxasyncresetsynchronizerimpl5_rst_meta)
);

(* ars_ff2 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_11 (
	.C(tdc2_clk),
	.CE(1'd1),
	.D(xilinxasyncresetsynchronizerimpl5_rst_meta),
	.PRE(sys_rst),
	.Q(tdc2_rst)
);

(* ars_ff1 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_12 (
	.C(tdc3_clk),
	.CE(1'd1),
	.D(1'd0),
	.PRE(sys_rst),
	.Q(xilinxasyncresetsynchronizerimpl6_rst_meta)
);

(* ars_ff2 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_13 (
	.C(tdc3_clk),
	.CE(1'd1),
	.D(xilinxasyncresetsynchronizerimpl6_rst_meta),
	.PRE(sys_rst),
	.Q(tdc3_rst)
);

endmodule
