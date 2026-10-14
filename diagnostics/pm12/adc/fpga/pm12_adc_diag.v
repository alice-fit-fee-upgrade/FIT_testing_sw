/* Machine-generated using Migen */
module pm12_adc_diag(
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
	output EVNT
);

wire sys_clk;
reg sys_rst = 1'd0;
wire top_m;
wire top_ref;
wire cap_clk;
wire cap_rst;
reg top_reset = 1'd0;
reg top_power_down = 1'd0;
wire top_locked;
wire top_clkin_signal;
wire top_clkout;
wire top_clkout_buf;
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
reg [20:0] top_waittimer0_count = 21'd1250000;
reg top_waittimer1_wait = 1'd0;
wire top_waittimer1_done;
reg [20:0] top_waittimer1_count = 21'd1250000;
reg top_waittimer2_wait = 1'd0;
wire top_waittimer2_done;
reg [17:0] top_waittimer2_count = 18'd200000;
reg [19:0] top_checker_count = 20'd0;
reg top_checker_tick = 1'd0;
reg top_checker_error = 1'd0;
wire top_sgmii_speed_valid;
wire [1:0] top_sgmii_tx_speed;
wire [1:0] top_sgmii_rx_speed;
reg top_pma_k7_gtx_basex_reset = 1'd0;
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
wire top_mac_core_sink_valid;
wire top_mac_core_sink_ready;
wire top_mac_core_sink_first;
wire top_mac_core_sink_last;
wire [7:0] top_mac_core_sink_payload_data;
wire top_mac_core_sink_payload_be;
wire top_mac_core_sink_payload_error;
wire top_mac_core_source_valid;
wire top_mac_core_source_ready;
wire top_mac_core_source_first;
wire top_mac_core_source_last;
wire [7:0] top_mac_core_source_payload_data;
wire top_mac_core_source_payload_be;
wire top_mac_core_source_payload_error;
wire top_mac_core_tx_padding_sink_valid;
reg top_mac_core_tx_padding_sink_ready;
wire top_mac_core_tx_padding_sink_first;
wire top_mac_core_tx_padding_sink_last;
wire [7:0] top_mac_core_tx_padding_sink_payload_data;
wire top_mac_core_tx_padding_sink_payload_be;
wire top_mac_core_tx_padding_sink_payload_error;
reg top_mac_core_tx_padding_source_valid;
wire top_mac_core_tx_padding_source_ready;
reg top_mac_core_tx_padding_source_first;
reg top_mac_core_tx_padding_source_last;
reg [7:0] top_mac_core_tx_padding_source_payload_data;
reg top_mac_core_tx_padding_source_payload_be;
reg top_mac_core_tx_padding_source_payload_error;
reg [15:0] top_mac_core_tx_padding_counter = 16'd0;
wire top_mac_core_tx_padding_counter_done;
wire top_mac_core_tx_crc_sink_valid;
reg top_mac_core_tx_crc_sink_ready;
wire top_mac_core_tx_crc_sink_first;
wire top_mac_core_tx_crc_sink_last;
wire [7:0] top_mac_core_tx_crc_sink_payload_data;
wire top_mac_core_tx_crc_sink_payload_be;
wire top_mac_core_tx_crc_sink_payload_error;
reg top_mac_core_tx_crc_source_valid;
wire top_mac_core_tx_crc_source_ready;
reg top_mac_core_tx_crc_source_first;
reg top_mac_core_tx_crc_source_last;
reg [7:0] top_mac_core_tx_crc_source_payload_data;
reg top_mac_core_tx_crc_source_payload_be;
reg top_mac_core_tx_crc_source_payload_error;
reg [31:0] top_mac_core_tx_crc_crc_packet = 32'd0;
reg top_mac_core_tx_crc_be0 = 1'd0;
wire [7:0] top_mac_core_tx_crc_data0;
wire top_mac_core_tx_crc_be1;
reg [31:0] top_mac_core_tx_crc_value;
reg top_mac_core_tx_crc_error;
wire [7:0] top_mac_core_tx_crc_data1;
wire [31:0] top_mac_core_tx_crc_crc_prev;
reg [31:0] top_mac_core_tx_crc_crc_next;
reg [31:0] top_mac_core_tx_crc_reg = 32'd4294967295;
reg top_mac_core_tx_crc_ce;
reg top_mac_core_tx_crc_reset;
reg [1:0] top_mac_core_tx_crc_cnt = 2'd3;
wire top_mac_core_tx_crc_cnt_done;
reg top_mac_core_tx_crc_is_ongoing0;
reg top_mac_core_tx_crc_is_ongoing1;
wire top_mac_core_tx_crc_sink_sink_valid;
wire top_mac_core_tx_crc_sink_sink_ready;
wire top_mac_core_tx_crc_sink_sink_first;
wire top_mac_core_tx_crc_sink_sink_last;
wire [7:0] top_mac_core_tx_crc_sink_sink_payload_data;
wire top_mac_core_tx_crc_sink_sink_payload_be;
wire top_mac_core_tx_crc_sink_sink_payload_error;
wire top_mac_core_tx_crc_source_source_valid;
wire top_mac_core_tx_crc_source_source_ready;
wire top_mac_core_tx_crc_source_source_first;
wire top_mac_core_tx_crc_source_source_last;
wire [7:0] top_mac_core_tx_crc_source_source_payload_data;
wire top_mac_core_tx_crc_source_source_payload_be;
wire top_mac_core_tx_crc_source_source_payload_error;
wire top_mac_core_tx_crc_pipe_valid_sink_valid;
wire top_mac_core_tx_crc_pipe_valid_sink_ready;
wire top_mac_core_tx_crc_pipe_valid_sink_first;
wire top_mac_core_tx_crc_pipe_valid_sink_last;
wire [7:0] top_mac_core_tx_crc_pipe_valid_sink_payload_data;
wire top_mac_core_tx_crc_pipe_valid_sink_payload_be;
wire top_mac_core_tx_crc_pipe_valid_sink_payload_error;
reg top_mac_core_tx_crc_pipe_valid_source_valid = 1'd0;
wire top_mac_core_tx_crc_pipe_valid_source_ready;
reg top_mac_core_tx_crc_pipe_valid_source_first = 1'd0;
reg top_mac_core_tx_crc_pipe_valid_source_last = 1'd0;
reg [7:0] top_mac_core_tx_crc_pipe_valid_source_payload_data = 8'd0;
reg top_mac_core_tx_crc_pipe_valid_source_payload_be = 1'd0;
reg top_mac_core_tx_crc_pipe_valid_source_payload_error = 1'd0;
wire top_mac_core_tx_preamble_sink_valid;
reg top_mac_core_tx_preamble_sink_ready;
wire top_mac_core_tx_preamble_sink_first;
wire top_mac_core_tx_preamble_sink_last;
wire [7:0] top_mac_core_tx_preamble_sink_payload_data;
wire top_mac_core_tx_preamble_sink_payload_be;
wire top_mac_core_tx_preamble_sink_payload_error;
reg top_mac_core_tx_preamble_source_valid;
wire top_mac_core_tx_preamble_source_ready;
reg top_mac_core_tx_preamble_source_first;
reg top_mac_core_tx_preamble_source_last;
reg [7:0] top_mac_core_tx_preamble_source_payload_data;
reg top_mac_core_tx_preamble_source_payload_be;
reg top_mac_core_tx_preamble_source_payload_error;
reg [63:0] top_mac_core_tx_preamble_preamble = 64'd15372286728091293013;
reg [2:0] top_mac_core_tx_preamble_count = 3'd0;
wire top_mac_core_txdatapath_sink_sink_valid;
wire top_mac_core_txdatapath_sink_sink_ready;
wire top_mac_core_txdatapath_sink_sink_first;
wire top_mac_core_txdatapath_sink_sink_last;
wire [7:0] top_mac_core_txdatapath_sink_sink_payload_data;
wire top_mac_core_txdatapath_sink_sink_payload_be;
wire top_mac_core_txdatapath_sink_sink_payload_error;
wire top_mac_core_txdatapath_source_source_valid;
wire top_mac_core_txdatapath_source_source_ready;
wire top_mac_core_txdatapath_source_source_first;
wire top_mac_core_txdatapath_source_source_last;
wire [7:0] top_mac_core_txdatapath_source_source_payload_data;
wire top_mac_core_txdatapath_source_source_payload_be;
wire top_mac_core_txdatapath_source_source_payload_error;
wire top_mac_core_txdatapath_cdc_sink_valid;
wire top_mac_core_txdatapath_cdc_sink_ready;
wire top_mac_core_txdatapath_cdc_sink_first;
wire top_mac_core_txdatapath_cdc_sink_last;
wire [7:0] top_mac_core_txdatapath_cdc_sink_payload_data;
wire top_mac_core_txdatapath_cdc_sink_payload_be;
wire top_mac_core_txdatapath_cdc_sink_payload_error;
wire top_mac_core_txdatapath_cdc_source_valid;
wire top_mac_core_txdatapath_cdc_source_ready;
wire top_mac_core_txdatapath_cdc_source_first;
wire top_mac_core_txdatapath_cdc_source_last;
wire [7:0] top_mac_core_txdatapath_cdc_source_payload_data;
wire top_mac_core_txdatapath_cdc_source_payload_be;
wire top_mac_core_txdatapath_cdc_source_payload_error;
wire top_mac_core_txdatapath_cdc_re;
reg top_mac_core_txdatapath_cdc_readable = 1'd0;
reg [11:0] top_mac_core_txdatapath_cdc_dout = 12'd0;
wire top_mac_core_txdatapath_cdc_asyncfifo_we;
wire top_mac_core_txdatapath_cdc_asyncfifo_writable;
wire top_mac_core_txdatapath_cdc_asyncfifo_re;
wire top_mac_core_txdatapath_cdc_asyncfifo_readable;
wire [11:0] top_mac_core_txdatapath_cdc_asyncfifo_din;
wire [11:0] top_mac_core_txdatapath_cdc_asyncfifo_dout;
wire top_mac_core_txdatapath_cdc_graycounter0_ce;
(* no_retiming = "true" *) reg [5:0] top_mac_core_txdatapath_cdc_graycounter0_q = 6'd0;
wire [5:0] top_mac_core_txdatapath_cdc_graycounter0_q_next;
reg [5:0] top_mac_core_txdatapath_cdc_graycounter0_q_binary = 6'd0;
reg [5:0] top_mac_core_txdatapath_cdc_graycounter0_q_next_binary;
wire top_mac_core_txdatapath_cdc_graycounter1_ce;
(* no_retiming = "true" *) reg [5:0] top_mac_core_txdatapath_cdc_graycounter1_q = 6'd0;
wire [5:0] top_mac_core_txdatapath_cdc_graycounter1_q_next;
reg [5:0] top_mac_core_txdatapath_cdc_graycounter1_q_binary = 6'd0;
reg [5:0] top_mac_core_txdatapath_cdc_graycounter1_q_next_binary;
wire [5:0] top_mac_core_txdatapath_cdc_produce_rdomain;
wire [5:0] top_mac_core_txdatapath_cdc_consume_wdomain;
wire [4:0] top_mac_core_txdatapath_cdc_wrport_adr;
wire [11:0] top_mac_core_txdatapath_cdc_wrport_dat_r;
wire top_mac_core_txdatapath_cdc_wrport_we;
wire [11:0] top_mac_core_txdatapath_cdc_wrport_dat_w;
wire [4:0] top_mac_core_txdatapath_cdc_rdport_adr;
wire [11:0] top_mac_core_txdatapath_cdc_rdport_dat_r;
wire [7:0] top_mac_core_txdatapath_cdc_fifo_in_payload_data;
wire top_mac_core_txdatapath_cdc_fifo_in_payload_be;
wire top_mac_core_txdatapath_cdc_fifo_in_payload_error;
wire top_mac_core_txdatapath_cdc_fifo_in_first;
wire top_mac_core_txdatapath_cdc_fifo_in_last;
wire [7:0] top_mac_core_txdatapath_cdc_fifo_out_payload_data;
wire top_mac_core_txdatapath_cdc_fifo_out_payload_be;
wire top_mac_core_txdatapath_cdc_fifo_out_payload_error;
wire top_mac_core_txdatapath_cdc_fifo_out_first;
wire top_mac_core_txdatapath_cdc_fifo_out_last;
wire top_mac_core_tx_packet_fifo_sink_sink_valid;
wire top_mac_core_tx_packet_fifo_sink_sink_ready;
wire top_mac_core_tx_packet_fifo_sink_sink_first;
wire top_mac_core_tx_packet_fifo_sink_sink_last;
wire [7:0] top_mac_core_tx_packet_fifo_sink_sink_payload_data;
wire top_mac_core_tx_packet_fifo_sink_sink_payload_be;
wire top_mac_core_tx_packet_fifo_sink_sink_payload_error;
wire top_mac_core_tx_packet_fifo_source_source_valid;
wire top_mac_core_tx_packet_fifo_source_source_ready;
reg top_mac_core_tx_packet_fifo_source_source_first;
wire top_mac_core_tx_packet_fifo_source_source_last;
wire [7:0] top_mac_core_tx_packet_fifo_source_source_payload_data;
wire top_mac_core_tx_packet_fifo_source_source_payload_be;
wire top_mac_core_tx_packet_fifo_source_source_payload_error;
wire top_mac_core_tx_packet_fifo_payload_fifo_sink_valid;
wire top_mac_core_tx_packet_fifo_payload_fifo_sink_ready;
wire top_mac_core_tx_packet_fifo_payload_fifo_sink_first;
wire top_mac_core_tx_packet_fifo_payload_fifo_sink_last;
wire [7:0] top_mac_core_tx_packet_fifo_payload_fifo_sink_payload_data;
wire top_mac_core_tx_packet_fifo_payload_fifo_sink_payload_be;
wire top_mac_core_tx_packet_fifo_payload_fifo_sink_payload_error;
wire top_mac_core_tx_packet_fifo_payload_fifo_source_valid;
wire top_mac_core_tx_packet_fifo_payload_fifo_source_ready;
wire top_mac_core_tx_packet_fifo_payload_fifo_source_first;
wire top_mac_core_tx_packet_fifo_payload_fifo_source_last;
wire [7:0] top_mac_core_tx_packet_fifo_payload_fifo_source_payload_data;
wire top_mac_core_tx_packet_fifo_payload_fifo_source_payload_be;
wire top_mac_core_tx_packet_fifo_payload_fifo_source_payload_error;
wire top_mac_core_tx_packet_fifo_payload_fifo_re;
reg top_mac_core_tx_packet_fifo_payload_fifo_readable = 1'd0;
wire top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_we;
wire top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_writable;
wire top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_re;
wire top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_readable;
wire [11:0] top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_din;
wire [11:0] top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_dout;
reg [11:0] top_mac_core_tx_packet_fifo_payload_fifo_level0 = 12'd0;
reg top_mac_core_tx_packet_fifo_payload_fifo_replace = 1'd0;
reg [10:0] top_mac_core_tx_packet_fifo_payload_fifo_produce = 11'd0;
reg [10:0] top_mac_core_tx_packet_fifo_payload_fifo_consume = 11'd0;
reg [10:0] top_mac_core_tx_packet_fifo_payload_fifo_wrport_adr;
wire [11:0] top_mac_core_tx_packet_fifo_payload_fifo_wrport_dat_r;
wire top_mac_core_tx_packet_fifo_payload_fifo_wrport_we;
wire [11:0] top_mac_core_tx_packet_fifo_payload_fifo_wrport_dat_w;
wire top_mac_core_tx_packet_fifo_payload_fifo_do_read;
wire [10:0] top_mac_core_tx_packet_fifo_payload_fifo_rdport_adr;
wire [11:0] top_mac_core_tx_packet_fifo_payload_fifo_rdport_dat_r;
wire top_mac_core_tx_packet_fifo_payload_fifo_rdport_re;
wire [11:0] top_mac_core_tx_packet_fifo_payload_fifo_level1;
wire [7:0] top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_payload_data;
wire top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_payload_be;
wire top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_payload_error;
wire top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_first;
wire top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_last;
wire [7:0] top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_payload_data;
wire top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_payload_be;
wire top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_payload_error;
wire top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_first;
wire top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_last;
wire top_mac_core_tx_packet_fifo_param_fifo_sink_valid;
wire top_mac_core_tx_packet_fifo_param_fifo_sink_ready;
reg top_mac_core_tx_packet_fifo_param_fifo_sink_first = 1'd0;
reg top_mac_core_tx_packet_fifo_param_fifo_sink_last = 1'd0;
reg top_mac_core_tx_packet_fifo_param_fifo_sink_param_dummy = 1'd0;
wire top_mac_core_tx_packet_fifo_param_fifo_source_valid;
wire top_mac_core_tx_packet_fifo_param_fifo_source_ready;
wire top_mac_core_tx_packet_fifo_param_fifo_source_first;
wire top_mac_core_tx_packet_fifo_param_fifo_source_last;
wire top_mac_core_tx_packet_fifo_param_fifo_source_param_dummy;
wire top_mac_core_tx_packet_fifo_param_fifo_re;
reg top_mac_core_tx_packet_fifo_param_fifo_readable = 1'd0;
wire top_mac_core_tx_packet_fifo_param_fifo_syncfifo_we;
wire top_mac_core_tx_packet_fifo_param_fifo_syncfifo_writable;
wire top_mac_core_tx_packet_fifo_param_fifo_syncfifo_re;
wire top_mac_core_tx_packet_fifo_param_fifo_syncfifo_readable;
wire [2:0] top_mac_core_tx_packet_fifo_param_fifo_syncfifo_din;
wire [2:0] top_mac_core_tx_packet_fifo_param_fifo_syncfifo_dout;
reg [2:0] top_mac_core_tx_packet_fifo_param_fifo_level0 = 3'd0;
reg top_mac_core_tx_packet_fifo_param_fifo_replace = 1'd0;
reg [2:0] top_mac_core_tx_packet_fifo_param_fifo_produce = 3'd0;
reg [2:0] top_mac_core_tx_packet_fifo_param_fifo_consume = 3'd0;
reg [2:0] top_mac_core_tx_packet_fifo_param_fifo_wrport_adr;
wire [2:0] top_mac_core_tx_packet_fifo_param_fifo_wrport_dat_r;
wire top_mac_core_tx_packet_fifo_param_fifo_wrport_we;
wire [2:0] top_mac_core_tx_packet_fifo_param_fifo_wrport_dat_w;
wire top_mac_core_tx_packet_fifo_param_fifo_do_read;
wire [2:0] top_mac_core_tx_packet_fifo_param_fifo_rdport_adr;
wire [2:0] top_mac_core_tx_packet_fifo_param_fifo_rdport_dat_r;
wire top_mac_core_tx_packet_fifo_param_fifo_rdport_re;
wire [2:0] top_mac_core_tx_packet_fifo_param_fifo_level1;
wire top_mac_core_tx_packet_fifo_param_fifo_fifo_in_param_dummy;
wire top_mac_core_tx_packet_fifo_param_fifo_fifo_in_first;
wire top_mac_core_tx_packet_fifo_param_fifo_fifo_in_last;
wire top_mac_core_tx_packet_fifo_param_fifo_fifo_out_param_dummy;
wire top_mac_core_tx_packet_fifo_param_fifo_fifo_out_first;
wire top_mac_core_tx_packet_fifo_param_fifo_fifo_out_last;
wire top_mac_core_tx_gap_sink_valid;
reg top_mac_core_tx_gap_sink_ready;
wire top_mac_core_tx_gap_sink_first;
wire top_mac_core_tx_gap_sink_last;
wire [7:0] top_mac_core_tx_gap_sink_payload_data;
wire top_mac_core_tx_gap_sink_payload_be;
wire top_mac_core_tx_gap_sink_payload_error;
reg top_mac_core_tx_gap_source_valid;
wire top_mac_core_tx_gap_source_ready;
reg top_mac_core_tx_gap_source_first;
reg top_mac_core_tx_gap_source_last;
reg [7:0] top_mac_core_tx_gap_source_payload_data;
reg top_mac_core_tx_gap_source_payload_be;
reg top_mac_core_tx_gap_source_payload_error;
reg [3:0] top_mac_core_tx_gap_counter = 4'd0;
reg [31:0] top_mac_core_preamble_errors_status = 32'd0;
reg [31:0] top_mac_core_crc_errors_status = 32'd0;
reg [31:0] top_mac_core_drops_status = 32'd0;
wire top_mac_core_rx_packet_fifo_sink_sink_valid;
wire top_mac_core_rx_packet_fifo_sink_sink_ready;
wire top_mac_core_rx_packet_fifo_sink_sink_first;
wire top_mac_core_rx_packet_fifo_sink_sink_last;
wire [7:0] top_mac_core_rx_packet_fifo_sink_sink_payload_data;
wire top_mac_core_rx_packet_fifo_sink_sink_payload_be;
wire top_mac_core_rx_packet_fifo_sink_sink_payload_error;
wire top_mac_core_rx_packet_fifo_source_source_valid;
wire top_mac_core_rx_packet_fifo_source_source_ready;
wire top_mac_core_rx_packet_fifo_source_source_first;
wire top_mac_core_rx_packet_fifo_source_source_last;
wire [7:0] top_mac_core_rx_packet_fifo_source_source_payload_data;
wire top_mac_core_rx_packet_fifo_source_source_payload_be;
wire top_mac_core_rx_packet_fifo_source_source_payload_error;
reg top_mac_core_rx_packet_fifo_discard = 1'd0;
wire top_mac_core_rx_packet_fifo_drop;
wire top_mac_core_rx_packet_fifo_param_fifo_sink_valid;
wire top_mac_core_rx_packet_fifo_param_fifo_sink_ready;
reg top_mac_core_rx_packet_fifo_param_fifo_sink_first = 1'd0;
wire top_mac_core_rx_packet_fifo_param_fifo_sink_last;
reg top_mac_core_rx_packet_fifo_param_fifo_sink_param_dummy = 1'd0;
wire top_mac_core_rx_packet_fifo_param_fifo_source_valid;
wire top_mac_core_rx_packet_fifo_param_fifo_source_ready;
wire top_mac_core_rx_packet_fifo_param_fifo_source_first;
wire top_mac_core_rx_packet_fifo_param_fifo_source_last;
wire top_mac_core_rx_packet_fifo_param_fifo_source_param_dummy;
wire top_mac_core_rx_packet_fifo_param_fifo_syncfifo_we;
wire top_mac_core_rx_packet_fifo_param_fifo_syncfifo_writable;
wire top_mac_core_rx_packet_fifo_param_fifo_syncfifo_re;
wire top_mac_core_rx_packet_fifo_param_fifo_syncfifo_readable;
wire [2:0] top_mac_core_rx_packet_fifo_param_fifo_syncfifo_din;
wire [2:0] top_mac_core_rx_packet_fifo_param_fifo_syncfifo_dout;
reg [2:0] top_mac_core_rx_packet_fifo_param_fifo_level = 3'd0;
reg top_mac_core_rx_packet_fifo_param_fifo_replace = 1'd0;
reg [1:0] top_mac_core_rx_packet_fifo_param_fifo_produce = 2'd0;
reg [1:0] top_mac_core_rx_packet_fifo_param_fifo_consume = 2'd0;
reg [1:0] top_mac_core_rx_packet_fifo_param_fifo_wrport_adr;
wire [2:0] top_mac_core_rx_packet_fifo_param_fifo_wrport_dat_r;
wire top_mac_core_rx_packet_fifo_param_fifo_wrport_we;
wire [2:0] top_mac_core_rx_packet_fifo_param_fifo_wrport_dat_w;
wire top_mac_core_rx_packet_fifo_param_fifo_do_read;
wire [1:0] top_mac_core_rx_packet_fifo_param_fifo_rdport_adr;
wire [2:0] top_mac_core_rx_packet_fifo_param_fifo_rdport_dat_r;
wire top_mac_core_rx_packet_fifo_param_fifo_fifo_in_param_dummy;
wire top_mac_core_rx_packet_fifo_param_fifo_fifo_in_first;
wire top_mac_core_rx_packet_fifo_param_fifo_fifo_in_last;
wire top_mac_core_rx_packet_fifo_param_fifo_fifo_out_param_dummy;
wire top_mac_core_rx_packet_fifo_param_fifo_fifo_out_first;
wire top_mac_core_rx_packet_fifo_param_fifo_fifo_out_last;
wire [10:0] top_mac_core_rx_packet_fifo_wr_port_adr;
wire [11:0] top_mac_core_rx_packet_fifo_wr_port_dat_r;
wire top_mac_core_rx_packet_fifo_wr_port_we;
wire [11:0] top_mac_core_rx_packet_fifo_wr_port_dat_w;
wire [10:0] top_mac_core_rx_packet_fifo_rd_port_adr;
wire [11:0] top_mac_core_rx_packet_fifo_rd_port_dat_r;
wire top_mac_core_rx_packet_fifo_rd_port_re;
reg [11:0] top_mac_core_rx_packet_fifo_wr_ptr = 12'd0;
reg [11:0] top_mac_core_rx_packet_fifo_commit_ptr = 12'd0;
reg [11:0] top_mac_core_rx_packet_fifo_rd_ptr = 12'd0;
reg top_mac_core_rx_packet_fifo_out_valid = 1'd0;
wire [11:0] top_mac_core_rx_packet_fifo_used;
wire top_mac_core_rx_packet_fifo_full;
reg top_mac_core_rx_packet_fifo_overflow = 1'd0;
reg top_mac_core_rx_packet_fifo_invalid = 1'd0;
wire top_mac_core_rx_packet_fifo_commit;
wire top_mac_core_rx_packet_fifo_fetch;
wire top_mac_core_i;
wire top_mac_core_o;
reg top_mac_core_toggle_i = 1'd0;
wire top_mac_core_toggle_o;
reg top_mac_core_toggle_o_r = 1'd0;
wire top_mac_core_rx_cdc_sink_sink_valid;
wire top_mac_core_rx_cdc_sink_sink_ready;
wire top_mac_core_rx_cdc_sink_sink_first;
wire top_mac_core_rx_cdc_sink_sink_last;
wire [7:0] top_mac_core_rx_cdc_sink_sink_payload_data;
wire top_mac_core_rx_cdc_sink_sink_payload_be;
wire top_mac_core_rx_cdc_sink_sink_payload_error;
wire top_mac_core_rx_cdc_source_source_valid;
wire top_mac_core_rx_cdc_source_source_ready;
wire top_mac_core_rx_cdc_source_source_first;
wire top_mac_core_rx_cdc_source_source_last;
wire [7:0] top_mac_core_rx_cdc_source_source_payload_data;
wire top_mac_core_rx_cdc_source_source_payload_be;
wire top_mac_core_rx_cdc_source_source_payload_error;
wire top_mac_core_rx_cdc_cdc_sink_valid;
wire top_mac_core_rx_cdc_cdc_sink_ready;
wire top_mac_core_rx_cdc_cdc_sink_first;
wire top_mac_core_rx_cdc_cdc_sink_last;
wire [7:0] top_mac_core_rx_cdc_cdc_sink_payload_data;
wire top_mac_core_rx_cdc_cdc_sink_payload_be;
wire top_mac_core_rx_cdc_cdc_sink_payload_error;
wire top_mac_core_rx_cdc_cdc_source_valid;
wire top_mac_core_rx_cdc_cdc_source_ready;
wire top_mac_core_rx_cdc_cdc_source_first;
wire top_mac_core_rx_cdc_cdc_source_last;
wire [7:0] top_mac_core_rx_cdc_cdc_source_payload_data;
wire top_mac_core_rx_cdc_cdc_source_payload_be;
wire top_mac_core_rx_cdc_cdc_source_payload_error;
wire top_mac_core_rx_cdc_cdc_re;
reg top_mac_core_rx_cdc_cdc_readable = 1'd0;
reg [11:0] top_mac_core_rx_cdc_cdc_dout = 12'd0;
wire top_mac_core_rx_cdc_cdc_asyncfifo_we;
wire top_mac_core_rx_cdc_cdc_asyncfifo_writable;
wire top_mac_core_rx_cdc_cdc_asyncfifo_re;
wire top_mac_core_rx_cdc_cdc_asyncfifo_readable;
wire [11:0] top_mac_core_rx_cdc_cdc_asyncfifo_din;
wire [11:0] top_mac_core_rx_cdc_cdc_asyncfifo_dout;
wire top_mac_core_rx_cdc_cdc_graycounter0_ce;
(* no_retiming = "true" *) reg [5:0] top_mac_core_rx_cdc_cdc_graycounter0_q = 6'd0;
wire [5:0] top_mac_core_rx_cdc_cdc_graycounter0_q_next;
reg [5:0] top_mac_core_rx_cdc_cdc_graycounter0_q_binary = 6'd0;
reg [5:0] top_mac_core_rx_cdc_cdc_graycounter0_q_next_binary;
wire top_mac_core_rx_cdc_cdc_graycounter1_ce;
(* no_retiming = "true" *) reg [5:0] top_mac_core_rx_cdc_cdc_graycounter1_q = 6'd0;
wire [5:0] top_mac_core_rx_cdc_cdc_graycounter1_q_next;
reg [5:0] top_mac_core_rx_cdc_cdc_graycounter1_q_binary = 6'd0;
reg [5:0] top_mac_core_rx_cdc_cdc_graycounter1_q_next_binary;
wire [5:0] top_mac_core_rx_cdc_cdc_produce_rdomain;
wire [5:0] top_mac_core_rx_cdc_cdc_consume_wdomain;
wire [4:0] top_mac_core_rx_cdc_cdc_wrport_adr;
wire [11:0] top_mac_core_rx_cdc_cdc_wrport_dat_r;
wire top_mac_core_rx_cdc_cdc_wrport_we;
wire [11:0] top_mac_core_rx_cdc_cdc_wrport_dat_w;
wire [4:0] top_mac_core_rx_cdc_cdc_rdport_adr;
wire [11:0] top_mac_core_rx_cdc_cdc_rdport_dat_r;
wire [7:0] top_mac_core_rx_cdc_cdc_fifo_in_payload_data;
wire top_mac_core_rx_cdc_cdc_fifo_in_payload_be;
wire top_mac_core_rx_cdc_cdc_fifo_in_payload_error;
wire top_mac_core_rx_cdc_cdc_fifo_in_first;
wire top_mac_core_rx_cdc_cdc_fifo_in_last;
wire [7:0] top_mac_core_rx_cdc_cdc_fifo_out_payload_data;
wire top_mac_core_rx_cdc_cdc_fifo_out_payload_be;
wire top_mac_core_rx_cdc_cdc_fifo_out_payload_error;
wire top_mac_core_rx_cdc_cdc_fifo_out_first;
wire top_mac_core_rx_cdc_cdc_fifo_out_last;
wire top_mac_core_rx_preamble_sink_valid;
reg top_mac_core_rx_preamble_sink_ready;
wire top_mac_core_rx_preamble_sink_first;
wire top_mac_core_rx_preamble_sink_last;
wire [7:0] top_mac_core_rx_preamble_sink_payload_data;
wire top_mac_core_rx_preamble_sink_payload_be;
wire top_mac_core_rx_preamble_sink_payload_error;
reg top_mac_core_rx_preamble_source_valid;
wire top_mac_core_rx_preamble_source_ready;
reg top_mac_core_rx_preamble_source_first;
reg top_mac_core_rx_preamble_source_last;
wire [7:0] top_mac_core_rx_preamble_source_payload_data;
wire top_mac_core_rx_preamble_source_payload_be;
reg top_mac_core_rx_preamble_source_payload_error;
reg top_mac_core_rx_preamble_error;
reg [63:0] top_mac_core_rx_preamble_preamble = 64'd15372286728091293013;
wire top_mac_core_pulsesynchronizer0_i;
wire top_mac_core_pulsesynchronizer0_o;
reg top_mac_core_pulsesynchronizer0_toggle_i = 1'd0;
wire top_mac_core_pulsesynchronizer0_toggle_o;
reg top_mac_core_pulsesynchronizer0_toggle_o_r = 1'd0;
wire top_mac_core_liteethmaccrc32checker_sink_sink_valid;
reg top_mac_core_liteethmaccrc32checker_sink_sink_ready;
wire top_mac_core_liteethmaccrc32checker_sink_sink_first;
wire top_mac_core_liteethmaccrc32checker_sink_sink_last;
wire [7:0] top_mac_core_liteethmaccrc32checker_sink_sink_payload_data;
wire top_mac_core_liteethmaccrc32checker_sink_sink_payload_be;
wire top_mac_core_liteethmaccrc32checker_sink_sink_payload_error;
reg top_mac_core_liteethmaccrc32checker_source_source_valid;
wire top_mac_core_liteethmaccrc32checker_source_source_ready;
wire top_mac_core_liteethmaccrc32checker_source_source_first;
reg top_mac_core_liteethmaccrc32checker_source_source_last;
wire [7:0] top_mac_core_liteethmaccrc32checker_source_source_payload_data;
reg top_mac_core_liteethmaccrc32checker_source_source_payload_be;
reg top_mac_core_liteethmaccrc32checker_source_source_payload_error;
reg top_mac_core_liteethmaccrc32checker_error;
wire [7:0] top_mac_core_liteethmaccrc32checker_crc_data0;
wire top_mac_core_liteethmaccrc32checker_crc_be;
reg top_mac_core_liteethmaccrc32checker_crc_error;
reg [7:0] top_mac_core_liteethmaccrc32checker_crc_data1;
wire [31:0] top_mac_core_liteethmaccrc32checker_crc_crc_prev;
reg [31:0] top_mac_core_liteethmaccrc32checker_crc_crc_next;
reg [31:0] top_mac_core_liteethmaccrc32checker_crc_reg = 32'd4294967295;
reg top_mac_core_liteethmaccrc32checker_crc_ce;
reg top_mac_core_liteethmaccrc32checker_crc_reset;
reg top_mac_core_liteethmaccrc32checker_syncfifo_sink_valid;
wire top_mac_core_liteethmaccrc32checker_syncfifo_sink_ready;
wire top_mac_core_liteethmaccrc32checker_syncfifo_sink_first;
wire top_mac_core_liteethmaccrc32checker_syncfifo_sink_last;
wire [7:0] top_mac_core_liteethmaccrc32checker_syncfifo_sink_payload_data;
wire top_mac_core_liteethmaccrc32checker_syncfifo_sink_payload_be;
wire top_mac_core_liteethmaccrc32checker_syncfifo_sink_payload_error;
wire top_mac_core_liteethmaccrc32checker_syncfifo_source_valid;
reg top_mac_core_liteethmaccrc32checker_syncfifo_source_ready;
wire top_mac_core_liteethmaccrc32checker_syncfifo_source_first;
wire top_mac_core_liteethmaccrc32checker_syncfifo_source_last;
wire [7:0] top_mac_core_liteethmaccrc32checker_syncfifo_source_payload_data;
wire top_mac_core_liteethmaccrc32checker_syncfifo_source_payload_be;
wire top_mac_core_liteethmaccrc32checker_syncfifo_source_payload_error;
wire top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_we;
wire top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_writable;
wire top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_re;
wire top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_readable;
wire [11:0] top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_din;
wire [11:0] top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_dout;
reg [2:0] top_mac_core_liteethmaccrc32checker_syncfifo_level = 3'd0;
reg top_mac_core_liteethmaccrc32checker_syncfifo_replace = 1'd0;
reg [2:0] top_mac_core_liteethmaccrc32checker_syncfifo_produce = 3'd0;
reg [2:0] top_mac_core_liteethmaccrc32checker_syncfifo_consume = 3'd0;
reg [2:0] top_mac_core_liteethmaccrc32checker_syncfifo_wrport_adr;
wire [11:0] top_mac_core_liteethmaccrc32checker_syncfifo_wrport_dat_r;
wire top_mac_core_liteethmaccrc32checker_syncfifo_wrport_we;
wire [11:0] top_mac_core_liteethmaccrc32checker_syncfifo_wrport_dat_w;
wire top_mac_core_liteethmaccrc32checker_syncfifo_do_read;
wire [2:0] top_mac_core_liteethmaccrc32checker_syncfifo_rdport_adr;
wire [11:0] top_mac_core_liteethmaccrc32checker_syncfifo_rdport_dat_r;
wire [7:0] top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_payload_data;
wire top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_payload_be;
wire top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_payload_error;
wire top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_first;
wire top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_last;
wire [7:0] top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_payload_data;
wire top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_payload_be;
wire top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_payload_error;
wire top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_first;
wire top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_last;
reg top_mac_core_liteethmaccrc32checker_fifo_reset;
wire top_mac_core_liteethmaccrc32checker_fifo_in;
wire top_mac_core_liteethmaccrc32checker_fifo_out;
wire top_mac_core_liteethmaccrc32checker_fifo_full;
reg top_mac_core_liteethmaccrc32checker_is_ongoing0;
reg top_mac_core_liteethmaccrc32checker_is_ongoing1;
reg top_mac_core_liteethmaccrc32checker_be = 1'd0;
reg top_mac_core_liteethmaccrc32checker_last_error = 1'd0;
wire top_mac_core_liteethmaccrc32checker_last_word_error;
reg top_mac_core_liteethmaccrc32checker_packet_error = 1'd0;
reg top_mac_core_liteethmaccrc32checker_is_ongoing2;
wire top_mac_core_bufferizeendpoints_sink_sink_valid;
wire top_mac_core_bufferizeendpoints_sink_sink_ready;
wire top_mac_core_bufferizeendpoints_sink_sink_first;
wire top_mac_core_bufferizeendpoints_sink_sink_last;
wire [7:0] top_mac_core_bufferizeendpoints_sink_sink_payload_data;
wire top_mac_core_bufferizeendpoints_sink_sink_payload_be;
wire top_mac_core_bufferizeendpoints_sink_sink_payload_error;
wire top_mac_core_bufferizeendpoints_source_source_valid;
wire top_mac_core_bufferizeendpoints_source_source_ready;
wire top_mac_core_bufferizeendpoints_source_source_first;
wire top_mac_core_bufferizeendpoints_source_source_last;
wire [7:0] top_mac_core_bufferizeendpoints_source_source_payload_data;
wire top_mac_core_bufferizeendpoints_source_source_payload_be;
wire top_mac_core_bufferizeendpoints_source_source_payload_error;
wire top_mac_core_bufferizeendpoints_pipe_valid_sink_valid;
wire top_mac_core_bufferizeendpoints_pipe_valid_sink_ready;
wire top_mac_core_bufferizeendpoints_pipe_valid_sink_first;
wire top_mac_core_bufferizeendpoints_pipe_valid_sink_last;
wire [7:0] top_mac_core_bufferizeendpoints_pipe_valid_sink_payload_data;
wire top_mac_core_bufferizeendpoints_pipe_valid_sink_payload_be;
wire top_mac_core_bufferizeendpoints_pipe_valid_sink_payload_error;
reg top_mac_core_bufferizeendpoints_pipe_valid_source_valid = 1'd0;
wire top_mac_core_bufferizeendpoints_pipe_valid_source_ready;
reg top_mac_core_bufferizeendpoints_pipe_valid_source_first = 1'd0;
reg top_mac_core_bufferizeendpoints_pipe_valid_source_last = 1'd0;
reg [7:0] top_mac_core_bufferizeendpoints_pipe_valid_source_payload_data = 8'd0;
reg top_mac_core_bufferizeendpoints_pipe_valid_source_payload_be = 1'd0;
reg top_mac_core_bufferizeendpoints_pipe_valid_source_payload_error = 1'd0;
wire top_mac_core_pulsesynchronizer1_i;
wire top_mac_core_pulsesynchronizer1_o;
reg top_mac_core_pulsesynchronizer1_toggle_i = 1'd0;
wire top_mac_core_pulsesynchronizer1_toggle_o;
reg top_mac_core_pulsesynchronizer1_toggle_o_r = 1'd0;
wire top_mac_core_rx_padding_sink_valid;
wire top_mac_core_rx_padding_sink_ready;
wire top_mac_core_rx_padding_sink_first;
wire top_mac_core_rx_padding_sink_last;
wire [7:0] top_mac_core_rx_padding_sink_payload_data;
wire top_mac_core_rx_padding_sink_payload_be;
wire top_mac_core_rx_padding_sink_payload_error;
wire top_mac_core_rx_padding_source_valid;
wire top_mac_core_rx_padding_source_ready;
wire top_mac_core_rx_padding_source_first;
wire top_mac_core_rx_padding_source_last;
wire [7:0] top_mac_core_rx_padding_source_payload_data;
wire top_mac_core_rx_padding_source_payload_be;
reg top_mac_core_rx_padding_source_payload_error;
reg [10:0] top_mac_core_rx_padding_length = 11'd0;
wire [3:0] top_mac_core_rx_padding_length_inc;
reg top_mac_crossbar_source_valid;
wire top_mac_crossbar_source_ready;
reg top_mac_crossbar_source_first;
reg top_mac_crossbar_source_last;
reg [15:0] top_mac_crossbar_source_payload_ethernet_type;
reg [47:0] top_mac_crossbar_source_payload_sender_mac;
reg [47:0] top_mac_crossbar_source_payload_target_mac;
reg [7:0] top_mac_crossbar_source_payload_data;
reg top_mac_crossbar_source_payload_be;
reg top_mac_crossbar_source_payload_error;
wire top_mac_crossbar_sink_valid;
reg top_mac_crossbar_sink_ready;
wire top_mac_crossbar_sink_first;
wire top_mac_crossbar_sink_last;
wire [15:0] top_mac_crossbar_sink_payload_ethernet_type;
wire [47:0] top_mac_crossbar_sink_payload_sender_mac;
wire [47:0] top_mac_crossbar_sink_payload_target_mac;
wire [7:0] top_mac_crossbar_sink_payload_data;
wire top_mac_crossbar_sink_payload_be;
wire top_mac_crossbar_sink_payload_error;
wire top_mac_packetizer_sink_valid;
reg top_mac_packetizer_sink_ready;
wire top_mac_packetizer_sink_first;
wire top_mac_packetizer_sink_last;
wire [15:0] top_mac_packetizer_sink_payload_ethernet_type;
wire [47:0] top_mac_packetizer_sink_payload_sender_mac;
wire [47:0] top_mac_packetizer_sink_payload_target_mac;
wire [7:0] top_mac_packetizer_sink_payload_data;
wire top_mac_packetizer_sink_payload_be;
wire top_mac_packetizer_sink_payload_error;
reg top_mac_packetizer_source_valid;
wire top_mac_packetizer_source_ready;
reg top_mac_packetizer_source_first;
reg top_mac_packetizer_source_last;
reg [7:0] top_mac_packetizer_source_payload_data;
wire top_mac_packetizer_source_payload_be;
reg top_mac_packetizer_source_payload_error;
reg [111:0] top_mac_packetizer_header;
reg top_mac_packetizer_source_be;
reg [3:0] top_mac_packetizer_count = 4'd0;
reg top_mac_packetizer_is_ongoing;
wire top_mac_depacketizer_sink_valid;
reg top_mac_depacketizer_sink_ready;
wire top_mac_depacketizer_sink_first;
wire top_mac_depacketizer_sink_last;
wire [7:0] top_mac_depacketizer_sink_payload_data;
wire top_mac_depacketizer_sink_payload_be;
wire top_mac_depacketizer_sink_payload_error;
reg top_mac_depacketizer_source_valid;
wire top_mac_depacketizer_source_ready;
reg top_mac_depacketizer_source_first;
reg top_mac_depacketizer_source_last;
wire [15:0] top_mac_depacketizer_source_payload_ethernet_type;
wire [47:0] top_mac_depacketizer_source_payload_sender_mac;
wire [47:0] top_mac_depacketizer_source_payload_target_mac;
reg [7:0] top_mac_depacketizer_source_payload_data;
wire top_mac_depacketizer_source_payload_be;
wire top_mac_depacketizer_source_payload_error;
wire [111:0] top_mac_depacketizer_header;
reg [111:0] top_mac_depacketizer_sr = 112'd0;
reg top_mac_depacketizer_sr_shift;
reg top_mac_depacketizer_sr_shift_leftover = 1'd0;
reg [3:0] top_mac_depacketizer_count = 4'd0;
reg top_mac_depacketizer_data_copy_first = 1'd0;
wire top_mac_depacketizer_sink_be;
reg top_mac_depacketizer_source_be;
reg top_mac_depacketizer_fsm_from_idle = 1'd0;
wire top_arp_tx_sink_sink_valid;
reg top_arp_tx_sink_sink_ready;
wire top_arp_tx_sink_sink_first;
wire top_arp_tx_sink_sink_last;
wire top_arp_tx_sink_sink_payload_reply;
wire top_arp_tx_sink_sink_payload_request;
wire [31:0] top_arp_tx_sink_sink_payload_ip_address;
wire [47:0] top_arp_tx_sink_sink_payload_mac_address;
reg top_arp_tx_source_source_valid;
wire top_arp_tx_source_source_ready;
wire top_arp_tx_source_source_first;
wire top_arp_tx_source_source_last;
reg [15:0] top_arp_tx_source_source_payload_ethernet_type;
reg [47:0] top_arp_tx_source_source_payload_sender_mac;
reg [47:0] top_arp_tx_source_source_payload_target_mac;
wire [7:0] top_arp_tx_source_source_payload_data;
wire top_arp_tx_source_source_payload_be;
wire top_arp_tx_source_source_payload_error;
reg [4:0] top_arp_tx_counter = 5'd0;
reg top_arp_tx_packetizer_sink_valid;
reg top_arp_tx_packetizer_sink_ready;
wire top_arp_tx_packetizer_sink_last;
reg [7:0] top_arp_tx_packetizer_sink_payload_data = 8'd0;
wire top_arp_tx_packetizer_sink_payload_be;
reg top_arp_tx_packetizer_sink_payload_error = 1'd0;
wire [7:0] top_arp_tx_packetizer_sink_param_hwsize;
wire [15:0] top_arp_tx_packetizer_sink_param_hwtype;
reg [15:0] top_arp_tx_packetizer_sink_param_opcode;
wire [15:0] top_arp_tx_packetizer_sink_param_proto;
wire [7:0] top_arp_tx_packetizer_sink_param_protosize;
wire [31:0] top_arp_tx_packetizer_sink_param_sender_ip;
wire [47:0] top_arp_tx_packetizer_sink_param_sender_mac;
wire [31:0] top_arp_tx_packetizer_sink_param_target_ip;
reg [47:0] top_arp_tx_packetizer_sink_param_target_mac;
reg top_arp_tx_packetizer_source_valid;
reg top_arp_tx_packetizer_source_ready;
reg top_arp_tx_packetizer_source_first;
reg top_arp_tx_packetizer_source_last;
reg [15:0] top_arp_tx_packetizer_source_payload_ethernet_type = 16'd0;
reg [47:0] top_arp_tx_packetizer_source_payload_sender_mac = 48'd0;
reg [47:0] top_arp_tx_packetizer_source_payload_target_mac = 48'd0;
reg [7:0] top_arp_tx_packetizer_source_payload_data;
wire top_arp_tx_packetizer_source_payload_be;
reg top_arp_tx_packetizer_source_payload_error;
reg [223:0] top_arp_tx_packetizer_header;
reg top_arp_tx_packetizer_source_be;
reg [4:0] top_arp_tx_packetizer_count = 5'd0;
reg top_arp_tx_packetizer_is_ongoing;
wire top_arp_rx_sink_sink_valid;
wire top_arp_rx_sink_sink_ready;
wire top_arp_rx_sink_sink_first;
wire top_arp_rx_sink_sink_last;
wire [15:0] top_arp_rx_sink_sink_payload_ethernet_type;
wire [47:0] top_arp_rx_sink_sink_payload_sender_mac;
wire [47:0] top_arp_rx_sink_sink_payload_target_mac;
wire [7:0] top_arp_rx_sink_sink_payload_data;
wire top_arp_rx_sink_sink_payload_be;
wire top_arp_rx_sink_sink_payload_error;
reg top_arp_rx_source_source_valid;
wire top_arp_rx_source_source_ready;
reg top_arp_rx_source_source_first = 1'd0;
reg top_arp_rx_source_source_last = 1'd0;
reg top_arp_rx_source_source_payload_reply;
reg top_arp_rx_source_source_payload_request;
wire [31:0] top_arp_rx_source_source_payload_ip_address;
wire [47:0] top_arp_rx_source_source_payload_mac_address;
wire top_arp_rx_depacketizer_sink_valid;
reg top_arp_rx_depacketizer_sink_ready;
wire top_arp_rx_depacketizer_sink_first;
wire top_arp_rx_depacketizer_sink_last;
wire [15:0] top_arp_rx_depacketizer_sink_payload_ethernet_type;
wire [47:0] top_arp_rx_depacketizer_sink_payload_sender_mac;
wire [47:0] top_arp_rx_depacketizer_sink_payload_target_mac;
wire [7:0] top_arp_rx_depacketizer_sink_payload_data;
wire top_arp_rx_depacketizer_sink_payload_be;
wire top_arp_rx_depacketizer_sink_payload_error;
reg top_arp_rx_depacketizer_source_valid;
reg top_arp_rx_depacketizer_source_ready;
reg top_arp_rx_depacketizer_source_first;
reg top_arp_rx_depacketizer_source_last;
reg [7:0] top_arp_rx_depacketizer_source_payload_data;
wire top_arp_rx_depacketizer_source_payload_be;
wire top_arp_rx_depacketizer_source_payload_error;
wire [7:0] top_arp_rx_depacketizer_source_param_hwsize;
wire [15:0] top_arp_rx_depacketizer_source_param_hwtype;
wire [15:0] top_arp_rx_depacketizer_source_param_opcode;
wire [15:0] top_arp_rx_depacketizer_source_param_proto;
wire [7:0] top_arp_rx_depacketizer_source_param_protosize;
wire [31:0] top_arp_rx_depacketizer_source_param_sender_ip;
wire [47:0] top_arp_rx_depacketizer_source_param_sender_mac;
wire [31:0] top_arp_rx_depacketizer_source_param_target_ip;
wire [47:0] top_arp_rx_depacketizer_source_param_target_mac;
wire [223:0] top_arp_rx_depacketizer_header;
reg [223:0] top_arp_rx_depacketizer_sr = 224'd0;
reg top_arp_rx_depacketizer_sr_shift;
reg top_arp_rx_depacketizer_sr_shift_leftover = 1'd0;
reg [4:0] top_arp_rx_depacketizer_count = 5'd0;
reg top_arp_rx_depacketizer_data_copy_first = 1'd0;
wire top_arp_rx_depacketizer_sink_be;
reg top_arp_rx_depacketizer_source_be;
reg top_arp_rx_depacketizer_fsm_from_idle = 1'd0;
reg top_arp_rx_valid = 1'd0;
reg top_arp_rx_reply;
reg top_arp_rx_request;
wire top_arp_table_sink_valid;
reg top_arp_table_sink_ready = 1'd0;
wire top_arp_table_sink_first;
wire top_arp_table_sink_last;
wire top_arp_table_sink_payload_reply;
wire top_arp_table_sink_payload_request;
wire [31:0] top_arp_table_sink_payload_ip_address;
wire [47:0] top_arp_table_sink_payload_mac_address;
reg top_arp_table_source_valid;
wire top_arp_table_source_ready;
reg top_arp_table_source_first = 1'd0;
reg top_arp_table_source_last = 1'd0;
reg top_arp_table_source_payload_reply;
reg top_arp_table_source_payload_request;
reg [31:0] top_arp_table_source_payload_ip_address;
reg [47:0] top_arp_table_source_payload_mac_address;
reg top_arp_table_request_request_valid;
reg top_arp_table_request_request_ready;
wire [31:0] top_arp_table_request_request_payload_ip_address;
reg top_arp_table_response_response_valid;
reg top_arp_table_response_response_ready;
reg top_arp_table_response_response_payload_failed = 1'd0;
reg [47:0] top_arp_table_response_response_payload_mac_address = 48'd0;
reg top_arp_table_request_pending = 1'd0;
reg [2:0] top_arp_table_request_counter = 3'd0;
reg [31:0] top_arp_table_request_ip_address = 32'd0;
wire top_arp_table_request_timer_wait;
wire top_arp_table_request_timer_done;
reg [21:0] top_arp_table_request_timer_count = 22'd4000000;
reg top_arp_table_cache_update_valid;
reg top_arp_table_cache_update_ready;
reg [31:0] top_arp_table_cache_update_payload_ip_address;
reg [47:0] top_arp_table_cache_update_payload_mac_address;
reg top_arp_table_cache_request_valid;
reg top_arp_table_cache_request_ready;
reg [31:0] top_arp_table_cache_request_payload_ip_address;
reg top_arp_table_cache_response_valid;
reg [47:0] top_arp_table_cache_response_payload_mac_address;
reg top_arp_table_cache_response_payload_error;
reg top_arp_table_cache_enable = 1'd1;
reg top_arp_table_cache_clear_enable = 1'd1;
reg top_arp_table_cache_update_count = 1'd0;
reg top_arp_table_cache_search_count = 1'd0;
reg top_arp_table_cache_error = 1'd0;
reg top_arp_table_cache_mem_wr_port_adr;
wire [80:0] top_arp_table_cache_mem_wr_port_dat_r;
reg top_arp_table_cache_mem_wr_port_we;
reg [80:0] top_arp_table_cache_mem_wr_port_dat_w;
reg top_arp_table_cache_mem_rd_port_adr;
wire [80:0] top_arp_table_cache_mem_rd_port_dat_r;
reg top_arp_table_cache_mem_wr_port_valid;
reg [31:0] top_arp_table_cache_mem_wr_port_ip_address;
reg [47:0] top_arp_table_cache_mem_wr_port_mac_address;
wire top_arp_table_cache_mem_rd_port_valid;
wire [31:0] top_arp_table_cache_mem_rd_port_ip_address;
wire [47:0] top_arp_table_cache_mem_rd_port_mac_address;
reg top_arp_table_cache_wait;
wire top_arp_table_cache_done;
reg [25:0] top_arp_table_cache_count = 26'd40000000;
wire top_arp_mac_port_sink_valid;
reg top_arp_mac_port_sink_ready;
wire top_arp_mac_port_sink_first;
wire top_arp_mac_port_sink_last;
wire [15:0] top_arp_mac_port_sink_payload_ethernet_type;
wire [47:0] top_arp_mac_port_sink_payload_sender_mac;
wire [47:0] top_arp_mac_port_sink_payload_target_mac;
wire [7:0] top_arp_mac_port_sink_payload_data;
wire top_arp_mac_port_sink_payload_be;
wire top_arp_mac_port_sink_payload_error;
reg top_arp_mac_port_source_valid;
wire top_arp_mac_port_source_ready;
reg top_arp_mac_port_source_first;
reg top_arp_mac_port_source_last;
reg [15:0] top_arp_mac_port_source_payload_ethernet_type;
reg [47:0] top_arp_mac_port_source_payload_sender_mac;
reg [47:0] top_arp_mac_port_source_payload_target_mac;
reg [7:0] top_arp_mac_port_source_payload_data;
reg top_arp_mac_port_source_payload_be;
reg top_arp_mac_port_source_payload_error;
wire top_ip_tx_sink_sink_valid0;
wire top_ip_tx_sink_sink_ready0;
wire top_ip_tx_sink_sink_first0;
wire top_ip_tx_sink_sink_last0;
wire [7:0] top_ip_tx_sink_sink_payload_data0;
wire top_ip_tx_sink_sink_payload_be0;
wire top_ip_tx_sink_sink_payload_error0;
wire [15:0] top_ip_tx_sink_sink_param_length0;
wire [7:0] top_ip_tx_sink_sink_param_protocol0;
wire [31:0] top_ip_tx_sink_sink_param_ip_address0;
wire top_ip_tx_source_source_valid0;
wire top_ip_tx_source_source_ready0;
wire top_ip_tx_source_source_first0;
wire top_ip_tx_source_source_last0;
wire [15:0] top_ip_tx_source_source_payload_ethernet_type;
wire [47:0] top_ip_tx_source_source_payload_sender_mac;
wire [47:0] top_ip_tx_source_source_payload_target_mac;
wire [7:0] top_ip_tx_source_source_payload_data0;
wire top_ip_tx_source_source_payload_be0;
wire top_ip_tx_source_source_payload_error0;
reg top_ip_tx_target_unreachable;
wire top_ip_tx_sink_sink_valid1;
wire top_ip_tx_sink_sink_ready1;
wire top_ip_tx_sink_sink_first1;
wire top_ip_tx_sink_sink_last1;
wire [7:0] top_ip_tx_sink_sink_payload_data1;
wire top_ip_tx_sink_sink_payload_be1;
wire top_ip_tx_sink_sink_payload_error1;
wire [15:0] top_ip_tx_sink_sink_param_length1;
wire [7:0] top_ip_tx_sink_sink_param_protocol1;
wire [31:0] top_ip_tx_sink_sink_param_ip_address1;
wire top_ip_tx_source_source_valid1;
wire top_ip_tx_source_source_ready1;
wire top_ip_tx_source_source_first1;
wire top_ip_tx_source_source_last1;
wire [7:0] top_ip_tx_source_source_payload_data1;
wire top_ip_tx_source_source_payload_be1;
wire top_ip_tx_source_source_payload_error1;
wire [15:0] top_ip_tx_source_source_param_length;
wire [7:0] top_ip_tx_source_source_param_protocol;
wire [31:0] top_ip_tx_source_source_param_ip_address;
wire top_ip_tx_pipe_valid_sink_valid;
wire top_ip_tx_pipe_valid_sink_ready;
wire top_ip_tx_pipe_valid_sink_first;
wire top_ip_tx_pipe_valid_sink_last;
wire [7:0] top_ip_tx_pipe_valid_sink_payload_data;
wire top_ip_tx_pipe_valid_sink_payload_be;
wire top_ip_tx_pipe_valid_sink_payload_error;
wire [15:0] top_ip_tx_pipe_valid_sink_param_length;
wire [7:0] top_ip_tx_pipe_valid_sink_param_protocol;
wire [31:0] top_ip_tx_pipe_valid_sink_param_ip_address;
reg top_ip_tx_pipe_valid_source_valid = 1'd0;
wire top_ip_tx_pipe_valid_source_ready;
reg top_ip_tx_pipe_valid_source_first = 1'd0;
reg top_ip_tx_pipe_valid_source_last = 1'd0;
reg [7:0] top_ip_tx_pipe_valid_source_payload_data = 8'd0;
reg top_ip_tx_pipe_valid_source_payload_be = 1'd0;
reg top_ip_tx_pipe_valid_source_payload_error = 1'd0;
reg [15:0] top_ip_tx_pipe_valid_source_param_length = 16'd0;
reg [7:0] top_ip_tx_pipe_valid_source_param_protocol = 8'd0;
reg [31:0] top_ip_tx_pipe_valid_source_param_ip_address = 32'd0;
wire [159:0] top_ip_tx_liteethipv4checksum_header;
wire [15:0] top_ip_tx_liteethipv4checksum_value;
wire top_ip_tx_liteethipv4checksum_done;
reg [16:0] top_ip_tx_liteethipv4checksum_r = 17'd0;
wire [16:0] top_ip_tx_liteethipv4checksum_s_next0;
reg [16:0] top_ip_tx_liteethipv4checksum_r_next0 = 17'd0;
reg top_ip_tx_liteethipv4checksum0 = 1'd0;
wire [16:0] top_ip_tx_liteethipv4checksum_s_next1;
reg [16:0] top_ip_tx_liteethipv4checksum_r_next1 = 17'd0;
reg top_ip_tx_liteethipv4checksum1 = 1'd0;
wire [16:0] top_ip_tx_liteethipv4checksum_s_next2;
reg [16:0] top_ip_tx_liteethipv4checksum_r_next2 = 17'd0;
reg top_ip_tx_liteethipv4checksum2 = 1'd0;
wire [16:0] top_ip_tx_liteethipv4checksum_s_next3;
reg [16:0] top_ip_tx_liteethipv4checksum_r_next3 = 17'd0;
reg top_ip_tx_liteethipv4checksum3 = 1'd0;
wire [16:0] top_ip_tx_liteethipv4checksum_s_next4;
reg [16:0] top_ip_tx_liteethipv4checksum_r_next4 = 17'd0;
reg top_ip_tx_liteethipv4checksum4 = 1'd0;
wire [16:0] top_ip_tx_liteethipv4checksum_s_next5;
reg [16:0] top_ip_tx_liteethipv4checksum_r_next5 = 17'd0;
reg top_ip_tx_liteethipv4checksum5 = 1'd0;
wire [16:0] top_ip_tx_liteethipv4checksum_s_next6;
reg [16:0] top_ip_tx_liteethipv4checksum_r_next6 = 17'd0;
reg top_ip_tx_liteethipv4checksum6 = 1'd0;
wire [16:0] top_ip_tx_liteethipv4checksum_s_next7;
reg [16:0] top_ip_tx_liteethipv4checksum_r_next7 = 17'd0;
reg top_ip_tx_liteethipv4checksum7 = 1'd0;
wire [16:0] top_ip_tx_liteethipv4checksum_s_next8;
reg [16:0] top_ip_tx_liteethipv4checksum_r_next8 = 17'd0;
reg top_ip_tx_liteethipv4checksum8 = 1'd0;
reg [3:0] top_ip_tx_liteethipv4checksum_counter = 4'd0;
wire top_ip_tx_liteethipv4checksum_counter_ce;
wire top_ip_tx_ce;
wire top_ip_tx_reset;
wire top_ip_tx_packetizer_sink_valid;
reg top_ip_tx_packetizer_sink_ready;
wire top_ip_tx_packetizer_sink_last;
wire [7:0] top_ip_tx_packetizer_sink_payload_data;
wire top_ip_tx_packetizer_sink_payload_be;
reg top_ip_tx_packetizer_sink_payload_error = 1'd0;
wire [15:0] top_ip_tx_packetizer_sink_param_checksum;
wire [15:0] top_ip_tx_packetizer_sink_param_flags_offset;
wire [15:0] top_ip_tx_packetizer_sink_param_identification;
wire [3:0] top_ip_tx_packetizer_sink_param_ihl;
wire [7:0] top_ip_tx_packetizer_sink_param_protocol;
wire [31:0] top_ip_tx_packetizer_sink_param_sender_ip;
wire [31:0] top_ip_tx_packetizer_sink_param_target_ip;
wire [15:0] top_ip_tx_packetizer_sink_param_total_length;
wire [7:0] top_ip_tx_packetizer_sink_param_ttl;
wire [3:0] top_ip_tx_packetizer_sink_param_version;
reg top_ip_tx_packetizer_source_valid;
wire top_ip_tx_packetizer_source_ready;
reg top_ip_tx_packetizer_source_first;
reg top_ip_tx_packetizer_source_last;
reg [7:0] top_ip_tx_packetizer_source_payload_data;
wire top_ip_tx_packetizer_source_payload_be;
reg top_ip_tx_packetizer_source_payload_error;
reg [159:0] top_ip_tx_packetizer_header;
reg top_ip_tx_packetizer_source_be;
reg [4:0] top_ip_tx_packetizer_count = 5'd0;
reg top_ip_tx_packetizer_is_ongoing;
reg [47:0] top_ip_tx_target_mac = 48'd0;
reg top_ip_tx_fsm_is_ongoing0;
reg top_ip_tx_fsm_is_ongoing1;
reg top_ip_tx_fsm_is_ongoing2;
wire top_ip_rx_sink_sink_valid;
wire top_ip_rx_sink_sink_ready;
wire top_ip_rx_sink_sink_first;
wire top_ip_rx_sink_sink_last;
wire [15:0] top_ip_rx_sink_sink_payload_ethernet_type;
wire [47:0] top_ip_rx_sink_sink_payload_sender_mac;
wire [47:0] top_ip_rx_sink_sink_payload_target_mac;
wire [7:0] top_ip_rx_sink_sink_payload_data;
wire top_ip_rx_sink_sink_payload_be;
wire top_ip_rx_sink_sink_payload_error;
wire top_ip_rx_source_source_valid;
wire top_ip_rx_source_source_ready;
reg top_ip_rx_source_source_first = 1'd0;
wire top_ip_rx_source_source_last;
wire [7:0] top_ip_rx_source_source_payload_data;
wire top_ip_rx_source_source_payload_be;
wire top_ip_rx_source_source_payload_error;
wire [15:0] top_ip_rx_source_source_param_length;
wire [7:0] top_ip_rx_source_source_param_protocol;
wire [31:0] top_ip_rx_source_source_param_ip_address;
wire top_ip_rx_depacketizer_sink_valid;
reg top_ip_rx_depacketizer_sink_ready;
wire top_ip_rx_depacketizer_sink_first;
wire top_ip_rx_depacketizer_sink_last;
wire [15:0] top_ip_rx_depacketizer_sink_payload_ethernet_type;
wire [47:0] top_ip_rx_depacketizer_sink_payload_sender_mac;
wire [47:0] top_ip_rx_depacketizer_sink_payload_target_mac;
wire [7:0] top_ip_rx_depacketizer_sink_payload_data;
wire top_ip_rx_depacketizer_sink_payload_be;
wire top_ip_rx_depacketizer_sink_payload_error;
reg top_ip_rx_depacketizer_source_valid;
wire top_ip_rx_depacketizer_source_ready;
reg top_ip_rx_depacketizer_source_first;
reg top_ip_rx_depacketizer_source_last;
reg [7:0] top_ip_rx_depacketizer_source_payload_data;
wire top_ip_rx_depacketizer_source_payload_be;
wire top_ip_rx_depacketizer_source_payload_error;
wire [15:0] top_ip_rx_depacketizer_source_param_checksum;
wire [15:0] top_ip_rx_depacketizer_source_param_flags_offset;
wire [15:0] top_ip_rx_depacketizer_source_param_identification;
wire [3:0] top_ip_rx_depacketizer_source_param_ihl;
wire [7:0] top_ip_rx_depacketizer_source_param_protocol;
wire [31:0] top_ip_rx_depacketizer_source_param_sender_ip;
wire [31:0] top_ip_rx_depacketizer_source_param_target_ip;
wire [15:0] top_ip_rx_depacketizer_source_param_total_length;
wire [7:0] top_ip_rx_depacketizer_source_param_ttl;
wire [3:0] top_ip_rx_depacketizer_source_param_version;
wire [159:0] top_ip_rx_depacketizer_header;
reg [159:0] top_ip_rx_depacketizer_sr = 160'd0;
reg top_ip_rx_depacketizer_sr_shift;
reg top_ip_rx_depacketizer_sr_shift_leftover = 1'd0;
reg [4:0] top_ip_rx_depacketizer_count = 5'd0;
reg top_ip_rx_depacketizer_data_copy_first = 1'd0;
wire top_ip_rx_depacketizer_sink_be;
reg top_ip_rx_depacketizer_source_be;
reg top_ip_rx_depacketizer_fsm_from_idle = 1'd0;
wire [159:0] top_ip_rx_liteethipv4checksum_header;
wire [15:0] top_ip_rx_liteethipv4checksum_value;
wire top_ip_rx_liteethipv4checksum_done;
reg [16:0] top_ip_rx_liteethipv4checksum_r = 17'd0;
wire [16:0] top_ip_rx_liteethipv4checksum_s_next0;
reg [16:0] top_ip_rx_liteethipv4checksum_r_next0 = 17'd0;
reg top_ip_rx_liteethipv4checksum0 = 1'd0;
wire [16:0] top_ip_rx_liteethipv4checksum_s_next1;
reg [16:0] top_ip_rx_liteethipv4checksum_r_next1 = 17'd0;
reg top_ip_rx_liteethipv4checksum1 = 1'd0;
wire [16:0] top_ip_rx_liteethipv4checksum_s_next2;
reg [16:0] top_ip_rx_liteethipv4checksum_r_next2 = 17'd0;
reg top_ip_rx_liteethipv4checksum2 = 1'd0;
wire [16:0] top_ip_rx_liteethipv4checksum_s_next3;
reg [16:0] top_ip_rx_liteethipv4checksum_r_next3 = 17'd0;
reg top_ip_rx_liteethipv4checksum3 = 1'd0;
wire [16:0] top_ip_rx_liteethipv4checksum_s_next4;
reg [16:0] top_ip_rx_liteethipv4checksum_r_next4 = 17'd0;
reg top_ip_rx_liteethipv4checksum4 = 1'd0;
wire [16:0] top_ip_rx_liteethipv4checksum_s_next5;
reg [16:0] top_ip_rx_liteethipv4checksum_r_next5 = 17'd0;
reg top_ip_rx_liteethipv4checksum5 = 1'd0;
wire [16:0] top_ip_rx_liteethipv4checksum_s_next6;
reg [16:0] top_ip_rx_liteethipv4checksum_r_next6 = 17'd0;
reg top_ip_rx_liteethipv4checksum6 = 1'd0;
wire [16:0] top_ip_rx_liteethipv4checksum_s_next7;
reg [16:0] top_ip_rx_liteethipv4checksum_r_next7 = 17'd0;
reg top_ip_rx_liteethipv4checksum7 = 1'd0;
wire [16:0] top_ip_rx_liteethipv4checksum_s_next8;
reg [16:0] top_ip_rx_liteethipv4checksum_r_next8 = 17'd0;
reg top_ip_rx_liteethipv4checksum8 = 1'd0;
wire [16:0] top_ip_rx_liteethipv4checksum_s_next9;
reg [16:0] top_ip_rx_liteethipv4checksum_r_next9 = 17'd0;
reg top_ip_rx_liteethipv4checksum9 = 1'd0;
reg [3:0] top_ip_rx_liteethipv4checksum_counter = 4'd0;
wire top_ip_rx_liteethipv4checksum_counter_ce;
wire top_ip_rx_ce;
wire top_ip_rx_reset;
wire top_ip_rx_accepted;
wire top_ip_rx_receiving;
reg top_ip_rx_is_ongoing0;
reg top_ip_rx_is_ongoing1;
wire top_ip_mac_port_sink_valid;
reg top_ip_mac_port_sink_ready;
wire top_ip_mac_port_sink_first;
wire top_ip_mac_port_sink_last;
wire [15:0] top_ip_mac_port_sink_payload_ethernet_type;
wire [47:0] top_ip_mac_port_sink_payload_sender_mac;
wire [47:0] top_ip_mac_port_sink_payload_target_mac;
wire [7:0] top_ip_mac_port_sink_payload_data;
wire top_ip_mac_port_sink_payload_be;
wire top_ip_mac_port_sink_payload_error;
reg top_ip_mac_port_source_valid;
wire top_ip_mac_port_source_ready;
reg top_ip_mac_port_source_first;
reg top_ip_mac_port_source_last;
reg [15:0] top_ip_mac_port_source_payload_ethernet_type;
reg [47:0] top_ip_mac_port_source_payload_sender_mac;
reg [47:0] top_ip_mac_port_source_payload_target_mac;
reg [7:0] top_ip_mac_port_source_payload_data;
reg top_ip_mac_port_source_payload_be;
reg top_ip_mac_port_source_payload_error;
reg top_ip_crossbar_source_valid;
wire top_ip_crossbar_source_ready;
reg top_ip_crossbar_source_first;
reg top_ip_crossbar_source_last;
reg [7:0] top_ip_crossbar_source_payload_data;
reg top_ip_crossbar_source_payload_be;
reg top_ip_crossbar_source_payload_error;
reg [15:0] top_ip_crossbar_source_param_length;
reg [7:0] top_ip_crossbar_source_param_protocol;
reg [31:0] top_ip_crossbar_source_param_ip_address;
wire top_ip_crossbar_sink_valid;
reg top_ip_crossbar_sink_ready;
wire top_ip_crossbar_sink_first;
wire top_ip_crossbar_sink_last;
wire [7:0] top_ip_crossbar_sink_payload_data;
wire top_ip_crossbar_sink_payload_be;
wire top_ip_crossbar_sink_payload_error;
wire [15:0] top_ip_crossbar_sink_param_length;
wire [7:0] top_ip_crossbar_sink_param_protocol;
wire [31:0] top_ip_crossbar_sink_param_ip_address;
wire top_icmp_tx_sink_sink_valid;
wire top_icmp_tx_sink_sink_ready;
wire top_icmp_tx_sink_sink_first;
wire top_icmp_tx_sink_sink_last;
wire [7:0] top_icmp_tx_sink_sink_payload_data;
wire top_icmp_tx_sink_sink_payload_be;
wire top_icmp_tx_sink_sink_payload_error;
wire [15:0] top_icmp_tx_sink_sink_param_checksum;
wire [7:0] top_icmp_tx_sink_sink_param_code;
wire [7:0] top_icmp_tx_sink_sink_param_msgtype;
wire [31:0] top_icmp_tx_sink_sink_param_quench;
wire [31:0] top_icmp_tx_sink_sink_param_ip_address;
wire [15:0] top_icmp_tx_sink_sink_param_length;
wire top_icmp_tx_source_source_valid;
wire top_icmp_tx_source_source_ready;
wire top_icmp_tx_source_source_first;
wire top_icmp_tx_source_source_last;
wire [7:0] top_icmp_tx_source_source_payload_data;
wire top_icmp_tx_source_source_payload_be;
wire top_icmp_tx_source_source_payload_error;
wire [15:0] top_icmp_tx_source_source_param_length;
wire [7:0] top_icmp_tx_source_source_param_protocol;
wire [31:0] top_icmp_tx_source_source_param_ip_address;
wire top_icmp_tx_packetizer_sink_valid;
reg top_icmp_tx_packetizer_sink_ready;
wire top_icmp_tx_packetizer_sink_last;
wire [7:0] top_icmp_tx_packetizer_sink_payload_data;
wire top_icmp_tx_packetizer_sink_payload_be;
reg top_icmp_tx_packetizer_sink_payload_error = 1'd0;
wire [15:0] top_icmp_tx_packetizer_sink_param_checksum;
wire [7:0] top_icmp_tx_packetizer_sink_param_code;
wire [7:0] top_icmp_tx_packetizer_sink_param_msgtype;
wire [31:0] top_icmp_tx_packetizer_sink_param_quench;
reg top_icmp_tx_packetizer_source_valid;
wire top_icmp_tx_packetizer_source_ready;
reg top_icmp_tx_packetizer_source_first;
reg top_icmp_tx_packetizer_source_last;
reg [7:0] top_icmp_tx_packetizer_source_payload_data;
wire top_icmp_tx_packetizer_source_payload_be;
reg top_icmp_tx_packetizer_source_payload_error;
reg [63:0] top_icmp_tx_packetizer_header;
reg top_icmp_tx_packetizer_source_be;
reg [2:0] top_icmp_tx_packetizer_count = 3'd0;
reg top_icmp_tx_packetizer_is_ongoing;
reg top_icmp_tx_active = 1'd0;
reg [15:0] top_icmp_tx_length = 16'd0;
reg [31:0] top_icmp_tx_ip_address = 32'd0;
wire top_icmp_rx_sink_sink_valid;
wire top_icmp_rx_sink_sink_ready;
wire top_icmp_rx_sink_sink_first;
wire top_icmp_rx_sink_sink_last;
wire [7:0] top_icmp_rx_sink_sink_payload_data;
wire top_icmp_rx_sink_sink_payload_be;
wire top_icmp_rx_sink_sink_payload_error;
wire [15:0] top_icmp_rx_sink_sink_param_length;
wire [7:0] top_icmp_rx_sink_sink_param_protocol;
wire [31:0] top_icmp_rx_sink_sink_param_ip_address;
wire top_icmp_rx_source_source_valid;
wire top_icmp_rx_source_source_ready;
reg top_icmp_rx_source_source_first = 1'd0;
reg top_icmp_rx_source_source_last;
wire [7:0] top_icmp_rx_source_source_payload_data;
reg top_icmp_rx_source_source_payload_be;
reg top_icmp_rx_source_source_payload_error;
wire [15:0] top_icmp_rx_source_source_param_checksum;
wire [7:0] top_icmp_rx_source_source_param_code;
wire [7:0] top_icmp_rx_source_source_param_msgtype;
wire [31:0] top_icmp_rx_source_source_param_quench;
wire [31:0] top_icmp_rx_source_source_param_ip_address;
wire [15:0] top_icmp_rx_source_source_param_length;
wire top_icmp_rx_depacketizer_sink_valid;
reg top_icmp_rx_depacketizer_sink_ready;
wire top_icmp_rx_depacketizer_sink_first;
wire top_icmp_rx_depacketizer_sink_last;
wire [7:0] top_icmp_rx_depacketizer_sink_payload_data;
wire top_icmp_rx_depacketizer_sink_payload_be;
wire top_icmp_rx_depacketizer_sink_payload_error;
wire [15:0] top_icmp_rx_depacketizer_sink_param_length;
wire [7:0] top_icmp_rx_depacketizer_sink_param_protocol;
wire [31:0] top_icmp_rx_depacketizer_sink_param_ip_address;
reg top_icmp_rx_depacketizer_source_valid;
wire top_icmp_rx_depacketizer_source_ready;
reg top_icmp_rx_depacketizer_source_first;
reg top_icmp_rx_depacketizer_source_last;
reg [7:0] top_icmp_rx_depacketizer_source_payload_data;
wire top_icmp_rx_depacketizer_source_payload_be;
wire top_icmp_rx_depacketizer_source_payload_error;
wire [15:0] top_icmp_rx_depacketizer_source_param_checksum;
wire [7:0] top_icmp_rx_depacketizer_source_param_code;
wire [7:0] top_icmp_rx_depacketizer_source_param_msgtype;
wire [31:0] top_icmp_rx_depacketizer_source_param_quench;
wire [63:0] top_icmp_rx_depacketizer_header;
reg [63:0] top_icmp_rx_depacketizer_sr = 64'd0;
reg top_icmp_rx_depacketizer_sr_shift;
reg top_icmp_rx_depacketizer_sr_shift_leftover = 1'd0;
reg [2:0] top_icmp_rx_depacketizer_count = 3'd0;
reg top_icmp_rx_depacketizer_data_copy_first = 1'd0;
wire top_icmp_rx_depacketizer_sink_be;
reg top_icmp_rx_depacketizer_source_be;
reg top_icmp_rx_depacketizer_fsm_from_idle = 1'd0;
reg top_icmp_rx_active = 1'd0;
reg [15:0] top_icmp_rx_length = 16'd0;
reg [7:0] top_icmp_rx_protocol = 8'd0;
reg [31:0] top_icmp_rx_ip_address = 32'd0;
reg [16:0] top_icmp_rx_count = 17'd0;
reg top_icmp_rx_is_ongoing0;
reg top_icmp_rx_is_ongoing1;
reg top_icmp_rx_is_ongoing2;
wire top_icmp_echo_sink_sink_valid;
wire top_icmp_echo_sink_sink_ready;
wire top_icmp_echo_sink_sink_first;
wire top_icmp_echo_sink_sink_last;
wire [7:0] top_icmp_echo_sink_sink_payload_data;
wire top_icmp_echo_sink_sink_payload_be;
wire top_icmp_echo_sink_sink_payload_error;
wire [15:0] top_icmp_echo_sink_sink_param_checksum;
wire [7:0] top_icmp_echo_sink_sink_param_code;
wire [7:0] top_icmp_echo_sink_sink_param_msgtype;
wire [31:0] top_icmp_echo_sink_sink_param_quench;
wire [31:0] top_icmp_echo_sink_sink_param_ip_address;
wire [15:0] top_icmp_echo_sink_sink_param_length;
wire top_icmp_echo_source_source_valid;
wire top_icmp_echo_source_source_ready;
wire top_icmp_echo_source_source_first;
wire top_icmp_echo_source_source_last;
wire [7:0] top_icmp_echo_source_source_payload_data;
wire top_icmp_echo_source_source_payload_be;
wire top_icmp_echo_source_source_payload_error;
wire [15:0] top_icmp_echo_source_source_param_checksum;
wire [7:0] top_icmp_echo_source_source_param_code;
reg [7:0] top_icmp_echo_source_source_param_msgtype;
wire [31:0] top_icmp_echo_source_source_param_quench;
wire [31:0] top_icmp_echo_source_source_param_ip_address;
wire [15:0] top_icmp_echo_source_source_param_length;
wire top_icmp_echo_buffer_sink_valid;
wire top_icmp_echo_buffer_sink_ready;
wire top_icmp_echo_buffer_sink_first;
wire top_icmp_echo_buffer_sink_last;
wire [7:0] top_icmp_echo_buffer_sink_payload_data;
wire top_icmp_echo_buffer_sink_payload_be;
wire top_icmp_echo_buffer_sink_payload_error;
wire [15:0] top_icmp_echo_buffer_sink_param_checksum;
wire [7:0] top_icmp_echo_buffer_sink_param_code;
wire [7:0] top_icmp_echo_buffer_sink_param_msgtype;
wire [31:0] top_icmp_echo_buffer_sink_param_quench;
wire [31:0] top_icmp_echo_buffer_sink_param_ip_address;
wire [15:0] top_icmp_echo_buffer_sink_param_length;
wire top_icmp_echo_buffer_source_valid;
wire top_icmp_echo_buffer_source_ready;
wire top_icmp_echo_buffer_source_first;
wire top_icmp_echo_buffer_source_last;
wire [7:0] top_icmp_echo_buffer_source_payload_data;
wire top_icmp_echo_buffer_source_payload_be;
wire top_icmp_echo_buffer_source_payload_error;
wire [15:0] top_icmp_echo_buffer_source_param_checksum;
wire [7:0] top_icmp_echo_buffer_source_param_code;
wire [7:0] top_icmp_echo_buffer_source_param_msgtype;
wire [31:0] top_icmp_echo_buffer_source_param_quench;
wire [31:0] top_icmp_echo_buffer_source_param_ip_address;
wire [15:0] top_icmp_echo_buffer_source_param_length;
wire top_icmp_echo_buffer_discard;
wire top_icmp_echo_buffer_drop;
wire top_icmp_echo_buffer_sink_sink_valid;
wire top_icmp_echo_buffer_sink_sink_ready;
reg top_icmp_echo_buffer_sink_sink_first = 1'd0;
wire top_icmp_echo_buffer_sink_sink_last;
wire [15:0] top_icmp_echo_buffer_sink_sink_param_checksum;
wire [7:0] top_icmp_echo_buffer_sink_sink_param_code;
wire [7:0] top_icmp_echo_buffer_sink_sink_param_msgtype;
wire [31:0] top_icmp_echo_buffer_sink_sink_param_quench;
wire [31:0] top_icmp_echo_buffer_sink_sink_param_ip_address;
wire [15:0] top_icmp_echo_buffer_sink_sink_param_length;
wire top_icmp_echo_buffer_source_source_valid;
wire top_icmp_echo_buffer_source_source_ready;
wire top_icmp_echo_buffer_source_source_first;
wire top_icmp_echo_buffer_source_source_last;
wire [15:0] top_icmp_echo_buffer_source_source_param_checksum;
wire [7:0] top_icmp_echo_buffer_source_source_param_code;
wire [7:0] top_icmp_echo_buffer_source_source_param_msgtype;
wire [31:0] top_icmp_echo_buffer_source_source_param_quench;
wire [31:0] top_icmp_echo_buffer_source_source_param_ip_address;
wire [15:0] top_icmp_echo_buffer_source_source_param_length;
wire top_icmp_echo_buffer_pipe_valid_sink_valid;
wire top_icmp_echo_buffer_pipe_valid_sink_ready;
wire top_icmp_echo_buffer_pipe_valid_sink_first;
wire top_icmp_echo_buffer_pipe_valid_sink_last;
wire [15:0] top_icmp_echo_buffer_pipe_valid_sink_param_checksum;
wire [7:0] top_icmp_echo_buffer_pipe_valid_sink_param_code;
wire [7:0] top_icmp_echo_buffer_pipe_valid_sink_param_msgtype;
wire [31:0] top_icmp_echo_buffer_pipe_valid_sink_param_quench;
wire [31:0] top_icmp_echo_buffer_pipe_valid_sink_param_ip_address;
wire [15:0] top_icmp_echo_buffer_pipe_valid_sink_param_length;
reg top_icmp_echo_buffer_pipe_valid_source_valid = 1'd0;
wire top_icmp_echo_buffer_pipe_valid_source_ready;
reg top_icmp_echo_buffer_pipe_valid_source_first = 1'd0;
reg top_icmp_echo_buffer_pipe_valid_source_last = 1'd0;
reg [15:0] top_icmp_echo_buffer_pipe_valid_source_param_checksum = 16'd0;
reg [7:0] top_icmp_echo_buffer_pipe_valid_source_param_code = 8'd0;
reg [7:0] top_icmp_echo_buffer_pipe_valid_source_param_msgtype = 8'd0;
reg [31:0] top_icmp_echo_buffer_pipe_valid_source_param_quench = 32'd0;
reg [31:0] top_icmp_echo_buffer_pipe_valid_source_param_ip_address = 32'd0;
reg [15:0] top_icmp_echo_buffer_pipe_valid_source_param_length = 16'd0;
wire top_icmp_echo_buffer_level;
wire [6:0] top_icmp_echo_buffer_wr_port_adr;
wire [11:0] top_icmp_echo_buffer_wr_port_dat_r;
wire top_icmp_echo_buffer_wr_port_we;
wire [11:0] top_icmp_echo_buffer_wr_port_dat_w;
wire [6:0] top_icmp_echo_buffer_rd_port_adr;
wire [11:0] top_icmp_echo_buffer_rd_port_dat_r;
wire top_icmp_echo_buffer_rd_port_re;
reg [7:0] top_icmp_echo_buffer_wr_ptr = 8'd0;
reg [7:0] top_icmp_echo_buffer_commit_ptr = 8'd0;
reg [7:0] top_icmp_echo_buffer_rd_ptr = 8'd0;
reg top_icmp_echo_buffer_out_valid = 1'd0;
wire [7:0] top_icmp_echo_buffer_used;
wire top_icmp_echo_buffer_full;
reg top_icmp_echo_buffer_overflow = 1'd0;
reg top_icmp_echo_buffer_invalid = 1'd0;
wire top_icmp_echo_buffer_commit;
wire top_icmp_echo_buffer_fetch;
reg top_icmp_echo_busy = 1'd0;
reg top_icmp_echo_receiving = 1'd0;
reg [7:0] top_icmp_echo_count = 8'd0;
wire [7:0] top_icmp_echo_size;
wire top_icmp_sink_valid;
reg top_icmp_sink_ready;
wire top_icmp_sink_first;
wire top_icmp_sink_last;
wire [7:0] top_icmp_sink_payload_data;
wire top_icmp_sink_payload_be;
wire top_icmp_sink_payload_error;
wire [15:0] top_icmp_sink_param_length;
wire [7:0] top_icmp_sink_param_protocol;
wire [31:0] top_icmp_sink_param_ip_address;
reg top_icmp_source_valid;
wire top_icmp_source_ready;
reg top_icmp_source_first;
reg top_icmp_source_last;
reg [7:0] top_icmp_source_payload_data;
reg top_icmp_source_payload_be;
reg top_icmp_source_payload_error;
reg [15:0] top_icmp_source_param_length;
reg [7:0] top_icmp_source_param_protocol;
reg [31:0] top_icmp_source_param_ip_address;
wire top_tx_sink_sink_valid;
wire top_tx_sink_sink_ready;
wire top_tx_sink_sink_first;
wire top_tx_sink_sink_last;
wire [7:0] top_tx_sink_sink_payload_data;
wire top_tx_sink_sink_payload_be;
wire top_tx_sink_sink_payload_error;
wire [15:0] top_tx_sink_sink_param_src_port;
wire [15:0] top_tx_sink_sink_param_dst_port;
wire [31:0] top_tx_sink_sink_param_ip_address;
wire [15:0] top_tx_sink_sink_param_length;
wire top_tx_source_source_valid;
wire top_tx_source_source_ready;
wire top_tx_source_source_first;
wire top_tx_source_source_last;
wire [7:0] top_tx_source_source_payload_data;
wire top_tx_source_source_payload_be;
wire top_tx_source_source_payload_error;
wire [15:0] top_tx_source_source_param_length;
wire [7:0] top_tx_source_source_param_protocol;
wire [31:0] top_tx_source_source_param_ip_address;
wire top_tx_packetizer_sink_valid;
reg top_tx_packetizer_sink_ready;
wire top_tx_packetizer_sink_last;
wire [7:0] top_tx_packetizer_sink_payload_data;
wire top_tx_packetizer_sink_payload_be;
reg top_tx_packetizer_sink_payload_error = 1'd0;
wire [15:0] top_tx_packetizer_sink_param_checksum;
wire [15:0] top_tx_packetizer_sink_param_dst_port;
wire [15:0] top_tx_packetizer_sink_param_length;
wire [15:0] top_tx_packetizer_sink_param_src_port;
reg top_tx_packetizer_source_valid;
wire top_tx_packetizer_source_ready;
reg top_tx_packetizer_source_first;
reg top_tx_packetizer_source_last;
reg [7:0] top_tx_packetizer_source_payload_data;
wire top_tx_packetizer_source_payload_be;
reg top_tx_packetizer_source_payload_error;
reg [63:0] top_tx_packetizer_header;
reg top_tx_packetizer_source_be;
reg [2:0] top_tx_packetizer_count = 3'd0;
reg top_tx_packetizer_is_ongoing;
reg top_tx_active = 1'd0;
reg [15:0] top_tx_length = 16'd0;
reg [31:0] top_tx_ip_address = 32'd0;
wire top_rx_sink_sink_valid;
wire top_rx_sink_sink_ready;
wire top_rx_sink_sink_first;
wire top_rx_sink_sink_last;
wire [7:0] top_rx_sink_sink_payload_data;
wire top_rx_sink_sink_payload_be;
wire top_rx_sink_sink_payload_error;
wire [15:0] top_rx_sink_sink_param_length;
wire [7:0] top_rx_sink_sink_param_protocol;
wire [31:0] top_rx_sink_sink_param_ip_address;
wire top_rx_source_source_valid;
wire top_rx_source_source_ready;
reg top_rx_source_source_first = 1'd0;
wire top_rx_source_source_last;
wire [7:0] top_rx_source_source_payload_data;
reg top_rx_source_source_payload_be;
reg top_rx_source_source_payload_error;
wire [15:0] top_rx_source_source_param_src_port;
wire [15:0] top_rx_source_source_param_dst_port;
wire [31:0] top_rx_source_source_param_ip_address;
wire [15:0] top_rx_source_source_param_length;
wire top_rx_depacketizer_sink_valid;
reg top_rx_depacketizer_sink_ready;
wire top_rx_depacketizer_sink_first;
wire top_rx_depacketizer_sink_last;
wire [7:0] top_rx_depacketizer_sink_payload_data;
wire top_rx_depacketizer_sink_payload_be;
wire top_rx_depacketizer_sink_payload_error;
wire [15:0] top_rx_depacketizer_sink_param_length;
wire [7:0] top_rx_depacketizer_sink_param_protocol;
wire [31:0] top_rx_depacketizer_sink_param_ip_address;
reg top_rx_depacketizer_source_valid;
wire top_rx_depacketizer_source_ready;
reg top_rx_depacketizer_source_first;
reg top_rx_depacketizer_source_last;
reg [7:0] top_rx_depacketizer_source_payload_data;
wire top_rx_depacketizer_source_payload_be;
wire top_rx_depacketizer_source_payload_error;
wire [15:0] top_rx_depacketizer_source_param_checksum;
wire [15:0] top_rx_depacketizer_source_param_dst_port;
wire [15:0] top_rx_depacketizer_source_param_length;
wire [15:0] top_rx_depacketizer_source_param_src_port;
wire [63:0] top_rx_depacketizer_header;
reg [63:0] top_rx_depacketizer_sr = 64'd0;
reg top_rx_depacketizer_sr_shift;
reg top_rx_depacketizer_sr_shift_leftover = 1'd0;
reg [2:0] top_rx_depacketizer_count = 3'd0;
reg top_rx_depacketizer_data_copy_first = 1'd0;
wire top_rx_depacketizer_sink_be;
reg top_rx_depacketizer_source_be;
reg top_rx_depacketizer_fsm_from_idle = 1'd0;
reg top_rx_active = 1'd0;
reg [15:0] top_rx_length = 16'd0;
reg [7:0] top_rx_protocol = 8'd0;
reg [31:0] top_rx_ip_address = 32'd0;
reg [16:0] top_rx_count = 17'd0;
wire top_rx_accepted;
wire top_rx_receiving;
wire [16:0] top_rx_end_count;
reg top_rx_is_ongoing0;
reg top_rx_is_ongoing1;
wire top_ip_port_sink_valid;
reg top_ip_port_sink_ready;
wire top_ip_port_sink_first;
wire top_ip_port_sink_last;
wire [7:0] top_ip_port_sink_payload_data;
wire top_ip_port_sink_payload_be;
wire top_ip_port_sink_payload_error;
wire [15:0] top_ip_port_sink_param_length;
wire [7:0] top_ip_port_sink_param_protocol;
wire [31:0] top_ip_port_sink_param_ip_address;
reg top_ip_port_source_valid;
wire top_ip_port_source_ready;
reg top_ip_port_source_first;
reg top_ip_port_source_last;
reg [7:0] top_ip_port_source_payload_data;
reg top_ip_port_source_payload_be;
reg top_ip_port_source_payload_error;
reg [15:0] top_ip_port_source_param_length;
reg [7:0] top_ip_port_source_param_protocol;
reg [31:0] top_ip_port_source_param_ip_address;
wire top_crossbar_source_valid;
wire top_crossbar_source_ready;
wire top_crossbar_source_first;
wire top_crossbar_source_last;
wire [7:0] top_crossbar_source_payload_data;
wire top_crossbar_source_payload_be;
wire top_crossbar_source_payload_error;
wire [15:0] top_crossbar_source_param_src_port;
wire [15:0] top_crossbar_source_param_dst_port;
wire [31:0] top_crossbar_source_param_ip_address;
wire [15:0] top_crossbar_source_param_length;
wire top_crossbar_sink_valid;
reg top_crossbar_sink_ready;
wire top_crossbar_sink_first;
wire top_crossbar_sink_last;
wire [7:0] top_crossbar_sink_payload_data;
wire top_crossbar_sink_payload_be;
wire top_crossbar_sink_payload_error;
wire [15:0] top_crossbar_sink_param_src_port;
wire [15:0] top_crossbar_sink_param_dst_port;
wire [31:0] top_crossbar_sink_param_ip_address;
wire [15:0] top_crossbar_sink_param_length;
reg top_arm;
wire top_done;
wire [11:0] top_address;
wire top_arm_cdc_i;
wire top_arm_cdc_o;
reg top_arm_cdc_toggle_i = 1'd0;
wire top_arm_cdc_toggle_o;
reg top_arm_cdc_toggle_o_r = 1'd0;
wire top_done_cdc_i;
wire top_done_cdc_o;
reg top_done_cdc_toggle_i = 1'd0;
wire top_done_cdc_toggle_o;
reg top_done_cdc_toggle_o_r = 1'd0;
reg top_active = 1'd0;
reg [11:0] top_index = 12'd0;
wire [13:0] top_sampled0;
wire [11:0] top_wp_memory0_adr;
wire [15:0] top_wp_memory0_dat_r;
wire top_wp_memory0_we;
wire [15:0] top_wp_memory0_dat_w;
wire [11:0] top_rp_memory0_adr;
wire [15:0] top_rp_memory0_dat_r;
wire [13:0] top_sampled1;
wire [11:0] top_wp_memory1_adr;
wire [15:0] top_wp_memory1_dat_r;
wire top_wp_memory1_we;
wire [15:0] top_wp_memory1_dat_w;
wire [11:0] top_rp_memory1_adr;
wire [15:0] top_rp_memory1_dat_r;
wire [13:0] top_sampled2;
wire [11:0] top_wp_memory2_adr;
wire [15:0] top_wp_memory2_dat_r;
wire top_wp_memory2_we;
wire [15:0] top_wp_memory2_dat_w;
wire [11:0] top_rp_memory2_adr;
wire [15:0] top_rp_memory2_dat_r;
wire [13:0] top_sampled3;
wire [11:0] top_wp_memory3_adr;
wire [15:0] top_wp_memory3_dat_r;
wire top_wp_memory3_we;
wire [15:0] top_wp_memory3_dat_w;
wire [11:0] top_rp_memory3_adr;
wire [15:0] top_rp_memory3_dat_r;
wire [13:0] top_sampled4;
wire [11:0] top_wp_memory4_adr;
wire [15:0] top_wp_memory4_dat_r;
wire top_wp_memory4_we;
wire [15:0] top_wp_memory4_dat_w;
wire [11:0] top_rp_memory4_adr;
wire [15:0] top_rp_memory4_dat_r;
wire [13:0] top_sampled5;
wire [11:0] top_wp_memory5_adr;
wire [15:0] top_wp_memory5_dat_r;
wire top_wp_memory5_we;
wire [15:0] top_wp_memory5_dat_w;
wire [11:0] top_rp_memory5_adr;
wire [15:0] top_rp_memory5_dat_r;
wire [13:0] top_sampled6;
wire [11:0] top_wp_memory6_adr;
wire [15:0] top_wp_memory6_dat_r;
wire top_wp_memory6_we;
wire [15:0] top_wp_memory6_dat_w;
wire [11:0] top_rp_memory6_adr;
wire [15:0] top_rp_memory6_dat_r;
wire [13:0] top_sampled7;
wire [11:0] top_wp_memory7_adr;
wire [15:0] top_wp_memory7_dat_r;
wire top_wp_memory7_we;
wire [15:0] top_wp_memory7_dat_w;
wire [11:0] top_rp_memory7_adr;
wire [15:0] top_rp_memory7_dat_r;
wire [13:0] top_sampled8;
wire [11:0] top_wp_memory8_adr;
wire [15:0] top_wp_memory8_dat_r;
wire top_wp_memory8_we;
wire [15:0] top_wp_memory8_dat_w;
wire [11:0] top_rp_memory8_adr;
wire [15:0] top_rp_memory8_dat_r;
wire [13:0] top_sampled9;
wire [11:0] top_wp_memory9_adr;
wire [15:0] top_wp_memory9_dat_r;
wire top_wp_memory9_we;
wire [15:0] top_wp_memory9_dat_w;
wire [11:0] top_rp_memory9_adr;
wire [15:0] top_rp_memory9_dat_r;
wire [13:0] top_sampled10;
wire [11:0] top_wp_memory10_adr;
wire [15:0] top_wp_memory10_dat_r;
wire top_wp_memory10_we;
wire [15:0] top_wp_memory10_dat_w;
wire [11:0] top_rp_memory10_adr;
wire [15:0] top_rp_memory10_dat_r;
wire [13:0] top_sampled11;
wire [11:0] top_wp_memory11_adr;
wire [15:0] top_wp_memory11_dat_r;
wire top_wp_memory11_we;
wire [15:0] top_wp_memory11_dat_w;
wire [11:0] top_rp_memory11_adr;
wire [15:0] top_rp_memory11_dat_r;
reg top_user_port_sink_valid;
wire top_user_port_sink_ready;
reg top_user_port_sink_first;
reg top_user_port_sink_last;
reg [7:0] top_user_port_sink_payload_data;
wire top_user_port_sink_payload_be;
wire top_user_port_sink_payload_error;
wire [15:0] top_user_port_sink_param_src_port;
wire [15:0] top_user_port_sink_param_dst_port;
wire [31:0] top_user_port_sink_param_ip_address;
wire [15:0] top_user_port_sink_param_length;
wire top_user_port_source_valid;
wire top_user_port_source_ready;
wire top_user_port_source_first;
wire top_user_port_source_last;
wire [7:0] top_user_port_source_payload_data;
wire top_user_port_source_payload_be;
wire top_user_port_source_payload_error;
wire [15:0] top_user_port_source_param_src_port;
wire [15:0] top_user_port_source_param_dst_port;
wire [31:0] top_user_port_source_param_ip_address;
wire [15:0] top_user_port_source_param_length;
wire top_internal_port_sink_valid;
wire top_internal_port_sink_ready;
wire top_internal_port_sink_first;
wire top_internal_port_sink_last;
wire [7:0] top_internal_port_sink_payload_data;
wire top_internal_port_sink_payload_be;
wire top_internal_port_sink_payload_error;
wire [15:0] top_internal_port_sink_param_src_port;
wire [15:0] top_internal_port_sink_param_dst_port;
wire [31:0] top_internal_port_sink_param_ip_address;
wire [15:0] top_internal_port_sink_param_length;
reg top_internal_port_source_valid;
wire top_internal_port_source_ready;
reg top_internal_port_source_first;
reg top_internal_port_source_last;
reg [7:0] top_internal_port_source_payload_data;
reg top_internal_port_source_payload_be;
reg top_internal_port_source_payload_error;
reg [15:0] top_internal_port_source_param_src_port;
reg [15:0] top_internal_port_source_param_dst_port;
reg [31:0] top_internal_port_source_param_ip_address;
reg [15:0] top_internal_port_source_param_length;
wire top_tx_cdc_sink_valid;
wire top_tx_cdc_sink_ready;
wire top_tx_cdc_sink_first;
wire top_tx_cdc_sink_last;
wire [7:0] top_tx_cdc_sink_payload_data;
wire top_tx_cdc_sink_payload_be;
wire top_tx_cdc_sink_payload_error;
wire [15:0] top_tx_cdc_sink_param_src_port;
wire [15:0] top_tx_cdc_sink_param_dst_port;
wire [31:0] top_tx_cdc_sink_param_ip_address;
wire [15:0] top_tx_cdc_sink_param_length;
wire top_tx_cdc_source_valid;
wire top_tx_cdc_source_ready;
wire top_tx_cdc_source_first;
wire top_tx_cdc_source_last;
wire [7:0] top_tx_cdc_source_payload_data;
wire top_tx_cdc_source_payload_be;
wire top_tx_cdc_source_payload_error;
wire [15:0] top_tx_cdc_source_param_src_port;
wire [15:0] top_tx_cdc_source_param_dst_port;
wire [31:0] top_tx_cdc_source_param_ip_address;
wire [15:0] top_tx_cdc_source_param_length;
wire top_tx_converter_sink_sink_valid;
wire top_tx_converter_sink_sink_ready;
wire top_tx_converter_sink_sink_first;
wire top_tx_converter_sink_sink_last;
wire [7:0] top_tx_converter_sink_sink_payload_data;
wire top_tx_converter_sink_sink_payload_be;
wire top_tx_converter_sink_sink_payload_error;
wire [15:0] top_tx_converter_sink_sink_param_src_port;
wire [15:0] top_tx_converter_sink_sink_param_dst_port;
wire [31:0] top_tx_converter_sink_sink_param_ip_address;
wire [15:0] top_tx_converter_sink_sink_param_length;
wire top_tx_converter_source_source_valid;
wire top_tx_converter_source_source_ready;
wire top_tx_converter_source_source_first;
wire top_tx_converter_source_source_last;
wire [7:0] top_tx_converter_source_source_payload_data;
wire top_tx_converter_source_source_payload_be;
wire top_tx_converter_source_source_payload_error;
wire [15:0] top_tx_converter_source_source_param_src_port;
wire [15:0] top_tx_converter_source_source_param_dst_port;
wire [31:0] top_tx_converter_source_source_param_ip_address;
wire [15:0] top_tx_converter_source_source_param_length;
wire top_tx_converter_converter_sink_valid;
wire top_tx_converter_converter_sink_ready;
wire top_tx_converter_converter_sink_first;
wire top_tx_converter_converter_sink_last;
wire [9:0] top_tx_converter_converter_sink_payload_data;
wire top_tx_converter_converter_source_valid;
wire top_tx_converter_converter_source_ready;
wire top_tx_converter_converter_source_first;
wire top_tx_converter_converter_source_last;
wire [9:0] top_tx_converter_converter_source_payload_data;
wire top_tx_converter_converter_source_payload_valid_token_count;
wire top_rx_converter_sink_sink_valid;
wire top_rx_converter_sink_sink_ready;
wire top_rx_converter_sink_sink_first;
wire top_rx_converter_sink_sink_last;
wire [7:0] top_rx_converter_sink_sink_payload_data;
wire top_rx_converter_sink_sink_payload_be;
wire top_rx_converter_sink_sink_payload_error;
wire [15:0] top_rx_converter_sink_sink_param_src_port;
wire [15:0] top_rx_converter_sink_sink_param_dst_port;
wire [31:0] top_rx_converter_sink_sink_param_ip_address;
wire [15:0] top_rx_converter_sink_sink_param_length;
wire top_rx_converter_source_source_valid;
wire top_rx_converter_source_source_ready;
wire top_rx_converter_source_source_first;
wire top_rx_converter_source_source_last;
wire [7:0] top_rx_converter_source_source_payload_data;
wire top_rx_converter_source_source_payload_be;
wire top_rx_converter_source_source_payload_error;
wire [15:0] top_rx_converter_source_source_param_src_port;
wire [15:0] top_rx_converter_source_source_param_dst_port;
wire [31:0] top_rx_converter_source_source_param_ip_address;
wire [15:0] top_rx_converter_source_source_param_length;
wire top_rx_converter_converter_sink_valid;
wire top_rx_converter_converter_sink_ready;
wire top_rx_converter_converter_sink_first;
wire top_rx_converter_converter_sink_last;
wire [9:0] top_rx_converter_converter_sink_payload_data;
wire top_rx_converter_converter_source_valid;
wire top_rx_converter_converter_source_ready;
wire top_rx_converter_converter_source_first;
wire top_rx_converter_converter_source_last;
wire [9:0] top_rx_converter_converter_source_payload_data;
wire top_rx_converter_converter_source_payload_valid_token_count;
wire top_rx_cdc_sink_valid;
wire top_rx_cdc_sink_ready;
wire top_rx_cdc_sink_first;
wire top_rx_cdc_sink_last;
wire [7:0] top_rx_cdc_sink_payload_data;
wire top_rx_cdc_sink_payload_be;
wire top_rx_cdc_sink_payload_error;
wire [15:0] top_rx_cdc_sink_param_src_port;
wire [15:0] top_rx_cdc_sink_param_dst_port;
wire [31:0] top_rx_cdc_sink_param_ip_address;
wire [15:0] top_rx_cdc_sink_param_length;
wire top_rx_cdc_source_valid;
wire top_rx_cdc_source_ready;
wire top_rx_cdc_source_first;
wire top_rx_cdc_source_last;
wire [7:0] top_rx_cdc_source_payload_data;
wire top_rx_cdc_source_payload_be;
wire top_rx_cdc_source_payload_error;
wire [15:0] top_rx_cdc_source_param_src_port;
wire [15:0] top_rx_cdc_source_param_dst_port;
wire [31:0] top_rx_cdc_source_param_ip_address;
wire [15:0] top_rx_cdc_source_param_length;
reg [31:0] top_server_rx_count = 32'd0;
reg [31:0] top_server_checked = 32'd0;
reg [31:0] top_server_tx_count = 32'd0;
reg top_server_ev = 1'd0;
reg [31:0] top_server_capture_id = 32'd0;
reg top_server_valid = 1'd0;
wire top_server_link;
wire top_server_locked;
reg [3:0] top_server_count = 4'd0;
reg top_server_bad = 1'd0;
reg [7:0] top_server0 = 8'd0;
reg [7:0] top_server1 = 8'd0;
reg [7:0] top_server2 = 8'd0;
reg [7:0] top_server3 = 8'd0;
reg [7:0] top_server4 = 8'd0;
reg [7:0] top_server5 = 8'd0;
reg [7:0] top_server6 = 8'd0;
reg [7:0] top_server7 = 8'd0;
reg [31:0] top_server_remote_ip = 32'd0;
reg [15:0] top_server_remote_port = 16'd0;
wire [31:0] top_server_flags;
reg [15:0] top_server_word = 16'd0;
reg [8:0] top_server_wordidx = 9'd0;
reg [3:0] top_server_hidx = 4'd0;
reg [10:0] top_server_settle = 11'd0;
reg top_server_is_ongoing;
reg [31:0] top_tick = 32'd0;
wire [511:0] top_report;
wire [15:0] top_cmd;
wire reset0;
wire reset1;
wire reset2;
wire reset3;
wire reset4;
wire reset5;
wire reset6;
wire reset7;
wire mmcm_fb;
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
wire s7mmcm0_reset0;
wire s7mmcm0_reset1;
wire s7mmcm0_reset2;
wire s7mmcm0_reset3;
wire s7mmcm0_reset4;
wire s7mmcm0_reset5;
wire s7mmcm0_reset6;
wire s7mmcm0_reset7;
wire s7mmcm0_mmcm_fb;
wire s7mmcm1_reset0;
wire s7mmcm1_reset1;
wire s7mmcm1_reset2;
wire s7mmcm1_reset3;
wire s7mmcm1_reset4;
wire s7mmcm1_reset5;
wire s7mmcm1_reset6;
wire s7mmcm1_reset7;
wire s7mmcm1_mmcm_fb;
reg [3:0] gtxtxinit_state = 4'd0;
reg [3:0] gtxtxinit_next_state;
reg [3:0] gtxrxinit_state = 4'd0;
reg [3:0] gtxrxinit_next_state;
reg liteethmac_txdatapath_liteethmacpaddinginserter_state = 1'd0;
reg liteethmac_txdatapath_liteethmacpaddinginserter_next_state;
reg [15:0] top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value;
reg top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value_ce;
reg [1:0] liteethmac_txdatapath_bufferizeendpoints_state = 2'd0;
reg [1:0] liteethmac_txdatapath_bufferizeendpoints_next_state;
reg [31:0] top_mac_core_tx_crc_crc_packet_liteethmaccore_clockdomainsrenamer1_next_value0;
reg top_mac_core_tx_crc_crc_packet_liteethmaccore_clockdomainsrenamer1_next_value_ce0;
reg top_mac_core_tx_crc_be0_liteethmaccore_clockdomainsrenamer1_next_value1;
reg top_mac_core_tx_crc_be0_liteethmaccore_clockdomainsrenamer1_next_value_ce1;
reg [1:0] liteethmac_txdatapath_liteethmacpreambleinserter_state = 2'd0;
reg [1:0] liteethmac_txdatapath_liteethmacpreambleinserter_next_state;
reg [2:0] top_mac_core_tx_preamble_count_liteethmaccore_clockdomainsrenamer2_next_value;
reg top_mac_core_tx_preamble_count_liteethmaccore_clockdomainsrenamer2_next_value_ce;
reg liteethmac_txdatapath_liteethmacgap_state = 1'd0;
reg liteethmac_txdatapath_liteethmacgap_next_state;
reg [3:0] top_mac_core_tx_gap_counter_liteethmaccore_clockdomainsrenamer3_next_value;
reg top_mac_core_tx_gap_counter_liteethmaccore_clockdomainsrenamer3_next_value_ce;
reg liteethmac_rxdatapath_liteethmacpreamblechecker_state = 1'd0;
reg liteethmac_rxdatapath_liteethmacpreamblechecker_next_state;
reg [1:0] liteethmac_rxdatapath_bufferizeendpoints_state = 2'd0;
reg [1:0] liteethmac_rxdatapath_bufferizeendpoints_next_state;
reg top_mac_core_liteethmaccrc32checker_be_liteethmaccore_next_value0;
reg top_mac_core_liteethmaccrc32checker_be_liteethmaccore_next_value_ce0;
reg top_mac_core_liteethmaccrc32checker_last_error_liteethmaccore_next_value1;
reg top_mac_core_liteethmaccrc32checker_last_error_liteethmaccore_next_value_ce1;
reg [1:0] liteethmac_request;
reg liteethmac_grant = 1'd0;
reg liteethmac_status0_first = 1'd1;
wire liteethmac_status0_last;
wire liteethmac_status0_ongoing0;
reg liteethmac_status0_ongoing1 = 1'd0;
reg liteethmac_status1_first = 1'd1;
wire liteethmac_status1_last;
wire liteethmac_status1_ongoing0;
reg liteethmac_status1_ongoing1 = 1'd0;
reg [1:0] liteethmac_sel0;
reg liteethmac_first = 1'd1;
wire liteethmac_last;
wire liteethmac_ongoing0;
reg liteethmac_ongoing1 = 1'd0;
reg [1:0] liteethmac_sel1;
reg [1:0] liteethmac_sel_ongoing = 2'd0;
reg liteethmac_sel_locked = 1'd0;
reg liteethmac_liteethmacpacketizer_state = 1'd1;
reg liteethmac_liteethmacpacketizer_next_state;
reg [3:0] top_mac_packetizer_count_liteethmacpacketizer_next_value;
reg top_mac_packetizer_count_liteethmacpacketizer_next_value_ce;
reg [1:0] liteethmac_liteethmacdepacketizer_state = 2'd0;
reg [1:0] liteethmac_liteethmacdepacketizer_next_state;
reg [3:0] top_mac_depacketizer_count_liteethmacdepacketizer_next_value0;
reg top_mac_depacketizer_count_liteethmacdepacketizer_next_value_ce0;
reg top_mac_depacketizer_fsm_from_idle_liteethmacdepacketizer_next_value1;
reg top_mac_depacketizer_fsm_from_idle_liteethmacdepacketizer_next_value_ce1;
reg top_mac_depacketizer_data_copy_first_liteethmacdepacketizer_next_value2;
reg top_mac_depacketizer_data_copy_first_liteethmacdepacketizer_next_value_ce2;
reg liteetharptx_liteetharppacketizer_state = 1'd1;
reg liteetharptx_liteetharppacketizer_next_state;
reg [4:0] top_arp_tx_packetizer_count_liteetharp_liteetharptx_liteetharppacketizer_next_value;
reg top_arp_tx_packetizer_count_liteetharp_liteetharptx_liteetharppacketizer_next_value_ce;
reg liteetharptx_fsm_state = 1'd0;
reg liteetharptx_fsm_next_state;
reg [4:0] top_arp_tx_counter_liteetharp_liteetharptx_fsm_next_value;
reg top_arp_tx_counter_liteetharp_liteetharptx_fsm_next_value_ce;
reg [1:0] liteetharprx_liteetharpdepacketizer_state = 2'd0;
reg [1:0] liteetharprx_liteetharpdepacketizer_next_state;
reg [4:0] top_arp_rx_depacketizer_count_liteetharp_next_value0;
reg top_arp_rx_depacketizer_count_liteetharp_next_value_ce0;
reg top_arp_rx_depacketizer_fsm_from_idle_liteetharp_next_value1;
reg top_arp_rx_depacketizer_fsm_from_idle_liteetharp_next_value_ce1;
reg top_arp_rx_depacketizer_data_copy_first_liteetharp_next_value2;
reg top_arp_rx_depacketizer_data_copy_first_liteetharp_next_value_ce2;
reg [1:0] liteetharprx_fsm_state = 2'd0;
reg [1:0] liteetharprx_fsm_next_state;
reg [2:0] liteetharptable_liteetharpcache_state = 3'd0;
reg [2:0] liteetharptable_liteetharpcache_next_state;
reg top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value0;
reg top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce0;
reg top_arp_table_cache_search_count_liteetharp_liteetharptable_liteetharpcache_next_value1;
reg top_arp_table_cache_search_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce1;
reg top_arp_table_cache_error_liteetharp_liteetharptable_liteetharpcache_next_value2;
reg top_arp_table_cache_error_liteetharp_liteetharptable_liteetharpcache_next_value_ce2;
reg [2:0] liteetharptable_fsm_state = 3'd0;
reg [2:0] liteetharptable_fsm_next_state;
reg top_arp_table_request_pending_liteetharp_liteetharptable_fsm_next_value0;
reg top_arp_table_request_pending_liteetharp_liteetharptable_fsm_next_value_ce0;
reg [47:0] top_arp_table_response_response_payload_mac_address_liteetharp_liteetharptable_fsm_next_value1;
reg top_arp_table_response_response_payload_mac_address_liteetharp_liteetharptable_fsm_next_value_ce1;
reg top_arp_table_response_response_payload_failed_liteetharp_liteetharptable_fsm_next_value2;
reg top_arp_table_response_response_payload_failed_liteetharp_liteetharptable_fsm_next_value_ce2;
reg [2:0] top_arp_table_request_counter_liteetharp_liteetharptable_fsm_next_value3;
reg top_arp_table_request_counter_liteetharp_liteetharptable_fsm_next_value_ce3;
reg [31:0] top_arp_table_request_ip_address_liteetharp_liteetharptable_fsm_next_value4;
reg top_arp_table_request_ip_address_liteetharp_liteetharptable_fsm_next_value_ce4;
reg liteethip_liteethiptx_liteethipv4packetizer_state = 1'd1;
reg liteethip_liteethiptx_liteethipv4packetizer_next_state;
reg [4:0] top_ip_tx_packetizer_count_liteethip_liteethipv4packetizer_next_value;
reg top_ip_tx_packetizer_count_liteethip_liteethipv4packetizer_next_value_ce;
reg [2:0] liteethip_liteethiptx_fsm_state = 3'd2;
reg [2:0] liteethip_liteethiptx_fsm_next_state;
reg [47:0] top_ip_tx_target_mac_liteethip_fsm_next_value;
reg top_ip_tx_target_mac_liteethip_fsm_next_value_ce;
reg [1:0] liteethip_liteethiprx_liteethipv4depacketizer_state = 2'd0;
reg [1:0] liteethip_liteethiprx_liteethipv4depacketizer_next_state;
reg [4:0] top_ip_rx_depacketizer_count_liteethip_next_value0;
reg top_ip_rx_depacketizer_count_liteethip_next_value_ce0;
reg top_ip_rx_depacketizer_fsm_from_idle_liteethip_next_value1;
reg top_ip_rx_depacketizer_fsm_from_idle_liteethip_next_value_ce1;
reg top_ip_rx_depacketizer_data_copy_first_liteethip_next_value2;
reg top_ip_rx_depacketizer_data_copy_first_liteethip_next_value_ce2;
reg [1:0] liteethip_liteethiprx_fsm_state = 2'd1;
reg [1:0] liteethip_liteethiprx_fsm_next_state;
reg [1:0] liteethip_request;
reg liteethip_grant = 1'd0;
reg liteethip_status0_first = 1'd1;
wire liteethip_status0_last;
wire liteethip_status0_ongoing0;
reg liteethip_status0_ongoing1 = 1'd0;
reg liteethip_status1_first = 1'd1;
wire liteethip_status1_last;
wire liteethip_status1_ongoing0;
reg liteethip_status1_ongoing1 = 1'd0;
reg [1:0] liteethip_sel0;
reg liteethip_first = 1'd1;
wire liteethip_last;
wire liteethip_ongoing0;
reg liteethip_ongoing1 = 1'd0;
reg [1:0] liteethip_sel1;
reg [1:0] liteethip_sel_ongoing = 2'd0;
reg liteethip_sel_locked = 1'd0;
reg liteethicmp_state = 1'd1;
reg liteethicmp_next_state;
reg [2:0] top_icmp_tx_packetizer_count_liteethicmp_next_value;
reg top_icmp_tx_packetizer_count_liteethicmp_next_value_ce;
reg [1:0] liteethicmp_liteethicmpdepacketizer_state = 2'd0;
reg [1:0] liteethicmp_liteethicmpdepacketizer_next_state;
reg [2:0] top_icmp_rx_depacketizer_count_liteethicmp_liteethicmpdepacketizer_next_value0;
reg top_icmp_rx_depacketizer_count_liteethicmp_liteethicmpdepacketizer_next_value_ce0;
reg top_icmp_rx_depacketizer_fsm_from_idle_liteethicmp_liteethicmpdepacketizer_next_value1;
reg top_icmp_rx_depacketizer_fsm_from_idle_liteethicmp_liteethicmpdepacketizer_next_value_ce1;
reg top_icmp_rx_depacketizer_data_copy_first_liteethicmp_liteethicmpdepacketizer_next_value2;
reg top_icmp_rx_depacketizer_data_copy_first_liteethicmp_liteethicmpdepacketizer_next_value_ce2;
reg [1:0] liteethicmp_fsm_state = 2'd2;
reg [1:0] liteethicmp_fsm_next_state;
reg [16:0] top_icmp_rx_count_liteethicmp_fsm_next_value;
reg top_icmp_rx_count_liteethicmp_fsm_next_value_ce;
reg liteethudp_state = 1'd1;
reg liteethudp_next_state;
reg [2:0] top_tx_packetizer_count_liteethudp_next_value;
reg top_tx_packetizer_count_liteethudp_next_value_ce;
reg [1:0] liteethudp_liteethudpdepacketizer_state = 2'd0;
reg [1:0] liteethudp_liteethudpdepacketizer_next_state;
reg [2:0] top_rx_depacketizer_count_liteethudp_liteethudpdepacketizer_next_value0;
reg top_rx_depacketizer_count_liteethudp_liteethudpdepacketizer_next_value_ce0;
reg top_rx_depacketizer_fsm_from_idle_liteethudp_liteethudpdepacketizer_next_value1;
reg top_rx_depacketizer_fsm_from_idle_liteethudp_liteethudpdepacketizer_next_value_ce1;
reg top_rx_depacketizer_data_copy_first_liteethudp_liteethudpdepacketizer_next_value2;
reg top_rx_depacketizer_data_copy_first_liteethudp_liteethudpdepacketizer_next_value_ce2;
reg [1:0] liteethudp_fsm_state = 2'd2;
reg [1:0] liteethudp_fsm_next_state;
reg [16:0] top_rx_count_liteethudp_fsm_next_value;
reg top_rx_count_liteethudp_fsm_next_value_ce;
reg liteethudp_sel0;
reg liteethudp_first = 1'd1;
wire liteethudp_last;
wire liteethudp_ongoing0;
reg liteethudp_ongoing1 = 1'd0;
reg liteethudp_sel1;
reg liteethudp_sel_ongoing = 1'd0;
reg liteethudp_sel_locked = 1'd0;
reg [3:0] state = 4'd0;
reg [3:0] next_state;
reg [7:0] next_value;
reg next_value_ce;
reg [31:0] top_server_remote_ip_next_value0;
reg top_server_remote_ip_next_value_ce0;
reg [15:0] top_server_remote_port_next_value1;
reg top_server_remote_port_next_value_ce1;
reg top_server_bad_next_value2;
reg top_server_bad_next_value_ce2;
reg [3:0] top_server_count_next_value3;
reg top_server_count_next_value_ce3;
reg [31:0] top_server_checked_next_value4;
reg top_server_checked_next_value_ce4;
reg [3:0] top_server_hidx_next_value5;
reg top_server_hidx_next_value_ce5;
reg [8:0] top_server_wordidx_next_value6;
reg top_server_wordidx_next_value_ce6;
reg top_server_ev_next_value7;
reg top_server_ev_next_value_ce7;
reg top_server_valid_next_value8;
reg top_server_valid_next_value_ce8;
reg [10:0] top_server_settle_next_value9;
reg top_server_settle_next_value_ce9;
reg [31:0] top_server_capture_id_next_value10;
reg top_server_capture_id_next_value_ce10;
reg [15:0] top_server_word_next_value11;
reg top_server_word_next_value_ce11;
wire [39:0] complexslicelowerer_slice_proxy;
wire [15:0] rhs_slice_proxy0;
wire [15:0] rhs_slice_proxy1;
wire [47:0] rhs_slice_proxy2;
wire [47:0] rhs_slice_proxy3;
wire [47:0] rhs_slice_proxy4;
wire [47:0] rhs_slice_proxy5;
wire [47:0] rhs_slice_proxy6;
wire [47:0] rhs_slice_proxy7;
wire [47:0] rhs_slice_proxy8;
wire [47:0] rhs_slice_proxy9;
wire [47:0] rhs_slice_proxy10;
wire [47:0] rhs_slice_proxy11;
wire [47:0] rhs_slice_proxy12;
wire [47:0] rhs_slice_proxy13;
wire [7:0] rhs_slice_proxy14;
wire [15:0] rhs_slice_proxy15;
wire [15:0] rhs_slice_proxy16;
wire [15:0] rhs_slice_proxy17;
wire [15:0] rhs_slice_proxy18;
wire [15:0] rhs_slice_proxy19;
wire [15:0] rhs_slice_proxy20;
wire [7:0] rhs_slice_proxy21;
wire [31:0] rhs_slice_proxy22;
wire [31:0] rhs_slice_proxy23;
wire [31:0] rhs_slice_proxy24;
wire [31:0] rhs_slice_proxy25;
wire [47:0] rhs_slice_proxy26;
wire [47:0] rhs_slice_proxy27;
wire [47:0] rhs_slice_proxy28;
wire [47:0] rhs_slice_proxy29;
wire [47:0] rhs_slice_proxy30;
wire [47:0] rhs_slice_proxy31;
wire [31:0] rhs_slice_proxy32;
wire [31:0] rhs_slice_proxy33;
wire [31:0] rhs_slice_proxy34;
wire [31:0] rhs_slice_proxy35;
wire [47:0] rhs_slice_proxy36;
wire [47:0] rhs_slice_proxy37;
wire [47:0] rhs_slice_proxy38;
wire [47:0] rhs_slice_proxy39;
wire [47:0] rhs_slice_proxy40;
wire [47:0] rhs_slice_proxy41;
wire [15:0] rhs_slice_proxy42;
wire [15:0] rhs_slice_proxy43;
wire [15:0] rhs_slice_proxy44;
wire [15:0] rhs_slice_proxy45;
wire [15:0] rhs_slice_proxy46;
wire [15:0] rhs_slice_proxy47;
wire [3:0] rhs_slice_proxy48;
wire [7:0] rhs_slice_proxy49;
wire [31:0] rhs_slice_proxy50;
wire [31:0] rhs_slice_proxy51;
wire [31:0] rhs_slice_proxy52;
wire [31:0] rhs_slice_proxy53;
wire [31:0] rhs_slice_proxy54;
wire [31:0] rhs_slice_proxy55;
wire [31:0] rhs_slice_proxy56;
wire [31:0] rhs_slice_proxy57;
wire [15:0] rhs_slice_proxy58;
wire [15:0] rhs_slice_proxy59;
wire [7:0] rhs_slice_proxy60;
wire [3:0] rhs_slice_proxy61;
wire [15:0] rhs_slice_proxy62;
wire [15:0] rhs_slice_proxy63;
wire [7:0] rhs_slice_proxy64;
wire [7:0] rhs_slice_proxy65;
wire [31:0] rhs_slice_proxy66;
wire [31:0] rhs_slice_proxy67;
wire [31:0] rhs_slice_proxy68;
wire [31:0] rhs_slice_proxy69;
wire [15:0] rhs_slice_proxy70;
wire [15:0] rhs_slice_proxy71;
wire [15:0] rhs_slice_proxy72;
wire [15:0] rhs_slice_proxy73;
wire [15:0] rhs_slice_proxy74;
wire [15:0] rhs_slice_proxy75;
wire [15:0] rhs_slice_proxy76;
wire [15:0] rhs_slice_proxy77;
reg [7:0] comb_rhs_self;
reg [15:0] comb_basiclowerer_self;
reg [2:0] sync_t_self0;
reg [2:0] sync_t_self1;
reg [2:0] sync_f_self;
reg [5:0] sync_rhs_self0;
reg sync_rhs_self1;
reg sync_rhs_self2;
reg [3:0] sync_rhs_self3;
reg sync_rhs_self4;
reg sync_rhs_self5;
reg [7:0] sync_lhs_self = 8'd0;
wire xilinxasyncresetsynchronizerimpl0_async_reset;
wire xilinxasyncresetsynchronizerimpl0_rst_meta;
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
wire xilinxasyncresetsynchronizerimpl1_async_reset;
wire xilinxasyncresetsynchronizerimpl1_rst_meta;
wire xilinxasyncresetsynchronizerimpl2_async_reset;
wire xilinxasyncresetsynchronizerimpl2_rst_meta;
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
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl24_xilinxmultiregimpl240 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl24_xilinxmultiregimpl241 = 14'd0;
wire xilinxmultiregimpl24_i;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl25_xilinxmultiregimpl250 = 14'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [13:0] xilinxmultiregimpl25_xilinxmultiregimpl251 = 14'd0;
wire xilinxmultiregimpl25_i;
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

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign EVNT = top_server_ev;
assign top_server_link = top_link_up;
assign top_server_locked = top_locked;
assign top_report = {top_server_tx_count, top_server_checked, top_server_rx_count, 28'd0, top_locked, top_link_up, top_server_valid, top_server_ev, top_server_capture_id, top_tick, 32'd1347267841};
assign top_clkin_signal = sys_clk;
assign cap_clk = top_clkout_buf;
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
assign top_mac_packetizer_sink_valid = top_mac_crossbar_source_valid;
assign top_mac_crossbar_source_ready = top_mac_packetizer_sink_ready;
assign top_mac_packetizer_sink_first = top_mac_crossbar_source_first;
assign top_mac_packetizer_sink_last = top_mac_crossbar_source_last;
assign top_mac_packetizer_sink_payload_ethernet_type = top_mac_crossbar_source_payload_ethernet_type;
assign top_mac_packetizer_sink_payload_sender_mac = top_mac_crossbar_source_payload_sender_mac;
assign top_mac_packetizer_sink_payload_target_mac = top_mac_crossbar_source_payload_target_mac;
assign top_mac_packetizer_sink_payload_data = top_mac_crossbar_source_payload_data;
assign top_mac_packetizer_sink_payload_be = top_mac_crossbar_source_payload_be;
assign top_mac_packetizer_sink_payload_error = top_mac_crossbar_source_payload_error;
assign top_mac_core_sink_valid = top_mac_packetizer_source_valid;
assign top_mac_packetizer_source_ready = top_mac_core_sink_ready;
assign top_mac_core_sink_first = top_mac_packetizer_source_first;
assign top_mac_core_sink_last = top_mac_packetizer_source_last;
assign top_mac_core_sink_payload_data = top_mac_packetizer_source_payload_data;
assign top_mac_core_sink_payload_be = top_mac_packetizer_source_payload_be;
assign top_mac_core_sink_payload_error = top_mac_packetizer_source_payload_error;
assign top_mac_depacketizer_sink_valid = top_mac_core_source_valid;
assign top_mac_core_source_ready = top_mac_depacketizer_sink_ready;
assign top_mac_depacketizer_sink_first = top_mac_core_source_first;
assign top_mac_depacketizer_sink_last = top_mac_core_source_last;
assign top_mac_depacketizer_sink_payload_data = top_mac_core_source_payload_data;
assign top_mac_depacketizer_sink_payload_be = top_mac_core_source_payload_be;
assign top_mac_depacketizer_sink_payload_error = top_mac_core_source_payload_error;
assign top_mac_crossbar_sink_valid = top_mac_depacketizer_source_valid;
assign top_mac_depacketizer_source_ready = top_mac_crossbar_sink_ready;
assign top_mac_crossbar_sink_first = top_mac_depacketizer_source_first;
assign top_mac_crossbar_sink_last = top_mac_depacketizer_source_last;
assign top_mac_crossbar_sink_payload_ethernet_type = top_mac_depacketizer_source_payload_ethernet_type;
assign top_mac_crossbar_sink_payload_sender_mac = top_mac_depacketizer_source_payload_sender_mac;
assign top_mac_crossbar_sink_payload_target_mac = top_mac_depacketizer_source_payload_target_mac;
assign top_mac_crossbar_sink_payload_data = top_mac_depacketizer_source_payload_data;
assign top_mac_crossbar_sink_payload_be = top_mac_depacketizer_source_payload_be;
assign top_mac_crossbar_sink_payload_error = top_mac_depacketizer_source_payload_error;
assign top_mac_core_tx_padding_counter_done = (top_mac_core_tx_padding_counter >= 6'd59);

// synthesis translate_off
reg dummy_d_10;
// synthesis translate_on
always @(*) begin
	top_mac_core_tx_padding_sink_ready <= 1'd0;
	top_mac_core_tx_padding_source_valid <= 1'd0;
	top_mac_core_tx_padding_source_first <= 1'd0;
	top_mac_core_tx_padding_source_last <= 1'd0;
	top_mac_core_tx_padding_source_payload_data <= 8'd0;
	top_mac_core_tx_padding_source_payload_be <= 1'd0;
	top_mac_core_tx_padding_source_payload_error <= 1'd0;
	liteethmac_txdatapath_liteethmacpaddinginserter_next_state <= 1'd0;
	top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value <= 16'd0;
	top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value_ce <= 1'd0;
	liteethmac_txdatapath_liteethmacpaddinginserter_next_state <= liteethmac_txdatapath_liteethmacpaddinginserter_state;
	case (liteethmac_txdatapath_liteethmacpaddinginserter_state)
		1'd1: begin
			top_mac_core_tx_padding_source_valid <= 1'd1;
			top_mac_core_tx_padding_source_payload_be <= 1'd1;
			if (top_mac_core_tx_padding_counter_done) begin
				top_mac_core_tx_padding_source_payload_be <= 1'd1;
				top_mac_core_tx_padding_source_last <= 1'd1;
			end
			top_mac_core_tx_padding_source_payload_data <= 1'd0;
			if ((top_mac_core_tx_padding_source_valid & top_mac_core_tx_padding_source_ready)) begin
				top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value <= (top_mac_core_tx_padding_counter + 1'd1);
				top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value_ce <= 1'd1;
				if (top_mac_core_tx_padding_counter_done) begin
					top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value <= 1'd0;
					top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value_ce <= 1'd1;
					liteethmac_txdatapath_liteethmacpaddinginserter_next_state <= 1'd0;
				end
			end
		end
		default: begin
			top_mac_core_tx_padding_source_valid <= top_mac_core_tx_padding_sink_valid;
			top_mac_core_tx_padding_sink_ready <= top_mac_core_tx_padding_source_ready;
			top_mac_core_tx_padding_source_first <= top_mac_core_tx_padding_sink_first;
			top_mac_core_tx_padding_source_last <= top_mac_core_tx_padding_sink_last;
			top_mac_core_tx_padding_source_payload_data <= top_mac_core_tx_padding_sink_payload_data;
			top_mac_core_tx_padding_source_payload_be <= top_mac_core_tx_padding_sink_payload_be;
			top_mac_core_tx_padding_source_payload_error <= top_mac_core_tx_padding_sink_payload_error;
			if (top_mac_core_tx_padding_sink_last) begin
				if ((~top_mac_core_tx_padding_sink_payload_be)) begin
					top_mac_core_tx_padding_source_payload_data[7:0] <= 1'd0;
				end
				if ((~top_mac_core_tx_padding_counter_done)) begin
					top_mac_core_tx_padding_source_last <= 1'd0;
					top_mac_core_tx_padding_source_payload_be <= 1'd1;
				end else begin
					if (((top_mac_core_tx_padding_counter == 6'd59) & (top_mac_core_tx_padding_sink_payload_be < 1'd1))) begin
						top_mac_core_tx_padding_source_payload_be <= 1'd1;
					end
				end
			end
			if ((top_mac_core_tx_padding_source_valid & top_mac_core_tx_padding_source_ready)) begin
				top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value <= (top_mac_core_tx_padding_counter + 1'd1);
				top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value_ce <= 1'd1;
				if (top_mac_core_tx_padding_sink_last) begin
					if ((~top_mac_core_tx_padding_counter_done)) begin
						liteethmac_txdatapath_liteethmacpaddinginserter_next_state <= 1'd1;
					end else begin
						top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value <= 1'd0;
						top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value_ce <= 1'd1;
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_10 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_tx_crc_data0 = top_mac_core_tx_crc_sink_payload_data;
assign top_mac_core_tx_crc_be1 = top_mac_core_tx_crc_sink_payload_be;
assign top_mac_core_tx_crc_cnt_done = (top_mac_core_tx_crc_cnt == 1'd0);
assign top_mac_core_tx_crc_sink_valid = top_mac_core_tx_crc_source_source_valid;
assign top_mac_core_tx_crc_source_source_ready = top_mac_core_tx_crc_sink_ready;
assign top_mac_core_tx_crc_sink_first = top_mac_core_tx_crc_source_source_first;
assign top_mac_core_tx_crc_sink_last = top_mac_core_tx_crc_source_source_last;
assign top_mac_core_tx_crc_sink_payload_data = top_mac_core_tx_crc_source_source_payload_data;
assign top_mac_core_tx_crc_sink_payload_be = top_mac_core_tx_crc_source_source_payload_be;
assign top_mac_core_tx_crc_sink_payload_error = top_mac_core_tx_crc_source_source_payload_error;
assign top_mac_core_tx_crc_data1 = top_mac_core_tx_crc_data0;
assign top_mac_core_tx_crc_crc_prev = top_mac_core_tx_crc_reg;

// synthesis translate_off
reg dummy_d_11;
// synthesis translate_on
always @(*) begin
	top_mac_core_tx_crc_value <= 32'd0;
	top_mac_core_tx_crc_error <= 1'd0;
	if (top_mac_core_tx_crc_be1) begin
		top_mac_core_tx_crc_value <= ({top_mac_core_tx_crc_crc_next[0], top_mac_core_tx_crc_crc_next[1], top_mac_core_tx_crc_crc_next[2], top_mac_core_tx_crc_crc_next[3], top_mac_core_tx_crc_crc_next[4], top_mac_core_tx_crc_crc_next[5], top_mac_core_tx_crc_crc_next[6], top_mac_core_tx_crc_crc_next[7], top_mac_core_tx_crc_crc_next[8], top_mac_core_tx_crc_crc_next[9], top_mac_core_tx_crc_crc_next[10], top_mac_core_tx_crc_crc_next[11], top_mac_core_tx_crc_crc_next[12], top_mac_core_tx_crc_crc_next[13], top_mac_core_tx_crc_crc_next[14], top_mac_core_tx_crc_crc_next[15], top_mac_core_tx_crc_crc_next[16], top_mac_core_tx_crc_crc_next[17], top_mac_core_tx_crc_crc_next[18], top_mac_core_tx_crc_crc_next[19], top_mac_core_tx_crc_crc_next[20], top_mac_core_tx_crc_crc_next[21], top_mac_core_tx_crc_crc_next[22], top_mac_core_tx_crc_crc_next[23], top_mac_core_tx_crc_crc_next[24], top_mac_core_tx_crc_crc_next[25], top_mac_core_tx_crc_crc_next[26], top_mac_core_tx_crc_crc_next[27], top_mac_core_tx_crc_crc_next[28], top_mac_core_tx_crc_crc_next[29], top_mac_core_tx_crc_crc_next[30], top_mac_core_tx_crc_crc_next[31]} ^ 32'd4294967295);
		top_mac_core_tx_crc_error <= (top_mac_core_tx_crc_crc_next != 32'd3338984827);
	end
// synthesis translate_off
	dummy_d_11 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_12;
// synthesis translate_on
always @(*) begin
	top_mac_core_tx_crc_crc_next <= 32'd0;
	top_mac_core_tx_crc_crc_next[0] <= (((top_mac_core_tx_crc_crc_prev[24] ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[1] <= (((((((top_mac_core_tx_crc_crc_prev[25] ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_data1[6]) ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[2] <= (((((((((top_mac_core_tx_crc_crc_prev[26] ^ top_mac_core_tx_crc_data1[5]) ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_data1[6]) ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[3] <= (((((((top_mac_core_tx_crc_crc_prev[27] ^ top_mac_core_tx_crc_data1[4]) ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]) ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_data1[6]);
	top_mac_core_tx_crc_crc_next[4] <= (((((((((top_mac_core_tx_crc_crc_prev[28] ^ top_mac_core_tx_crc_data1[3]) ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]) ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]) ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[5] <= (((((((((((((top_mac_core_tx_crc_crc_prev[29] ^ top_mac_core_tx_crc_data1[2]) ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]) ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]) ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_data1[6]) ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[6] <= (((((((((((top_mac_core_tx_crc_crc_prev[30] ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]) ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]) ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]) ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_data1[6]);
	top_mac_core_tx_crc_crc_next[7] <= (((((((((top_mac_core_tx_crc_crc_prev[31] ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]) ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]) ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]) ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[8] <= ((((((((top_mac_core_tx_crc_crc_prev[0] ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]) ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]) ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_data1[6]) ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[9] <= ((((((((top_mac_core_tx_crc_crc_prev[1] ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]) ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]) ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]) ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_data1[6]);
	top_mac_core_tx_crc_crc_next[10] <= ((((((((top_mac_core_tx_crc_crc_prev[2] ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]) ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]) ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]) ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[11] <= ((((((((top_mac_core_tx_crc_crc_prev[3] ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]) ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]) ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_data1[6]) ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[12] <= ((((((((((((top_mac_core_tx_crc_crc_prev[4] ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]) ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]) ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]) ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_data1[6]) ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[13] <= ((((((((((((top_mac_core_tx_crc_crc_prev[5] ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]) ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]) ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]) ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_data1[6]);
	top_mac_core_tx_crc_crc_next[14] <= ((((((((((top_mac_core_tx_crc_crc_prev[6] ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]) ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]) ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]);
	top_mac_core_tx_crc_crc_next[15] <= ((((((((top_mac_core_tx_crc_crc_prev[7] ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]) ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]) ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]);
	top_mac_core_tx_crc_crc_next[16] <= ((((((top_mac_core_tx_crc_crc_prev[8] ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]) ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]) ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[17] <= ((((((top_mac_core_tx_crc_crc_prev[9] ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]) ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_data1[6]);
	top_mac_core_tx_crc_crc_next[18] <= ((((((top_mac_core_tx_crc_crc_prev[10] ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]);
	top_mac_core_tx_crc_crc_next[19] <= ((((top_mac_core_tx_crc_crc_prev[11] ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]);
	top_mac_core_tx_crc_crc_next[20] <= ((top_mac_core_tx_crc_crc_prev[12] ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]);
	top_mac_core_tx_crc_crc_next[21] <= ((top_mac_core_tx_crc_crc_prev[13] ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]);
	top_mac_core_tx_crc_crc_next[22] <= ((top_mac_core_tx_crc_crc_prev[14] ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[23] <= ((((((top_mac_core_tx_crc_crc_prev[15] ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_data1[6]) ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[24] <= ((((((top_mac_core_tx_crc_crc_prev[16] ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]) ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_data1[6]);
	top_mac_core_tx_crc_crc_next[25] <= ((((top_mac_core_tx_crc_crc_prev[17] ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]) ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]);
	top_mac_core_tx_crc_crc_next[26] <= ((((((((top_mac_core_tx_crc_crc_prev[18] ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]) ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]) ^ top_mac_core_tx_crc_crc_prev[24]) ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_data1[7]);
	top_mac_core_tx_crc_crc_next[27] <= ((((((((top_mac_core_tx_crc_crc_prev[19] ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]) ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]) ^ top_mac_core_tx_crc_crc_prev[25]) ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_data1[6]);
	top_mac_core_tx_crc_crc_next[28] <= ((((((top_mac_core_tx_crc_crc_prev[20] ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]) ^ top_mac_core_tx_crc_crc_prev[26]) ^ top_mac_core_tx_crc_data1[5]);
	top_mac_core_tx_crc_crc_next[29] <= ((((((top_mac_core_tx_crc_crc_prev[21] ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_crc_prev[30]) ^ top_mac_core_tx_crc_data1[1]) ^ top_mac_core_tx_crc_crc_prev[27]) ^ top_mac_core_tx_crc_data1[4]);
	top_mac_core_tx_crc_crc_next[30] <= ((((top_mac_core_tx_crc_crc_prev[22] ^ top_mac_core_tx_crc_crc_prev[31]) ^ top_mac_core_tx_crc_data1[0]) ^ top_mac_core_tx_crc_crc_prev[28]) ^ top_mac_core_tx_crc_data1[3]);
	top_mac_core_tx_crc_crc_next[31] <= ((top_mac_core_tx_crc_crc_prev[23] ^ top_mac_core_tx_crc_crc_prev[29]) ^ top_mac_core_tx_crc_data1[2]);
// synthesis translate_off
	dummy_d_12 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_13;
// synthesis translate_on
always @(*) begin
	top_mac_core_tx_crc_sink_ready <= 1'd0;
	top_mac_core_tx_crc_source_valid <= 1'd0;
	top_mac_core_tx_crc_source_first <= 1'd0;
	top_mac_core_tx_crc_source_last <= 1'd0;
	top_mac_core_tx_crc_source_payload_data <= 8'd0;
	top_mac_core_tx_crc_source_payload_be <= 1'd0;
	top_mac_core_tx_crc_source_payload_error <= 1'd0;
	top_mac_core_tx_crc_ce <= 1'd0;
	top_mac_core_tx_crc_reset <= 1'd0;
	top_mac_core_tx_crc_is_ongoing0 <= 1'd0;
	top_mac_core_tx_crc_is_ongoing1 <= 1'd0;
	liteethmac_txdatapath_bufferizeendpoints_next_state <= 2'd0;
	top_mac_core_tx_crc_crc_packet_liteethmaccore_clockdomainsrenamer1_next_value0 <= 32'd0;
	top_mac_core_tx_crc_crc_packet_liteethmaccore_clockdomainsrenamer1_next_value_ce0 <= 1'd0;
	top_mac_core_tx_crc_be0_liteethmaccore_clockdomainsrenamer1_next_value1 <= 1'd0;
	top_mac_core_tx_crc_be0_liteethmaccore_clockdomainsrenamer1_next_value_ce1 <= 1'd0;
	liteethmac_txdatapath_bufferizeendpoints_next_state <= liteethmac_txdatapath_bufferizeendpoints_state;
	case (liteethmac_txdatapath_bufferizeendpoints_state)
		1'd1: begin
			top_mac_core_tx_crc_ce <= (top_mac_core_tx_crc_sink_valid & top_mac_core_tx_crc_source_ready);
			top_mac_core_tx_crc_source_valid <= top_mac_core_tx_crc_sink_valid;
			top_mac_core_tx_crc_sink_ready <= top_mac_core_tx_crc_source_ready;
			top_mac_core_tx_crc_source_first <= top_mac_core_tx_crc_sink_first;
			top_mac_core_tx_crc_source_last <= top_mac_core_tx_crc_sink_last;
			top_mac_core_tx_crc_source_payload_data <= top_mac_core_tx_crc_sink_payload_data;
			top_mac_core_tx_crc_source_payload_be <= top_mac_core_tx_crc_sink_payload_be;
			top_mac_core_tx_crc_source_payload_error <= top_mac_core_tx_crc_sink_payload_error;
			top_mac_core_tx_crc_source_last <= 1'd0;
			top_mac_core_tx_crc_source_payload_be <= 1'd1;
			if (top_mac_core_tx_crc_sink_last) begin
				if (top_mac_core_tx_crc_sink_payload_be) begin
					top_mac_core_tx_crc_source_payload_data <= complexslicelowerer_slice_proxy[7:0];
				end
				if ((1'd0 & (top_mac_core_tx_crc_sink_payload_be <= 4'd15))) begin
					top_mac_core_tx_crc_source_last <= 1'd1;
					top_mac_core_tx_crc_source_payload_be <= ((top_mac_core_tx_crc_sink_payload_be <<< 3'd4) | 4'd15);
				end
			end
			if (((top_mac_core_tx_crc_sink_valid & top_mac_core_tx_crc_sink_last) & top_mac_core_tx_crc_source_ready)) begin
				if ((1'd0 & (top_mac_core_tx_crc_sink_payload_be <= 4'd15))) begin
					liteethmac_txdatapath_bufferizeendpoints_next_state <= 1'd0;
				end else begin
					top_mac_core_tx_crc_crc_packet_liteethmaccore_clockdomainsrenamer1_next_value0 <= top_mac_core_tx_crc_value;
					top_mac_core_tx_crc_crc_packet_liteethmaccore_clockdomainsrenamer1_next_value_ce0 <= 1'd1;
					if (1'd0) begin
						top_mac_core_tx_crc_be0_liteethmaccore_clockdomainsrenamer1_next_value1 <= (top_mac_core_tx_crc_sink_payload_be >>> 3'd4);
						top_mac_core_tx_crc_be0_liteethmaccore_clockdomainsrenamer1_next_value_ce1 <= 1'd1;
					end else begin
						top_mac_core_tx_crc_be0_liteethmaccore_clockdomainsrenamer1_next_value1 <= top_mac_core_tx_crc_sink_payload_be;
						top_mac_core_tx_crc_be0_liteethmaccore_clockdomainsrenamer1_next_value_ce1 <= 1'd1;
					end
					liteethmac_txdatapath_bufferizeendpoints_next_state <= 2'd2;
				end
			end
		end
		2'd2: begin
			top_mac_core_tx_crc_source_valid <= 1'd1;
			top_mac_core_tx_crc_source_payload_be <= 1'd1;
			case (top_mac_core_tx_crc_cnt)
				1'd0: begin
					top_mac_core_tx_crc_source_payload_data <= top_mac_core_tx_crc_crc_packet[31:24];
				end
				1'd1: begin
					top_mac_core_tx_crc_source_payload_data <= top_mac_core_tx_crc_crc_packet[23:16];
				end
				2'd2: begin
					top_mac_core_tx_crc_source_payload_data <= top_mac_core_tx_crc_crc_packet[15:8];
				end
				default: begin
					top_mac_core_tx_crc_source_payload_data <= top_mac_core_tx_crc_crc_packet[7:0];
				end
			endcase
			if (top_mac_core_tx_crc_cnt_done) begin
				top_mac_core_tx_crc_source_last <= 1'd1;
				if (top_mac_core_tx_crc_source_ready) begin
					liteethmac_txdatapath_bufferizeendpoints_next_state <= 1'd0;
				end
			end
			top_mac_core_tx_crc_is_ongoing1 <= 1'd1;
		end
		default: begin
			top_mac_core_tx_crc_reset <= 1'd1;
			top_mac_core_tx_crc_sink_ready <= 1'd1;
			if (top_mac_core_tx_crc_sink_valid) begin
				top_mac_core_tx_crc_sink_ready <= 1'd0;
				liteethmac_txdatapath_bufferizeendpoints_next_state <= 1'd1;
			end
			top_mac_core_tx_crc_is_ongoing0 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_13 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_tx_crc_pipe_valid_sink_ready = ((~top_mac_core_tx_crc_pipe_valid_source_valid) | top_mac_core_tx_crc_pipe_valid_source_ready);
assign top_mac_core_tx_crc_pipe_valid_sink_valid = top_mac_core_tx_crc_sink_sink_valid;
assign top_mac_core_tx_crc_sink_sink_ready = top_mac_core_tx_crc_pipe_valid_sink_ready;
assign top_mac_core_tx_crc_pipe_valid_sink_first = top_mac_core_tx_crc_sink_sink_first;
assign top_mac_core_tx_crc_pipe_valid_sink_last = top_mac_core_tx_crc_sink_sink_last;
assign top_mac_core_tx_crc_pipe_valid_sink_payload_data = top_mac_core_tx_crc_sink_sink_payload_data;
assign top_mac_core_tx_crc_pipe_valid_sink_payload_be = top_mac_core_tx_crc_sink_sink_payload_be;
assign top_mac_core_tx_crc_pipe_valid_sink_payload_error = top_mac_core_tx_crc_sink_sink_payload_error;
assign top_mac_core_tx_crc_source_source_valid = top_mac_core_tx_crc_pipe_valid_source_valid;
assign top_mac_core_tx_crc_pipe_valid_source_ready = top_mac_core_tx_crc_source_source_ready;
assign top_mac_core_tx_crc_source_source_first = top_mac_core_tx_crc_pipe_valid_source_first;
assign top_mac_core_tx_crc_source_source_last = top_mac_core_tx_crc_pipe_valid_source_last;
assign top_mac_core_tx_crc_source_source_payload_data = top_mac_core_tx_crc_pipe_valid_source_payload_data;
assign top_mac_core_tx_crc_source_source_payload_be = top_mac_core_tx_crc_pipe_valid_source_payload_be;
assign top_mac_core_tx_crc_source_source_payload_error = top_mac_core_tx_crc_pipe_valid_source_payload_error;

// synthesis translate_off
reg dummy_d_14;
// synthesis translate_on
always @(*) begin
	top_mac_core_tx_preamble_sink_ready <= 1'd0;
	top_mac_core_tx_preamble_source_valid <= 1'd0;
	top_mac_core_tx_preamble_source_first <= 1'd0;
	top_mac_core_tx_preamble_source_last <= 1'd0;
	top_mac_core_tx_preamble_source_payload_data <= 8'd0;
	top_mac_core_tx_preamble_source_payload_be <= 1'd0;
	top_mac_core_tx_preamble_source_payload_error <= 1'd0;
	liteethmac_txdatapath_liteethmacpreambleinserter_next_state <= 2'd0;
	top_mac_core_tx_preamble_count_liteethmaccore_clockdomainsrenamer2_next_value <= 3'd0;
	top_mac_core_tx_preamble_count_liteethmaccore_clockdomainsrenamer2_next_value_ce <= 1'd0;
	top_mac_core_tx_preamble_source_payload_data <= top_mac_core_tx_preamble_sink_payload_data;
	top_mac_core_tx_preamble_source_payload_be <= top_mac_core_tx_preamble_sink_payload_be;
	liteethmac_txdatapath_liteethmacpreambleinserter_next_state <= liteethmac_txdatapath_liteethmacpreambleinserter_state;
	case (liteethmac_txdatapath_liteethmacpreambleinserter_state)
		1'd1: begin
			top_mac_core_tx_preamble_source_valid <= 1'd1;
			top_mac_core_tx_preamble_source_payload_be <= 1'd1;
			case (top_mac_core_tx_preamble_count)
				1'd0: begin
					top_mac_core_tx_preamble_source_payload_data <= top_mac_core_tx_preamble_preamble[7:0];
				end
				1'd1: begin
					top_mac_core_tx_preamble_source_payload_data <= top_mac_core_tx_preamble_preamble[15:8];
				end
				2'd2: begin
					top_mac_core_tx_preamble_source_payload_data <= top_mac_core_tx_preamble_preamble[23:16];
				end
				2'd3: begin
					top_mac_core_tx_preamble_source_payload_data <= top_mac_core_tx_preamble_preamble[31:24];
				end
				3'd4: begin
					top_mac_core_tx_preamble_source_payload_data <= top_mac_core_tx_preamble_preamble[39:32];
				end
				3'd5: begin
					top_mac_core_tx_preamble_source_payload_data <= top_mac_core_tx_preamble_preamble[47:40];
				end
				3'd6: begin
					top_mac_core_tx_preamble_source_payload_data <= top_mac_core_tx_preamble_preamble[55:48];
				end
				default: begin
					top_mac_core_tx_preamble_source_payload_data <= top_mac_core_tx_preamble_preamble[63:56];
				end
			endcase
			if (top_mac_core_tx_preamble_source_ready) begin
				if ((top_mac_core_tx_preamble_count == 3'd7)) begin
					liteethmac_txdatapath_liteethmacpreambleinserter_next_state <= 2'd2;
				end else begin
					top_mac_core_tx_preamble_count_liteethmaccore_clockdomainsrenamer2_next_value <= (top_mac_core_tx_preamble_count + 1'd1);
					top_mac_core_tx_preamble_count_liteethmaccore_clockdomainsrenamer2_next_value_ce <= 1'd1;
				end
			end
		end
		2'd2: begin
			top_mac_core_tx_preamble_source_valid <= top_mac_core_tx_preamble_sink_valid;
			top_mac_core_tx_preamble_sink_ready <= top_mac_core_tx_preamble_source_ready;
			top_mac_core_tx_preamble_source_first <= top_mac_core_tx_preamble_sink_first;
			top_mac_core_tx_preamble_source_last <= top_mac_core_tx_preamble_sink_last;
			top_mac_core_tx_preamble_source_payload_error <= top_mac_core_tx_preamble_sink_payload_error;
			if (((top_mac_core_tx_preamble_sink_valid & top_mac_core_tx_preamble_sink_last) & top_mac_core_tx_preamble_source_ready)) begin
				liteethmac_txdatapath_liteethmacpreambleinserter_next_state <= 1'd0;
			end
		end
		default: begin
			top_mac_core_tx_preamble_sink_ready <= 1'd1;
			top_mac_core_tx_preamble_count_liteethmaccore_clockdomainsrenamer2_next_value <= 1'd0;
			top_mac_core_tx_preamble_count_liteethmaccore_clockdomainsrenamer2_next_value_ce <= 1'd1;
			if (top_mac_core_tx_preamble_sink_valid) begin
				top_mac_core_tx_preamble_sink_ready <= 1'd0;
				liteethmac_txdatapath_liteethmacpreambleinserter_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_14 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_txdatapath_cdc_sink_valid = top_mac_core_txdatapath_sink_sink_valid;
assign top_mac_core_txdatapath_sink_sink_ready = top_mac_core_txdatapath_cdc_sink_ready;
assign top_mac_core_txdatapath_cdc_sink_first = top_mac_core_txdatapath_sink_sink_first;
assign top_mac_core_txdatapath_cdc_sink_last = top_mac_core_txdatapath_sink_sink_last;
assign top_mac_core_txdatapath_cdc_sink_payload_data = top_mac_core_txdatapath_sink_sink_payload_data;
assign top_mac_core_txdatapath_cdc_sink_payload_be = top_mac_core_txdatapath_sink_sink_payload_be;
assign top_mac_core_txdatapath_cdc_sink_payload_error = top_mac_core_txdatapath_sink_sink_payload_error;
assign top_mac_core_txdatapath_source_source_valid = top_mac_core_txdatapath_cdc_source_valid;
assign top_mac_core_txdatapath_cdc_source_ready = top_mac_core_txdatapath_source_source_ready;
assign top_mac_core_txdatapath_source_source_first = top_mac_core_txdatapath_cdc_source_first;
assign top_mac_core_txdatapath_source_source_last = top_mac_core_txdatapath_cdc_source_last;
assign top_mac_core_txdatapath_source_source_payload_data = top_mac_core_txdatapath_cdc_source_payload_data;
assign top_mac_core_txdatapath_source_source_payload_be = top_mac_core_txdatapath_cdc_source_payload_be;
assign top_mac_core_txdatapath_source_source_payload_error = top_mac_core_txdatapath_cdc_source_payload_error;
assign top_mac_core_txdatapath_cdc_asyncfifo_din = {top_mac_core_txdatapath_cdc_fifo_in_last, top_mac_core_txdatapath_cdc_fifo_in_first, top_mac_core_txdatapath_cdc_fifo_in_payload_error, top_mac_core_txdatapath_cdc_fifo_in_payload_be, top_mac_core_txdatapath_cdc_fifo_in_payload_data};
assign {top_mac_core_txdatapath_cdc_fifo_out_last, top_mac_core_txdatapath_cdc_fifo_out_first, top_mac_core_txdatapath_cdc_fifo_out_payload_error, top_mac_core_txdatapath_cdc_fifo_out_payload_be, top_mac_core_txdatapath_cdc_fifo_out_payload_data} = top_mac_core_txdatapath_cdc_dout;
assign top_mac_core_txdatapath_cdc_sink_ready = top_mac_core_txdatapath_cdc_asyncfifo_writable;
assign top_mac_core_txdatapath_cdc_asyncfifo_we = top_mac_core_txdatapath_cdc_sink_valid;
assign top_mac_core_txdatapath_cdc_fifo_in_first = top_mac_core_txdatapath_cdc_sink_first;
assign top_mac_core_txdatapath_cdc_fifo_in_last = top_mac_core_txdatapath_cdc_sink_last;
assign top_mac_core_txdatapath_cdc_fifo_in_payload_data = top_mac_core_txdatapath_cdc_sink_payload_data;
assign top_mac_core_txdatapath_cdc_fifo_in_payload_be = top_mac_core_txdatapath_cdc_sink_payload_be;
assign top_mac_core_txdatapath_cdc_fifo_in_payload_error = top_mac_core_txdatapath_cdc_sink_payload_error;
assign top_mac_core_txdatapath_cdc_source_valid = top_mac_core_txdatapath_cdc_readable;
assign top_mac_core_txdatapath_cdc_source_first = top_mac_core_txdatapath_cdc_fifo_out_first;
assign top_mac_core_txdatapath_cdc_source_last = top_mac_core_txdatapath_cdc_fifo_out_last;
assign top_mac_core_txdatapath_cdc_source_payload_data = top_mac_core_txdatapath_cdc_fifo_out_payload_data;
assign top_mac_core_txdatapath_cdc_source_payload_be = top_mac_core_txdatapath_cdc_fifo_out_payload_be;
assign top_mac_core_txdatapath_cdc_source_payload_error = top_mac_core_txdatapath_cdc_fifo_out_payload_error;
assign top_mac_core_txdatapath_cdc_re = top_mac_core_txdatapath_cdc_source_ready;
assign top_mac_core_txdatapath_cdc_asyncfifo_re = (top_mac_core_txdatapath_cdc_re | (~top_mac_core_txdatapath_cdc_readable));
assign top_mac_core_txdatapath_cdc_graycounter0_ce = (top_mac_core_txdatapath_cdc_asyncfifo_writable & top_mac_core_txdatapath_cdc_asyncfifo_we);
assign top_mac_core_txdatapath_cdc_graycounter1_ce = (top_mac_core_txdatapath_cdc_asyncfifo_readable & top_mac_core_txdatapath_cdc_asyncfifo_re);
assign top_mac_core_txdatapath_cdc_asyncfifo_writable = (((top_mac_core_txdatapath_cdc_graycounter0_q[5] == top_mac_core_txdatapath_cdc_consume_wdomain[5]) | (top_mac_core_txdatapath_cdc_graycounter0_q[4] == top_mac_core_txdatapath_cdc_consume_wdomain[4])) | (top_mac_core_txdatapath_cdc_graycounter0_q[3:0] != top_mac_core_txdatapath_cdc_consume_wdomain[3:0]));
assign top_mac_core_txdatapath_cdc_asyncfifo_readable = (top_mac_core_txdatapath_cdc_graycounter1_q != top_mac_core_txdatapath_cdc_produce_rdomain);
assign top_mac_core_txdatapath_cdc_wrport_adr = top_mac_core_txdatapath_cdc_graycounter0_q_binary[4:0];
assign top_mac_core_txdatapath_cdc_wrport_dat_w = top_mac_core_txdatapath_cdc_asyncfifo_din;
assign top_mac_core_txdatapath_cdc_wrport_we = top_mac_core_txdatapath_cdc_graycounter0_ce;
assign top_mac_core_txdatapath_cdc_rdport_adr = top_mac_core_txdatapath_cdc_graycounter1_q_next_binary[4:0];
assign top_mac_core_txdatapath_cdc_asyncfifo_dout = top_mac_core_txdatapath_cdc_rdport_dat_r;

// synthesis translate_off
reg dummy_d_15;
// synthesis translate_on
always @(*) begin
	top_mac_core_txdatapath_cdc_graycounter0_q_next_binary <= 6'd0;
	if (top_mac_core_txdatapath_cdc_graycounter0_ce) begin
		top_mac_core_txdatapath_cdc_graycounter0_q_next_binary <= (top_mac_core_txdatapath_cdc_graycounter0_q_binary + 1'd1);
	end else begin
		top_mac_core_txdatapath_cdc_graycounter0_q_next_binary <= top_mac_core_txdatapath_cdc_graycounter0_q_binary;
	end
// synthesis translate_off
	dummy_d_15 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_txdatapath_cdc_graycounter0_q_next = (top_mac_core_txdatapath_cdc_graycounter0_q_next_binary ^ top_mac_core_txdatapath_cdc_graycounter0_q_next_binary[5:1]);

// synthesis translate_off
reg dummy_d_16;
// synthesis translate_on
always @(*) begin
	top_mac_core_txdatapath_cdc_graycounter1_q_next_binary <= 6'd0;
	if (top_mac_core_txdatapath_cdc_graycounter1_ce) begin
		top_mac_core_txdatapath_cdc_graycounter1_q_next_binary <= (top_mac_core_txdatapath_cdc_graycounter1_q_binary + 1'd1);
	end else begin
		top_mac_core_txdatapath_cdc_graycounter1_q_next_binary <= top_mac_core_txdatapath_cdc_graycounter1_q_binary;
	end
// synthesis translate_off
	dummy_d_16 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_txdatapath_cdc_graycounter1_q_next = (top_mac_core_txdatapath_cdc_graycounter1_q_next_binary ^ top_mac_core_txdatapath_cdc_graycounter1_q_next_binary[5:1]);
assign top_mac_core_tx_packet_fifo_payload_fifo_sink_first = top_mac_core_tx_packet_fifo_sink_sink_first;
assign top_mac_core_tx_packet_fifo_payload_fifo_sink_last = top_mac_core_tx_packet_fifo_sink_sink_last;
assign top_mac_core_tx_packet_fifo_payload_fifo_sink_payload_data = top_mac_core_tx_packet_fifo_sink_sink_payload_data;
assign top_mac_core_tx_packet_fifo_payload_fifo_sink_payload_be = top_mac_core_tx_packet_fifo_sink_sink_payload_be;
assign top_mac_core_tx_packet_fifo_payload_fifo_sink_payload_error = top_mac_core_tx_packet_fifo_sink_sink_payload_error;
assign top_mac_core_tx_packet_fifo_param_fifo_sink_valid = ((top_mac_core_tx_packet_fifo_sink_sink_valid & top_mac_core_tx_packet_fifo_sink_sink_last) & top_mac_core_tx_packet_fifo_payload_fifo_sink_ready);
assign top_mac_core_tx_packet_fifo_payload_fifo_sink_valid = (top_mac_core_tx_packet_fifo_sink_sink_valid & top_mac_core_tx_packet_fifo_param_fifo_sink_ready);
assign top_mac_core_tx_packet_fifo_sink_sink_ready = (top_mac_core_tx_packet_fifo_param_fifo_sink_ready & top_mac_core_tx_packet_fifo_payload_fifo_sink_ready);
assign top_mac_core_tx_packet_fifo_source_source_valid = top_mac_core_tx_packet_fifo_param_fifo_source_valid;

// synthesis translate_off
reg dummy_d_17;
// synthesis translate_on
always @(*) begin
	top_mac_core_tx_packet_fifo_source_source_first <= 1'd0;
	top_mac_core_tx_packet_fifo_source_source_first <= top_mac_core_tx_packet_fifo_param_fifo_source_first;
	top_mac_core_tx_packet_fifo_source_source_first <= top_mac_core_tx_packet_fifo_payload_fifo_source_first;
// synthesis translate_off
	dummy_d_17 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_tx_packet_fifo_source_source_last = top_mac_core_tx_packet_fifo_payload_fifo_source_last;
assign top_mac_core_tx_packet_fifo_source_source_payload_data = top_mac_core_tx_packet_fifo_payload_fifo_source_payload_data;
assign top_mac_core_tx_packet_fifo_source_source_payload_be = top_mac_core_tx_packet_fifo_payload_fifo_source_payload_be;
assign top_mac_core_tx_packet_fifo_source_source_payload_error = top_mac_core_tx_packet_fifo_payload_fifo_source_payload_error;
assign top_mac_core_tx_packet_fifo_param_fifo_source_ready = ((top_mac_core_tx_packet_fifo_source_source_valid & top_mac_core_tx_packet_fifo_source_source_last) & top_mac_core_tx_packet_fifo_source_source_ready);
assign top_mac_core_tx_packet_fifo_payload_fifo_source_ready = (top_mac_core_tx_packet_fifo_source_source_valid & top_mac_core_tx_packet_fifo_source_source_ready);
assign top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_din = {top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_last, top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_first, top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_payload_error, top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_payload_be, top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_payload_data};
assign {top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_last, top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_first, top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_payload_error, top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_payload_be, top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_payload_data} = top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_dout;
assign top_mac_core_tx_packet_fifo_payload_fifo_sink_ready = top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_writable;
assign top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_we = top_mac_core_tx_packet_fifo_payload_fifo_sink_valid;
assign top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_first = top_mac_core_tx_packet_fifo_payload_fifo_sink_first;
assign top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_last = top_mac_core_tx_packet_fifo_payload_fifo_sink_last;
assign top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_payload_data = top_mac_core_tx_packet_fifo_payload_fifo_sink_payload_data;
assign top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_payload_be = top_mac_core_tx_packet_fifo_payload_fifo_sink_payload_be;
assign top_mac_core_tx_packet_fifo_payload_fifo_fifo_in_payload_error = top_mac_core_tx_packet_fifo_payload_fifo_sink_payload_error;
assign top_mac_core_tx_packet_fifo_payload_fifo_source_valid = top_mac_core_tx_packet_fifo_payload_fifo_readable;
assign top_mac_core_tx_packet_fifo_payload_fifo_source_first = top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_first;
assign top_mac_core_tx_packet_fifo_payload_fifo_source_last = top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_last;
assign top_mac_core_tx_packet_fifo_payload_fifo_source_payload_data = top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_payload_data;
assign top_mac_core_tx_packet_fifo_payload_fifo_source_payload_be = top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_payload_be;
assign top_mac_core_tx_packet_fifo_payload_fifo_source_payload_error = top_mac_core_tx_packet_fifo_payload_fifo_fifo_out_payload_error;
assign top_mac_core_tx_packet_fifo_payload_fifo_re = top_mac_core_tx_packet_fifo_payload_fifo_source_ready;
assign top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_re = (top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_readable & ((~top_mac_core_tx_packet_fifo_payload_fifo_readable) | top_mac_core_tx_packet_fifo_payload_fifo_re));
assign top_mac_core_tx_packet_fifo_payload_fifo_level1 = (top_mac_core_tx_packet_fifo_payload_fifo_level0 + top_mac_core_tx_packet_fifo_payload_fifo_readable);

// synthesis translate_off
reg dummy_d_18;
// synthesis translate_on
always @(*) begin
	top_mac_core_tx_packet_fifo_payload_fifo_wrport_adr <= 11'd0;
	if (top_mac_core_tx_packet_fifo_payload_fifo_replace) begin
		top_mac_core_tx_packet_fifo_payload_fifo_wrport_adr <= (top_mac_core_tx_packet_fifo_payload_fifo_produce - 1'd1);
	end else begin
		top_mac_core_tx_packet_fifo_payload_fifo_wrport_adr <= top_mac_core_tx_packet_fifo_payload_fifo_produce;
	end
// synthesis translate_off
	dummy_d_18 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_tx_packet_fifo_payload_fifo_wrport_dat_w = top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_din;
assign top_mac_core_tx_packet_fifo_payload_fifo_wrport_we = (top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_we & (top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_writable | top_mac_core_tx_packet_fifo_payload_fifo_replace));
assign top_mac_core_tx_packet_fifo_payload_fifo_do_read = (top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_readable & top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_re);
assign top_mac_core_tx_packet_fifo_payload_fifo_rdport_adr = top_mac_core_tx_packet_fifo_payload_fifo_consume;
assign top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_dout = top_mac_core_tx_packet_fifo_payload_fifo_rdport_dat_r;
assign top_mac_core_tx_packet_fifo_payload_fifo_rdport_re = top_mac_core_tx_packet_fifo_payload_fifo_do_read;
assign top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_writable = (top_mac_core_tx_packet_fifo_payload_fifo_level0 != 12'd2048);
assign top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_readable = (top_mac_core_tx_packet_fifo_payload_fifo_level0 != 1'd0);
assign top_mac_core_tx_packet_fifo_param_fifo_syncfifo_din = {top_mac_core_tx_packet_fifo_param_fifo_fifo_in_last, top_mac_core_tx_packet_fifo_param_fifo_fifo_in_first, top_mac_core_tx_packet_fifo_param_fifo_fifo_in_param_dummy};
assign {top_mac_core_tx_packet_fifo_param_fifo_fifo_out_last, top_mac_core_tx_packet_fifo_param_fifo_fifo_out_first, top_mac_core_tx_packet_fifo_param_fifo_fifo_out_param_dummy} = top_mac_core_tx_packet_fifo_param_fifo_syncfifo_dout;
assign top_mac_core_tx_packet_fifo_param_fifo_sink_ready = top_mac_core_tx_packet_fifo_param_fifo_syncfifo_writable;
assign top_mac_core_tx_packet_fifo_param_fifo_syncfifo_we = top_mac_core_tx_packet_fifo_param_fifo_sink_valid;
assign top_mac_core_tx_packet_fifo_param_fifo_fifo_in_first = top_mac_core_tx_packet_fifo_param_fifo_sink_first;
assign top_mac_core_tx_packet_fifo_param_fifo_fifo_in_last = top_mac_core_tx_packet_fifo_param_fifo_sink_last;
assign top_mac_core_tx_packet_fifo_param_fifo_fifo_in_param_dummy = top_mac_core_tx_packet_fifo_param_fifo_sink_param_dummy;
assign top_mac_core_tx_packet_fifo_param_fifo_source_valid = top_mac_core_tx_packet_fifo_param_fifo_readable;
assign top_mac_core_tx_packet_fifo_param_fifo_source_first = top_mac_core_tx_packet_fifo_param_fifo_fifo_out_first;
assign top_mac_core_tx_packet_fifo_param_fifo_source_last = top_mac_core_tx_packet_fifo_param_fifo_fifo_out_last;
assign top_mac_core_tx_packet_fifo_param_fifo_source_param_dummy = top_mac_core_tx_packet_fifo_param_fifo_fifo_out_param_dummy;
assign top_mac_core_tx_packet_fifo_param_fifo_re = top_mac_core_tx_packet_fifo_param_fifo_source_ready;
assign top_mac_core_tx_packet_fifo_param_fifo_syncfifo_re = (top_mac_core_tx_packet_fifo_param_fifo_syncfifo_readable & ((~top_mac_core_tx_packet_fifo_param_fifo_readable) | top_mac_core_tx_packet_fifo_param_fifo_re));
assign top_mac_core_tx_packet_fifo_param_fifo_level1 = (top_mac_core_tx_packet_fifo_param_fifo_level0 + top_mac_core_tx_packet_fifo_param_fifo_readable);

// synthesis translate_off
reg dummy_d_19;
// synthesis translate_on
always @(*) begin
	top_mac_core_tx_packet_fifo_param_fifo_wrport_adr <= 3'd0;
	if (top_mac_core_tx_packet_fifo_param_fifo_replace) begin
		top_mac_core_tx_packet_fifo_param_fifo_wrport_adr <= (top_mac_core_tx_packet_fifo_param_fifo_produce - 1'd1);
	end else begin
		top_mac_core_tx_packet_fifo_param_fifo_wrport_adr <= top_mac_core_tx_packet_fifo_param_fifo_produce;
	end
// synthesis translate_off
	dummy_d_19 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_tx_packet_fifo_param_fifo_wrport_dat_w = top_mac_core_tx_packet_fifo_param_fifo_syncfifo_din;
assign top_mac_core_tx_packet_fifo_param_fifo_wrport_we = (top_mac_core_tx_packet_fifo_param_fifo_syncfifo_we & (top_mac_core_tx_packet_fifo_param_fifo_syncfifo_writable | top_mac_core_tx_packet_fifo_param_fifo_replace));
assign top_mac_core_tx_packet_fifo_param_fifo_do_read = (top_mac_core_tx_packet_fifo_param_fifo_syncfifo_readable & top_mac_core_tx_packet_fifo_param_fifo_syncfifo_re);
assign top_mac_core_tx_packet_fifo_param_fifo_rdport_adr = top_mac_core_tx_packet_fifo_param_fifo_consume;
assign top_mac_core_tx_packet_fifo_param_fifo_syncfifo_dout = top_mac_core_tx_packet_fifo_param_fifo_rdport_dat_r;
assign top_mac_core_tx_packet_fifo_param_fifo_rdport_re = top_mac_core_tx_packet_fifo_param_fifo_do_read;
assign top_mac_core_tx_packet_fifo_param_fifo_syncfifo_writable = (top_mac_core_tx_packet_fifo_param_fifo_level0 != 3'd5);
assign top_mac_core_tx_packet_fifo_param_fifo_syncfifo_readable = (top_mac_core_tx_packet_fifo_param_fifo_level0 != 1'd0);

// synthesis translate_off
reg dummy_d_20;
// synthesis translate_on
always @(*) begin
	top_mac_core_tx_gap_sink_ready <= 1'd0;
	top_mac_core_tx_gap_source_valid <= 1'd0;
	top_mac_core_tx_gap_source_first <= 1'd0;
	top_mac_core_tx_gap_source_last <= 1'd0;
	top_mac_core_tx_gap_source_payload_data <= 8'd0;
	top_mac_core_tx_gap_source_payload_be <= 1'd0;
	top_mac_core_tx_gap_source_payload_error <= 1'd0;
	liteethmac_txdatapath_liteethmacgap_next_state <= 1'd0;
	top_mac_core_tx_gap_counter_liteethmaccore_clockdomainsrenamer3_next_value <= 4'd0;
	top_mac_core_tx_gap_counter_liteethmaccore_clockdomainsrenamer3_next_value_ce <= 1'd0;
	liteethmac_txdatapath_liteethmacgap_next_state <= liteethmac_txdatapath_liteethmacgap_state;
	case (liteethmac_txdatapath_liteethmacgap_state)
		1'd1: begin
			top_mac_core_tx_gap_counter_liteethmaccore_clockdomainsrenamer3_next_value <= (top_mac_core_tx_gap_counter - 1'd1);
			top_mac_core_tx_gap_counter_liteethmaccore_clockdomainsrenamer3_next_value_ce <= 1'd1;
			if ((top_mac_core_tx_gap_counter == 1'd1)) begin
				liteethmac_txdatapath_liteethmacgap_next_state <= 1'd0;
			end
		end
		default: begin
			top_mac_core_tx_gap_source_valid <= top_mac_core_tx_gap_sink_valid;
			top_mac_core_tx_gap_sink_ready <= top_mac_core_tx_gap_source_ready;
			top_mac_core_tx_gap_source_first <= top_mac_core_tx_gap_sink_first;
			top_mac_core_tx_gap_source_last <= top_mac_core_tx_gap_sink_last;
			top_mac_core_tx_gap_source_payload_data <= top_mac_core_tx_gap_sink_payload_data;
			top_mac_core_tx_gap_source_payload_be <= top_mac_core_tx_gap_sink_payload_be;
			top_mac_core_tx_gap_source_payload_error <= top_mac_core_tx_gap_sink_payload_error;
			if (((top_mac_core_tx_gap_sink_valid & top_mac_core_tx_gap_sink_last) & top_mac_core_tx_gap_sink_ready)) begin
				top_mac_core_tx_gap_counter_liteethmaccore_clockdomainsrenamer3_next_value <= 4'd12;
				top_mac_core_tx_gap_counter_liteethmaccore_clockdomainsrenamer3_next_value_ce <= 1'd1;
				liteethmac_txdatapath_liteethmacgap_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_20 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_tx_padding_sink_valid = top_mac_core_sink_valid;
assign top_mac_core_sink_ready = top_mac_core_tx_padding_sink_ready;
assign top_mac_core_tx_padding_sink_first = top_mac_core_sink_first;
assign top_mac_core_tx_padding_sink_last = top_mac_core_sink_last;
assign top_mac_core_tx_padding_sink_payload_data = top_mac_core_sink_payload_data;
assign top_mac_core_tx_padding_sink_payload_be = top_mac_core_sink_payload_be;
assign top_mac_core_tx_padding_sink_payload_error = top_mac_core_sink_payload_error;
assign top_mac_core_tx_crc_sink_sink_valid = top_mac_core_tx_padding_source_valid;
assign top_mac_core_tx_padding_source_ready = top_mac_core_tx_crc_sink_sink_ready;
assign top_mac_core_tx_crc_sink_sink_first = top_mac_core_tx_padding_source_first;
assign top_mac_core_tx_crc_sink_sink_last = top_mac_core_tx_padding_source_last;
assign top_mac_core_tx_crc_sink_sink_payload_data = top_mac_core_tx_padding_source_payload_data;
assign top_mac_core_tx_crc_sink_sink_payload_be = top_mac_core_tx_padding_source_payload_be;
assign top_mac_core_tx_crc_sink_sink_payload_error = top_mac_core_tx_padding_source_payload_error;
assign top_mac_core_tx_preamble_sink_valid = top_mac_core_tx_crc_source_valid;
assign top_mac_core_tx_crc_source_ready = top_mac_core_tx_preamble_sink_ready;
assign top_mac_core_tx_preamble_sink_first = top_mac_core_tx_crc_source_first;
assign top_mac_core_tx_preamble_sink_last = top_mac_core_tx_crc_source_last;
assign top_mac_core_tx_preamble_sink_payload_data = top_mac_core_tx_crc_source_payload_data;
assign top_mac_core_tx_preamble_sink_payload_be = top_mac_core_tx_crc_source_payload_be;
assign top_mac_core_tx_preamble_sink_payload_error = top_mac_core_tx_crc_source_payload_error;
assign top_mac_core_txdatapath_sink_sink_valid = top_mac_core_tx_preamble_source_valid;
assign top_mac_core_tx_preamble_source_ready = top_mac_core_txdatapath_sink_sink_ready;
assign top_mac_core_txdatapath_sink_sink_first = top_mac_core_tx_preamble_source_first;
assign top_mac_core_txdatapath_sink_sink_last = top_mac_core_tx_preamble_source_last;
assign top_mac_core_txdatapath_sink_sink_payload_data = top_mac_core_tx_preamble_source_payload_data;
assign top_mac_core_txdatapath_sink_sink_payload_be = top_mac_core_tx_preamble_source_payload_be;
assign top_mac_core_txdatapath_sink_sink_payload_error = top_mac_core_tx_preamble_source_payload_error;
assign top_mac_core_tx_packet_fifo_sink_sink_valid = top_mac_core_txdatapath_source_source_valid;
assign top_mac_core_txdatapath_source_source_ready = top_mac_core_tx_packet_fifo_sink_sink_ready;
assign top_mac_core_tx_packet_fifo_sink_sink_first = top_mac_core_txdatapath_source_source_first;
assign top_mac_core_tx_packet_fifo_sink_sink_last = top_mac_core_txdatapath_source_source_last;
assign top_mac_core_tx_packet_fifo_sink_sink_payload_data = top_mac_core_txdatapath_source_source_payload_data;
assign top_mac_core_tx_packet_fifo_sink_sink_payload_be = top_mac_core_txdatapath_source_source_payload_be;
assign top_mac_core_tx_packet_fifo_sink_sink_payload_error = top_mac_core_txdatapath_source_source_payload_error;
assign top_mac_core_tx_gap_sink_valid = top_mac_core_tx_packet_fifo_source_source_valid;
assign top_mac_core_tx_packet_fifo_source_source_ready = top_mac_core_tx_gap_sink_ready;
assign top_mac_core_tx_gap_sink_first = top_mac_core_tx_packet_fifo_source_source_first;
assign top_mac_core_tx_gap_sink_last = top_mac_core_tx_packet_fifo_source_source_last;
assign top_mac_core_tx_gap_sink_payload_data = top_mac_core_tx_packet_fifo_source_source_payload_data;
assign top_mac_core_tx_gap_sink_payload_be = top_mac_core_tx_packet_fifo_source_source_payload_be;
assign top_mac_core_tx_gap_sink_payload_error = top_mac_core_tx_packet_fifo_source_source_payload_error;
assign top_sink_sink_valid = top_mac_core_tx_gap_source_valid;
assign top_mac_core_tx_gap_source_ready = top_sink_sink_ready;
assign top_sink_sink_first = top_mac_core_tx_gap_source_first;
assign top_sink_sink_last = top_mac_core_tx_gap_source_last;
assign top_sink_sink_payload_data = top_mac_core_tx_gap_source_payload_data;
assign top_sink_sink_payload_be = top_mac_core_tx_gap_source_payload_be;
assign top_sink_sink_payload_error = top_mac_core_tx_gap_source_payload_error;
assign top_mac_core_i = top_mac_core_rx_packet_fifo_drop;
assign top_mac_core_pulsesynchronizer0_i = top_mac_core_rx_preamble_error;
assign top_mac_core_pulsesynchronizer1_i = top_mac_core_liteethmaccrc32checker_error;
assign top_mac_core_rx_packet_fifo_used = (top_mac_core_rx_packet_fifo_wr_ptr - (top_mac_core_rx_packet_fifo_rd_ptr - top_mac_core_rx_packet_fifo_out_valid));
assign top_mac_core_rx_packet_fifo_full = (top_mac_core_rx_packet_fifo_used == 12'd2048);
assign top_mac_core_rx_packet_fifo_sink_sink_ready = 1'd1;
assign top_mac_core_rx_packet_fifo_wr_port_adr = top_mac_core_rx_packet_fifo_wr_ptr[10:0];
assign top_mac_core_rx_packet_fifo_wr_port_dat_w = {top_mac_core_rx_packet_fifo_sink_sink_last, top_mac_core_rx_packet_fifo_sink_sink_first, {top_mac_core_rx_packet_fifo_sink_sink_payload_error, top_mac_core_rx_packet_fifo_sink_sink_payload_be, top_mac_core_rx_packet_fifo_sink_sink_payload_data}};
assign top_mac_core_rx_packet_fifo_wr_port_we = ((top_mac_core_rx_packet_fifo_sink_sink_valid & (~top_mac_core_rx_packet_fifo_overflow)) & (~top_mac_core_rx_packet_fifo_full));
assign top_mac_core_rx_packet_fifo_commit = ((((((top_mac_core_rx_packet_fifo_sink_sink_valid & top_mac_core_rx_packet_fifo_sink_sink_last) & (~top_mac_core_rx_packet_fifo_overflow)) & (~top_mac_core_rx_packet_fifo_full)) & (~top_mac_core_rx_packet_fifo_invalid)) & (~top_mac_core_rx_packet_fifo_discard)) & top_mac_core_rx_packet_fifo_param_fifo_sink_ready);
assign top_mac_core_rx_packet_fifo_param_fifo_sink_valid = top_mac_core_rx_packet_fifo_commit;
assign top_mac_core_rx_packet_fifo_param_fifo_sink_last = 1'd1;
assign top_mac_core_rx_packet_fifo_drop = ((top_mac_core_rx_packet_fifo_sink_sink_valid & top_mac_core_rx_packet_fifo_sink_sink_last) & (~top_mac_core_rx_packet_fifo_commit));
assign top_mac_core_rx_packet_fifo_fetch = ((top_mac_core_rx_packet_fifo_rd_ptr != top_mac_core_rx_packet_fifo_commit_ptr) & ((~top_mac_core_rx_packet_fifo_out_valid) | (top_mac_core_rx_packet_fifo_source_source_valid & top_mac_core_rx_packet_fifo_source_source_ready)));
assign top_mac_core_rx_packet_fifo_rd_port_adr = top_mac_core_rx_packet_fifo_rd_ptr[10:0];
assign top_mac_core_rx_packet_fifo_rd_port_re = top_mac_core_rx_packet_fifo_fetch;
assign {top_mac_core_rx_packet_fifo_source_source_payload_error, top_mac_core_rx_packet_fifo_source_source_payload_be, top_mac_core_rx_packet_fifo_source_source_payload_data} = top_mac_core_rx_packet_fifo_rd_port_dat_r[9:0];
assign top_mac_core_rx_packet_fifo_source_source_first = top_mac_core_rx_packet_fifo_rd_port_dat_r[10];
assign top_mac_core_rx_packet_fifo_source_source_last = top_mac_core_rx_packet_fifo_rd_port_dat_r[11];
assign top_mac_core_rx_packet_fifo_source_source_valid = (top_mac_core_rx_packet_fifo_out_valid & top_mac_core_rx_packet_fifo_param_fifo_source_valid);
assign top_mac_core_rx_packet_fifo_param_fifo_source_ready = ((top_mac_core_rx_packet_fifo_source_source_valid & top_mac_core_rx_packet_fifo_source_source_last) & top_mac_core_rx_packet_fifo_source_source_ready);
assign top_mac_core_rx_packet_fifo_param_fifo_syncfifo_din = {top_mac_core_rx_packet_fifo_param_fifo_fifo_in_last, top_mac_core_rx_packet_fifo_param_fifo_fifo_in_first, top_mac_core_rx_packet_fifo_param_fifo_fifo_in_param_dummy};
assign {top_mac_core_rx_packet_fifo_param_fifo_fifo_out_last, top_mac_core_rx_packet_fifo_param_fifo_fifo_out_first, top_mac_core_rx_packet_fifo_param_fifo_fifo_out_param_dummy} = top_mac_core_rx_packet_fifo_param_fifo_syncfifo_dout;
assign top_mac_core_rx_packet_fifo_param_fifo_sink_ready = top_mac_core_rx_packet_fifo_param_fifo_syncfifo_writable;
assign top_mac_core_rx_packet_fifo_param_fifo_syncfifo_we = top_mac_core_rx_packet_fifo_param_fifo_sink_valid;
assign top_mac_core_rx_packet_fifo_param_fifo_fifo_in_first = top_mac_core_rx_packet_fifo_param_fifo_sink_first;
assign top_mac_core_rx_packet_fifo_param_fifo_fifo_in_last = top_mac_core_rx_packet_fifo_param_fifo_sink_last;
assign top_mac_core_rx_packet_fifo_param_fifo_fifo_in_param_dummy = top_mac_core_rx_packet_fifo_param_fifo_sink_param_dummy;
assign top_mac_core_rx_packet_fifo_param_fifo_source_valid = top_mac_core_rx_packet_fifo_param_fifo_syncfifo_readable;
assign top_mac_core_rx_packet_fifo_param_fifo_source_first = top_mac_core_rx_packet_fifo_param_fifo_fifo_out_first;
assign top_mac_core_rx_packet_fifo_param_fifo_source_last = top_mac_core_rx_packet_fifo_param_fifo_fifo_out_last;
assign top_mac_core_rx_packet_fifo_param_fifo_source_param_dummy = top_mac_core_rx_packet_fifo_param_fifo_fifo_out_param_dummy;
assign top_mac_core_rx_packet_fifo_param_fifo_syncfifo_re = top_mac_core_rx_packet_fifo_param_fifo_source_ready;

// synthesis translate_off
reg dummy_d_21;
// synthesis translate_on
always @(*) begin
	top_mac_core_rx_packet_fifo_param_fifo_wrport_adr <= 2'd0;
	if (top_mac_core_rx_packet_fifo_param_fifo_replace) begin
		top_mac_core_rx_packet_fifo_param_fifo_wrport_adr <= (top_mac_core_rx_packet_fifo_param_fifo_produce - 1'd1);
	end else begin
		top_mac_core_rx_packet_fifo_param_fifo_wrport_adr <= top_mac_core_rx_packet_fifo_param_fifo_produce;
	end
// synthesis translate_off
	dummy_d_21 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_rx_packet_fifo_param_fifo_wrport_dat_w = top_mac_core_rx_packet_fifo_param_fifo_syncfifo_din;
assign top_mac_core_rx_packet_fifo_param_fifo_wrport_we = (top_mac_core_rx_packet_fifo_param_fifo_syncfifo_we & (top_mac_core_rx_packet_fifo_param_fifo_syncfifo_writable | top_mac_core_rx_packet_fifo_param_fifo_replace));
assign top_mac_core_rx_packet_fifo_param_fifo_do_read = (top_mac_core_rx_packet_fifo_param_fifo_syncfifo_readable & top_mac_core_rx_packet_fifo_param_fifo_syncfifo_re);
assign top_mac_core_rx_packet_fifo_param_fifo_rdport_adr = top_mac_core_rx_packet_fifo_param_fifo_consume;
assign top_mac_core_rx_packet_fifo_param_fifo_syncfifo_dout = top_mac_core_rx_packet_fifo_param_fifo_rdport_dat_r;
assign top_mac_core_rx_packet_fifo_param_fifo_syncfifo_writable = (top_mac_core_rx_packet_fifo_param_fifo_level != 3'd4);
assign top_mac_core_rx_packet_fifo_param_fifo_syncfifo_readable = (top_mac_core_rx_packet_fifo_param_fifo_level != 1'd0);
assign top_mac_core_o = (top_mac_core_toggle_o ^ top_mac_core_toggle_o_r);
assign top_mac_core_rx_cdc_cdc_sink_valid = top_mac_core_rx_cdc_sink_sink_valid;
assign top_mac_core_rx_cdc_sink_sink_ready = top_mac_core_rx_cdc_cdc_sink_ready;
assign top_mac_core_rx_cdc_cdc_sink_first = top_mac_core_rx_cdc_sink_sink_first;
assign top_mac_core_rx_cdc_cdc_sink_last = top_mac_core_rx_cdc_sink_sink_last;
assign top_mac_core_rx_cdc_cdc_sink_payload_data = top_mac_core_rx_cdc_sink_sink_payload_data;
assign top_mac_core_rx_cdc_cdc_sink_payload_be = top_mac_core_rx_cdc_sink_sink_payload_be;
assign top_mac_core_rx_cdc_cdc_sink_payload_error = top_mac_core_rx_cdc_sink_sink_payload_error;
assign top_mac_core_rx_cdc_source_source_valid = top_mac_core_rx_cdc_cdc_source_valid;
assign top_mac_core_rx_cdc_cdc_source_ready = top_mac_core_rx_cdc_source_source_ready;
assign top_mac_core_rx_cdc_source_source_first = top_mac_core_rx_cdc_cdc_source_first;
assign top_mac_core_rx_cdc_source_source_last = top_mac_core_rx_cdc_cdc_source_last;
assign top_mac_core_rx_cdc_source_source_payload_data = top_mac_core_rx_cdc_cdc_source_payload_data;
assign top_mac_core_rx_cdc_source_source_payload_be = top_mac_core_rx_cdc_cdc_source_payload_be;
assign top_mac_core_rx_cdc_source_source_payload_error = top_mac_core_rx_cdc_cdc_source_payload_error;
assign top_mac_core_rx_cdc_cdc_asyncfifo_din = {top_mac_core_rx_cdc_cdc_fifo_in_last, top_mac_core_rx_cdc_cdc_fifo_in_first, top_mac_core_rx_cdc_cdc_fifo_in_payload_error, top_mac_core_rx_cdc_cdc_fifo_in_payload_be, top_mac_core_rx_cdc_cdc_fifo_in_payload_data};
assign {top_mac_core_rx_cdc_cdc_fifo_out_last, top_mac_core_rx_cdc_cdc_fifo_out_first, top_mac_core_rx_cdc_cdc_fifo_out_payload_error, top_mac_core_rx_cdc_cdc_fifo_out_payload_be, top_mac_core_rx_cdc_cdc_fifo_out_payload_data} = top_mac_core_rx_cdc_cdc_dout;
assign top_mac_core_rx_cdc_cdc_sink_ready = top_mac_core_rx_cdc_cdc_asyncfifo_writable;
assign top_mac_core_rx_cdc_cdc_asyncfifo_we = top_mac_core_rx_cdc_cdc_sink_valid;
assign top_mac_core_rx_cdc_cdc_fifo_in_first = top_mac_core_rx_cdc_cdc_sink_first;
assign top_mac_core_rx_cdc_cdc_fifo_in_last = top_mac_core_rx_cdc_cdc_sink_last;
assign top_mac_core_rx_cdc_cdc_fifo_in_payload_data = top_mac_core_rx_cdc_cdc_sink_payload_data;
assign top_mac_core_rx_cdc_cdc_fifo_in_payload_be = top_mac_core_rx_cdc_cdc_sink_payload_be;
assign top_mac_core_rx_cdc_cdc_fifo_in_payload_error = top_mac_core_rx_cdc_cdc_sink_payload_error;
assign top_mac_core_rx_cdc_cdc_source_valid = top_mac_core_rx_cdc_cdc_readable;
assign top_mac_core_rx_cdc_cdc_source_first = top_mac_core_rx_cdc_cdc_fifo_out_first;
assign top_mac_core_rx_cdc_cdc_source_last = top_mac_core_rx_cdc_cdc_fifo_out_last;
assign top_mac_core_rx_cdc_cdc_source_payload_data = top_mac_core_rx_cdc_cdc_fifo_out_payload_data;
assign top_mac_core_rx_cdc_cdc_source_payload_be = top_mac_core_rx_cdc_cdc_fifo_out_payload_be;
assign top_mac_core_rx_cdc_cdc_source_payload_error = top_mac_core_rx_cdc_cdc_fifo_out_payload_error;
assign top_mac_core_rx_cdc_cdc_re = top_mac_core_rx_cdc_cdc_source_ready;
assign top_mac_core_rx_cdc_cdc_asyncfifo_re = (top_mac_core_rx_cdc_cdc_re | (~top_mac_core_rx_cdc_cdc_readable));
assign top_mac_core_rx_cdc_cdc_graycounter0_ce = (top_mac_core_rx_cdc_cdc_asyncfifo_writable & top_mac_core_rx_cdc_cdc_asyncfifo_we);
assign top_mac_core_rx_cdc_cdc_graycounter1_ce = (top_mac_core_rx_cdc_cdc_asyncfifo_readable & top_mac_core_rx_cdc_cdc_asyncfifo_re);
assign top_mac_core_rx_cdc_cdc_asyncfifo_writable = (((top_mac_core_rx_cdc_cdc_graycounter0_q[5] == top_mac_core_rx_cdc_cdc_consume_wdomain[5]) | (top_mac_core_rx_cdc_cdc_graycounter0_q[4] == top_mac_core_rx_cdc_cdc_consume_wdomain[4])) | (top_mac_core_rx_cdc_cdc_graycounter0_q[3:0] != top_mac_core_rx_cdc_cdc_consume_wdomain[3:0]));
assign top_mac_core_rx_cdc_cdc_asyncfifo_readable = (top_mac_core_rx_cdc_cdc_graycounter1_q != top_mac_core_rx_cdc_cdc_produce_rdomain);
assign top_mac_core_rx_cdc_cdc_wrport_adr = top_mac_core_rx_cdc_cdc_graycounter0_q_binary[4:0];
assign top_mac_core_rx_cdc_cdc_wrport_dat_w = top_mac_core_rx_cdc_cdc_asyncfifo_din;
assign top_mac_core_rx_cdc_cdc_wrport_we = top_mac_core_rx_cdc_cdc_graycounter0_ce;
assign top_mac_core_rx_cdc_cdc_rdport_adr = top_mac_core_rx_cdc_cdc_graycounter1_q_next_binary[4:0];
assign top_mac_core_rx_cdc_cdc_asyncfifo_dout = top_mac_core_rx_cdc_cdc_rdport_dat_r;

// synthesis translate_off
reg dummy_d_22;
// synthesis translate_on
always @(*) begin
	top_mac_core_rx_cdc_cdc_graycounter0_q_next_binary <= 6'd0;
	if (top_mac_core_rx_cdc_cdc_graycounter0_ce) begin
		top_mac_core_rx_cdc_cdc_graycounter0_q_next_binary <= (top_mac_core_rx_cdc_cdc_graycounter0_q_binary + 1'd1);
	end else begin
		top_mac_core_rx_cdc_cdc_graycounter0_q_next_binary <= top_mac_core_rx_cdc_cdc_graycounter0_q_binary;
	end
// synthesis translate_off
	dummy_d_22 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_rx_cdc_cdc_graycounter0_q_next = (top_mac_core_rx_cdc_cdc_graycounter0_q_next_binary ^ top_mac_core_rx_cdc_cdc_graycounter0_q_next_binary[5:1]);

// synthesis translate_off
reg dummy_d_23;
// synthesis translate_on
always @(*) begin
	top_mac_core_rx_cdc_cdc_graycounter1_q_next_binary <= 6'd0;
	if (top_mac_core_rx_cdc_cdc_graycounter1_ce) begin
		top_mac_core_rx_cdc_cdc_graycounter1_q_next_binary <= (top_mac_core_rx_cdc_cdc_graycounter1_q_binary + 1'd1);
	end else begin
		top_mac_core_rx_cdc_cdc_graycounter1_q_next_binary <= top_mac_core_rx_cdc_cdc_graycounter1_q_binary;
	end
// synthesis translate_off
	dummy_d_23 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_rx_cdc_cdc_graycounter1_q_next = (top_mac_core_rx_cdc_cdc_graycounter1_q_next_binary ^ top_mac_core_rx_cdc_cdc_graycounter1_q_next_binary[5:1]);
assign top_mac_core_rx_preamble_source_payload_data = top_mac_core_rx_preamble_sink_payload_data;
assign top_mac_core_rx_preamble_source_payload_be = top_mac_core_rx_preamble_sink_payload_be;

// synthesis translate_off
reg dummy_d_24;
// synthesis translate_on
always @(*) begin
	top_mac_core_rx_preamble_sink_ready <= 1'd0;
	top_mac_core_rx_preamble_source_valid <= 1'd0;
	top_mac_core_rx_preamble_source_first <= 1'd0;
	top_mac_core_rx_preamble_source_last <= 1'd0;
	top_mac_core_rx_preamble_source_payload_error <= 1'd0;
	top_mac_core_rx_preamble_error <= 1'd0;
	liteethmac_rxdatapath_liteethmacpreamblechecker_next_state <= 1'd0;
	liteethmac_rxdatapath_liteethmacpreamblechecker_next_state <= liteethmac_rxdatapath_liteethmacpreamblechecker_state;
	case (liteethmac_rxdatapath_liteethmacpreamblechecker_state)
		1'd1: begin
			top_mac_core_rx_preamble_source_valid <= top_mac_core_rx_preamble_sink_valid;
			top_mac_core_rx_preamble_sink_ready <= top_mac_core_rx_preamble_source_ready;
			top_mac_core_rx_preamble_source_first <= top_mac_core_rx_preamble_sink_first;
			top_mac_core_rx_preamble_source_last <= top_mac_core_rx_preamble_sink_last;
			top_mac_core_rx_preamble_source_payload_error <= top_mac_core_rx_preamble_sink_payload_error;
			if (((top_mac_core_rx_preamble_source_valid & top_mac_core_rx_preamble_source_last) & top_mac_core_rx_preamble_source_ready)) begin
				liteethmac_rxdatapath_liteethmacpreamblechecker_next_state <= 1'd0;
			end
		end
		default: begin
			top_mac_core_rx_preamble_sink_ready <= 1'd1;
			if (((top_mac_core_rx_preamble_sink_valid & (~top_mac_core_rx_preamble_sink_last)) & (top_mac_core_rx_preamble_sink_payload_data == top_mac_core_rx_preamble_preamble[63:56]))) begin
				liteethmac_rxdatapath_liteethmacpreamblechecker_next_state <= 1'd1;
			end
			if ((top_mac_core_rx_preamble_sink_valid & top_mac_core_rx_preamble_sink_last)) begin
				top_mac_core_rx_preamble_error <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_24 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_pulsesynchronizer0_o = (top_mac_core_pulsesynchronizer0_toggle_o ^ top_mac_core_pulsesynchronizer0_toggle_o_r);
assign top_mac_core_liteethmaccrc32checker_fifo_full = (top_mac_core_liteethmaccrc32checker_syncfifo_level == 3'd4);
assign top_mac_core_liteethmaccrc32checker_fifo_out = (top_mac_core_liteethmaccrc32checker_source_source_valid & top_mac_core_liteethmaccrc32checker_source_source_ready);
assign top_mac_core_liteethmaccrc32checker_syncfifo_sink_first = top_mac_core_liteethmaccrc32checker_sink_sink_first;
assign top_mac_core_liteethmaccrc32checker_syncfifo_sink_last = top_mac_core_liteethmaccrc32checker_sink_sink_last;
assign top_mac_core_liteethmaccrc32checker_syncfifo_sink_payload_data = top_mac_core_liteethmaccrc32checker_sink_sink_payload_data;
assign top_mac_core_liteethmaccrc32checker_syncfifo_sink_payload_be = top_mac_core_liteethmaccrc32checker_sink_sink_payload_be;
assign top_mac_core_liteethmaccrc32checker_syncfifo_sink_payload_error = top_mac_core_liteethmaccrc32checker_sink_sink_payload_error;

// synthesis translate_off
reg dummy_d_25;
// synthesis translate_on
always @(*) begin
	top_mac_core_liteethmaccrc32checker_syncfifo_sink_valid <= 1'd0;
	top_mac_core_liteethmaccrc32checker_syncfifo_sink_valid <= top_mac_core_liteethmaccrc32checker_sink_sink_valid;
	top_mac_core_liteethmaccrc32checker_syncfifo_sink_valid <= top_mac_core_liteethmaccrc32checker_fifo_in;
// synthesis translate_off
	dummy_d_25 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_26;
// synthesis translate_on
always @(*) begin
	top_mac_core_liteethmaccrc32checker_sink_sink_ready <= 1'd0;
	top_mac_core_liteethmaccrc32checker_sink_sink_ready <= top_mac_core_liteethmaccrc32checker_syncfifo_sink_ready;
	top_mac_core_liteethmaccrc32checker_sink_sink_ready <= top_mac_core_liteethmaccrc32checker_fifo_in;
// synthesis translate_off
	dummy_d_26 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_liteethmaccrc32checker_fifo_in = (((top_mac_core_liteethmaccrc32checker_sink_sink_valid & ((~top_mac_core_liteethmaccrc32checker_fifo_full) | top_mac_core_liteethmaccrc32checker_fifo_out)) & (~top_mac_core_liteethmaccrc32checker_is_ongoing0)) & (~top_mac_core_liteethmaccrc32checker_is_ongoing1));
assign top_mac_core_liteethmaccrc32checker_crc_data0 = top_mac_core_liteethmaccrc32checker_sink_sink_payload_data;
assign top_mac_core_liteethmaccrc32checker_crc_be = top_mac_core_liteethmaccrc32checker_sink_sink_payload_be;
assign top_mac_core_liteethmaccrc32checker_last_word_error = ((top_mac_core_liteethmaccrc32checker_crc_error | top_mac_core_liteethmaccrc32checker_packet_error) | ((top_mac_core_liteethmaccrc32checker_sink_sink_payload_error & top_mac_core_liteethmaccrc32checker_sink_sink_payload_be) != 1'd0));
assign top_mac_core_liteethmaccrc32checker_source_source_first = top_mac_core_liteethmaccrc32checker_syncfifo_source_first;
assign top_mac_core_liteethmaccrc32checker_source_source_payload_data = top_mac_core_liteethmaccrc32checker_syncfifo_source_payload_data;
assign top_mac_core_liteethmaccrc32checker_sink_sink_valid = top_mac_core_bufferizeendpoints_source_source_valid;
assign top_mac_core_bufferizeendpoints_source_source_ready = top_mac_core_liteethmaccrc32checker_sink_sink_ready;
assign top_mac_core_liteethmaccrc32checker_sink_sink_first = top_mac_core_bufferizeendpoints_source_source_first;
assign top_mac_core_liteethmaccrc32checker_sink_sink_last = top_mac_core_bufferizeendpoints_source_source_last;
assign top_mac_core_liteethmaccrc32checker_sink_sink_payload_data = top_mac_core_bufferizeendpoints_source_source_payload_data;
assign top_mac_core_liteethmaccrc32checker_sink_sink_payload_be = top_mac_core_bufferizeendpoints_source_source_payload_be;
assign top_mac_core_liteethmaccrc32checker_sink_sink_payload_error = top_mac_core_bufferizeendpoints_source_source_payload_error;
assign top_mac_core_liteethmaccrc32checker_crc_crc_prev = top_mac_core_liteethmaccrc32checker_crc_reg;

// synthesis translate_off
reg dummy_d_27;
// synthesis translate_on
always @(*) begin
	top_mac_core_liteethmaccrc32checker_crc_error <= 1'd0;
	top_mac_core_liteethmaccrc32checker_crc_data1 <= 8'd0;
	top_mac_core_liteethmaccrc32checker_crc_data1 <= top_mac_core_liteethmaccrc32checker_crc_data0;
	if (top_mac_core_liteethmaccrc32checker_crc_be) begin
		top_mac_core_liteethmaccrc32checker_crc_data1 <= (top_mac_core_liteethmaccrc32checker_crc_data0 & 8'd255);
		top_mac_core_liteethmaccrc32checker_crc_error <= (top_mac_core_liteethmaccrc32checker_crc_crc_next != 32'd3338984827);
	end
// synthesis translate_off
	dummy_d_27 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_28;
// synthesis translate_on
always @(*) begin
	top_mac_core_liteethmaccrc32checker_crc_crc_next <= 32'd0;
	top_mac_core_liteethmaccrc32checker_crc_crc_next[0] <= (((top_mac_core_liteethmaccrc32checker_crc_crc_prev[24] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[1] <= (((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[25] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[2] <= (((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[26] ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[3] <= (((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[27] ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[4] <= (((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[28] ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[5] <= (((((((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[29] ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[6] <= (((((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[30] ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[7] <= (((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[31] ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[8] <= ((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[0] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[9] <= ((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[1] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[10] <= ((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[2] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[11] <= ((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[3] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[12] <= ((((((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[4] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[13] <= ((((((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[5] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[14] <= ((((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[6] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[15] <= ((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[7] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[16] <= ((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[8] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[17] <= ((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[9] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[18] <= ((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[10] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[19] <= ((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[11] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[20] <= ((top_mac_core_liteethmaccrc32checker_crc_crc_prev[12] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[21] <= ((top_mac_core_liteethmaccrc32checker_crc_crc_prev[13] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[22] <= ((top_mac_core_liteethmaccrc32checker_crc_crc_prev[14] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[23] <= ((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[15] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[24] <= ((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[16] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[25] <= ((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[17] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[26] <= ((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[18] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[24]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[7]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[27] <= ((((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[19] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[25]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[6]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[28] <= ((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[20] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[26]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[5]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[29] <= ((((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[21] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[30]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[1]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[27]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[4]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[30] <= ((((top_mac_core_liteethmaccrc32checker_crc_crc_prev[22] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[31]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[0]) ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[28]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[3]);
	top_mac_core_liteethmaccrc32checker_crc_crc_next[31] <= ((top_mac_core_liteethmaccrc32checker_crc_crc_prev[23] ^ top_mac_core_liteethmaccrc32checker_crc_crc_prev[29]) ^ top_mac_core_liteethmaccrc32checker_crc_data1[2]);
// synthesis translate_off
	dummy_d_28 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_din = {top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_last, top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_first, top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_payload_error, top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_payload_be, top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_payload_data};
assign {top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_last, top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_first, top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_payload_error, top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_payload_be, top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_payload_data} = top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_dout;
assign top_mac_core_liteethmaccrc32checker_syncfifo_sink_ready = top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_writable;
assign top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_we = top_mac_core_liteethmaccrc32checker_syncfifo_sink_valid;
assign top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_first = top_mac_core_liteethmaccrc32checker_syncfifo_sink_first;
assign top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_last = top_mac_core_liteethmaccrc32checker_syncfifo_sink_last;
assign top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_payload_data = top_mac_core_liteethmaccrc32checker_syncfifo_sink_payload_data;
assign top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_payload_be = top_mac_core_liteethmaccrc32checker_syncfifo_sink_payload_be;
assign top_mac_core_liteethmaccrc32checker_syncfifo_fifo_in_payload_error = top_mac_core_liteethmaccrc32checker_syncfifo_sink_payload_error;
assign top_mac_core_liteethmaccrc32checker_syncfifo_source_valid = top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_readable;
assign top_mac_core_liteethmaccrc32checker_syncfifo_source_first = top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_first;
assign top_mac_core_liteethmaccrc32checker_syncfifo_source_last = top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_last;
assign top_mac_core_liteethmaccrc32checker_syncfifo_source_payload_data = top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_payload_data;
assign top_mac_core_liteethmaccrc32checker_syncfifo_source_payload_be = top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_payload_be;
assign top_mac_core_liteethmaccrc32checker_syncfifo_source_payload_error = top_mac_core_liteethmaccrc32checker_syncfifo_fifo_out_payload_error;
assign top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_re = top_mac_core_liteethmaccrc32checker_syncfifo_source_ready;

// synthesis translate_off
reg dummy_d_29;
// synthesis translate_on
always @(*) begin
	top_mac_core_liteethmaccrc32checker_syncfifo_wrport_adr <= 3'd0;
	if (top_mac_core_liteethmaccrc32checker_syncfifo_replace) begin
		top_mac_core_liteethmaccrc32checker_syncfifo_wrport_adr <= (top_mac_core_liteethmaccrc32checker_syncfifo_produce - 1'd1);
	end else begin
		top_mac_core_liteethmaccrc32checker_syncfifo_wrport_adr <= top_mac_core_liteethmaccrc32checker_syncfifo_produce;
	end
// synthesis translate_off
	dummy_d_29 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_liteethmaccrc32checker_syncfifo_wrport_dat_w = top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_din;
assign top_mac_core_liteethmaccrc32checker_syncfifo_wrport_we = (top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_we & (top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_writable | top_mac_core_liteethmaccrc32checker_syncfifo_replace));
assign top_mac_core_liteethmaccrc32checker_syncfifo_do_read = (top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_readable & top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_re);
assign top_mac_core_liteethmaccrc32checker_syncfifo_rdport_adr = top_mac_core_liteethmaccrc32checker_syncfifo_consume;
assign top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_dout = top_mac_core_liteethmaccrc32checker_syncfifo_rdport_dat_r;
assign top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_writable = (top_mac_core_liteethmaccrc32checker_syncfifo_level != 3'd5);
assign top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_readable = (top_mac_core_liteethmaccrc32checker_syncfifo_level != 1'd0);

// synthesis translate_off
reg dummy_d_30;
// synthesis translate_on
always @(*) begin
	top_mac_core_liteethmaccrc32checker_source_source_valid <= 1'd0;
	top_mac_core_liteethmaccrc32checker_source_source_last <= 1'd0;
	top_mac_core_liteethmaccrc32checker_source_source_payload_be <= 1'd0;
	top_mac_core_liteethmaccrc32checker_source_source_payload_error <= 1'd0;
	top_mac_core_liteethmaccrc32checker_error <= 1'd0;
	top_mac_core_liteethmaccrc32checker_crc_ce <= 1'd0;
	top_mac_core_liteethmaccrc32checker_crc_reset <= 1'd0;
	top_mac_core_liteethmaccrc32checker_syncfifo_source_ready <= 1'd0;
	top_mac_core_liteethmaccrc32checker_fifo_reset <= 1'd0;
	top_mac_core_liteethmaccrc32checker_is_ongoing0 <= 1'd0;
	top_mac_core_liteethmaccrc32checker_is_ongoing1 <= 1'd0;
	top_mac_core_liteethmaccrc32checker_is_ongoing2 <= 1'd0;
	liteethmac_rxdatapath_bufferizeendpoints_next_state <= 2'd0;
	top_mac_core_liteethmaccrc32checker_be_liteethmaccore_next_value0 <= 1'd0;
	top_mac_core_liteethmaccrc32checker_be_liteethmaccore_next_value_ce0 <= 1'd0;
	top_mac_core_liteethmaccrc32checker_last_error_liteethmaccore_next_value1 <= 1'd0;
	top_mac_core_liteethmaccrc32checker_last_error_liteethmaccore_next_value_ce1 <= 1'd0;
	top_mac_core_liteethmaccrc32checker_source_source_payload_error <= top_mac_core_liteethmaccrc32checker_syncfifo_source_payload_error;
	liteethmac_rxdatapath_bufferizeendpoints_next_state <= liteethmac_rxdatapath_bufferizeendpoints_state;
	case (liteethmac_rxdatapath_bufferizeendpoints_state)
		1'd1: begin
			top_mac_core_liteethmaccrc32checker_is_ongoing1 <= 1'd1;
			top_mac_core_liteethmaccrc32checker_source_source_valid <= top_mac_core_liteethmaccrc32checker_syncfifo_source_valid;
			top_mac_core_liteethmaccrc32checker_syncfifo_source_ready <= top_mac_core_liteethmaccrc32checker_source_source_ready;
			top_mac_core_liteethmaccrc32checker_source_source_last <= top_mac_core_liteethmaccrc32checker_syncfifo_source_last;
			top_mac_core_liteethmaccrc32checker_source_source_payload_error <= (top_mac_core_liteethmaccrc32checker_syncfifo_source_payload_error | {1{top_mac_core_liteethmaccrc32checker_last_error}});
			top_mac_core_liteethmaccrc32checker_source_source_payload_be <= top_mac_core_liteethmaccrc32checker_be;
			if ((top_mac_core_liteethmaccrc32checker_source_source_valid & top_mac_core_liteethmaccrc32checker_source_source_ready)) begin
				liteethmac_rxdatapath_bufferizeendpoints_next_state <= 1'd0;
			end
		end
		2'd2: begin
			if ((top_mac_core_liteethmaccrc32checker_sink_sink_valid & top_mac_core_liteethmaccrc32checker_sink_sink_ready)) begin
				top_mac_core_liteethmaccrc32checker_crc_ce <= 1'd1;
				liteethmac_rxdatapath_bufferizeendpoints_next_state <= 2'd3;
			end
		end
		2'd3: begin
			top_mac_core_liteethmaccrc32checker_syncfifo_source_ready <= top_mac_core_liteethmaccrc32checker_fifo_out;
			top_mac_core_liteethmaccrc32checker_source_source_valid <= (top_mac_core_liteethmaccrc32checker_sink_sink_valid & top_mac_core_liteethmaccrc32checker_fifo_full);
			top_mac_core_liteethmaccrc32checker_source_source_payload_be <= 1'd1;
			if (1'd1) begin
				top_mac_core_liteethmaccrc32checker_source_source_last <= top_mac_core_liteethmaccrc32checker_sink_sink_last;
				if (top_mac_core_liteethmaccrc32checker_sink_sink_last) begin
					top_mac_core_liteethmaccrc32checker_source_source_payload_be <= top_mac_core_liteethmaccrc32checker_sink_sink_payload_be;
				end
			end else begin
				if ((top_mac_core_liteethmaccrc32checker_sink_sink_payload_be <= 4'd15)) begin
					top_mac_core_liteethmaccrc32checker_source_source_last <= top_mac_core_liteethmaccrc32checker_sink_sink_last;
					top_mac_core_liteethmaccrc32checker_source_source_payload_be <= ((top_mac_core_liteethmaccrc32checker_sink_sink_payload_be <<< 3'd4) | 4'd15);
				end else begin
					top_mac_core_liteethmaccrc32checker_be_liteethmaccore_next_value0 <= (top_mac_core_liteethmaccrc32checker_sink_sink_payload_be >>> 3'd4);
					top_mac_core_liteethmaccrc32checker_be_liteethmaccore_next_value_ce0 <= 1'd1;
					top_mac_core_liteethmaccrc32checker_last_error_liteethmaccore_next_value1 <= top_mac_core_liteethmaccrc32checker_last_word_error;
					top_mac_core_liteethmaccrc32checker_last_error_liteethmaccore_next_value_ce1 <= 1'd1;
				end
			end
			top_mac_core_liteethmaccrc32checker_source_source_payload_error <= (top_mac_core_liteethmaccrc32checker_sink_sink_last ? {1{top_mac_core_liteethmaccrc32checker_last_word_error}} : top_mac_core_liteethmaccrc32checker_syncfifo_source_payload_error);
			top_mac_core_liteethmaccrc32checker_error <= ((top_mac_core_liteethmaccrc32checker_sink_sink_valid & top_mac_core_liteethmaccrc32checker_sink_sink_last) & top_mac_core_liteethmaccrc32checker_crc_error);
			if ((top_mac_core_liteethmaccrc32checker_sink_sink_valid & top_mac_core_liteethmaccrc32checker_sink_sink_ready)) begin
				top_mac_core_liteethmaccrc32checker_crc_ce <= 1'd1;
				if ((top_mac_core_liteethmaccrc32checker_sink_sink_last & (top_mac_core_liteethmaccrc32checker_sink_sink_payload_be > 4'd15))) begin
					liteethmac_rxdatapath_bufferizeendpoints_next_state <= 1'd1;
				end else begin
					if (top_mac_core_liteethmaccrc32checker_sink_sink_last) begin
						liteethmac_rxdatapath_bufferizeendpoints_next_state <= 1'd0;
					end
				end
			end
		end
		default: begin
			top_mac_core_liteethmaccrc32checker_is_ongoing0 <= 1'd1;
			top_mac_core_liteethmaccrc32checker_crc_reset <= 1'd1;
			top_mac_core_liteethmaccrc32checker_fifo_reset <= 1'd1;
			liteethmac_rxdatapath_bufferizeendpoints_next_state <= 2'd2;
			top_mac_core_liteethmaccrc32checker_is_ongoing2 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_30 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_bufferizeendpoints_pipe_valid_sink_ready = ((~top_mac_core_bufferizeendpoints_pipe_valid_source_valid) | top_mac_core_bufferizeendpoints_pipe_valid_source_ready);
assign top_mac_core_bufferizeendpoints_pipe_valid_sink_valid = top_mac_core_bufferizeendpoints_sink_sink_valid;
assign top_mac_core_bufferizeendpoints_sink_sink_ready = top_mac_core_bufferizeendpoints_pipe_valid_sink_ready;
assign top_mac_core_bufferizeendpoints_pipe_valid_sink_first = top_mac_core_bufferizeendpoints_sink_sink_first;
assign top_mac_core_bufferizeendpoints_pipe_valid_sink_last = top_mac_core_bufferizeendpoints_sink_sink_last;
assign top_mac_core_bufferizeendpoints_pipe_valid_sink_payload_data = top_mac_core_bufferizeendpoints_sink_sink_payload_data;
assign top_mac_core_bufferizeendpoints_pipe_valid_sink_payload_be = top_mac_core_bufferizeendpoints_sink_sink_payload_be;
assign top_mac_core_bufferizeendpoints_pipe_valid_sink_payload_error = top_mac_core_bufferizeendpoints_sink_sink_payload_error;
assign top_mac_core_bufferizeendpoints_source_source_valid = top_mac_core_bufferizeendpoints_pipe_valid_source_valid;
assign top_mac_core_bufferizeendpoints_pipe_valid_source_ready = top_mac_core_bufferizeendpoints_source_source_ready;
assign top_mac_core_bufferizeendpoints_source_source_first = top_mac_core_bufferizeendpoints_pipe_valid_source_first;
assign top_mac_core_bufferizeendpoints_source_source_last = top_mac_core_bufferizeendpoints_pipe_valid_source_last;
assign top_mac_core_bufferizeendpoints_source_source_payload_data = top_mac_core_bufferizeendpoints_pipe_valid_source_payload_data;
assign top_mac_core_bufferizeendpoints_source_source_payload_be = top_mac_core_bufferizeendpoints_pipe_valid_source_payload_be;
assign top_mac_core_bufferizeendpoints_source_source_payload_error = top_mac_core_bufferizeendpoints_pipe_valid_source_payload_error;
assign top_mac_core_pulsesynchronizer1_o = (top_mac_core_pulsesynchronizer1_toggle_o ^ top_mac_core_pulsesynchronizer1_toggle_o_r);
assign top_mac_core_rx_padding_length_inc = (1'd0 + top_mac_core_rx_padding_sink_payload_be);
assign top_mac_core_rx_padding_source_valid = top_mac_core_rx_padding_sink_valid;
assign top_mac_core_rx_padding_sink_ready = top_mac_core_rx_padding_source_ready;
assign top_mac_core_rx_padding_source_first = top_mac_core_rx_padding_sink_first;
assign top_mac_core_rx_padding_source_last = top_mac_core_rx_padding_sink_last;
assign top_mac_core_rx_padding_source_payload_data = top_mac_core_rx_padding_sink_payload_data;
assign top_mac_core_rx_padding_source_payload_be = top_mac_core_rx_padding_sink_payload_be;

// synthesis translate_off
reg dummy_d_31;
// synthesis translate_on
always @(*) begin
	top_mac_core_rx_padding_source_payload_error <= 1'd0;
	if (((top_mac_core_rx_padding_sink_valid & top_mac_core_rx_padding_sink_last) & ((top_mac_core_rx_padding_length + top_mac_core_rx_padding_length_inc) < 6'd60))) begin
		top_mac_core_rx_padding_source_payload_error <= {1{1'd1}};
	end else begin
		top_mac_core_rx_padding_source_payload_error <= top_mac_core_rx_padding_sink_payload_error;
	end
// synthesis translate_off
	dummy_d_31 <= dummy_s;
// synthesis translate_on
end
assign top_mac_core_rx_packet_fifo_sink_sink_valid = top_source_source_valid;
assign top_source_source_ready = top_mac_core_rx_packet_fifo_sink_sink_ready;
assign top_mac_core_rx_packet_fifo_sink_sink_first = top_source_source_first;
assign top_mac_core_rx_packet_fifo_sink_sink_last = top_source_source_last;
assign top_mac_core_rx_packet_fifo_sink_sink_payload_data = top_source_source_payload_data;
assign top_mac_core_rx_packet_fifo_sink_sink_payload_be = top_source_source_payload_be;
assign top_mac_core_rx_packet_fifo_sink_sink_payload_error = top_source_source_payload_error;
assign top_mac_core_rx_cdc_sink_sink_valid = top_mac_core_rx_packet_fifo_source_source_valid;
assign top_mac_core_rx_packet_fifo_source_source_ready = top_mac_core_rx_cdc_sink_sink_ready;
assign top_mac_core_rx_cdc_sink_sink_first = top_mac_core_rx_packet_fifo_source_source_first;
assign top_mac_core_rx_cdc_sink_sink_last = top_mac_core_rx_packet_fifo_source_source_last;
assign top_mac_core_rx_cdc_sink_sink_payload_data = top_mac_core_rx_packet_fifo_source_source_payload_data;
assign top_mac_core_rx_cdc_sink_sink_payload_be = top_mac_core_rx_packet_fifo_source_source_payload_be;
assign top_mac_core_rx_cdc_sink_sink_payload_error = top_mac_core_rx_packet_fifo_source_source_payload_error;
assign top_mac_core_rx_preamble_sink_valid = top_mac_core_rx_cdc_source_source_valid;
assign top_mac_core_rx_cdc_source_source_ready = top_mac_core_rx_preamble_sink_ready;
assign top_mac_core_rx_preamble_sink_first = top_mac_core_rx_cdc_source_source_first;
assign top_mac_core_rx_preamble_sink_last = top_mac_core_rx_cdc_source_source_last;
assign top_mac_core_rx_preamble_sink_payload_data = top_mac_core_rx_cdc_source_source_payload_data;
assign top_mac_core_rx_preamble_sink_payload_be = top_mac_core_rx_cdc_source_source_payload_be;
assign top_mac_core_rx_preamble_sink_payload_error = top_mac_core_rx_cdc_source_source_payload_error;
assign top_mac_core_bufferizeendpoints_sink_sink_valid = top_mac_core_rx_preamble_source_valid;
assign top_mac_core_rx_preamble_source_ready = top_mac_core_bufferizeendpoints_sink_sink_ready;
assign top_mac_core_bufferizeendpoints_sink_sink_first = top_mac_core_rx_preamble_source_first;
assign top_mac_core_bufferizeendpoints_sink_sink_last = top_mac_core_rx_preamble_source_last;
assign top_mac_core_bufferizeendpoints_sink_sink_payload_data = top_mac_core_rx_preamble_source_payload_data;
assign top_mac_core_bufferizeendpoints_sink_sink_payload_be = top_mac_core_rx_preamble_source_payload_be;
assign top_mac_core_bufferizeendpoints_sink_sink_payload_error = top_mac_core_rx_preamble_source_payload_error;
assign top_mac_core_rx_padding_sink_valid = top_mac_core_liteethmaccrc32checker_source_source_valid;
assign top_mac_core_liteethmaccrc32checker_source_source_ready = top_mac_core_rx_padding_sink_ready;
assign top_mac_core_rx_padding_sink_first = top_mac_core_liteethmaccrc32checker_source_source_first;
assign top_mac_core_rx_padding_sink_last = top_mac_core_liteethmaccrc32checker_source_source_last;
assign top_mac_core_rx_padding_sink_payload_data = top_mac_core_liteethmaccrc32checker_source_source_payload_data;
assign top_mac_core_rx_padding_sink_payload_be = top_mac_core_liteethmaccrc32checker_source_source_payload_be;
assign top_mac_core_rx_padding_sink_payload_error = top_mac_core_liteethmaccrc32checker_source_source_payload_error;
assign top_mac_core_source_valid = top_mac_core_rx_padding_source_valid;
assign top_mac_core_rx_padding_source_ready = top_mac_core_source_ready;
assign top_mac_core_source_first = top_mac_core_rx_padding_source_first;
assign top_mac_core_source_last = top_mac_core_rx_padding_source_last;
assign top_mac_core_source_payload_data = top_mac_core_rx_padding_source_payload_data;
assign top_mac_core_source_payload_be = top_mac_core_rx_padding_source_payload_be;
assign top_mac_core_source_payload_error = top_mac_core_rx_padding_source_payload_error;

// synthesis translate_off
reg dummy_d_32;
// synthesis translate_on
always @(*) begin
	liteethmac_sel0 <= 2'd0;
	if ((top_mac_crossbar_sink_payload_ethernet_type == 12'd2054)) begin
		liteethmac_sel0 <= 1'd1;
	end
	if ((top_mac_crossbar_sink_payload_ethernet_type == 12'd2048)) begin
		liteethmac_sel0 <= 2'd2;
	end
// synthesis translate_off
	dummy_d_32 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_33;
// synthesis translate_on
always @(*) begin
	liteethmac_request <= 2'd0;
	liteethmac_request[0] <= liteethmac_status0_ongoing0;
	liteethmac_request[1] <= liteethmac_status1_ongoing0;
// synthesis translate_off
	dummy_d_33 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_34;
// synthesis translate_on
always @(*) begin
	top_mac_crossbar_source_valid <= 1'd0;
	top_mac_crossbar_source_first <= 1'd0;
	top_mac_crossbar_source_last <= 1'd0;
	top_mac_crossbar_source_payload_ethernet_type <= 16'd0;
	top_mac_crossbar_source_payload_sender_mac <= 48'd0;
	top_mac_crossbar_source_payload_target_mac <= 48'd0;
	top_mac_crossbar_source_payload_data <= 8'd0;
	top_mac_crossbar_source_payload_be <= 1'd0;
	top_mac_crossbar_source_payload_error <= 1'd0;
	top_arp_mac_port_sink_ready <= 1'd0;
	top_ip_mac_port_sink_ready <= 1'd0;
	case (liteethmac_grant)
		1'd0: begin
			top_mac_crossbar_source_valid <= top_arp_mac_port_sink_valid;
			top_arp_mac_port_sink_ready <= top_mac_crossbar_source_ready;
			top_mac_crossbar_source_first <= top_arp_mac_port_sink_first;
			top_mac_crossbar_source_last <= top_arp_mac_port_sink_last;
			top_mac_crossbar_source_payload_ethernet_type <= top_arp_mac_port_sink_payload_ethernet_type;
			top_mac_crossbar_source_payload_sender_mac <= top_arp_mac_port_sink_payload_sender_mac;
			top_mac_crossbar_source_payload_target_mac <= top_arp_mac_port_sink_payload_target_mac;
			top_mac_crossbar_source_payload_data <= top_arp_mac_port_sink_payload_data;
			top_mac_crossbar_source_payload_be <= top_arp_mac_port_sink_payload_be;
			top_mac_crossbar_source_payload_error <= top_arp_mac_port_sink_payload_error;
		end
		1'd1: begin
			top_mac_crossbar_source_valid <= top_ip_mac_port_sink_valid;
			top_ip_mac_port_sink_ready <= top_mac_crossbar_source_ready;
			top_mac_crossbar_source_first <= top_ip_mac_port_sink_first;
			top_mac_crossbar_source_last <= top_ip_mac_port_sink_last;
			top_mac_crossbar_source_payload_ethernet_type <= top_ip_mac_port_sink_payload_ethernet_type;
			top_mac_crossbar_source_payload_sender_mac <= top_ip_mac_port_sink_payload_sender_mac;
			top_mac_crossbar_source_payload_target_mac <= top_ip_mac_port_sink_payload_target_mac;
			top_mac_crossbar_source_payload_data <= top_ip_mac_port_sink_payload_data;
			top_mac_crossbar_source_payload_be <= top_ip_mac_port_sink_payload_be;
			top_mac_crossbar_source_payload_error <= top_ip_mac_port_sink_payload_error;
		end
	endcase
// synthesis translate_off
	dummy_d_34 <= dummy_s;
// synthesis translate_on
end
assign liteethmac_status0_last = ((top_arp_mac_port_sink_valid & top_arp_mac_port_sink_last) & top_arp_mac_port_sink_ready);
assign liteethmac_status0_ongoing0 = ((top_arp_mac_port_sink_valid | liteethmac_status0_ongoing1) & (~liteethmac_status0_last));
assign liteethmac_status1_last = ((top_ip_mac_port_sink_valid & top_ip_mac_port_sink_last) & top_ip_mac_port_sink_ready);
assign liteethmac_status1_ongoing0 = ((top_ip_mac_port_sink_valid | liteethmac_status1_ongoing1) & (~liteethmac_status1_last));

// synthesis translate_off
reg dummy_d_35;
// synthesis translate_on
always @(*) begin
	liteethmac_sel1 <= 2'd0;
	if ((~liteethmac_sel_locked)) begin
		liteethmac_sel1 <= liteethmac_sel0;
	end else begin
		liteethmac_sel1 <= liteethmac_sel_ongoing;
	end
// synthesis translate_off
	dummy_d_35 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_36;
// synthesis translate_on
always @(*) begin
	top_mac_crossbar_sink_ready <= 1'd0;
	top_arp_mac_port_source_valid <= 1'd0;
	top_arp_mac_port_source_first <= 1'd0;
	top_arp_mac_port_source_last <= 1'd0;
	top_arp_mac_port_source_payload_ethernet_type <= 16'd0;
	top_arp_mac_port_source_payload_sender_mac <= 48'd0;
	top_arp_mac_port_source_payload_target_mac <= 48'd0;
	top_arp_mac_port_source_payload_data <= 8'd0;
	top_arp_mac_port_source_payload_be <= 1'd0;
	top_arp_mac_port_source_payload_error <= 1'd0;
	top_ip_mac_port_source_valid <= 1'd0;
	top_ip_mac_port_source_first <= 1'd0;
	top_ip_mac_port_source_last <= 1'd0;
	top_ip_mac_port_source_payload_ethernet_type <= 16'd0;
	top_ip_mac_port_source_payload_sender_mac <= 48'd0;
	top_ip_mac_port_source_payload_target_mac <= 48'd0;
	top_ip_mac_port_source_payload_data <= 8'd0;
	top_ip_mac_port_source_payload_be <= 1'd0;
	top_ip_mac_port_source_payload_error <= 1'd0;
	case (liteethmac_sel1)
		1'd1: begin
			top_arp_mac_port_source_valid <= top_mac_crossbar_sink_valid;
			top_mac_crossbar_sink_ready <= top_arp_mac_port_source_ready;
			top_arp_mac_port_source_first <= top_mac_crossbar_sink_first;
			top_arp_mac_port_source_last <= top_mac_crossbar_sink_last;
			top_arp_mac_port_source_payload_ethernet_type <= top_mac_crossbar_sink_payload_ethernet_type;
			top_arp_mac_port_source_payload_sender_mac <= top_mac_crossbar_sink_payload_sender_mac;
			top_arp_mac_port_source_payload_target_mac <= top_mac_crossbar_sink_payload_target_mac;
			top_arp_mac_port_source_payload_data <= top_mac_crossbar_sink_payload_data;
			top_arp_mac_port_source_payload_be <= top_mac_crossbar_sink_payload_be;
			top_arp_mac_port_source_payload_error <= top_mac_crossbar_sink_payload_error;
		end
		2'd2: begin
			top_ip_mac_port_source_valid <= top_mac_crossbar_sink_valid;
			top_mac_crossbar_sink_ready <= top_ip_mac_port_source_ready;
			top_ip_mac_port_source_first <= top_mac_crossbar_sink_first;
			top_ip_mac_port_source_last <= top_mac_crossbar_sink_last;
			top_ip_mac_port_source_payload_ethernet_type <= top_mac_crossbar_sink_payload_ethernet_type;
			top_ip_mac_port_source_payload_sender_mac <= top_mac_crossbar_sink_payload_sender_mac;
			top_ip_mac_port_source_payload_target_mac <= top_mac_crossbar_sink_payload_target_mac;
			top_ip_mac_port_source_payload_data <= top_mac_crossbar_sink_payload_data;
			top_ip_mac_port_source_payload_be <= top_mac_crossbar_sink_payload_be;
			top_ip_mac_port_source_payload_error <= top_mac_crossbar_sink_payload_error;
		end
		default: begin
			top_mac_crossbar_sink_ready <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_36 <= dummy_s;
// synthesis translate_on
end
assign liteethmac_last = ((top_mac_crossbar_sink_valid & top_mac_crossbar_sink_last) & top_mac_crossbar_sink_ready);
assign liteethmac_ongoing0 = ((top_mac_crossbar_sink_valid | liteethmac_ongoing1) & (~liteethmac_last));

// synthesis translate_off
reg dummy_d_37;
// synthesis translate_on
always @(*) begin
	top_mac_packetizer_header <= 112'd0;
	top_mac_packetizer_header[111:96] <= {top_mac_packetizer_sink_payload_ethernet_type[7:0], top_mac_packetizer_sink_payload_ethernet_type[15:8]};
	top_mac_packetizer_header[95:48] <= {top_mac_packetizer_sink_payload_sender_mac[7:0], top_mac_packetizer_sink_payload_sender_mac[15:8], top_mac_packetizer_sink_payload_sender_mac[23:16], top_mac_packetizer_sink_payload_sender_mac[31:24], top_mac_packetizer_sink_payload_sender_mac[39:32], top_mac_packetizer_sink_payload_sender_mac[47:40]};
	top_mac_packetizer_header[47:0] <= {top_mac_packetizer_sink_payload_target_mac[7:0], top_mac_packetizer_sink_payload_target_mac[15:8], top_mac_packetizer_sink_payload_target_mac[23:16], top_mac_packetizer_sink_payload_target_mac[31:24], top_mac_packetizer_sink_payload_target_mac[39:32], top_mac_packetizer_sink_payload_target_mac[47:40]};
// synthesis translate_off
	dummy_d_37 <= dummy_s;
// synthesis translate_on
end
assign top_mac_packetizer_source_payload_be = top_mac_packetizer_source_be;

// synthesis translate_off
reg dummy_d_38;
// synthesis translate_on
always @(*) begin
	top_mac_packetizer_source_payload_error <= 1'd0;
	if (top_mac_packetizer_is_ongoing) begin
		top_mac_packetizer_source_payload_error <= top_mac_packetizer_sink_payload_error;
	end
// synthesis translate_off
	dummy_d_38 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_39;
// synthesis translate_on
always @(*) begin
	top_mac_packetizer_sink_ready <= 1'd0;
	top_mac_packetizer_source_valid <= 1'd0;
	top_mac_packetizer_source_first <= 1'd0;
	top_mac_packetizer_source_last <= 1'd0;
	top_mac_packetizer_source_payload_data <= 8'd0;
	top_mac_packetizer_source_be <= 1'd1;
	top_mac_packetizer_is_ongoing <= 1'd0;
	liteethmac_liteethmacpacketizer_next_state <= 1'd0;
	top_mac_packetizer_count_liteethmacpacketizer_next_value <= 4'd0;
	top_mac_packetizer_count_liteethmacpacketizer_next_value_ce <= 1'd0;
	liteethmac_liteethmacpacketizer_next_state <= liteethmac_liteethmacpacketizer_state;
	case (liteethmac_liteethmacpacketizer_state)
		1'd0: begin
			top_mac_packetizer_is_ongoing <= 1'd1;
			top_mac_packetizer_source_valid <= top_mac_packetizer_sink_valid;
			top_mac_packetizer_sink_ready <= top_mac_packetizer_source_ready;
			top_mac_packetizer_source_last <= top_mac_packetizer_sink_last;
			top_mac_packetizer_source_payload_data <= top_mac_packetizer_sink_payload_data;
			top_mac_packetizer_source_be <= top_mac_packetizer_sink_payload_be;
			if (((top_mac_packetizer_source_valid & top_mac_packetizer_source_ready) & top_mac_packetizer_source_last)) begin
				liteethmac_liteethmacpacketizer_next_state <= 1'd1;
			end
		end
		default: begin
			top_mac_packetizer_sink_ready <= (top_mac_packetizer_count == 1'd0);
			case (top_mac_packetizer_count)
				1'd0: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[7:0];
				end
				1'd1: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[15:8];
				end
				2'd2: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[23:16];
				end
				2'd3: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[31:24];
				end
				3'd4: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[39:32];
				end
				3'd5: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[47:40];
				end
				3'd6: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[55:48];
				end
				3'd7: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[63:56];
				end
				4'd8: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[71:64];
				end
				4'd9: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[79:72];
				end
				4'd10: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[87:80];
				end
				4'd11: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[95:88];
				end
				4'd12: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[103:96];
				end
				4'd13: begin
					top_mac_packetizer_source_payload_data <= top_mac_packetizer_header[111:104];
				end
			endcase
			if ((top_mac_packetizer_count == 4'd13)) begin
				top_mac_packetizer_source_be <= 1'd1;
			end
			if ((top_mac_packetizer_sink_valid & 1'd1)) begin
				top_mac_packetizer_source_valid <= 1'd1;
				top_mac_packetizer_source_first <= (top_mac_packetizer_count == 1'd0);
				top_mac_packetizer_source_last <= ((top_mac_packetizer_count == 4'd13) & (top_mac_packetizer_sink_last & (top_mac_packetizer_sink_payload_be == 1'd0)));
				top_mac_packetizer_sink_ready <= (((top_mac_packetizer_count == 4'd13) & (top_mac_packetizer_sink_last & (top_mac_packetizer_sink_payload_be == 1'd0))) & top_mac_packetizer_source_ready);
				if (top_mac_packetizer_source_ready) begin
					if ((top_mac_packetizer_count == 4'd13)) begin
						top_mac_packetizer_count_liteethmacpacketizer_next_value <= 1'd0;
						top_mac_packetizer_count_liteethmacpacketizer_next_value_ce <= 1'd1;
						if ((~top_mac_packetizer_source_last)) begin
							liteethmac_liteethmacpacketizer_next_state <= 1'd0;
						end
					end else begin
						top_mac_packetizer_count_liteethmacpacketizer_next_value <= (top_mac_packetizer_count + 1'd1);
						top_mac_packetizer_count_liteethmacpacketizer_next_value_ce <= 1'd1;
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_39 <= dummy_s;
// synthesis translate_on
end
assign top_mac_depacketizer_header = top_mac_depacketizer_sr;
assign top_mac_depacketizer_source_payload_ethernet_type = {rhs_slice_proxy1[7:0], rhs_slice_proxy0[15:8]};
assign top_mac_depacketizer_source_payload_sender_mac = {rhs_slice_proxy7[7:0], rhs_slice_proxy6[15:8], rhs_slice_proxy5[23:16], rhs_slice_proxy4[31:24], rhs_slice_proxy3[39:32], rhs_slice_proxy2[47:40]};
assign top_mac_depacketizer_source_payload_target_mac = {rhs_slice_proxy13[7:0], rhs_slice_proxy12[15:8], rhs_slice_proxy11[23:16], rhs_slice_proxy10[31:24], rhs_slice_proxy9[39:32], rhs_slice_proxy8[47:40]};
assign top_mac_depacketizer_sink_be = top_mac_depacketizer_sink_payload_be;
assign top_mac_depacketizer_source_payload_be = top_mac_depacketizer_source_be;
assign top_mac_depacketizer_source_payload_error = top_mac_depacketizer_sink_payload_error;

// synthesis translate_off
reg dummy_d_40;
// synthesis translate_on
always @(*) begin
	top_mac_depacketizer_sink_ready <= 1'd0;
	top_mac_depacketizer_source_valid <= 1'd0;
	top_mac_depacketizer_source_first <= 1'd0;
	top_mac_depacketizer_source_last <= 1'd0;
	top_mac_depacketizer_source_payload_data <= 8'd0;
	top_mac_depacketizer_sr_shift <= 1'd0;
	top_mac_depacketizer_source_be <= 1'd1;
	liteethmac_liteethmacdepacketizer_next_state <= 2'd0;
	top_mac_depacketizer_count_liteethmacdepacketizer_next_value0 <= 4'd0;
	top_mac_depacketizer_count_liteethmacdepacketizer_next_value_ce0 <= 1'd0;
	top_mac_depacketizer_fsm_from_idle_liteethmacdepacketizer_next_value1 <= 1'd0;
	top_mac_depacketizer_fsm_from_idle_liteethmacdepacketizer_next_value_ce1 <= 1'd0;
	top_mac_depacketizer_data_copy_first_liteethmacdepacketizer_next_value2 <= 1'd0;
	top_mac_depacketizer_data_copy_first_liteethmacdepacketizer_next_value_ce2 <= 1'd0;
	liteethmac_liteethmacdepacketizer_next_state <= liteethmac_liteethmacdepacketizer_state;
	case (liteethmac_liteethmacdepacketizer_state)
		1'd1: begin
			top_mac_depacketizer_sink_ready <= 1'd1;
			if (top_mac_depacketizer_sink_valid) begin
				top_mac_depacketizer_count_liteethmacdepacketizer_next_value0 <= (top_mac_depacketizer_count + 1'd1);
				top_mac_depacketizer_count_liteethmacdepacketizer_next_value_ce0 <= 1'd1;
				top_mac_depacketizer_sr_shift <= 1'd1;
				if ((top_mac_depacketizer_count == 4'd13)) begin
					top_mac_depacketizer_data_copy_first_liteethmacdepacketizer_next_value2 <= 1'd1;
					top_mac_depacketizer_data_copy_first_liteethmacdepacketizer_next_value_ce2 <= 1'd1;
					liteethmac_liteethmacdepacketizer_next_state <= 2'd2;
					top_mac_depacketizer_count_liteethmacdepacketizer_next_value0 <= (top_mac_depacketizer_count + 1'd1);
					top_mac_depacketizer_count_liteethmacdepacketizer_next_value_ce0 <= 1'd1;
				end
				if (top_mac_depacketizer_sink_last) begin
					liteethmac_liteethmacdepacketizer_next_state <= 1'd0;
				end
			end
		end
		2'd2: begin
			top_mac_depacketizer_source_valid <= top_mac_depacketizer_sink_valid;
			top_mac_depacketizer_source_first <= top_mac_depacketizer_data_copy_first;
			top_mac_depacketizer_source_last <= top_mac_depacketizer_sink_last;
			top_mac_depacketizer_sink_ready <= top_mac_depacketizer_source_ready;
			top_mac_depacketizer_source_payload_data <= top_mac_depacketizer_sink_payload_data;
			top_mac_depacketizer_source_be <= top_mac_depacketizer_sink_be;
			if ((top_mac_depacketizer_source_valid & top_mac_depacketizer_source_ready)) begin
				top_mac_depacketizer_data_copy_first_liteethmacdepacketizer_next_value2 <= 1'd0;
				top_mac_depacketizer_data_copy_first_liteethmacdepacketizer_next_value_ce2 <= 1'd1;
				top_mac_depacketizer_fsm_from_idle_liteethmacdepacketizer_next_value1 <= 1'd0;
				top_mac_depacketizer_fsm_from_idle_liteethmacdepacketizer_next_value_ce1 <= 1'd1;
				if (top_mac_depacketizer_source_last) begin
					liteethmac_liteethmacdepacketizer_next_state <= 1'd0;
				end
			end
		end
		default: begin
			top_mac_depacketizer_sink_ready <= 1'd1;
			top_mac_depacketizer_count_liteethmacdepacketizer_next_value0 <= 1'd1;
			top_mac_depacketizer_count_liteethmacdepacketizer_next_value_ce0 <= 1'd1;
			if (top_mac_depacketizer_sink_valid) begin
				top_mac_depacketizer_sr_shift <= 1'd1;
				top_mac_depacketizer_fsm_from_idle_liteethmacdepacketizer_next_value1 <= 1'd1;
				top_mac_depacketizer_fsm_from_idle_liteethmacdepacketizer_next_value_ce1 <= 1'd1;
				top_mac_depacketizer_data_copy_first_liteethmacdepacketizer_next_value2 <= 1'd1;
				top_mac_depacketizer_data_copy_first_liteethmacdepacketizer_next_value_ce2 <= 1'd1;
				if (1'd0) begin
					liteethmac_liteethmacdepacketizer_next_state <= 2'd2;
				end else begin
					liteethmac_liteethmacdepacketizer_next_state <= 1'd1;
				end
				if (($signed({1'd0, top_mac_depacketizer_sink_last}) & 1'sd1)) begin
					liteethmac_liteethmacdepacketizer_next_state <= 1'd0;
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_40 <= dummy_s;
// synthesis translate_on
end
assign top_arp_table_sink_valid = top_arp_rx_source_source_valid;
assign top_arp_rx_source_source_ready = top_arp_table_sink_ready;
assign top_arp_table_sink_first = top_arp_rx_source_source_first;
assign top_arp_table_sink_last = top_arp_rx_source_source_last;
assign top_arp_table_sink_payload_reply = top_arp_rx_source_source_payload_reply;
assign top_arp_table_sink_payload_request = top_arp_rx_source_source_payload_request;
assign top_arp_table_sink_payload_ip_address = top_arp_rx_source_source_payload_ip_address;
assign top_arp_table_sink_payload_mac_address = top_arp_rx_source_source_payload_mac_address;
assign top_arp_tx_sink_sink_valid = top_arp_table_source_valid;
assign top_arp_table_source_ready = top_arp_tx_sink_sink_ready;
assign top_arp_tx_sink_sink_first = top_arp_table_source_first;
assign top_arp_tx_sink_sink_last = top_arp_table_source_last;
assign top_arp_tx_sink_sink_payload_reply = top_arp_table_source_payload_reply;
assign top_arp_tx_sink_sink_payload_request = top_arp_table_source_payload_request;
assign top_arp_tx_sink_sink_payload_ip_address = top_arp_table_source_payload_ip_address;
assign top_arp_tx_sink_sink_payload_mac_address = top_arp_table_source_payload_mac_address;
assign top_arp_mac_port_sink_valid = top_arp_tx_source_source_valid;
assign top_arp_tx_source_source_ready = top_arp_mac_port_sink_ready;
assign top_arp_mac_port_sink_first = top_arp_tx_source_source_first;
assign top_arp_mac_port_sink_last = top_arp_tx_source_source_last;
assign top_arp_mac_port_sink_payload_ethernet_type = top_arp_tx_source_source_payload_ethernet_type;
assign top_arp_mac_port_sink_payload_sender_mac = top_arp_tx_source_source_payload_sender_mac;
assign top_arp_mac_port_sink_payload_target_mac = top_arp_tx_source_source_payload_target_mac;
assign top_arp_mac_port_sink_payload_data = top_arp_tx_source_source_payload_data;
assign top_arp_mac_port_sink_payload_be = top_arp_tx_source_source_payload_be;
assign top_arp_mac_port_sink_payload_error = top_arp_tx_source_source_payload_error;
assign top_arp_rx_sink_sink_valid = top_arp_mac_port_source_valid;
assign top_arp_mac_port_source_ready = top_arp_rx_sink_sink_ready;
assign top_arp_rx_sink_sink_first = top_arp_mac_port_source_first;
assign top_arp_rx_sink_sink_last = top_arp_mac_port_source_last;
assign top_arp_rx_sink_sink_payload_ethernet_type = top_arp_mac_port_source_payload_ethernet_type;
assign top_arp_rx_sink_sink_payload_sender_mac = top_arp_mac_port_source_payload_sender_mac;
assign top_arp_rx_sink_sink_payload_target_mac = top_arp_mac_port_source_payload_target_mac;
assign top_arp_rx_sink_sink_payload_data = top_arp_mac_port_source_payload_data;
assign top_arp_rx_sink_sink_payload_be = top_arp_mac_port_source_payload_be;
assign top_arp_rx_sink_sink_payload_error = top_arp_mac_port_source_payload_error;
assign top_arp_tx_packetizer_sink_last = (top_arp_tx_counter == 5'd17);
assign top_arp_tx_packetizer_sink_payload_be = (top_arp_tx_packetizer_sink_last ? 1'd1 : 1'd1);
assign top_arp_tx_packetizer_sink_param_hwtype = 1'd1;
assign top_arp_tx_packetizer_sink_param_proto = 12'd2048;
assign top_arp_tx_packetizer_sink_param_hwsize = 3'd6;
assign top_arp_tx_packetizer_sink_param_protosize = 3'd4;
assign top_arp_tx_packetizer_sink_param_sender_mac = 42'd2199023260161;
assign top_arp_tx_packetizer_sink_param_sender_ip = 32'd3232236272;
assign top_arp_tx_packetizer_sink_param_target_ip = top_arp_tx_sink_sink_payload_ip_address;

// synthesis translate_off
reg dummy_d_41;
// synthesis translate_on
always @(*) begin
	top_arp_tx_packetizer_sink_param_opcode <= 16'd0;
	top_arp_tx_packetizer_sink_param_target_mac <= 48'd0;
	if (top_arp_tx_sink_sink_payload_reply) begin
		top_arp_tx_packetizer_sink_param_opcode <= 2'd2;
		top_arp_tx_packetizer_sink_param_target_mac <= top_arp_tx_sink_sink_payload_mac_address;
	end else begin
		if (top_arp_tx_sink_sink_payload_request) begin
			top_arp_tx_packetizer_sink_param_opcode <= 1'd1;
			top_arp_tx_packetizer_sink_param_target_mac <= 48'd281474976710655;
		end
	end
// synthesis translate_off
	dummy_d_41 <= dummy_s;
// synthesis translate_on
end
assign top_arp_tx_source_source_first = top_arp_tx_packetizer_source_first;
assign top_arp_tx_source_source_last = top_arp_tx_packetizer_source_last;
assign top_arp_tx_source_source_payload_data = top_arp_tx_packetizer_source_payload_data;
assign top_arp_tx_source_source_payload_be = top_arp_tx_packetizer_source_payload_be;
assign top_arp_tx_source_source_payload_error = top_arp_tx_packetizer_source_payload_error;

// synthesis translate_off
reg dummy_d_42;
// synthesis translate_on
always @(*) begin
	top_arp_tx_source_source_payload_target_mac <= 48'd0;
	top_arp_tx_source_source_payload_target_mac <= top_arp_tx_packetizer_source_payload_target_mac;
	top_arp_tx_source_source_payload_target_mac <= top_arp_tx_packetizer_sink_param_target_mac;
// synthesis translate_off
	dummy_d_42 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_43;
// synthesis translate_on
always @(*) begin
	top_arp_tx_source_source_payload_sender_mac <= 48'd0;
	top_arp_tx_source_source_payload_sender_mac <= top_arp_tx_packetizer_source_payload_sender_mac;
	top_arp_tx_source_source_payload_sender_mac <= 42'd2199023260161;
// synthesis translate_off
	dummy_d_43 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_44;
// synthesis translate_on
always @(*) begin
	top_arp_tx_source_source_payload_ethernet_type <= 16'd0;
	top_arp_tx_source_source_payload_ethernet_type <= top_arp_tx_packetizer_source_payload_ethernet_type;
	top_arp_tx_source_source_payload_ethernet_type <= 12'd2054;
// synthesis translate_off
	dummy_d_44 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_45;
// synthesis translate_on
always @(*) begin
	top_arp_tx_packetizer_header <= 224'd0;
	top_arp_tx_packetizer_header[39:32] <= {top_arp_tx_packetizer_sink_param_hwsize[7:0]};
	top_arp_tx_packetizer_header[15:0] <= {top_arp_tx_packetizer_sink_param_hwtype[7:0], top_arp_tx_packetizer_sink_param_hwtype[15:8]};
	top_arp_tx_packetizer_header[63:48] <= {top_arp_tx_packetizer_sink_param_opcode[7:0], top_arp_tx_packetizer_sink_param_opcode[15:8]};
	top_arp_tx_packetizer_header[31:16] <= {top_arp_tx_packetizer_sink_param_proto[7:0], top_arp_tx_packetizer_sink_param_proto[15:8]};
	top_arp_tx_packetizer_header[47:40] <= {top_arp_tx_packetizer_sink_param_protosize[7:0]};
	top_arp_tx_packetizer_header[143:112] <= {top_arp_tx_packetizer_sink_param_sender_ip[7:0], top_arp_tx_packetizer_sink_param_sender_ip[15:8], top_arp_tx_packetizer_sink_param_sender_ip[23:16], top_arp_tx_packetizer_sink_param_sender_ip[31:24]};
	top_arp_tx_packetizer_header[111:64] <= {top_arp_tx_packetizer_sink_param_sender_mac[7:0], top_arp_tx_packetizer_sink_param_sender_mac[15:8], top_arp_tx_packetizer_sink_param_sender_mac[23:16], top_arp_tx_packetizer_sink_param_sender_mac[31:24], top_arp_tx_packetizer_sink_param_sender_mac[39:32], top_arp_tx_packetizer_sink_param_sender_mac[47:40]};
	top_arp_tx_packetizer_header[223:192] <= {top_arp_tx_packetizer_sink_param_target_ip[7:0], top_arp_tx_packetizer_sink_param_target_ip[15:8], top_arp_tx_packetizer_sink_param_target_ip[23:16], top_arp_tx_packetizer_sink_param_target_ip[31:24]};
	top_arp_tx_packetizer_header[191:144] <= {top_arp_tx_packetizer_sink_param_target_mac[7:0], top_arp_tx_packetizer_sink_param_target_mac[15:8], top_arp_tx_packetizer_sink_param_target_mac[23:16], top_arp_tx_packetizer_sink_param_target_mac[31:24], top_arp_tx_packetizer_sink_param_target_mac[39:32], top_arp_tx_packetizer_sink_param_target_mac[47:40]};
// synthesis translate_off
	dummy_d_45 <= dummy_s;
// synthesis translate_on
end
assign top_arp_tx_packetizer_source_payload_be = top_arp_tx_packetizer_source_be;

// synthesis translate_off
reg dummy_d_46;
// synthesis translate_on
always @(*) begin
	top_arp_tx_packetizer_source_payload_error <= 1'd0;
	if (top_arp_tx_packetizer_is_ongoing) begin
		top_arp_tx_packetizer_source_payload_error <= top_arp_tx_packetizer_sink_payload_error;
	end
// synthesis translate_off
	dummy_d_46 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_47;
// synthesis translate_on
always @(*) begin
	top_arp_tx_packetizer_sink_ready <= 1'd0;
	top_arp_tx_packetizer_source_valid <= 1'd0;
	top_arp_tx_packetizer_source_first <= 1'd0;
	top_arp_tx_packetizer_source_last <= 1'd0;
	top_arp_tx_packetizer_source_payload_data <= 8'd0;
	top_arp_tx_packetizer_source_be <= 1'd1;
	top_arp_tx_packetizer_is_ongoing <= 1'd0;
	liteetharptx_liteetharppacketizer_next_state <= 1'd0;
	top_arp_tx_packetizer_count_liteetharp_liteetharptx_liteetharppacketizer_next_value <= 5'd0;
	top_arp_tx_packetizer_count_liteetharp_liteetharptx_liteetharppacketizer_next_value_ce <= 1'd0;
	liteetharptx_liteetharppacketizer_next_state <= liteetharptx_liteetharppacketizer_state;
	case (liteetharptx_liteetharppacketizer_state)
		1'd0: begin
			top_arp_tx_packetizer_is_ongoing <= 1'd1;
			top_arp_tx_packetizer_source_valid <= top_arp_tx_packetizer_sink_valid;
			top_arp_tx_packetizer_sink_ready <= top_arp_tx_packetizer_source_ready;
			top_arp_tx_packetizer_source_last <= top_arp_tx_packetizer_sink_last;
			top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_sink_payload_data;
			top_arp_tx_packetizer_source_be <= top_arp_tx_packetizer_sink_payload_be;
			if (((top_arp_tx_packetizer_source_valid & top_arp_tx_packetizer_source_ready) & top_arp_tx_packetizer_source_last)) begin
				liteetharptx_liteetharppacketizer_next_state <= 1'd1;
			end
		end
		default: begin
			top_arp_tx_packetizer_sink_ready <= (top_arp_tx_packetizer_count == 1'd0);
			case (top_arp_tx_packetizer_count)
				1'd0: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[7:0];
				end
				1'd1: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[15:8];
				end
				2'd2: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[23:16];
				end
				2'd3: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[31:24];
				end
				3'd4: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[39:32];
				end
				3'd5: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[47:40];
				end
				3'd6: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[55:48];
				end
				3'd7: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[63:56];
				end
				4'd8: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[71:64];
				end
				4'd9: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[79:72];
				end
				4'd10: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[87:80];
				end
				4'd11: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[95:88];
				end
				4'd12: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[103:96];
				end
				4'd13: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[111:104];
				end
				4'd14: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[119:112];
				end
				4'd15: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[127:120];
				end
				5'd16: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[135:128];
				end
				5'd17: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[143:136];
				end
				5'd18: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[151:144];
				end
				5'd19: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[159:152];
				end
				5'd20: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[167:160];
				end
				5'd21: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[175:168];
				end
				5'd22: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[183:176];
				end
				5'd23: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[191:184];
				end
				5'd24: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[199:192];
				end
				5'd25: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[207:200];
				end
				5'd26: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[215:208];
				end
				5'd27: begin
					top_arp_tx_packetizer_source_payload_data <= top_arp_tx_packetizer_header[223:216];
				end
			endcase
			if ((top_arp_tx_packetizer_count == 5'd27)) begin
				top_arp_tx_packetizer_source_be <= 1'd1;
			end
			if ((top_arp_tx_packetizer_sink_valid & 1'd1)) begin
				top_arp_tx_packetizer_source_valid <= 1'd1;
				top_arp_tx_packetizer_source_first <= (top_arp_tx_packetizer_count == 1'd0);
				top_arp_tx_packetizer_source_last <= ((top_arp_tx_packetizer_count == 5'd27) & (top_arp_tx_packetizer_sink_last & (top_arp_tx_packetizer_sink_payload_be == 1'd0)));
				top_arp_tx_packetizer_sink_ready <= (((top_arp_tx_packetizer_count == 5'd27) & (top_arp_tx_packetizer_sink_last & (top_arp_tx_packetizer_sink_payload_be == 1'd0))) & top_arp_tx_packetizer_source_ready);
				if (top_arp_tx_packetizer_source_ready) begin
					if ((top_arp_tx_packetizer_count == 5'd27)) begin
						top_arp_tx_packetizer_count_liteetharp_liteetharptx_liteetharppacketizer_next_value <= 1'd0;
						top_arp_tx_packetizer_count_liteetharp_liteetharptx_liteetharppacketizer_next_value_ce <= 1'd1;
						if ((~top_arp_tx_packetizer_source_last)) begin
							liteetharptx_liteetharppacketizer_next_state <= 1'd0;
						end
					end else begin
						top_arp_tx_packetizer_count_liteetharp_liteetharptx_liteetharppacketizer_next_value <= (top_arp_tx_packetizer_count + 1'd1);
						top_arp_tx_packetizer_count_liteetharp_liteetharptx_liteetharppacketizer_next_value_ce <= 1'd1;
					end
				end
			end
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
	top_arp_tx_sink_sink_ready <= 1'd0;
	top_arp_tx_source_source_valid <= 1'd0;
	top_arp_tx_packetizer_sink_valid <= 1'd0;
	top_arp_tx_packetizer_source_ready <= 1'd0;
	liteetharptx_fsm_next_state <= 1'd0;
	top_arp_tx_counter_liteetharp_liteetharptx_fsm_next_value <= 5'd0;
	top_arp_tx_counter_liteetharp_liteetharptx_fsm_next_value_ce <= 1'd0;
	liteetharptx_fsm_next_state <= liteetharptx_fsm_state;
	case (liteetharptx_fsm_state)
		1'd1: begin
			top_arp_tx_packetizer_sink_valid <= 1'd1;
			top_arp_tx_source_source_valid <= top_arp_tx_packetizer_source_valid;
			top_arp_tx_packetizer_source_ready <= top_arp_tx_source_source_ready;
			if ((top_arp_tx_packetizer_sink_valid & top_arp_tx_packetizer_sink_ready)) begin
				top_arp_tx_counter_liteetharp_liteetharptx_fsm_next_value <= (top_arp_tx_counter + 1'd1);
				top_arp_tx_counter_liteetharp_liteetharptx_fsm_next_value_ce <= 1'd1;
			end
			if ((top_arp_tx_source_source_valid & top_arp_tx_source_source_ready)) begin
				if (top_arp_tx_source_source_last) begin
					top_arp_tx_sink_sink_ready <= 1'd1;
					liteetharptx_fsm_next_state <= 1'd0;
				end
			end
		end
		default: begin
			top_arp_tx_counter_liteetharp_liteetharptx_fsm_next_value <= 1'd0;
			top_arp_tx_counter_liteetharp_liteetharptx_fsm_next_value_ce <= 1'd1;
			if (top_arp_tx_sink_sink_valid) begin
				liteetharptx_fsm_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_48 <= dummy_s;
// synthesis translate_on
end
assign top_arp_rx_depacketizer_sink_valid = top_arp_rx_sink_sink_valid;
assign top_arp_rx_sink_sink_ready = top_arp_rx_depacketizer_sink_ready;
assign top_arp_rx_depacketizer_sink_first = top_arp_rx_sink_sink_first;
assign top_arp_rx_depacketizer_sink_last = top_arp_rx_sink_sink_last;
assign top_arp_rx_depacketizer_sink_payload_ethernet_type = top_arp_rx_sink_sink_payload_ethernet_type;
assign top_arp_rx_depacketizer_sink_payload_sender_mac = top_arp_rx_sink_sink_payload_sender_mac;
assign top_arp_rx_depacketizer_sink_payload_target_mac = top_arp_rx_sink_sink_payload_target_mac;
assign top_arp_rx_depacketizer_sink_payload_data = top_arp_rx_sink_sink_payload_data;
assign top_arp_rx_depacketizer_sink_payload_be = top_arp_rx_sink_sink_payload_be;
assign top_arp_rx_depacketizer_sink_payload_error = top_arp_rx_sink_sink_payload_error;

// synthesis translate_off
reg dummy_d_49;
// synthesis translate_on
always @(*) begin
	top_arp_rx_reply <= 1'd0;
	top_arp_rx_request <= 1'd0;
	case (top_arp_rx_depacketizer_source_param_opcode)
		1'd1: begin
			top_arp_rx_request <= 1'd1;
		end
		2'd2: begin
			top_arp_rx_reply <= 1'd1;
		end
		default: begin
		end
	endcase
// synthesis translate_off
	dummy_d_49 <= dummy_s;
// synthesis translate_on
end
assign top_arp_rx_source_source_payload_ip_address = top_arp_rx_depacketizer_source_param_sender_ip;
assign top_arp_rx_source_source_payload_mac_address = top_arp_rx_depacketizer_source_param_sender_mac;
assign top_arp_rx_depacketizer_header = top_arp_rx_depacketizer_sr;
assign top_arp_rx_depacketizer_source_param_hwsize = {rhs_slice_proxy14[7:0]};
assign top_arp_rx_depacketizer_source_param_hwtype = {rhs_slice_proxy16[7:0], rhs_slice_proxy15[15:8]};
assign top_arp_rx_depacketizer_source_param_opcode = {rhs_slice_proxy18[7:0], rhs_slice_proxy17[15:8]};
assign top_arp_rx_depacketizer_source_param_proto = {rhs_slice_proxy20[7:0], rhs_slice_proxy19[15:8]};
assign top_arp_rx_depacketizer_source_param_protosize = {rhs_slice_proxy21[7:0]};
assign top_arp_rx_depacketizer_source_param_sender_ip = {rhs_slice_proxy25[7:0], rhs_slice_proxy24[15:8], rhs_slice_proxy23[23:16], rhs_slice_proxy22[31:24]};
assign top_arp_rx_depacketizer_source_param_sender_mac = {rhs_slice_proxy31[7:0], rhs_slice_proxy30[15:8], rhs_slice_proxy29[23:16], rhs_slice_proxy28[31:24], rhs_slice_proxy27[39:32], rhs_slice_proxy26[47:40]};
assign top_arp_rx_depacketizer_source_param_target_ip = {rhs_slice_proxy35[7:0], rhs_slice_proxy34[15:8], rhs_slice_proxy33[23:16], rhs_slice_proxy32[31:24]};
assign top_arp_rx_depacketizer_source_param_target_mac = {rhs_slice_proxy41[7:0], rhs_slice_proxy40[15:8], rhs_slice_proxy39[23:16], rhs_slice_proxy38[31:24], rhs_slice_proxy37[39:32], rhs_slice_proxy36[47:40]};
assign top_arp_rx_depacketizer_sink_be = top_arp_rx_depacketizer_sink_payload_be;
assign top_arp_rx_depacketizer_source_payload_be = top_arp_rx_depacketizer_source_be;
assign top_arp_rx_depacketizer_source_payload_error = top_arp_rx_depacketizer_sink_payload_error;

// synthesis translate_off
reg dummy_d_50;
// synthesis translate_on
always @(*) begin
	top_arp_rx_depacketizer_sink_ready <= 1'd0;
	top_arp_rx_depacketizer_source_valid <= 1'd0;
	top_arp_rx_depacketizer_source_first <= 1'd0;
	top_arp_rx_depacketizer_source_last <= 1'd0;
	top_arp_rx_depacketizer_source_payload_data <= 8'd0;
	top_arp_rx_depacketizer_sr_shift <= 1'd0;
	top_arp_rx_depacketizer_source_be <= 1'd1;
	liteetharprx_liteetharpdepacketizer_next_state <= 2'd0;
	top_arp_rx_depacketizer_count_liteetharp_next_value0 <= 5'd0;
	top_arp_rx_depacketizer_count_liteetharp_next_value_ce0 <= 1'd0;
	top_arp_rx_depacketizer_fsm_from_idle_liteetharp_next_value1 <= 1'd0;
	top_arp_rx_depacketizer_fsm_from_idle_liteetharp_next_value_ce1 <= 1'd0;
	top_arp_rx_depacketizer_data_copy_first_liteetharp_next_value2 <= 1'd0;
	top_arp_rx_depacketizer_data_copy_first_liteetharp_next_value_ce2 <= 1'd0;
	liteetharprx_liteetharpdepacketizer_next_state <= liteetharprx_liteetharpdepacketizer_state;
	case (liteetharprx_liteetharpdepacketizer_state)
		1'd1: begin
			top_arp_rx_depacketizer_sink_ready <= 1'd1;
			if (top_arp_rx_depacketizer_sink_valid) begin
				top_arp_rx_depacketizer_count_liteetharp_next_value0 <= (top_arp_rx_depacketizer_count + 1'd1);
				top_arp_rx_depacketizer_count_liteetharp_next_value_ce0 <= 1'd1;
				top_arp_rx_depacketizer_sr_shift <= 1'd1;
				if ((top_arp_rx_depacketizer_count == 5'd27)) begin
					top_arp_rx_depacketizer_data_copy_first_liteetharp_next_value2 <= 1'd1;
					top_arp_rx_depacketizer_data_copy_first_liteetharp_next_value_ce2 <= 1'd1;
					liteetharprx_liteetharpdepacketizer_next_state <= 2'd2;
					top_arp_rx_depacketizer_count_liteetharp_next_value0 <= (top_arp_rx_depacketizer_count + 1'd1);
					top_arp_rx_depacketizer_count_liteetharp_next_value_ce0 <= 1'd1;
				end
				if (top_arp_rx_depacketizer_sink_last) begin
					liteetharprx_liteetharpdepacketizer_next_state <= 1'd0;
				end
			end
		end
		2'd2: begin
			top_arp_rx_depacketizer_source_valid <= top_arp_rx_depacketizer_sink_valid;
			top_arp_rx_depacketizer_source_first <= top_arp_rx_depacketizer_data_copy_first;
			top_arp_rx_depacketizer_source_last <= top_arp_rx_depacketizer_sink_last;
			top_arp_rx_depacketizer_sink_ready <= top_arp_rx_depacketizer_source_ready;
			top_arp_rx_depacketizer_source_payload_data <= top_arp_rx_depacketizer_sink_payload_data;
			top_arp_rx_depacketizer_source_be <= top_arp_rx_depacketizer_sink_be;
			if ((top_arp_rx_depacketizer_source_valid & top_arp_rx_depacketizer_source_ready)) begin
				top_arp_rx_depacketizer_data_copy_first_liteetharp_next_value2 <= 1'd0;
				top_arp_rx_depacketizer_data_copy_first_liteetharp_next_value_ce2 <= 1'd1;
				top_arp_rx_depacketizer_fsm_from_idle_liteetharp_next_value1 <= 1'd0;
				top_arp_rx_depacketizer_fsm_from_idle_liteetharp_next_value_ce1 <= 1'd1;
				if (top_arp_rx_depacketizer_source_last) begin
					liteetharprx_liteetharpdepacketizer_next_state <= 1'd0;
				end
			end
		end
		default: begin
			top_arp_rx_depacketizer_sink_ready <= 1'd1;
			top_arp_rx_depacketizer_count_liteetharp_next_value0 <= 1'd1;
			top_arp_rx_depacketizer_count_liteetharp_next_value_ce0 <= 1'd1;
			if (top_arp_rx_depacketizer_sink_valid) begin
				top_arp_rx_depacketizer_sr_shift <= 1'd1;
				top_arp_rx_depacketizer_fsm_from_idle_liteetharp_next_value1 <= 1'd1;
				top_arp_rx_depacketizer_fsm_from_idle_liteetharp_next_value_ce1 <= 1'd1;
				top_arp_rx_depacketizer_data_copy_first_liteetharp_next_value2 <= 1'd1;
				top_arp_rx_depacketizer_data_copy_first_liteetharp_next_value_ce2 <= 1'd1;
				if (1'd0) begin
					liteetharprx_liteetharpdepacketizer_next_state <= 2'd2;
				end else begin
					liteetharprx_liteetharpdepacketizer_next_state <= 1'd1;
				end
				if (($signed({1'd0, top_arp_rx_depacketizer_sink_last}) & 1'sd1)) begin
					liteetharprx_liteetharpdepacketizer_next_state <= 1'd0;
				end
			end
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
	top_arp_rx_source_source_valid <= 1'd0;
	top_arp_rx_source_source_payload_reply <= 1'd0;
	top_arp_rx_source_source_payload_request <= 1'd0;
	top_arp_rx_depacketizer_source_ready <= 1'd0;
	liteetharprx_fsm_next_state <= 2'd0;
	liteetharprx_fsm_next_state <= liteetharprx_fsm_state;
	case (liteetharprx_fsm_state)
		1'd1: begin
			if (top_arp_rx_valid) begin
				top_arp_rx_source_source_valid <= 1'd1;
				top_arp_rx_source_source_payload_reply <= top_arp_rx_reply;
				top_arp_rx_source_source_payload_request <= top_arp_rx_request;
			end
			liteetharprx_fsm_next_state <= 2'd2;
		end
		2'd2: begin
			top_arp_rx_depacketizer_source_ready <= 1'd1;
			if ((top_arp_rx_depacketizer_source_valid & top_arp_rx_depacketizer_source_last)) begin
				liteetharprx_fsm_next_state <= 1'd0;
			end
		end
		default: begin
			top_arp_rx_depacketizer_source_ready <= 1'd1;
			if (top_arp_rx_depacketizer_source_valid) begin
				top_arp_rx_depacketizer_source_ready <= 1'd0;
				liteetharprx_fsm_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_51 <= dummy_s;
// synthesis translate_on
end
assign top_arp_table_request_timer_wait = (top_arp_table_request_pending & (~top_arp_table_request_timer_done));
assign top_arp_table_request_timer_done = (top_arp_table_request_timer_count == 1'd0);

// synthesis translate_off
reg dummy_d_52;
// synthesis translate_on
always @(*) begin
	top_arp_table_cache_mem_wr_port_dat_w <= 81'd0;
	top_arp_table_cache_mem_wr_port_dat_w[80] <= top_arp_table_cache_mem_wr_port_valid;
	top_arp_table_cache_mem_wr_port_dat_w[31:0] <= top_arp_table_cache_mem_wr_port_ip_address;
	top_arp_table_cache_mem_wr_port_dat_w[79:32] <= top_arp_table_cache_mem_wr_port_mac_address;
// synthesis translate_off
	dummy_d_52 <= dummy_s;
// synthesis translate_on
end
assign top_arp_table_cache_mem_rd_port_valid = top_arp_table_cache_mem_rd_port_dat_r[80];
assign top_arp_table_cache_mem_rd_port_ip_address = top_arp_table_cache_mem_rd_port_dat_r[31:0];
assign top_arp_table_cache_mem_rd_port_mac_address = top_arp_table_cache_mem_rd_port_dat_r[79:32];
assign top_arp_table_cache_done = (top_arp_table_cache_count == 1'd0);

// synthesis translate_off
reg dummy_d_53;
// synthesis translate_on
always @(*) begin
	top_arp_table_cache_update_ready <= 1'd0;
	top_arp_table_cache_request_ready <= 1'd0;
	top_arp_table_cache_response_valid <= 1'd0;
	top_arp_table_cache_response_payload_mac_address <= 48'd0;
	top_arp_table_cache_response_payload_error <= 1'd0;
	top_arp_table_cache_mem_wr_port_adr <= 1'd0;
	top_arp_table_cache_mem_wr_port_we <= 1'd0;
	top_arp_table_cache_mem_rd_port_adr <= 1'd0;
	top_arp_table_cache_mem_wr_port_valid <= 1'd0;
	top_arp_table_cache_mem_wr_port_ip_address <= 32'd0;
	top_arp_table_cache_mem_wr_port_mac_address <= 48'd0;
	top_arp_table_cache_wait <= 1'd0;
	liteetharptable_liteetharpcache_next_state <= 3'd0;
	top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value0 <= 1'd0;
	top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce0 <= 1'd0;
	top_arp_table_cache_search_count_liteetharp_liteetharptable_liteetharpcache_next_value1 <= 1'd0;
	top_arp_table_cache_search_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce1 <= 1'd0;
	top_arp_table_cache_error_liteetharp_liteetharptable_liteetharpcache_next_value2 <= 1'd0;
	top_arp_table_cache_error_liteetharp_liteetharptable_liteetharpcache_next_value_ce2 <= 1'd0;
	liteetharptable_liteetharpcache_next_state <= liteetharptable_liteetharpcache_state;
	case (liteetharptable_liteetharpcache_state)
		1'd1: begin
			if ((top_arp_table_cache_enable & top_arp_table_cache_update_valid)) begin
				liteetharptable_liteetharpcache_next_state <= 2'd2;
			end
			if ((top_arp_table_cache_enable & top_arp_table_cache_request_valid)) begin
				top_arp_table_cache_search_count_liteetharp_liteetharptable_liteetharpcache_next_value1 <= 1'd0;
				top_arp_table_cache_search_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce1 <= 1'd1;
				liteetharptable_liteetharpcache_next_state <= 2'd3;
			end
			top_arp_table_cache_wait <= top_arp_table_cache_clear_enable;
			if (top_arp_table_cache_done) begin
				top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value0 <= 1'd0;
				top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce0 <= 1'd1;
				liteetharptable_liteetharpcache_next_state <= 1'd0;
			end
		end
		2'd2: begin
			top_arp_table_cache_mem_wr_port_we <= 1'd1;
			top_arp_table_cache_mem_wr_port_adr <= top_arp_table_cache_update_count;
			top_arp_table_cache_mem_wr_port_valid <= 1'd1;
			top_arp_table_cache_mem_wr_port_ip_address <= top_arp_table_cache_update_payload_ip_address;
			top_arp_table_cache_mem_wr_port_mac_address <= top_arp_table_cache_update_payload_mac_address;
			top_arp_table_cache_update_ready <= 1'd1;
			if ((top_arp_table_cache_update_count == 1'd1)) begin
				top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value0 <= 1'd0;
				top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce0 <= 1'd1;
			end else begin
				top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value0 <= (top_arp_table_cache_update_count + 1'd1);
				top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce0 <= 1'd1;
			end
			liteetharptable_liteetharpcache_next_state <= 1'd1;
		end
		2'd3: begin
			top_arp_table_cache_mem_rd_port_adr <= top_arp_table_cache_search_count;
			if ((top_arp_table_cache_mem_rd_port_valid & (top_arp_table_cache_mem_rd_port_ip_address == top_arp_table_cache_request_payload_ip_address))) begin
				top_arp_table_cache_error_liteetharp_liteetharptable_liteetharpcache_next_value2 <= 1'd0;
				top_arp_table_cache_error_liteetharp_liteetharptable_liteetharpcache_next_value_ce2 <= 1'd1;
				liteetharptable_liteetharpcache_next_state <= 3'd4;
			end else begin
				if ((top_arp_table_cache_search_count == 1'd1)) begin
					top_arp_table_cache_error_liteetharp_liteetharptable_liteetharpcache_next_value2 <= 1'd1;
					top_arp_table_cache_error_liteetharp_liteetharptable_liteetharpcache_next_value_ce2 <= 1'd1;
					liteetharptable_liteetharpcache_next_state <= 3'd4;
				end else begin
					top_arp_table_cache_search_count_liteetharp_liteetharptable_liteetharpcache_next_value1 <= (top_arp_table_cache_search_count + 1'd1);
					top_arp_table_cache_search_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce1 <= 1'd1;
				end
			end
		end
		3'd4: begin
			top_arp_table_cache_mem_rd_port_adr <= top_arp_table_cache_search_count;
			top_arp_table_cache_request_ready <= 1'd1;
			top_arp_table_cache_response_valid <= 1'd1;
			top_arp_table_cache_response_payload_error <= top_arp_table_cache_error;
			top_arp_table_cache_response_payload_mac_address <= top_arp_table_cache_mem_rd_port_mac_address;
			liteetharptable_liteetharpcache_next_state <= 1'd1;
		end
		default: begin
			top_arp_table_cache_mem_wr_port_we <= 1'd1;
			top_arp_table_cache_mem_wr_port_adr <= top_arp_table_cache_update_count;
			top_arp_table_cache_mem_wr_port_valid <= 1'd0;
			top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value0 <= (top_arp_table_cache_update_count + 1'd1);
			top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce0 <= 1'd1;
			if ((top_arp_table_cache_update_count == 1'd1)) begin
				top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value0 <= 1'd0;
				top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce0 <= 1'd1;
				liteetharptable_liteetharpcache_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_53 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_54;
// synthesis translate_on
always @(*) begin
	top_arp_table_source_valid <= 1'd0;
	top_arp_table_source_payload_reply <= 1'd0;
	top_arp_table_source_payload_request <= 1'd0;
	top_arp_table_source_payload_ip_address <= 32'd0;
	top_arp_table_source_payload_mac_address <= 48'd0;
	top_arp_table_request_request_ready <= 1'd0;
	top_arp_table_response_response_valid <= 1'd0;
	top_arp_table_cache_update_valid <= 1'd0;
	top_arp_table_cache_update_payload_ip_address <= 32'd0;
	top_arp_table_cache_update_payload_mac_address <= 48'd0;
	top_arp_table_cache_request_valid <= 1'd0;
	top_arp_table_cache_request_payload_ip_address <= 32'd0;
	liteetharptable_fsm_next_state <= 3'd0;
	top_arp_table_request_pending_liteetharp_liteetharptable_fsm_next_value0 <= 1'd0;
	top_arp_table_request_pending_liteetharp_liteetharptable_fsm_next_value_ce0 <= 1'd0;
	top_arp_table_response_response_payload_mac_address_liteetharp_liteetharptable_fsm_next_value1 <= 48'd0;
	top_arp_table_response_response_payload_mac_address_liteetharp_liteetharptable_fsm_next_value_ce1 <= 1'd0;
	top_arp_table_response_response_payload_failed_liteetharp_liteetharptable_fsm_next_value2 <= 1'd0;
	top_arp_table_response_response_payload_failed_liteetharp_liteetharptable_fsm_next_value_ce2 <= 1'd0;
	top_arp_table_request_counter_liteetharp_liteetharptable_fsm_next_value3 <= 3'd0;
	top_arp_table_request_counter_liteetharp_liteetharptable_fsm_next_value_ce3 <= 1'd0;
	top_arp_table_request_ip_address_liteetharp_liteetharptable_fsm_next_value4 <= 32'd0;
	top_arp_table_request_ip_address_liteetharp_liteetharptable_fsm_next_value_ce4 <= 1'd0;
	liteetharptable_fsm_next_state <= liteetharptable_fsm_state;
	case (liteetharptable_fsm_state)
		1'd1: begin
			top_arp_table_source_valid <= 1'd1;
			top_arp_table_source_payload_reply <= 1'd1;
			top_arp_table_source_payload_ip_address <= top_arp_table_sink_payload_ip_address;
			top_arp_table_source_payload_mac_address <= top_arp_table_sink_payload_mac_address;
			if (top_arp_table_source_ready) begin
				liteetharptable_fsm_next_state <= 1'd0;
			end
		end
		2'd2: begin
			if ((top_arp_table_request_pending & (top_arp_table_request_ip_address == top_arp_table_sink_payload_ip_address))) begin
				top_arp_table_cache_update_valid <= 1'd1;
				top_arp_table_cache_update_payload_ip_address <= top_arp_table_sink_payload_ip_address;
				top_arp_table_cache_update_payload_mac_address <= top_arp_table_sink_payload_mac_address;
				if (top_arp_table_cache_update_ready) begin
					top_arp_table_request_pending_liteetharp_liteetharptable_fsm_next_value0 <= 1'd0;
					top_arp_table_request_pending_liteetharp_liteetharptable_fsm_next_value_ce0 <= 1'd1;
					top_arp_table_response_response_payload_mac_address_liteetharp_liteetharptable_fsm_next_value1 <= top_arp_table_sink_payload_mac_address;
					top_arp_table_response_response_payload_mac_address_liteetharp_liteetharptable_fsm_next_value_ce1 <= 1'd1;
					liteetharptable_fsm_next_state <= 3'd6;
				end
			end else begin
				liteetharptable_fsm_next_state <= 1'd0;
			end
		end
		2'd3: begin
			if ((top_arp_table_request_counter == 3'd7)) begin
				top_arp_table_response_response_payload_failed_liteetharp_liteetharptable_fsm_next_value2 <= 1'd1;
				top_arp_table_response_response_payload_failed_liteetharp_liteetharptable_fsm_next_value_ce2 <= 1'd1;
				top_arp_table_request_counter_liteetharp_liteetharptable_fsm_next_value3 <= 1'd0;
				top_arp_table_request_counter_liteetharp_liteetharptable_fsm_next_value_ce3 <= 1'd1;
				top_arp_table_request_pending_liteetharp_liteetharptable_fsm_next_value0 <= 1'd0;
				top_arp_table_request_pending_liteetharp_liteetharptable_fsm_next_value_ce0 <= 1'd1;
				liteetharptable_fsm_next_state <= 3'd6;
			end else begin
				liteetharptable_fsm_next_state <= 3'd5;
			end
		end
		3'd4: begin
			top_arp_table_cache_request_valid <= 1'd1;
			top_arp_table_cache_request_payload_ip_address <= top_arp_table_request_request_payload_ip_address;
			if (top_arp_table_cache_response_valid) begin
				top_arp_table_request_request_ready <= 1'd1;
				if (top_arp_table_cache_response_payload_error) begin
					top_arp_table_request_counter_liteetharp_liteetharptable_fsm_next_value3 <= 1'd0;
					top_arp_table_request_counter_liteetharp_liteetharptable_fsm_next_value_ce3 <= 1'd1;
					top_arp_table_request_pending_liteetharp_liteetharptable_fsm_next_value0 <= 1'd1;
					top_arp_table_request_pending_liteetharp_liteetharptable_fsm_next_value_ce0 <= 1'd1;
					top_arp_table_request_ip_address_liteetharp_liteetharptable_fsm_next_value4 <= top_arp_table_request_request_payload_ip_address;
					top_arp_table_request_ip_address_liteetharp_liteetharptable_fsm_next_value_ce4 <= 1'd1;
					liteetharptable_fsm_next_state <= 3'd5;
				end else begin
					top_arp_table_response_response_payload_mac_address_liteetharp_liteetharptable_fsm_next_value1 <= top_arp_table_cache_response_payload_mac_address;
					top_arp_table_response_response_payload_mac_address_liteetharp_liteetharptable_fsm_next_value_ce1 <= 1'd1;
					liteetharptable_fsm_next_state <= 3'd6;
				end
			end
		end
		3'd5: begin
			top_arp_table_source_valid <= 1'd1;
			top_arp_table_source_payload_request <= 1'd1;
			top_arp_table_source_payload_ip_address <= top_arp_table_request_ip_address;
			if (top_arp_table_source_ready) begin
				top_arp_table_request_counter_liteetharp_liteetharptable_fsm_next_value3 <= (top_arp_table_request_counter + 1'd1);
				top_arp_table_request_counter_liteetharp_liteetharptable_fsm_next_value_ce3 <= 1'd1;
				liteetharptable_fsm_next_state <= 1'd0;
			end
		end
		3'd6: begin
			top_arp_table_response_response_valid <= 1'd1;
			if (top_arp_table_response_response_ready) begin
				top_arp_table_response_response_payload_failed_liteetharp_liteetharptable_fsm_next_value2 <= 1'd0;
				top_arp_table_response_response_payload_failed_liteetharp_liteetharptable_fsm_next_value_ce2 <= 1'd1;
				liteetharptable_fsm_next_state <= 1'd0;
			end
		end
		default: begin
			if ((top_arp_table_sink_valid & top_arp_table_sink_payload_request)) begin
				liteetharptable_fsm_next_state <= 1'd1;
			end else begin
				if ((top_arp_table_sink_valid & top_arp_table_sink_payload_reply)) begin
					liteetharptable_fsm_next_state <= 2'd2;
				end else begin
					if (top_arp_table_request_request_valid) begin
						liteetharptable_fsm_next_state <= 3'd4;
					end else begin
						if (top_arp_table_request_timer_done) begin
							liteetharptable_fsm_next_state <= 2'd3;
						end
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_54 <= dummy_s;
// synthesis translate_on
end
assign top_ip_mac_port_sink_valid = top_ip_tx_source_source_valid0;
assign top_ip_tx_source_source_ready0 = top_ip_mac_port_sink_ready;
assign top_ip_mac_port_sink_first = top_ip_tx_source_source_first0;
assign top_ip_mac_port_sink_last = top_ip_tx_source_source_last0;
assign top_ip_mac_port_sink_payload_ethernet_type = top_ip_tx_source_source_payload_ethernet_type;
assign top_ip_mac_port_sink_payload_sender_mac = top_ip_tx_source_source_payload_sender_mac;
assign top_ip_mac_port_sink_payload_target_mac = top_ip_tx_source_source_payload_target_mac;
assign top_ip_mac_port_sink_payload_data = top_ip_tx_source_source_payload_data0;
assign top_ip_mac_port_sink_payload_be = top_ip_tx_source_source_payload_be0;
assign top_ip_mac_port_sink_payload_error = top_ip_tx_source_source_payload_error0;
assign top_ip_rx_sink_sink_valid = top_ip_mac_port_source_valid;
assign top_ip_mac_port_source_ready = top_ip_rx_sink_sink_ready;
assign top_ip_rx_sink_sink_first = top_ip_mac_port_source_first;
assign top_ip_rx_sink_sink_last = top_ip_mac_port_source_last;
assign top_ip_rx_sink_sink_payload_ethernet_type = top_ip_mac_port_source_payload_ethernet_type;
assign top_ip_rx_sink_sink_payload_sender_mac = top_ip_mac_port_source_payload_sender_mac;
assign top_ip_rx_sink_sink_payload_target_mac = top_ip_mac_port_source_payload_target_mac;
assign top_ip_rx_sink_sink_payload_data = top_ip_mac_port_source_payload_data;
assign top_ip_rx_sink_sink_payload_be = top_ip_mac_port_source_payload_be;
assign top_ip_rx_sink_sink_payload_error = top_ip_mac_port_source_payload_error;
assign top_ip_tx_sink_sink_valid0 = top_ip_crossbar_source_valid;
assign top_ip_crossbar_source_ready = top_ip_tx_sink_sink_ready0;
assign top_ip_tx_sink_sink_first0 = top_ip_crossbar_source_first;
assign top_ip_tx_sink_sink_last0 = top_ip_crossbar_source_last;
assign top_ip_tx_sink_sink_payload_data0 = top_ip_crossbar_source_payload_data;
assign top_ip_tx_sink_sink_payload_be0 = top_ip_crossbar_source_payload_be;
assign top_ip_tx_sink_sink_payload_error0 = top_ip_crossbar_source_payload_error;
assign top_ip_tx_sink_sink_param_length0 = top_ip_crossbar_source_param_length;
assign top_ip_tx_sink_sink_param_protocol0 = top_ip_crossbar_source_param_protocol;
assign top_ip_tx_sink_sink_param_ip_address0 = top_ip_crossbar_source_param_ip_address;
assign top_ip_crossbar_sink_valid = top_ip_rx_source_source_valid;
assign top_ip_rx_source_source_ready = top_ip_crossbar_sink_ready;
assign top_ip_crossbar_sink_first = top_ip_rx_source_source_first;
assign top_ip_crossbar_sink_last = top_ip_rx_source_source_last;
assign top_ip_crossbar_sink_payload_data = top_ip_rx_source_source_payload_data;
assign top_ip_crossbar_sink_payload_be = top_ip_rx_source_source_payload_be;
assign top_ip_crossbar_sink_payload_error = top_ip_rx_source_source_payload_error;
assign top_ip_crossbar_sink_param_length = top_ip_rx_source_source_param_length;
assign top_ip_crossbar_sink_param_protocol = top_ip_rx_source_source_param_protocol;
assign top_ip_crossbar_sink_param_ip_address = top_ip_rx_source_source_param_ip_address;
assign top_ip_tx_sink_sink_valid1 = top_ip_tx_sink_sink_valid0;
assign top_ip_tx_sink_sink_ready0 = top_ip_tx_sink_sink_ready1;
assign top_ip_tx_sink_sink_first1 = top_ip_tx_sink_sink_first0;
assign top_ip_tx_sink_sink_last1 = top_ip_tx_sink_sink_last0;
assign top_ip_tx_sink_sink_payload_data1 = top_ip_tx_sink_sink_payload_data0;
assign top_ip_tx_sink_sink_payload_be1 = top_ip_tx_sink_sink_payload_be0;
assign top_ip_tx_sink_sink_payload_error1 = top_ip_tx_sink_sink_payload_error0;
assign top_ip_tx_sink_sink_param_length1 = top_ip_tx_sink_sink_param_length0;
assign top_ip_tx_sink_sink_param_protocol1 = top_ip_tx_sink_sink_param_protocol0;
assign top_ip_tx_sink_sink_param_ip_address1 = top_ip_tx_sink_sink_param_ip_address0;
assign top_ip_tx_ce = top_ip_tx_source_source_valid1;
assign top_ip_tx_reset = ((top_ip_tx_packetizer_source_valid & top_ip_tx_packetizer_source_last) & top_ip_tx_packetizer_source_ready);
assign top_ip_tx_packetizer_sink_last = top_ip_tx_source_source_last1;
assign top_ip_tx_packetizer_sink_payload_data = top_ip_tx_source_source_payload_data1;
assign top_ip_tx_packetizer_sink_payload_be = top_ip_tx_source_source_payload_be1;
assign top_ip_tx_packetizer_sink_param_protocol = top_ip_tx_source_source_param_protocol;
assign top_ip_tx_packetizer_sink_valid = (top_ip_tx_source_source_valid1 & top_ip_tx_liteethipv4checksum_done);
assign top_ip_tx_source_source_ready1 = (top_ip_tx_packetizer_sink_ready & top_ip_tx_liteethipv4checksum_done);
assign top_ip_tx_packetizer_sink_param_target_ip = top_ip_tx_source_source_param_ip_address;
assign top_ip_tx_packetizer_sink_param_total_length = (5'd20 + top_ip_tx_source_source_param_length);
assign top_ip_tx_packetizer_sink_param_version = 3'd4;
assign top_ip_tx_packetizer_sink_param_ihl = 3'd5;
assign top_ip_tx_packetizer_sink_param_identification = 1'd0;
assign top_ip_tx_packetizer_sink_param_flags_offset = 1'd0;
assign top_ip_tx_packetizer_sink_param_ttl = 8'd128;
assign top_ip_tx_packetizer_sink_param_sender_ip = 32'd3232236272;
assign top_ip_tx_liteethipv4checksum_header = top_ip_tx_packetizer_header;
assign top_ip_tx_packetizer_sink_param_checksum = top_ip_tx_liteethipv4checksum_value;
assign top_ip_tx_source_source_first0 = top_ip_tx_packetizer_source_first;
assign top_ip_tx_source_source_last0 = top_ip_tx_packetizer_source_last;
assign top_ip_tx_source_source_payload_data0 = top_ip_tx_packetizer_source_payload_data;
assign top_ip_tx_source_source_payload_be0 = top_ip_tx_packetizer_source_payload_be;
assign top_ip_tx_source_source_payload_error0 = top_ip_tx_packetizer_source_payload_error;
assign top_ip_tx_source_source_valid0 = (top_ip_tx_packetizer_source_valid & top_ip_tx_fsm_is_ongoing0);
assign top_ip_tx_packetizer_source_ready = (top_ip_tx_fsm_is_ongoing1 | (top_ip_tx_fsm_is_ongoing2 & top_ip_tx_source_source_ready0));
assign top_ip_tx_source_source_payload_ethernet_type = 12'd2048;
assign top_ip_tx_source_source_payload_target_mac = top_ip_tx_target_mac;
assign top_ip_tx_source_source_payload_sender_mac = 42'd2199023260161;
assign top_arp_table_request_request_payload_ip_address = top_ip_tx_source_source_param_ip_address;
assign top_ip_tx_pipe_valid_sink_ready = ((~top_ip_tx_pipe_valid_source_valid) | top_ip_tx_pipe_valid_source_ready);
assign top_ip_tx_pipe_valid_sink_valid = top_ip_tx_sink_sink_valid1;
assign top_ip_tx_sink_sink_ready1 = top_ip_tx_pipe_valid_sink_ready;
assign top_ip_tx_pipe_valid_sink_first = top_ip_tx_sink_sink_first1;
assign top_ip_tx_pipe_valid_sink_last = top_ip_tx_sink_sink_last1;
assign top_ip_tx_pipe_valid_sink_payload_data = top_ip_tx_sink_sink_payload_data1;
assign top_ip_tx_pipe_valid_sink_payload_be = top_ip_tx_sink_sink_payload_be1;
assign top_ip_tx_pipe_valid_sink_payload_error = top_ip_tx_sink_sink_payload_error1;
assign top_ip_tx_pipe_valid_sink_param_length = top_ip_tx_sink_sink_param_length1;
assign top_ip_tx_pipe_valid_sink_param_protocol = top_ip_tx_sink_sink_param_protocol1;
assign top_ip_tx_pipe_valid_sink_param_ip_address = top_ip_tx_sink_sink_param_ip_address1;
assign top_ip_tx_source_source_valid1 = top_ip_tx_pipe_valid_source_valid;
assign top_ip_tx_pipe_valid_source_ready = top_ip_tx_source_source_ready1;
assign top_ip_tx_source_source_first1 = top_ip_tx_pipe_valid_source_first;
assign top_ip_tx_source_source_last1 = top_ip_tx_pipe_valid_source_last;
assign top_ip_tx_source_source_payload_data1 = top_ip_tx_pipe_valid_source_payload_data;
assign top_ip_tx_source_source_payload_be1 = top_ip_tx_pipe_valid_source_payload_be;
assign top_ip_tx_source_source_payload_error1 = top_ip_tx_pipe_valid_source_payload_error;
assign top_ip_tx_source_source_param_length = top_ip_tx_pipe_valid_source_param_length;
assign top_ip_tx_source_source_param_protocol = top_ip_tx_pipe_valid_source_param_protocol;
assign top_ip_tx_source_source_param_ip_address = top_ip_tx_pipe_valid_source_param_ip_address;
assign top_ip_tx_liteethipv4checksum_s_next0 = (top_ip_tx_liteethipv4checksum_r + top_ip_tx_liteethipv4checksum_header[15:0]);
assign top_ip_tx_liteethipv4checksum_s_next1 = (top_ip_tx_liteethipv4checksum_r_next0 + top_ip_tx_liteethipv4checksum_header[31:16]);
assign top_ip_tx_liteethipv4checksum_s_next2 = (top_ip_tx_liteethipv4checksum_r_next1 + top_ip_tx_liteethipv4checksum_header[47:32]);
assign top_ip_tx_liteethipv4checksum_s_next3 = (top_ip_tx_liteethipv4checksum_r_next2 + top_ip_tx_liteethipv4checksum_header[63:48]);
assign top_ip_tx_liteethipv4checksum_s_next4 = (top_ip_tx_liteethipv4checksum_r_next3 + top_ip_tx_liteethipv4checksum_header[79:64]);
assign top_ip_tx_liteethipv4checksum_s_next5 = (top_ip_tx_liteethipv4checksum_r_next4 + top_ip_tx_liteethipv4checksum_header[111:96]);
assign top_ip_tx_liteethipv4checksum_s_next6 = (top_ip_tx_liteethipv4checksum_r_next5 + top_ip_tx_liteethipv4checksum_header[127:112]);
assign top_ip_tx_liteethipv4checksum_s_next7 = (top_ip_tx_liteethipv4checksum_r_next6 + top_ip_tx_liteethipv4checksum_header[143:128]);
assign top_ip_tx_liteethipv4checksum_s_next8 = (top_ip_tx_liteethipv4checksum_r_next7 + top_ip_tx_liteethipv4checksum_header[159:144]);
assign top_ip_tx_liteethipv4checksum_value = (~{top_ip_tx_liteethipv4checksum_r_next8[7:0], top_ip_tx_liteethipv4checksum_r_next8[15:8]});
assign top_ip_tx_liteethipv4checksum_counter_ce = (~top_ip_tx_liteethipv4checksum_done);
assign top_ip_tx_liteethipv4checksum_done = (top_ip_tx_liteethipv4checksum_counter == 4'd9);

// synthesis translate_off
reg dummy_d_55;
// synthesis translate_on
always @(*) begin
	top_ip_tx_packetizer_header <= 160'd0;
	top_ip_tx_packetizer_header[95:80] <= {top_ip_tx_packetizer_sink_param_checksum[7:0], top_ip_tx_packetizer_sink_param_checksum[15:8]};
	top_ip_tx_packetizer_header[63:48] <= {top_ip_tx_packetizer_sink_param_flags_offset[7:0], top_ip_tx_packetizer_sink_param_flags_offset[15:8]};
	top_ip_tx_packetizer_header[47:32] <= {top_ip_tx_packetizer_sink_param_identification[7:0], top_ip_tx_packetizer_sink_param_identification[15:8]};
	top_ip_tx_packetizer_header[3:0] <= {top_ip_tx_packetizer_sink_param_ihl[3:0]};
	top_ip_tx_packetizer_header[79:72] <= {top_ip_tx_packetizer_sink_param_protocol[7:0]};
	top_ip_tx_packetizer_header[127:96] <= {top_ip_tx_packetizer_sink_param_sender_ip[7:0], top_ip_tx_packetizer_sink_param_sender_ip[15:8], top_ip_tx_packetizer_sink_param_sender_ip[23:16], top_ip_tx_packetizer_sink_param_sender_ip[31:24]};
	top_ip_tx_packetizer_header[159:128] <= {top_ip_tx_packetizer_sink_param_target_ip[7:0], top_ip_tx_packetizer_sink_param_target_ip[15:8], top_ip_tx_packetizer_sink_param_target_ip[23:16], top_ip_tx_packetizer_sink_param_target_ip[31:24]};
	top_ip_tx_packetizer_header[31:16] <= {top_ip_tx_packetizer_sink_param_total_length[7:0], top_ip_tx_packetizer_sink_param_total_length[15:8]};
	top_ip_tx_packetizer_header[71:64] <= {top_ip_tx_packetizer_sink_param_ttl[7:0]};
	top_ip_tx_packetizer_header[7:4] <= {top_ip_tx_packetizer_sink_param_version[3:0]};
// synthesis translate_off
	dummy_d_55 <= dummy_s;
// synthesis translate_on
end
assign top_ip_tx_packetizer_source_payload_be = top_ip_tx_packetizer_source_be;

// synthesis translate_off
reg dummy_d_56;
// synthesis translate_on
always @(*) begin
	top_ip_tx_packetizer_source_payload_error <= 1'd0;
	if (top_ip_tx_packetizer_is_ongoing) begin
		top_ip_tx_packetizer_source_payload_error <= top_ip_tx_packetizer_sink_payload_error;
	end
// synthesis translate_off
	dummy_d_56 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_57;
// synthesis translate_on
always @(*) begin
	top_ip_tx_packetizer_sink_ready <= 1'd0;
	top_ip_tx_packetizer_source_valid <= 1'd0;
	top_ip_tx_packetizer_source_first <= 1'd0;
	top_ip_tx_packetizer_source_last <= 1'd0;
	top_ip_tx_packetizer_source_payload_data <= 8'd0;
	top_ip_tx_packetizer_source_be <= 1'd1;
	top_ip_tx_packetizer_is_ongoing <= 1'd0;
	liteethip_liteethiptx_liteethipv4packetizer_next_state <= 1'd0;
	top_ip_tx_packetizer_count_liteethip_liteethipv4packetizer_next_value <= 5'd0;
	top_ip_tx_packetizer_count_liteethip_liteethipv4packetizer_next_value_ce <= 1'd0;
	liteethip_liteethiptx_liteethipv4packetizer_next_state <= liteethip_liteethiptx_liteethipv4packetizer_state;
	case (liteethip_liteethiptx_liteethipv4packetizer_state)
		1'd0: begin
			top_ip_tx_packetizer_is_ongoing <= 1'd1;
			top_ip_tx_packetizer_source_valid <= top_ip_tx_packetizer_sink_valid;
			top_ip_tx_packetizer_sink_ready <= top_ip_tx_packetizer_source_ready;
			top_ip_tx_packetizer_source_last <= top_ip_tx_packetizer_sink_last;
			top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_sink_payload_data;
			top_ip_tx_packetizer_source_be <= top_ip_tx_packetizer_sink_payload_be;
			if (((top_ip_tx_packetizer_source_valid & top_ip_tx_packetizer_source_ready) & top_ip_tx_packetizer_source_last)) begin
				liteethip_liteethiptx_liteethipv4packetizer_next_state <= 1'd1;
			end
		end
		default: begin
			top_ip_tx_packetizer_sink_ready <= (top_ip_tx_packetizer_count == 1'd0);
			case (top_ip_tx_packetizer_count)
				1'd0: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[7:0];
				end
				1'd1: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[15:8];
				end
				2'd2: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[23:16];
				end
				2'd3: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[31:24];
				end
				3'd4: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[39:32];
				end
				3'd5: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[47:40];
				end
				3'd6: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[55:48];
				end
				3'd7: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[63:56];
				end
				4'd8: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[71:64];
				end
				4'd9: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[79:72];
				end
				4'd10: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[87:80];
				end
				4'd11: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[95:88];
				end
				4'd12: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[103:96];
				end
				4'd13: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[111:104];
				end
				4'd14: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[119:112];
				end
				4'd15: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[127:120];
				end
				5'd16: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[135:128];
				end
				5'd17: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[143:136];
				end
				5'd18: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[151:144];
				end
				5'd19: begin
					top_ip_tx_packetizer_source_payload_data <= top_ip_tx_packetizer_header[159:152];
				end
			endcase
			if ((top_ip_tx_packetizer_count == 5'd19)) begin
				top_ip_tx_packetizer_source_be <= 1'd1;
			end
			if ((top_ip_tx_packetizer_sink_valid & 1'd1)) begin
				top_ip_tx_packetizer_source_valid <= 1'd1;
				top_ip_tx_packetizer_source_first <= (top_ip_tx_packetizer_count == 1'd0);
				top_ip_tx_packetizer_source_last <= ((top_ip_tx_packetizer_count == 5'd19) & (top_ip_tx_packetizer_sink_last & (top_ip_tx_packetizer_sink_payload_be == 1'd0)));
				top_ip_tx_packetizer_sink_ready <= (((top_ip_tx_packetizer_count == 5'd19) & (top_ip_tx_packetizer_sink_last & (top_ip_tx_packetizer_sink_payload_be == 1'd0))) & top_ip_tx_packetizer_source_ready);
				if (top_ip_tx_packetizer_source_ready) begin
					if ((top_ip_tx_packetizer_count == 5'd19)) begin
						top_ip_tx_packetizer_count_liteethip_liteethipv4packetizer_next_value <= 1'd0;
						top_ip_tx_packetizer_count_liteethip_liteethipv4packetizer_next_value_ce <= 1'd1;
						if ((~top_ip_tx_packetizer_source_last)) begin
							liteethip_liteethiptx_liteethipv4packetizer_next_state <= 1'd0;
						end
					end else begin
						top_ip_tx_packetizer_count_liteethip_liteethipv4packetizer_next_value <= (top_ip_tx_packetizer_count + 1'd1);
						top_ip_tx_packetizer_count_liteethip_liteethipv4packetizer_next_value_ce <= 1'd1;
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_57 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_58;
// synthesis translate_on
always @(*) begin
	top_arp_table_request_request_valid <= 1'd0;
	top_arp_table_response_response_ready <= 1'd0;
	top_ip_tx_target_unreachable <= 1'd0;
	top_ip_tx_fsm_is_ongoing0 <= 1'd0;
	top_ip_tx_fsm_is_ongoing1 <= 1'd0;
	top_ip_tx_fsm_is_ongoing2 <= 1'd0;
	liteethip_liteethiptx_fsm_next_state <= 3'd0;
	top_ip_tx_target_mac_liteethip_fsm_next_value <= 48'd0;
	top_ip_tx_target_mac_liteethip_fsm_next_value_ce <= 1'd0;
	liteethip_liteethiptx_fsm_next_state <= liteethip_liteethiptx_fsm_state;
	case (liteethip_liteethiptx_fsm_state)
		1'd0: begin
			top_ip_tx_fsm_is_ongoing0 <= 1'd1;
			top_ip_tx_fsm_is_ongoing2 <= 1'd1;
			if (((top_ip_tx_source_source_valid0 & top_ip_tx_source_source_last0) & top_ip_tx_source_source_ready0)) begin
				liteethip_liteethiptx_fsm_next_state <= 2'd2;
			end
		end
		1'd1: begin
			top_ip_tx_fsm_is_ongoing1 <= 1'd1;
			if (((top_ip_tx_packetizer_source_valid & top_ip_tx_packetizer_source_last) & top_ip_tx_packetizer_source_ready)) begin
				liteethip_liteethiptx_fsm_next_state <= 2'd2;
			end
		end
		2'd3: begin
			top_arp_table_request_request_valid <= 1'd1;
			if ((top_arp_table_request_request_valid & top_arp_table_request_request_ready)) begin
				liteethip_liteethiptx_fsm_next_state <= 3'd4;
			end
		end
		3'd4: begin
			if (top_arp_table_response_response_valid) begin
				top_ip_tx_target_mac_liteethip_fsm_next_value <= top_arp_table_response_response_payload_mac_address;
				top_ip_tx_target_mac_liteethip_fsm_next_value_ce <= 1'd1;
				top_arp_table_response_response_ready <= 1'd1;
				if (top_arp_table_response_response_payload_failed) begin
					top_ip_tx_target_unreachable <= 1'd1;
					liteethip_liteethiptx_fsm_next_state <= 1'd1;
				end else begin
					liteethip_liteethiptx_fsm_next_state <= 1'd0;
				end
			end
		end
		default: begin
			if (top_ip_tx_packetizer_source_valid) begin
				if ((top_ip_tx_source_source_param_ip_address[7:0] == 8'd255)) begin
					top_ip_tx_target_mac_liteethip_fsm_next_value <= 48'd281474976710655;
					top_ip_tx_target_mac_liteethip_fsm_next_value_ce <= 1'd1;
					liteethip_liteethiptx_fsm_next_state <= 1'd0;
				end else begin
					if ((top_ip_tx_source_source_param_ip_address[31:28] == 4'd14)) begin
						top_ip_tx_target_mac_liteethip_fsm_next_value <= {24'd65630, 1'd0, top_ip_tx_source_source_param_ip_address[22:0]};
						top_ip_tx_target_mac_liteethip_fsm_next_value_ce <= 1'd1;
						liteethip_liteethiptx_fsm_next_state <= 1'd0;
					end else begin
						liteethip_liteethiptx_fsm_next_state <= 2'd3;
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_58 <= dummy_s;
// synthesis translate_on
end
assign top_ip_rx_depacketizer_sink_valid = top_ip_rx_sink_sink_valid;
assign top_ip_rx_sink_sink_ready = top_ip_rx_depacketizer_sink_ready;
assign top_ip_rx_depacketizer_sink_first = top_ip_rx_sink_sink_first;
assign top_ip_rx_depacketizer_sink_last = top_ip_rx_sink_sink_last;
assign top_ip_rx_depacketizer_sink_payload_ethernet_type = top_ip_rx_sink_sink_payload_ethernet_type;
assign top_ip_rx_depacketizer_sink_payload_sender_mac = top_ip_rx_sink_sink_payload_sender_mac;
assign top_ip_rx_depacketizer_sink_payload_target_mac = top_ip_rx_sink_sink_payload_target_mac;
assign top_ip_rx_depacketizer_sink_payload_data = top_ip_rx_sink_sink_payload_data;
assign top_ip_rx_depacketizer_sink_payload_be = top_ip_rx_sink_sink_payload_be;
assign top_ip_rx_depacketizer_sink_payload_error = top_ip_rx_sink_sink_payload_error;
assign top_ip_rx_liteethipv4checksum_header = top_ip_rx_depacketizer_header;
assign top_ip_rx_reset = (~top_ip_rx_depacketizer_source_valid);
assign top_ip_rx_ce = 1'd1;
assign top_ip_rx_accepted = (((((((top_ip_rx_depacketizer_source_param_target_ip == 32'd3232236272) | 1'd1) & (top_ip_rx_depacketizer_source_param_version == 3'd4)) & (top_ip_rx_depacketizer_source_param_ihl == 3'd5)) & (top_ip_rx_depacketizer_source_param_total_length > 5'd20)) & ((top_ip_rx_depacketizer_source_param_flags_offset & 14'd16383) == 1'd0)) & (top_ip_rx_liteethipv4checksum_value == 1'd0));
assign top_ip_rx_receiving = top_ip_rx_is_ongoing0;
assign top_ip_rx_source_source_valid = (top_ip_rx_depacketizer_source_valid & top_ip_rx_receiving);
assign top_ip_rx_depacketizer_source_ready = (top_ip_rx_is_ongoing1 | (top_ip_rx_receiving & top_ip_rx_source_source_ready));
assign top_ip_rx_source_source_last = top_ip_rx_depacketizer_source_last;
assign top_ip_rx_source_source_payload_data = top_ip_rx_depacketizer_source_payload_data;
assign top_ip_rx_source_source_payload_be = top_ip_rx_depacketizer_source_payload_be;
assign top_ip_rx_source_source_payload_error = top_ip_rx_depacketizer_source_payload_error;
assign top_ip_rx_source_source_param_protocol = top_ip_rx_depacketizer_source_param_protocol;
assign top_ip_rx_source_source_param_length = (top_ip_rx_depacketizer_source_param_total_length - 5'd20);
assign top_ip_rx_source_source_param_ip_address = top_ip_rx_depacketizer_source_param_sender_ip;
assign top_ip_rx_depacketizer_header = top_ip_rx_depacketizer_sr;
assign top_ip_rx_depacketizer_source_param_checksum = {rhs_slice_proxy43[7:0], rhs_slice_proxy42[15:8]};
assign top_ip_rx_depacketizer_source_param_flags_offset = {rhs_slice_proxy45[7:0], rhs_slice_proxy44[15:8]};
assign top_ip_rx_depacketizer_source_param_identification = {rhs_slice_proxy47[7:0], rhs_slice_proxy46[15:8]};
assign top_ip_rx_depacketizer_source_param_ihl = {rhs_slice_proxy48[3:0]};
assign top_ip_rx_depacketizer_source_param_protocol = {rhs_slice_proxy49[7:0]};
assign top_ip_rx_depacketizer_source_param_sender_ip = {rhs_slice_proxy53[7:0], rhs_slice_proxy52[15:8], rhs_slice_proxy51[23:16], rhs_slice_proxy50[31:24]};
assign top_ip_rx_depacketizer_source_param_target_ip = {rhs_slice_proxy57[7:0], rhs_slice_proxy56[15:8], rhs_slice_proxy55[23:16], rhs_slice_proxy54[31:24]};
assign top_ip_rx_depacketizer_source_param_total_length = {rhs_slice_proxy59[7:0], rhs_slice_proxy58[15:8]};
assign top_ip_rx_depacketizer_source_param_ttl = {rhs_slice_proxy60[7:0]};
assign top_ip_rx_depacketizer_source_param_version = {rhs_slice_proxy61[3:0]};
assign top_ip_rx_depacketizer_sink_be = top_ip_rx_depacketizer_sink_payload_be;
assign top_ip_rx_depacketizer_source_payload_be = top_ip_rx_depacketizer_source_be;
assign top_ip_rx_depacketizer_source_payload_error = top_ip_rx_depacketizer_sink_payload_error;

// synthesis translate_off
reg dummy_d_59;
// synthesis translate_on
always @(*) begin
	top_ip_rx_depacketizer_sink_ready <= 1'd0;
	top_ip_rx_depacketizer_source_valid <= 1'd0;
	top_ip_rx_depacketizer_source_first <= 1'd0;
	top_ip_rx_depacketizer_source_last <= 1'd0;
	top_ip_rx_depacketizer_source_payload_data <= 8'd0;
	top_ip_rx_depacketizer_sr_shift <= 1'd0;
	top_ip_rx_depacketizer_source_be <= 1'd1;
	liteethip_liteethiprx_liteethipv4depacketizer_next_state <= 2'd0;
	top_ip_rx_depacketizer_count_liteethip_next_value0 <= 5'd0;
	top_ip_rx_depacketizer_count_liteethip_next_value_ce0 <= 1'd0;
	top_ip_rx_depacketizer_fsm_from_idle_liteethip_next_value1 <= 1'd0;
	top_ip_rx_depacketizer_fsm_from_idle_liteethip_next_value_ce1 <= 1'd0;
	top_ip_rx_depacketizer_data_copy_first_liteethip_next_value2 <= 1'd0;
	top_ip_rx_depacketizer_data_copy_first_liteethip_next_value_ce2 <= 1'd0;
	liteethip_liteethiprx_liteethipv4depacketizer_next_state <= liteethip_liteethiprx_liteethipv4depacketizer_state;
	case (liteethip_liteethiprx_liteethipv4depacketizer_state)
		1'd1: begin
			top_ip_rx_depacketizer_sink_ready <= 1'd1;
			if (top_ip_rx_depacketizer_sink_valid) begin
				top_ip_rx_depacketizer_count_liteethip_next_value0 <= (top_ip_rx_depacketizer_count + 1'd1);
				top_ip_rx_depacketizer_count_liteethip_next_value_ce0 <= 1'd1;
				top_ip_rx_depacketizer_sr_shift <= 1'd1;
				if ((top_ip_rx_depacketizer_count == 5'd19)) begin
					top_ip_rx_depacketizer_data_copy_first_liteethip_next_value2 <= 1'd1;
					top_ip_rx_depacketizer_data_copy_first_liteethip_next_value_ce2 <= 1'd1;
					liteethip_liteethiprx_liteethipv4depacketizer_next_state <= 2'd2;
					top_ip_rx_depacketizer_count_liteethip_next_value0 <= (top_ip_rx_depacketizer_count + 1'd1);
					top_ip_rx_depacketizer_count_liteethip_next_value_ce0 <= 1'd1;
				end
				if (top_ip_rx_depacketizer_sink_last) begin
					liteethip_liteethiprx_liteethipv4depacketizer_next_state <= 1'd0;
				end
			end
		end
		2'd2: begin
			top_ip_rx_depacketizer_source_valid <= top_ip_rx_depacketizer_sink_valid;
			top_ip_rx_depacketizer_source_first <= top_ip_rx_depacketizer_data_copy_first;
			top_ip_rx_depacketizer_source_last <= top_ip_rx_depacketizer_sink_last;
			top_ip_rx_depacketizer_sink_ready <= top_ip_rx_depacketizer_source_ready;
			top_ip_rx_depacketizer_source_payload_data <= top_ip_rx_depacketizer_sink_payload_data;
			top_ip_rx_depacketizer_source_be <= top_ip_rx_depacketizer_sink_be;
			if ((top_ip_rx_depacketizer_source_valid & top_ip_rx_depacketizer_source_ready)) begin
				top_ip_rx_depacketizer_data_copy_first_liteethip_next_value2 <= 1'd0;
				top_ip_rx_depacketizer_data_copy_first_liteethip_next_value_ce2 <= 1'd1;
				top_ip_rx_depacketizer_fsm_from_idle_liteethip_next_value1 <= 1'd0;
				top_ip_rx_depacketizer_fsm_from_idle_liteethip_next_value_ce1 <= 1'd1;
				if (top_ip_rx_depacketizer_source_last) begin
					liteethip_liteethiprx_liteethipv4depacketizer_next_state <= 1'd0;
				end
			end
		end
		default: begin
			top_ip_rx_depacketizer_sink_ready <= 1'd1;
			top_ip_rx_depacketizer_count_liteethip_next_value0 <= 1'd1;
			top_ip_rx_depacketizer_count_liteethip_next_value_ce0 <= 1'd1;
			if (top_ip_rx_depacketizer_sink_valid) begin
				top_ip_rx_depacketizer_sr_shift <= 1'd1;
				top_ip_rx_depacketizer_fsm_from_idle_liteethip_next_value1 <= 1'd1;
				top_ip_rx_depacketizer_fsm_from_idle_liteethip_next_value_ce1 <= 1'd1;
				top_ip_rx_depacketizer_data_copy_first_liteethip_next_value2 <= 1'd1;
				top_ip_rx_depacketizer_data_copy_first_liteethip_next_value_ce2 <= 1'd1;
				if (1'd0) begin
					liteethip_liteethiprx_liteethipv4depacketizer_next_state <= 2'd2;
				end else begin
					liteethip_liteethiprx_liteethipv4depacketizer_next_state <= 1'd1;
				end
				if (($signed({1'd0, top_ip_rx_depacketizer_sink_last}) & 1'sd1)) begin
					liteethip_liteethiprx_liteethipv4depacketizer_next_state <= 1'd0;
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_59 <= dummy_s;
// synthesis translate_on
end
assign top_ip_rx_liteethipv4checksum_s_next0 = (top_ip_rx_liteethipv4checksum_r + top_ip_rx_liteethipv4checksum_header[15:0]);
assign top_ip_rx_liteethipv4checksum_s_next1 = (top_ip_rx_liteethipv4checksum_r_next0 + top_ip_rx_liteethipv4checksum_header[31:16]);
assign top_ip_rx_liteethipv4checksum_s_next2 = (top_ip_rx_liteethipv4checksum_r_next1 + top_ip_rx_liteethipv4checksum_header[47:32]);
assign top_ip_rx_liteethipv4checksum_s_next3 = (top_ip_rx_liteethipv4checksum_r_next2 + top_ip_rx_liteethipv4checksum_header[63:48]);
assign top_ip_rx_liteethipv4checksum_s_next4 = (top_ip_rx_liteethipv4checksum_r_next3 + top_ip_rx_liteethipv4checksum_header[79:64]);
assign top_ip_rx_liteethipv4checksum_s_next5 = (top_ip_rx_liteethipv4checksum_r_next4 + top_ip_rx_liteethipv4checksum_header[95:80]);
assign top_ip_rx_liteethipv4checksum_s_next6 = (top_ip_rx_liteethipv4checksum_r_next5 + top_ip_rx_liteethipv4checksum_header[111:96]);
assign top_ip_rx_liteethipv4checksum_s_next7 = (top_ip_rx_liteethipv4checksum_r_next6 + top_ip_rx_liteethipv4checksum_header[127:112]);
assign top_ip_rx_liteethipv4checksum_s_next8 = (top_ip_rx_liteethipv4checksum_r_next7 + top_ip_rx_liteethipv4checksum_header[143:128]);
assign top_ip_rx_liteethipv4checksum_s_next9 = (top_ip_rx_liteethipv4checksum_r_next8 + top_ip_rx_liteethipv4checksum_header[159:144]);
assign top_ip_rx_liteethipv4checksum_value = (~{top_ip_rx_liteethipv4checksum_r_next9[7:0], top_ip_rx_liteethipv4checksum_r_next9[15:8]});
assign top_ip_rx_liteethipv4checksum_counter_ce = (~top_ip_rx_liteethipv4checksum_done);
assign top_ip_rx_liteethipv4checksum_done = (top_ip_rx_liteethipv4checksum_counter == 4'd11);

// synthesis translate_off
reg dummy_d_60;
// synthesis translate_on
always @(*) begin
	top_ip_rx_is_ongoing0 <= 1'd0;
	top_ip_rx_is_ongoing1 <= 1'd0;
	liteethip_liteethiprx_fsm_next_state <= 2'd0;
	liteethip_liteethiprx_fsm_next_state <= liteethip_liteethiprx_fsm_state;
	case (liteethip_liteethiprx_fsm_state)
		1'd0: begin
			top_ip_rx_is_ongoing0 <= 1'd1;
			if ((top_ip_rx_source_source_valid & top_ip_rx_source_source_ready)) begin
				if (top_ip_rx_source_source_last) begin
					liteethip_liteethiprx_fsm_next_state <= 1'd1;
				end
			end
		end
		2'd2: begin
			top_ip_rx_is_ongoing1 <= 1'd1;
			if (((top_ip_rx_depacketizer_source_valid & top_ip_rx_depacketizer_source_last) & top_ip_rx_depacketizer_source_ready)) begin
				liteethip_liteethiprx_fsm_next_state <= 1'd1;
			end
		end
		default: begin
			if ((top_ip_rx_depacketizer_source_valid & top_ip_rx_liteethipv4checksum_done)) begin
				liteethip_liteethiprx_fsm_next_state <= 2'd2;
				if (top_ip_rx_accepted) begin
					liteethip_liteethiprx_fsm_next_state <= 1'd0;
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_60 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_61;
// synthesis translate_on
always @(*) begin
	liteethip_sel0 <= 2'd0;
	if ((top_ip_crossbar_sink_param_protocol == 1'd1)) begin
		liteethip_sel0 <= 1'd1;
	end
	if ((top_ip_crossbar_sink_param_protocol == 5'd17)) begin
		liteethip_sel0 <= 2'd2;
	end
// synthesis translate_off
	dummy_d_61 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_62;
// synthesis translate_on
always @(*) begin
	liteethip_request <= 2'd0;
	liteethip_request[0] <= liteethip_status0_ongoing0;
	liteethip_request[1] <= liteethip_status1_ongoing0;
// synthesis translate_off
	dummy_d_62 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_63;
// synthesis translate_on
always @(*) begin
	top_ip_crossbar_source_valid <= 1'd0;
	top_ip_crossbar_source_first <= 1'd0;
	top_ip_crossbar_source_last <= 1'd0;
	top_ip_crossbar_source_payload_data <= 8'd0;
	top_ip_crossbar_source_payload_be <= 1'd0;
	top_ip_crossbar_source_payload_error <= 1'd0;
	top_ip_crossbar_source_param_length <= 16'd0;
	top_ip_crossbar_source_param_protocol <= 8'd0;
	top_ip_crossbar_source_param_ip_address <= 32'd0;
	top_icmp_sink_ready <= 1'd0;
	top_ip_port_sink_ready <= 1'd0;
	case (liteethip_grant)
		1'd0: begin
			top_ip_crossbar_source_valid <= top_icmp_sink_valid;
			top_icmp_sink_ready <= top_ip_crossbar_source_ready;
			top_ip_crossbar_source_first <= top_icmp_sink_first;
			top_ip_crossbar_source_last <= top_icmp_sink_last;
			top_ip_crossbar_source_payload_data <= top_icmp_sink_payload_data;
			top_ip_crossbar_source_payload_be <= top_icmp_sink_payload_be;
			top_ip_crossbar_source_payload_error <= top_icmp_sink_payload_error;
			top_ip_crossbar_source_param_length <= top_icmp_sink_param_length;
			top_ip_crossbar_source_param_protocol <= top_icmp_sink_param_protocol;
			top_ip_crossbar_source_param_ip_address <= top_icmp_sink_param_ip_address;
		end
		1'd1: begin
			top_ip_crossbar_source_valid <= top_ip_port_sink_valid;
			top_ip_port_sink_ready <= top_ip_crossbar_source_ready;
			top_ip_crossbar_source_first <= top_ip_port_sink_first;
			top_ip_crossbar_source_last <= top_ip_port_sink_last;
			top_ip_crossbar_source_payload_data <= top_ip_port_sink_payload_data;
			top_ip_crossbar_source_payload_be <= top_ip_port_sink_payload_be;
			top_ip_crossbar_source_payload_error <= top_ip_port_sink_payload_error;
			top_ip_crossbar_source_param_length <= top_ip_port_sink_param_length;
			top_ip_crossbar_source_param_protocol <= top_ip_port_sink_param_protocol;
			top_ip_crossbar_source_param_ip_address <= top_ip_port_sink_param_ip_address;
		end
	endcase
// synthesis translate_off
	dummy_d_63 <= dummy_s;
// synthesis translate_on
end
assign liteethip_status0_last = ((top_icmp_sink_valid & top_icmp_sink_last) & top_icmp_sink_ready);
assign liteethip_status0_ongoing0 = ((top_icmp_sink_valid | liteethip_status0_ongoing1) & (~liteethip_status0_last));
assign liteethip_status1_last = ((top_ip_port_sink_valid & top_ip_port_sink_last) & top_ip_port_sink_ready);
assign liteethip_status1_ongoing0 = ((top_ip_port_sink_valid | liteethip_status1_ongoing1) & (~liteethip_status1_last));

// synthesis translate_off
reg dummy_d_64;
// synthesis translate_on
always @(*) begin
	liteethip_sel1 <= 2'd0;
	if ((~liteethip_sel_locked)) begin
		liteethip_sel1 <= liteethip_sel0;
	end else begin
		liteethip_sel1 <= liteethip_sel_ongoing;
	end
// synthesis translate_off
	dummy_d_64 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_65;
// synthesis translate_on
always @(*) begin
	top_ip_crossbar_sink_ready <= 1'd0;
	top_icmp_source_valid <= 1'd0;
	top_icmp_source_first <= 1'd0;
	top_icmp_source_last <= 1'd0;
	top_icmp_source_payload_data <= 8'd0;
	top_icmp_source_payload_be <= 1'd0;
	top_icmp_source_payload_error <= 1'd0;
	top_icmp_source_param_length <= 16'd0;
	top_icmp_source_param_protocol <= 8'd0;
	top_icmp_source_param_ip_address <= 32'd0;
	top_ip_port_source_valid <= 1'd0;
	top_ip_port_source_first <= 1'd0;
	top_ip_port_source_last <= 1'd0;
	top_ip_port_source_payload_data <= 8'd0;
	top_ip_port_source_payload_be <= 1'd0;
	top_ip_port_source_payload_error <= 1'd0;
	top_ip_port_source_param_length <= 16'd0;
	top_ip_port_source_param_protocol <= 8'd0;
	top_ip_port_source_param_ip_address <= 32'd0;
	case (liteethip_sel1)
		1'd1: begin
			top_icmp_source_valid <= top_ip_crossbar_sink_valid;
			top_ip_crossbar_sink_ready <= top_icmp_source_ready;
			top_icmp_source_first <= top_ip_crossbar_sink_first;
			top_icmp_source_last <= top_ip_crossbar_sink_last;
			top_icmp_source_payload_data <= top_ip_crossbar_sink_payload_data;
			top_icmp_source_payload_be <= top_ip_crossbar_sink_payload_be;
			top_icmp_source_payload_error <= top_ip_crossbar_sink_payload_error;
			top_icmp_source_param_length <= top_ip_crossbar_sink_param_length;
			top_icmp_source_param_protocol <= top_ip_crossbar_sink_param_protocol;
			top_icmp_source_param_ip_address <= top_ip_crossbar_sink_param_ip_address;
		end
		2'd2: begin
			top_ip_port_source_valid <= top_ip_crossbar_sink_valid;
			top_ip_crossbar_sink_ready <= top_ip_port_source_ready;
			top_ip_port_source_first <= top_ip_crossbar_sink_first;
			top_ip_port_source_last <= top_ip_crossbar_sink_last;
			top_ip_port_source_payload_data <= top_ip_crossbar_sink_payload_data;
			top_ip_port_source_payload_be <= top_ip_crossbar_sink_payload_be;
			top_ip_port_source_payload_error <= top_ip_crossbar_sink_payload_error;
			top_ip_port_source_param_length <= top_ip_crossbar_sink_param_length;
			top_ip_port_source_param_protocol <= top_ip_crossbar_sink_param_protocol;
			top_ip_port_source_param_ip_address <= top_ip_crossbar_sink_param_ip_address;
		end
		default: begin
			top_ip_crossbar_sink_ready <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_65 <= dummy_s;
// synthesis translate_on
end
assign liteethip_last = ((top_ip_crossbar_sink_valid & top_ip_crossbar_sink_last) & top_ip_crossbar_sink_ready);
assign liteethip_ongoing0 = ((top_ip_crossbar_sink_valid | liteethip_ongoing1) & (~liteethip_last));
assign top_icmp_echo_sink_sink_valid = top_icmp_rx_source_source_valid;
assign top_icmp_rx_source_source_ready = top_icmp_echo_sink_sink_ready;
assign top_icmp_echo_sink_sink_first = top_icmp_rx_source_source_first;
assign top_icmp_echo_sink_sink_last = top_icmp_rx_source_source_last;
assign top_icmp_echo_sink_sink_payload_data = top_icmp_rx_source_source_payload_data;
assign top_icmp_echo_sink_sink_payload_be = top_icmp_rx_source_source_payload_be;
assign top_icmp_echo_sink_sink_payload_error = top_icmp_rx_source_source_payload_error;
assign top_icmp_echo_sink_sink_param_checksum = top_icmp_rx_source_source_param_checksum;
assign top_icmp_echo_sink_sink_param_code = top_icmp_rx_source_source_param_code;
assign top_icmp_echo_sink_sink_param_msgtype = top_icmp_rx_source_source_param_msgtype;
assign top_icmp_echo_sink_sink_param_quench = top_icmp_rx_source_source_param_quench;
assign top_icmp_echo_sink_sink_param_ip_address = top_icmp_rx_source_source_param_ip_address;
assign top_icmp_echo_sink_sink_param_length = top_icmp_rx_source_source_param_length;
assign top_icmp_tx_sink_sink_valid = top_icmp_echo_source_source_valid;
assign top_icmp_echo_source_source_ready = top_icmp_tx_sink_sink_ready;
assign top_icmp_tx_sink_sink_first = top_icmp_echo_source_source_first;
assign top_icmp_tx_sink_sink_last = top_icmp_echo_source_source_last;
assign top_icmp_tx_sink_sink_payload_data = top_icmp_echo_source_source_payload_data;
assign top_icmp_tx_sink_sink_payload_be = top_icmp_echo_source_source_payload_be;
assign top_icmp_tx_sink_sink_payload_error = top_icmp_echo_source_source_payload_error;
assign top_icmp_tx_sink_sink_param_checksum = top_icmp_echo_source_source_param_checksum;
assign top_icmp_tx_sink_sink_param_code = top_icmp_echo_source_source_param_code;
assign top_icmp_tx_sink_sink_param_msgtype = top_icmp_echo_source_source_param_msgtype;
assign top_icmp_tx_sink_sink_param_quench = top_icmp_echo_source_source_param_quench;
assign top_icmp_tx_sink_sink_param_ip_address = top_icmp_echo_source_source_param_ip_address;
assign top_icmp_tx_sink_sink_param_length = top_icmp_echo_source_source_param_length;
assign top_icmp_sink_valid = top_icmp_tx_source_source_valid;
assign top_icmp_tx_source_source_ready = top_icmp_sink_ready;
assign top_icmp_sink_first = top_icmp_tx_source_source_first;
assign top_icmp_sink_last = top_icmp_tx_source_source_last;
assign top_icmp_sink_payload_data = top_icmp_tx_source_source_payload_data;
assign top_icmp_sink_payload_be = top_icmp_tx_source_source_payload_be;
assign top_icmp_sink_payload_error = top_icmp_tx_source_source_payload_error;
assign top_icmp_sink_param_length = top_icmp_tx_source_source_param_length;
assign top_icmp_sink_param_protocol = top_icmp_tx_source_source_param_protocol;
assign top_icmp_sink_param_ip_address = top_icmp_tx_source_source_param_ip_address;
assign top_icmp_rx_sink_sink_valid = top_icmp_source_valid;
assign top_icmp_source_ready = top_icmp_rx_sink_sink_ready;
assign top_icmp_rx_sink_sink_first = top_icmp_source_first;
assign top_icmp_rx_sink_sink_last = top_icmp_source_last;
assign top_icmp_rx_sink_sink_payload_data = top_icmp_source_payload_data;
assign top_icmp_rx_sink_sink_payload_be = top_icmp_source_payload_be;
assign top_icmp_rx_sink_sink_payload_error = top_icmp_source_payload_error;
assign top_icmp_rx_sink_sink_param_length = top_icmp_source_param_length;
assign top_icmp_rx_sink_sink_param_protocol = top_icmp_source_param_protocol;
assign top_icmp_rx_sink_sink_param_ip_address = top_icmp_source_param_ip_address;
assign top_icmp_tx_packetizer_sink_valid = top_icmp_tx_sink_sink_valid;
assign top_icmp_tx_sink_sink_ready = top_icmp_tx_packetizer_sink_ready;
assign top_icmp_tx_packetizer_sink_last = top_icmp_tx_sink_sink_last;
assign top_icmp_tx_packetizer_sink_payload_data = top_icmp_tx_sink_sink_payload_data;
assign top_icmp_tx_packetizer_sink_payload_be = top_icmp_tx_sink_sink_payload_be;
assign top_icmp_tx_packetizer_sink_param_checksum = top_icmp_tx_sink_sink_param_checksum;
assign top_icmp_tx_packetizer_sink_param_code = top_icmp_tx_sink_sink_param_code;
assign top_icmp_tx_packetizer_sink_param_msgtype = top_icmp_tx_sink_sink_param_msgtype;
assign top_icmp_tx_packetizer_sink_param_quench = top_icmp_tx_sink_sink_param_quench;
assign top_icmp_tx_source_source_valid = top_icmp_tx_packetizer_source_valid;
assign top_icmp_tx_packetizer_source_ready = top_icmp_tx_source_source_ready;
assign top_icmp_tx_source_source_first = top_icmp_tx_packetizer_source_first;
assign top_icmp_tx_source_source_last = top_icmp_tx_packetizer_source_last;
assign top_icmp_tx_source_source_payload_data = top_icmp_tx_packetizer_source_payload_data;
assign top_icmp_tx_source_source_payload_be = top_icmp_tx_packetizer_source_payload_be;
assign top_icmp_tx_source_source_payload_error = top_icmp_tx_packetizer_source_payload_error;
assign top_icmp_tx_source_source_param_length = (top_icmp_tx_active ? top_icmp_tx_length : (top_icmp_tx_sink_sink_param_length + 4'd8));
assign top_icmp_tx_source_source_param_protocol = 1'd1;
assign top_icmp_tx_source_source_param_ip_address = (top_icmp_tx_active ? top_icmp_tx_ip_address : top_icmp_tx_sink_sink_param_ip_address);

// synthesis translate_off
reg dummy_d_66;
// synthesis translate_on
always @(*) begin
	top_icmp_tx_packetizer_header <= 64'd0;
	top_icmp_tx_packetizer_header[31:16] <= {top_icmp_tx_packetizer_sink_param_checksum[7:0], top_icmp_tx_packetizer_sink_param_checksum[15:8]};
	top_icmp_tx_packetizer_header[15:8] <= {top_icmp_tx_packetizer_sink_param_code[7:0]};
	top_icmp_tx_packetizer_header[7:0] <= {top_icmp_tx_packetizer_sink_param_msgtype[7:0]};
	top_icmp_tx_packetizer_header[63:32] <= {top_icmp_tx_packetizer_sink_param_quench[7:0], top_icmp_tx_packetizer_sink_param_quench[15:8], top_icmp_tx_packetizer_sink_param_quench[23:16], top_icmp_tx_packetizer_sink_param_quench[31:24]};
// synthesis translate_off
	dummy_d_66 <= dummy_s;
// synthesis translate_on
end
assign top_icmp_tx_packetizer_source_payload_be = top_icmp_tx_packetizer_source_be;

// synthesis translate_off
reg dummy_d_67;
// synthesis translate_on
always @(*) begin
	top_icmp_tx_packetizer_source_payload_error <= 1'd0;
	if (top_icmp_tx_packetizer_is_ongoing) begin
		top_icmp_tx_packetizer_source_payload_error <= top_icmp_tx_packetizer_sink_payload_error;
	end
// synthesis translate_off
	dummy_d_67 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_68;
// synthesis translate_on
always @(*) begin
	top_icmp_tx_packetizer_sink_ready <= 1'd0;
	top_icmp_tx_packetizer_source_valid <= 1'd0;
	top_icmp_tx_packetizer_source_first <= 1'd0;
	top_icmp_tx_packetizer_source_last <= 1'd0;
	top_icmp_tx_packetizer_source_payload_data <= 8'd0;
	top_icmp_tx_packetizer_source_be <= 1'd1;
	top_icmp_tx_packetizer_is_ongoing <= 1'd0;
	liteethicmp_next_state <= 1'd0;
	top_icmp_tx_packetizer_count_liteethicmp_next_value <= 3'd0;
	top_icmp_tx_packetizer_count_liteethicmp_next_value_ce <= 1'd0;
	liteethicmp_next_state <= liteethicmp_state;
	case (liteethicmp_state)
		1'd0: begin
			top_icmp_tx_packetizer_is_ongoing <= 1'd1;
			top_icmp_tx_packetizer_source_valid <= top_icmp_tx_packetizer_sink_valid;
			top_icmp_tx_packetizer_sink_ready <= top_icmp_tx_packetizer_source_ready;
			top_icmp_tx_packetizer_source_last <= top_icmp_tx_packetizer_sink_last;
			top_icmp_tx_packetizer_source_payload_data <= top_icmp_tx_packetizer_sink_payload_data;
			top_icmp_tx_packetizer_source_be <= top_icmp_tx_packetizer_sink_payload_be;
			if (((top_icmp_tx_packetizer_source_valid & top_icmp_tx_packetizer_source_ready) & top_icmp_tx_packetizer_source_last)) begin
				liteethicmp_next_state <= 1'd1;
			end
		end
		default: begin
			top_icmp_tx_packetizer_sink_ready <= (top_icmp_tx_packetizer_count == 1'd0);
			case (top_icmp_tx_packetizer_count)
				1'd0: begin
					top_icmp_tx_packetizer_source_payload_data <= top_icmp_tx_packetizer_header[7:0];
				end
				1'd1: begin
					top_icmp_tx_packetizer_source_payload_data <= top_icmp_tx_packetizer_header[15:8];
				end
				2'd2: begin
					top_icmp_tx_packetizer_source_payload_data <= top_icmp_tx_packetizer_header[23:16];
				end
				2'd3: begin
					top_icmp_tx_packetizer_source_payload_data <= top_icmp_tx_packetizer_header[31:24];
				end
				3'd4: begin
					top_icmp_tx_packetizer_source_payload_data <= top_icmp_tx_packetizer_header[39:32];
				end
				3'd5: begin
					top_icmp_tx_packetizer_source_payload_data <= top_icmp_tx_packetizer_header[47:40];
				end
				3'd6: begin
					top_icmp_tx_packetizer_source_payload_data <= top_icmp_tx_packetizer_header[55:48];
				end
				3'd7: begin
					top_icmp_tx_packetizer_source_payload_data <= top_icmp_tx_packetizer_header[63:56];
				end
			endcase
			if ((top_icmp_tx_packetizer_count == 3'd7)) begin
				top_icmp_tx_packetizer_source_be <= 1'd1;
			end
			if ((top_icmp_tx_packetizer_sink_valid & 1'd1)) begin
				top_icmp_tx_packetizer_source_valid <= 1'd1;
				top_icmp_tx_packetizer_source_first <= (top_icmp_tx_packetizer_count == 1'd0);
				top_icmp_tx_packetizer_source_last <= ((top_icmp_tx_packetizer_count == 3'd7) & (top_icmp_tx_packetizer_sink_last & (top_icmp_tx_packetizer_sink_payload_be == 1'd0)));
				top_icmp_tx_packetizer_sink_ready <= (((top_icmp_tx_packetizer_count == 3'd7) & (top_icmp_tx_packetizer_sink_last & (top_icmp_tx_packetizer_sink_payload_be == 1'd0))) & top_icmp_tx_packetizer_source_ready);
				if (top_icmp_tx_packetizer_source_ready) begin
					if ((top_icmp_tx_packetizer_count == 3'd7)) begin
						top_icmp_tx_packetizer_count_liteethicmp_next_value <= 1'd0;
						top_icmp_tx_packetizer_count_liteethicmp_next_value_ce <= 1'd1;
						if ((~top_icmp_tx_packetizer_source_last)) begin
							liteethicmp_next_state <= 1'd0;
						end
					end else begin
						top_icmp_tx_packetizer_count_liteethicmp_next_value <= (top_icmp_tx_packetizer_count + 1'd1);
						top_icmp_tx_packetizer_count_liteethicmp_next_value_ce <= 1'd1;
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_68 <= dummy_s;
// synthesis translate_on
end
assign top_icmp_rx_depacketizer_sink_valid = top_icmp_rx_sink_sink_valid;
assign top_icmp_rx_sink_sink_ready = top_icmp_rx_depacketizer_sink_ready;
assign top_icmp_rx_depacketizer_sink_first = top_icmp_rx_sink_sink_first;
assign top_icmp_rx_depacketizer_sink_last = top_icmp_rx_sink_sink_last;
assign top_icmp_rx_depacketizer_sink_payload_data = top_icmp_rx_sink_sink_payload_data;
assign top_icmp_rx_depacketizer_sink_payload_be = top_icmp_rx_sink_sink_payload_be;
assign top_icmp_rx_depacketizer_sink_payload_error = top_icmp_rx_sink_sink_payload_error;
assign top_icmp_rx_depacketizer_sink_param_length = top_icmp_rx_sink_sink_param_length;
assign top_icmp_rx_depacketizer_sink_param_protocol = top_icmp_rx_sink_sink_param_protocol;
assign top_icmp_rx_depacketizer_sink_param_ip_address = top_icmp_rx_sink_sink_param_ip_address;
assign top_icmp_rx_source_source_valid = (top_icmp_rx_depacketizer_source_valid & top_icmp_rx_is_ongoing0);
assign top_icmp_rx_depacketizer_source_ready = (top_icmp_rx_is_ongoing1 | (top_icmp_rx_is_ongoing2 & top_icmp_rx_source_source_ready));
assign top_icmp_rx_source_source_payload_data = top_icmp_rx_depacketizer_source_payload_data;
assign top_icmp_rx_source_source_param_checksum = top_icmp_rx_depacketizer_source_param_checksum;
assign top_icmp_rx_source_source_param_code = top_icmp_rx_depacketizer_source_param_code;
assign top_icmp_rx_source_source_param_msgtype = top_icmp_rx_depacketizer_source_param_msgtype;
assign top_icmp_rx_source_source_param_quench = top_icmp_rx_depacketizer_source_param_quench;
assign top_icmp_rx_source_source_param_ip_address = top_icmp_rx_ip_address;
assign top_icmp_rx_source_source_param_length = (top_icmp_rx_length - 4'd8);
assign top_icmp_rx_depacketizer_header = top_icmp_rx_depacketizer_sr;
assign top_icmp_rx_depacketizer_source_param_checksum = {rhs_slice_proxy63[7:0], rhs_slice_proxy62[15:8]};
assign top_icmp_rx_depacketizer_source_param_code = {rhs_slice_proxy64[7:0]};
assign top_icmp_rx_depacketizer_source_param_msgtype = {rhs_slice_proxy65[7:0]};
assign top_icmp_rx_depacketizer_source_param_quench = {rhs_slice_proxy69[7:0], rhs_slice_proxy68[15:8], rhs_slice_proxy67[23:16], rhs_slice_proxy66[31:24]};
assign top_icmp_rx_depacketizer_sink_be = top_icmp_rx_depacketizer_sink_payload_be;
assign top_icmp_rx_depacketizer_source_payload_be = top_icmp_rx_depacketizer_source_be;
assign top_icmp_rx_depacketizer_source_payload_error = top_icmp_rx_depacketizer_sink_payload_error;

// synthesis translate_off
reg dummy_d_69;
// synthesis translate_on
always @(*) begin
	top_icmp_rx_depacketizer_sink_ready <= 1'd0;
	top_icmp_rx_depacketizer_source_valid <= 1'd0;
	top_icmp_rx_depacketizer_source_first <= 1'd0;
	top_icmp_rx_depacketizer_source_last <= 1'd0;
	top_icmp_rx_depacketizer_source_payload_data <= 8'd0;
	top_icmp_rx_depacketizer_sr_shift <= 1'd0;
	top_icmp_rx_depacketizer_source_be <= 1'd1;
	liteethicmp_liteethicmpdepacketizer_next_state <= 2'd0;
	top_icmp_rx_depacketizer_count_liteethicmp_liteethicmpdepacketizer_next_value0 <= 3'd0;
	top_icmp_rx_depacketizer_count_liteethicmp_liteethicmpdepacketizer_next_value_ce0 <= 1'd0;
	top_icmp_rx_depacketizer_fsm_from_idle_liteethicmp_liteethicmpdepacketizer_next_value1 <= 1'd0;
	top_icmp_rx_depacketizer_fsm_from_idle_liteethicmp_liteethicmpdepacketizer_next_value_ce1 <= 1'd0;
	top_icmp_rx_depacketizer_data_copy_first_liteethicmp_liteethicmpdepacketizer_next_value2 <= 1'd0;
	top_icmp_rx_depacketizer_data_copy_first_liteethicmp_liteethicmpdepacketizer_next_value_ce2 <= 1'd0;
	liteethicmp_liteethicmpdepacketizer_next_state <= liteethicmp_liteethicmpdepacketizer_state;
	case (liteethicmp_liteethicmpdepacketizer_state)
		1'd1: begin
			top_icmp_rx_depacketizer_sink_ready <= 1'd1;
			if (top_icmp_rx_depacketizer_sink_valid) begin
				top_icmp_rx_depacketizer_count_liteethicmp_liteethicmpdepacketizer_next_value0 <= (top_icmp_rx_depacketizer_count + 1'd1);
				top_icmp_rx_depacketizer_count_liteethicmp_liteethicmpdepacketizer_next_value_ce0 <= 1'd1;
				top_icmp_rx_depacketizer_sr_shift <= 1'd1;
				if ((top_icmp_rx_depacketizer_count == 3'd7)) begin
					top_icmp_rx_depacketizer_data_copy_first_liteethicmp_liteethicmpdepacketizer_next_value2 <= 1'd1;
					top_icmp_rx_depacketizer_data_copy_first_liteethicmp_liteethicmpdepacketizer_next_value_ce2 <= 1'd1;
					liteethicmp_liteethicmpdepacketizer_next_state <= 2'd2;
					top_icmp_rx_depacketizer_count_liteethicmp_liteethicmpdepacketizer_next_value0 <= (top_icmp_rx_depacketizer_count + 1'd1);
					top_icmp_rx_depacketizer_count_liteethicmp_liteethicmpdepacketizer_next_value_ce0 <= 1'd1;
				end
				if (top_icmp_rx_depacketizer_sink_last) begin
					liteethicmp_liteethicmpdepacketizer_next_state <= 1'd0;
				end
			end
		end
		2'd2: begin
			top_icmp_rx_depacketizer_source_valid <= top_icmp_rx_depacketizer_sink_valid;
			top_icmp_rx_depacketizer_source_first <= top_icmp_rx_depacketizer_data_copy_first;
			top_icmp_rx_depacketizer_source_last <= top_icmp_rx_depacketizer_sink_last;
			top_icmp_rx_depacketizer_sink_ready <= top_icmp_rx_depacketizer_source_ready;
			top_icmp_rx_depacketizer_source_payload_data <= top_icmp_rx_depacketizer_sink_payload_data;
			top_icmp_rx_depacketizer_source_be <= top_icmp_rx_depacketizer_sink_be;
			if ((top_icmp_rx_depacketizer_source_valid & top_icmp_rx_depacketizer_source_ready)) begin
				top_icmp_rx_depacketizer_data_copy_first_liteethicmp_liteethicmpdepacketizer_next_value2 <= 1'd0;
				top_icmp_rx_depacketizer_data_copy_first_liteethicmp_liteethicmpdepacketizer_next_value_ce2 <= 1'd1;
				top_icmp_rx_depacketizer_fsm_from_idle_liteethicmp_liteethicmpdepacketizer_next_value1 <= 1'd0;
				top_icmp_rx_depacketizer_fsm_from_idle_liteethicmp_liteethicmpdepacketizer_next_value_ce1 <= 1'd1;
				if (top_icmp_rx_depacketizer_source_last) begin
					liteethicmp_liteethicmpdepacketizer_next_state <= 1'd0;
				end
			end
		end
		default: begin
			top_icmp_rx_depacketizer_sink_ready <= 1'd1;
			top_icmp_rx_depacketizer_count_liteethicmp_liteethicmpdepacketizer_next_value0 <= 1'd1;
			top_icmp_rx_depacketizer_count_liteethicmp_liteethicmpdepacketizer_next_value_ce0 <= 1'd1;
			if (top_icmp_rx_depacketizer_sink_valid) begin
				top_icmp_rx_depacketizer_sr_shift <= 1'd1;
				top_icmp_rx_depacketizer_fsm_from_idle_liteethicmp_liteethicmpdepacketizer_next_value1 <= 1'd1;
				top_icmp_rx_depacketizer_fsm_from_idle_liteethicmp_liteethicmpdepacketizer_next_value_ce1 <= 1'd1;
				top_icmp_rx_depacketizer_data_copy_first_liteethicmp_liteethicmpdepacketizer_next_value2 <= 1'd1;
				top_icmp_rx_depacketizer_data_copy_first_liteethicmp_liteethicmpdepacketizer_next_value_ce2 <= 1'd1;
				if (1'd0) begin
					liteethicmp_liteethicmpdepacketizer_next_state <= 2'd2;
				end else begin
					liteethicmp_liteethicmpdepacketizer_next_state <= 1'd1;
				end
				if (($signed({1'd0, top_icmp_rx_depacketizer_sink_last}) & 1'sd1)) begin
					liteethicmp_liteethicmpdepacketizer_next_state <= 1'd0;
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_69 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_70;
// synthesis translate_on
always @(*) begin
	top_icmp_rx_source_source_last <= 1'd0;
	top_icmp_rx_source_source_payload_be <= 1'd0;
	top_icmp_rx_source_source_payload_error <= 1'd0;
	top_icmp_rx_is_ongoing0 <= 1'd0;
	top_icmp_rx_is_ongoing1 <= 1'd0;
	top_icmp_rx_is_ongoing2 <= 1'd0;
	liteethicmp_fsm_next_state <= 2'd0;
	top_icmp_rx_count_liteethicmp_fsm_next_value <= 17'd0;
	top_icmp_rx_count_liteethicmp_fsm_next_value_ce <= 1'd0;
	top_icmp_rx_source_source_last <= top_icmp_rx_depacketizer_source_last;
	top_icmp_rx_source_source_payload_be <= top_icmp_rx_depacketizer_source_payload_be;
	top_icmp_rx_source_source_payload_error <= top_icmp_rx_depacketizer_source_payload_error;
	liteethicmp_fsm_next_state <= liteethicmp_fsm_state;
	case (liteethicmp_fsm_state)
		1'd0: begin
			top_icmp_rx_is_ongoing0 <= 1'd1;
			top_icmp_rx_is_ongoing2 <= 1'd1;
			top_icmp_rx_source_source_last <= (top_icmp_rx_depacketizer_source_last | (top_icmp_rx_count >= top_icmp_rx_source_source_param_length));
			if ((top_icmp_rx_count >= top_icmp_rx_source_source_param_length)) begin
				top_icmp_rx_source_source_payload_be <= (top_icmp_rx_depacketizer_source_payload_be & {((((top_icmp_rx_source_source_param_length & 1'd0) == 1'd0) ? 1'd1 : (top_icmp_rx_source_source_param_length & 1'd0)) > 1'd0)});
			end
			if ((top_icmp_rx_depacketizer_source_last & (((top_icmp_rx_count - 1'd1) + (1'd0 + top_icmp_rx_depacketizer_source_payload_be)) < top_icmp_rx_source_source_param_length))) begin
				top_icmp_rx_source_source_payload_error <= top_icmp_rx_source_source_payload_be;
			end
			if ((top_icmp_rx_source_source_valid & top_icmp_rx_source_source_ready)) begin
				top_icmp_rx_count_liteethicmp_fsm_next_value <= (top_icmp_rx_count + 1'd1);
				top_icmp_rx_count_liteethicmp_fsm_next_value_ce <= 1'd1;
				if (top_icmp_rx_depacketizer_source_last) begin
					liteethicmp_fsm_next_state <= 2'd2;
				end else begin
					if (top_icmp_rx_source_source_last) begin
						liteethicmp_fsm_next_state <= 1'd1;
					end
				end
			end
		end
		1'd1: begin
			top_icmp_rx_is_ongoing1 <= 1'd1;
			if (((top_icmp_rx_depacketizer_source_valid & top_icmp_rx_depacketizer_source_last) & top_icmp_rx_depacketizer_source_ready)) begin
				liteethicmp_fsm_next_state <= 2'd2;
			end
		end
		default: begin
			top_icmp_rx_count_liteethicmp_fsm_next_value <= 1'd1;
			top_icmp_rx_count_liteethicmp_fsm_next_value_ce <= 1'd1;
			if (top_icmp_rx_depacketizer_source_valid) begin
				liteethicmp_fsm_next_state <= 1'd1;
				if (((top_icmp_rx_protocol == 1'd1) & (top_icmp_rx_length > 4'd8))) begin
					if (((top_icmp_rx_depacketizer_source_param_msgtype == 4'd8) & (top_icmp_rx_depacketizer_source_param_code == 1'd0))) begin
						liteethicmp_fsm_next_state <= 1'd0;
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_70 <= dummy_s;
// synthesis translate_on
end
assign top_icmp_echo_buffer_sink_first = top_icmp_echo_sink_sink_first;
assign top_icmp_echo_buffer_sink_last = top_icmp_echo_sink_sink_last;
assign top_icmp_echo_buffer_sink_payload_data = top_icmp_echo_sink_sink_payload_data;
assign top_icmp_echo_buffer_sink_payload_be = top_icmp_echo_sink_sink_payload_be;
assign top_icmp_echo_buffer_sink_payload_error = top_icmp_echo_sink_sink_payload_error;
assign top_icmp_echo_buffer_sink_param_checksum = top_icmp_echo_sink_sink_param_checksum;
assign top_icmp_echo_buffer_sink_param_code = top_icmp_echo_sink_sink_param_code;
assign top_icmp_echo_buffer_sink_param_msgtype = top_icmp_echo_sink_sink_param_msgtype;
assign top_icmp_echo_buffer_sink_param_quench = top_icmp_echo_sink_sink_param_quench;
assign top_icmp_echo_buffer_sink_param_ip_address = top_icmp_echo_sink_sink_param_ip_address;
assign top_icmp_echo_buffer_sink_param_length = top_icmp_echo_sink_sink_param_length;
assign top_icmp_echo_buffer_sink_valid = (top_icmp_echo_sink_sink_valid & ((~top_icmp_echo_busy) | top_icmp_echo_receiving));
assign top_icmp_echo_sink_sink_ready = ((~top_icmp_echo_busy) | top_icmp_echo_receiving);
assign top_icmp_echo_size = (top_icmp_echo_count + (1'd0 + top_icmp_echo_sink_sink_payload_be));
assign top_icmp_echo_buffer_discard = (((((top_icmp_echo_sink_sink_param_length == 1'd0) | (top_icmp_echo_sink_sink_param_length > 8'd128)) | (top_icmp_echo_size > 8'd128)) | ((top_icmp_echo_sink_sink_payload_error & top_icmp_echo_sink_sink_payload_be) != 1'd0)) | (top_icmp_echo_sink_sink_last & (top_icmp_echo_size != top_icmp_echo_sink_sink_param_length)));
assign top_icmp_echo_source_source_valid = top_icmp_echo_buffer_source_valid;
assign top_icmp_echo_buffer_source_ready = top_icmp_echo_source_source_ready;
assign top_icmp_echo_source_source_first = top_icmp_echo_buffer_source_first;
assign top_icmp_echo_source_source_last = top_icmp_echo_buffer_source_last;
assign top_icmp_echo_source_source_payload_data = top_icmp_echo_buffer_source_payload_data;
assign top_icmp_echo_source_source_payload_be = top_icmp_echo_buffer_source_payload_be;
assign top_icmp_echo_source_source_payload_error = top_icmp_echo_buffer_source_payload_error;
assign top_icmp_echo_source_source_param_code = top_icmp_echo_buffer_source_param_code;
assign top_icmp_echo_source_source_param_quench = top_icmp_echo_buffer_source_param_quench;
assign top_icmp_echo_source_source_param_ip_address = top_icmp_echo_buffer_source_param_ip_address;
assign top_icmp_echo_source_source_param_length = top_icmp_echo_buffer_source_param_length;

// synthesis translate_off
reg dummy_d_71;
// synthesis translate_on
always @(*) begin
	top_icmp_echo_source_source_param_msgtype <= 8'd0;
	top_icmp_echo_source_source_param_msgtype <= top_icmp_echo_buffer_source_param_msgtype;
	top_icmp_echo_source_source_param_msgtype <= 1'd0;
// synthesis translate_off
	dummy_d_71 <= dummy_s;
// synthesis translate_on
end
assign top_icmp_echo_source_source_param_checksum = ((top_icmp_echo_buffer_source_param_checksum + 12'd2048) + (top_icmp_echo_buffer_source_param_checksum >= 16'd63488));
assign top_icmp_echo_buffer_used = (top_icmp_echo_buffer_wr_ptr - (top_icmp_echo_buffer_rd_ptr - top_icmp_echo_buffer_out_valid));
assign top_icmp_echo_buffer_full = (top_icmp_echo_buffer_used == 8'd128);
assign top_icmp_echo_buffer_sink_ready = 1'd1;
assign top_icmp_echo_buffer_wr_port_adr = top_icmp_echo_buffer_wr_ptr[6:0];
assign top_icmp_echo_buffer_wr_port_dat_w = {top_icmp_echo_buffer_sink_last, top_icmp_echo_buffer_sink_first, {top_icmp_echo_buffer_sink_payload_error, top_icmp_echo_buffer_sink_payload_be, top_icmp_echo_buffer_sink_payload_data}};
assign top_icmp_echo_buffer_wr_port_we = ((top_icmp_echo_buffer_sink_valid & (~top_icmp_echo_buffer_overflow)) & (~top_icmp_echo_buffer_full));
assign top_icmp_echo_buffer_commit = ((((((top_icmp_echo_buffer_sink_valid & top_icmp_echo_buffer_sink_last) & (~top_icmp_echo_buffer_overflow)) & (~top_icmp_echo_buffer_full)) & (~top_icmp_echo_buffer_invalid)) & (~top_icmp_echo_buffer_discard)) & top_icmp_echo_buffer_sink_sink_ready);
assign top_icmp_echo_buffer_sink_sink_param_checksum = top_icmp_echo_buffer_sink_param_checksum;
assign top_icmp_echo_buffer_sink_sink_param_code = top_icmp_echo_buffer_sink_param_code;
assign top_icmp_echo_buffer_sink_sink_param_msgtype = top_icmp_echo_buffer_sink_param_msgtype;
assign top_icmp_echo_buffer_sink_sink_param_quench = top_icmp_echo_buffer_sink_param_quench;
assign top_icmp_echo_buffer_sink_sink_param_ip_address = top_icmp_echo_buffer_sink_param_ip_address;
assign top_icmp_echo_buffer_sink_sink_param_length = top_icmp_echo_buffer_sink_param_length;
assign top_icmp_echo_buffer_sink_sink_valid = top_icmp_echo_buffer_commit;
assign top_icmp_echo_buffer_sink_sink_last = 1'd1;
assign top_icmp_echo_buffer_drop = ((top_icmp_echo_buffer_sink_valid & top_icmp_echo_buffer_sink_last) & (~top_icmp_echo_buffer_commit));
assign top_icmp_echo_buffer_fetch = ((top_icmp_echo_buffer_rd_ptr != top_icmp_echo_buffer_commit_ptr) & ((~top_icmp_echo_buffer_out_valid) | (top_icmp_echo_buffer_source_valid & top_icmp_echo_buffer_source_ready)));
assign top_icmp_echo_buffer_rd_port_adr = top_icmp_echo_buffer_rd_ptr[6:0];
assign top_icmp_echo_buffer_rd_port_re = top_icmp_echo_buffer_fetch;
assign top_icmp_echo_buffer_source_param_checksum = top_icmp_echo_buffer_source_source_param_checksum;
assign top_icmp_echo_buffer_source_param_code = top_icmp_echo_buffer_source_source_param_code;
assign top_icmp_echo_buffer_source_param_msgtype = top_icmp_echo_buffer_source_source_param_msgtype;
assign top_icmp_echo_buffer_source_param_quench = top_icmp_echo_buffer_source_source_param_quench;
assign top_icmp_echo_buffer_source_param_ip_address = top_icmp_echo_buffer_source_source_param_ip_address;
assign top_icmp_echo_buffer_source_param_length = top_icmp_echo_buffer_source_source_param_length;
assign {top_icmp_echo_buffer_source_payload_error, top_icmp_echo_buffer_source_payload_be, top_icmp_echo_buffer_source_payload_data} = top_icmp_echo_buffer_rd_port_dat_r[9:0];
assign top_icmp_echo_buffer_source_first = top_icmp_echo_buffer_rd_port_dat_r[10];
assign top_icmp_echo_buffer_source_last = top_icmp_echo_buffer_rd_port_dat_r[11];
assign top_icmp_echo_buffer_source_valid = (top_icmp_echo_buffer_out_valid & top_icmp_echo_buffer_source_source_valid);
assign top_icmp_echo_buffer_source_source_ready = ((top_icmp_echo_buffer_source_valid & top_icmp_echo_buffer_source_last) & top_icmp_echo_buffer_source_ready);
assign top_icmp_echo_buffer_level = top_icmp_echo_buffer_source_source_valid;
assign top_icmp_echo_buffer_pipe_valid_sink_ready = ((~top_icmp_echo_buffer_pipe_valid_source_valid) | top_icmp_echo_buffer_pipe_valid_source_ready);
assign top_icmp_echo_buffer_pipe_valid_sink_valid = top_icmp_echo_buffer_sink_sink_valid;
assign top_icmp_echo_buffer_sink_sink_ready = top_icmp_echo_buffer_pipe_valid_sink_ready;
assign top_icmp_echo_buffer_pipe_valid_sink_first = top_icmp_echo_buffer_sink_sink_first;
assign top_icmp_echo_buffer_pipe_valid_sink_last = top_icmp_echo_buffer_sink_sink_last;
assign top_icmp_echo_buffer_pipe_valid_sink_param_checksum = top_icmp_echo_buffer_sink_sink_param_checksum;
assign top_icmp_echo_buffer_pipe_valid_sink_param_code = top_icmp_echo_buffer_sink_sink_param_code;
assign top_icmp_echo_buffer_pipe_valid_sink_param_msgtype = top_icmp_echo_buffer_sink_sink_param_msgtype;
assign top_icmp_echo_buffer_pipe_valid_sink_param_quench = top_icmp_echo_buffer_sink_sink_param_quench;
assign top_icmp_echo_buffer_pipe_valid_sink_param_ip_address = top_icmp_echo_buffer_sink_sink_param_ip_address;
assign top_icmp_echo_buffer_pipe_valid_sink_param_length = top_icmp_echo_buffer_sink_sink_param_length;
assign top_icmp_echo_buffer_source_source_valid = top_icmp_echo_buffer_pipe_valid_source_valid;
assign top_icmp_echo_buffer_pipe_valid_source_ready = top_icmp_echo_buffer_source_source_ready;
assign top_icmp_echo_buffer_source_source_first = top_icmp_echo_buffer_pipe_valid_source_first;
assign top_icmp_echo_buffer_source_source_last = top_icmp_echo_buffer_pipe_valid_source_last;
assign top_icmp_echo_buffer_source_source_param_checksum = top_icmp_echo_buffer_pipe_valid_source_param_checksum;
assign top_icmp_echo_buffer_source_source_param_code = top_icmp_echo_buffer_pipe_valid_source_param_code;
assign top_icmp_echo_buffer_source_source_param_msgtype = top_icmp_echo_buffer_pipe_valid_source_param_msgtype;
assign top_icmp_echo_buffer_source_source_param_quench = top_icmp_echo_buffer_pipe_valid_source_param_quench;
assign top_icmp_echo_buffer_source_source_param_ip_address = top_icmp_echo_buffer_pipe_valid_source_param_ip_address;
assign top_icmp_echo_buffer_source_source_param_length = top_icmp_echo_buffer_pipe_valid_source_param_length;
assign top_ip_port_sink_valid = top_tx_source_source_valid;
assign top_tx_source_source_ready = top_ip_port_sink_ready;
assign top_ip_port_sink_first = top_tx_source_source_first;
assign top_ip_port_sink_last = top_tx_source_source_last;
assign top_ip_port_sink_payload_data = top_tx_source_source_payload_data;
assign top_ip_port_sink_payload_be = top_tx_source_source_payload_be;
assign top_ip_port_sink_payload_error = top_tx_source_source_payload_error;
assign top_ip_port_sink_param_length = top_tx_source_source_param_length;
assign top_ip_port_sink_param_protocol = top_tx_source_source_param_protocol;
assign top_ip_port_sink_param_ip_address = top_tx_source_source_param_ip_address;
assign top_rx_sink_sink_valid = top_ip_port_source_valid;
assign top_ip_port_source_ready = top_rx_sink_sink_ready;
assign top_rx_sink_sink_first = top_ip_port_source_first;
assign top_rx_sink_sink_last = top_ip_port_source_last;
assign top_rx_sink_sink_payload_data = top_ip_port_source_payload_data;
assign top_rx_sink_sink_payload_be = top_ip_port_source_payload_be;
assign top_rx_sink_sink_payload_error = top_ip_port_source_payload_error;
assign top_rx_sink_sink_param_length = top_ip_port_source_param_length;
assign top_rx_sink_sink_param_protocol = top_ip_port_source_param_protocol;
assign top_rx_sink_sink_param_ip_address = top_ip_port_source_param_ip_address;
assign top_tx_sink_sink_valid = top_crossbar_source_valid;
assign top_crossbar_source_ready = top_tx_sink_sink_ready;
assign top_tx_sink_sink_first = top_crossbar_source_first;
assign top_tx_sink_sink_last = top_crossbar_source_last;
assign top_tx_sink_sink_payload_data = top_crossbar_source_payload_data;
assign top_tx_sink_sink_payload_be = top_crossbar_source_payload_be;
assign top_tx_sink_sink_payload_error = top_crossbar_source_payload_error;
assign top_tx_sink_sink_param_src_port = top_crossbar_source_param_src_port;
assign top_tx_sink_sink_param_dst_port = top_crossbar_source_param_dst_port;
assign top_tx_sink_sink_param_ip_address = top_crossbar_source_param_ip_address;
assign top_tx_sink_sink_param_length = top_crossbar_source_param_length;
assign top_crossbar_sink_valid = top_rx_source_source_valid;
assign top_rx_source_source_ready = top_crossbar_sink_ready;
assign top_crossbar_sink_first = top_rx_source_source_first;
assign top_crossbar_sink_last = top_rx_source_source_last;
assign top_crossbar_sink_payload_data = top_rx_source_source_payload_data;
assign top_crossbar_sink_payload_be = top_rx_source_source_payload_be;
assign top_crossbar_sink_payload_error = top_rx_source_source_payload_error;
assign top_crossbar_sink_param_src_port = top_rx_source_source_param_src_port;
assign top_crossbar_sink_param_dst_port = top_rx_source_source_param_dst_port;
assign top_crossbar_sink_param_ip_address = top_rx_source_source_param_ip_address;
assign top_crossbar_sink_param_length = top_rx_source_source_param_length;
assign top_tx_packetizer_sink_valid = top_tx_sink_sink_valid;
assign top_tx_sink_sink_ready = top_tx_packetizer_sink_ready;
assign top_tx_packetizer_sink_last = top_tx_sink_sink_last;
assign top_tx_packetizer_sink_payload_data = top_tx_sink_sink_payload_data;
assign top_tx_packetizer_sink_payload_be = top_tx_sink_sink_payload_be;
assign top_tx_packetizer_sink_param_src_port = top_tx_sink_sink_param_src_port;
assign top_tx_packetizer_sink_param_dst_port = top_tx_sink_sink_param_dst_port;
assign top_tx_packetizer_sink_param_length = (top_tx_sink_sink_param_length + 4'd8);
assign top_tx_packetizer_sink_param_checksum = 1'd0;
assign top_tx_source_source_valid = top_tx_packetizer_source_valid;
assign top_tx_packetizer_source_ready = top_tx_source_source_ready;
assign top_tx_source_source_first = top_tx_packetizer_source_first;
assign top_tx_source_source_last = top_tx_packetizer_source_last;
assign top_tx_source_source_payload_data = top_tx_packetizer_source_payload_data;
assign top_tx_source_source_payload_be = top_tx_packetizer_source_payload_be;
assign top_tx_source_source_payload_error = top_tx_packetizer_source_payload_error;
assign top_tx_source_source_param_length = (top_tx_active ? top_tx_length : top_tx_packetizer_sink_param_length);
assign top_tx_source_source_param_protocol = 5'd17;
assign top_tx_source_source_param_ip_address = (top_tx_active ? top_tx_ip_address : top_tx_sink_sink_param_ip_address);

// synthesis translate_off
reg dummy_d_72;
// synthesis translate_on
always @(*) begin
	top_tx_packetizer_header <= 64'd0;
	top_tx_packetizer_header[63:48] <= {top_tx_packetizer_sink_param_checksum[7:0], top_tx_packetizer_sink_param_checksum[15:8]};
	top_tx_packetizer_header[31:16] <= {top_tx_packetizer_sink_param_dst_port[7:0], top_tx_packetizer_sink_param_dst_port[15:8]};
	top_tx_packetizer_header[47:32] <= {top_tx_packetizer_sink_param_length[7:0], top_tx_packetizer_sink_param_length[15:8]};
	top_tx_packetizer_header[15:0] <= {top_tx_packetizer_sink_param_src_port[7:0], top_tx_packetizer_sink_param_src_port[15:8]};
// synthesis translate_off
	dummy_d_72 <= dummy_s;
// synthesis translate_on
end
assign top_tx_packetizer_source_payload_be = top_tx_packetizer_source_be;

// synthesis translate_off
reg dummy_d_73;
// synthesis translate_on
always @(*) begin
	top_tx_packetizer_source_payload_error <= 1'd0;
	if (top_tx_packetizer_is_ongoing) begin
		top_tx_packetizer_source_payload_error <= top_tx_packetizer_sink_payload_error;
	end
// synthesis translate_off
	dummy_d_73 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_74;
// synthesis translate_on
always @(*) begin
	top_tx_packetizer_sink_ready <= 1'd0;
	top_tx_packetizer_source_valid <= 1'd0;
	top_tx_packetizer_source_first <= 1'd0;
	top_tx_packetizer_source_last <= 1'd0;
	top_tx_packetizer_source_payload_data <= 8'd0;
	top_tx_packetizer_source_be <= 1'd1;
	top_tx_packetizer_is_ongoing <= 1'd0;
	liteethudp_next_state <= 1'd0;
	top_tx_packetizer_count_liteethudp_next_value <= 3'd0;
	top_tx_packetizer_count_liteethudp_next_value_ce <= 1'd0;
	liteethudp_next_state <= liteethudp_state;
	case (liteethudp_state)
		1'd0: begin
			top_tx_packetizer_is_ongoing <= 1'd1;
			top_tx_packetizer_source_valid <= top_tx_packetizer_sink_valid;
			top_tx_packetizer_sink_ready <= top_tx_packetizer_source_ready;
			top_tx_packetizer_source_last <= top_tx_packetizer_sink_last;
			top_tx_packetizer_source_payload_data <= top_tx_packetizer_sink_payload_data;
			top_tx_packetizer_source_be <= top_tx_packetizer_sink_payload_be;
			if (((top_tx_packetizer_source_valid & top_tx_packetizer_source_ready) & top_tx_packetizer_source_last)) begin
				liteethudp_next_state <= 1'd1;
			end
		end
		default: begin
			top_tx_packetizer_sink_ready <= (top_tx_packetizer_count == 1'd0);
			case (top_tx_packetizer_count)
				1'd0: begin
					top_tx_packetizer_source_payload_data <= top_tx_packetizer_header[7:0];
				end
				1'd1: begin
					top_tx_packetizer_source_payload_data <= top_tx_packetizer_header[15:8];
				end
				2'd2: begin
					top_tx_packetizer_source_payload_data <= top_tx_packetizer_header[23:16];
				end
				2'd3: begin
					top_tx_packetizer_source_payload_data <= top_tx_packetizer_header[31:24];
				end
				3'd4: begin
					top_tx_packetizer_source_payload_data <= top_tx_packetizer_header[39:32];
				end
				3'd5: begin
					top_tx_packetizer_source_payload_data <= top_tx_packetizer_header[47:40];
				end
				3'd6: begin
					top_tx_packetizer_source_payload_data <= top_tx_packetizer_header[55:48];
				end
				3'd7: begin
					top_tx_packetizer_source_payload_data <= top_tx_packetizer_header[63:56];
				end
			endcase
			if ((top_tx_packetizer_count == 3'd7)) begin
				top_tx_packetizer_source_be <= 1'd1;
			end
			if ((top_tx_packetizer_sink_valid & 1'd1)) begin
				top_tx_packetizer_source_valid <= 1'd1;
				top_tx_packetizer_source_first <= (top_tx_packetizer_count == 1'd0);
				top_tx_packetizer_source_last <= ((top_tx_packetizer_count == 3'd7) & (top_tx_packetizer_sink_last & (top_tx_packetizer_sink_payload_be == 1'd0)));
				top_tx_packetizer_sink_ready <= (((top_tx_packetizer_count == 3'd7) & (top_tx_packetizer_sink_last & (top_tx_packetizer_sink_payload_be == 1'd0))) & top_tx_packetizer_source_ready);
				if (top_tx_packetizer_source_ready) begin
					if ((top_tx_packetizer_count == 3'd7)) begin
						top_tx_packetizer_count_liteethudp_next_value <= 1'd0;
						top_tx_packetizer_count_liteethudp_next_value_ce <= 1'd1;
						if ((~top_tx_packetizer_source_last)) begin
							liteethudp_next_state <= 1'd0;
						end
					end else begin
						top_tx_packetizer_count_liteethudp_next_value <= (top_tx_packetizer_count + 1'd1);
						top_tx_packetizer_count_liteethudp_next_value_ce <= 1'd1;
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_74 <= dummy_s;
// synthesis translate_on
end
assign top_rx_depacketizer_sink_valid = top_rx_sink_sink_valid;
assign top_rx_sink_sink_ready = top_rx_depacketizer_sink_ready;
assign top_rx_depacketizer_sink_first = top_rx_sink_sink_first;
assign top_rx_depacketizer_sink_last = top_rx_sink_sink_last;
assign top_rx_depacketizer_sink_payload_data = top_rx_sink_sink_payload_data;
assign top_rx_depacketizer_sink_payload_be = top_rx_sink_sink_payload_be;
assign top_rx_depacketizer_sink_payload_error = top_rx_sink_sink_payload_error;
assign top_rx_depacketizer_sink_param_length = top_rx_sink_sink_param_length;
assign top_rx_depacketizer_sink_param_protocol = top_rx_sink_sink_param_protocol;
assign top_rx_depacketizer_sink_param_ip_address = top_rx_sink_sink_param_ip_address;
assign top_rx_source_source_payload_data = top_rx_depacketizer_source_payload_data;
assign top_rx_source_source_param_dst_port = top_rx_depacketizer_source_param_dst_port;
assign top_rx_source_source_param_src_port = top_rx_depacketizer_source_param_src_port;
assign top_rx_source_source_param_ip_address = top_rx_ip_address;
assign top_rx_source_source_param_length = (top_rx_depacketizer_source_param_length - 4'd8);
assign top_rx_accepted = (((top_rx_protocol == 5'd17) & (top_rx_depacketizer_source_param_length > 4'd8)) & (top_rx_depacketizer_source_param_length <= top_rx_length));
assign top_rx_receiving = top_rx_is_ongoing0;
assign top_rx_end_count = top_rx_count;
assign top_rx_source_source_valid = (top_rx_depacketizer_source_valid & top_rx_receiving);
assign top_rx_depacketizer_source_ready = (top_rx_is_ongoing1 | (top_rx_receiving & top_rx_source_source_ready));
assign top_rx_source_source_last = (top_rx_depacketizer_source_last | (top_rx_end_count >= top_rx_source_source_param_length));

// synthesis translate_off
reg dummy_d_75;
// synthesis translate_on
always @(*) begin
	top_rx_source_source_payload_be <= 1'd0;
	top_rx_source_source_payload_be <= top_rx_depacketizer_source_payload_be;
	if ((top_rx_end_count >= top_rx_source_source_param_length)) begin
		top_rx_source_source_payload_be <= (top_rx_depacketizer_source_payload_be & {((((top_rx_source_source_param_length & 1'd0) == 1'd0) ? 1'd1 : (top_rx_source_source_param_length & 1'd0)) > 1'd0)});
	end
// synthesis translate_off
	dummy_d_75 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_76;
// synthesis translate_on
always @(*) begin
	top_rx_source_source_payload_error <= 1'd0;
	top_rx_source_source_payload_error <= top_rx_depacketizer_source_payload_error;
	if ((top_rx_depacketizer_source_last & (((top_rx_end_count - 1'd1) + (1'd0 + top_rx_depacketizer_source_payload_be)) < top_rx_source_source_param_length))) begin
		top_rx_source_source_payload_error <= top_rx_source_source_payload_be;
	end
// synthesis translate_off
	dummy_d_76 <= dummy_s;
// synthesis translate_on
end
assign top_rx_depacketizer_header = top_rx_depacketizer_sr;
assign top_rx_depacketizer_source_param_checksum = {rhs_slice_proxy71[7:0], rhs_slice_proxy70[15:8]};
assign top_rx_depacketizer_source_param_dst_port = {rhs_slice_proxy73[7:0], rhs_slice_proxy72[15:8]};
assign top_rx_depacketizer_source_param_length = {rhs_slice_proxy75[7:0], rhs_slice_proxy74[15:8]};
assign top_rx_depacketizer_source_param_src_port = {rhs_slice_proxy77[7:0], rhs_slice_proxy76[15:8]};
assign top_rx_depacketizer_sink_be = top_rx_depacketizer_sink_payload_be;
assign top_rx_depacketizer_source_payload_be = top_rx_depacketizer_source_be;
assign top_rx_depacketizer_source_payload_error = top_rx_depacketizer_sink_payload_error;

// synthesis translate_off
reg dummy_d_77;
// synthesis translate_on
always @(*) begin
	top_rx_depacketizer_sink_ready <= 1'd0;
	top_rx_depacketizer_source_valid <= 1'd0;
	top_rx_depacketizer_source_first <= 1'd0;
	top_rx_depacketizer_source_last <= 1'd0;
	top_rx_depacketizer_source_payload_data <= 8'd0;
	top_rx_depacketizer_sr_shift <= 1'd0;
	top_rx_depacketizer_source_be <= 1'd1;
	liteethudp_liteethudpdepacketizer_next_state <= 2'd0;
	top_rx_depacketizer_count_liteethudp_liteethudpdepacketizer_next_value0 <= 3'd0;
	top_rx_depacketizer_count_liteethudp_liteethudpdepacketizer_next_value_ce0 <= 1'd0;
	top_rx_depacketizer_fsm_from_idle_liteethudp_liteethudpdepacketizer_next_value1 <= 1'd0;
	top_rx_depacketizer_fsm_from_idle_liteethudp_liteethudpdepacketizer_next_value_ce1 <= 1'd0;
	top_rx_depacketizer_data_copy_first_liteethudp_liteethudpdepacketizer_next_value2 <= 1'd0;
	top_rx_depacketizer_data_copy_first_liteethudp_liteethudpdepacketizer_next_value_ce2 <= 1'd0;
	liteethudp_liteethudpdepacketizer_next_state <= liteethudp_liteethudpdepacketizer_state;
	case (liteethudp_liteethudpdepacketizer_state)
		1'd1: begin
			top_rx_depacketizer_sink_ready <= 1'd1;
			if (top_rx_depacketizer_sink_valid) begin
				top_rx_depacketizer_count_liteethudp_liteethudpdepacketizer_next_value0 <= (top_rx_depacketizer_count + 1'd1);
				top_rx_depacketizer_count_liteethudp_liteethudpdepacketizer_next_value_ce0 <= 1'd1;
				top_rx_depacketizer_sr_shift <= 1'd1;
				if ((top_rx_depacketizer_count == 3'd7)) begin
					top_rx_depacketizer_data_copy_first_liteethudp_liteethudpdepacketizer_next_value2 <= 1'd1;
					top_rx_depacketizer_data_copy_first_liteethudp_liteethudpdepacketizer_next_value_ce2 <= 1'd1;
					liteethudp_liteethudpdepacketizer_next_state <= 2'd2;
					top_rx_depacketizer_count_liteethudp_liteethudpdepacketizer_next_value0 <= (top_rx_depacketizer_count + 1'd1);
					top_rx_depacketizer_count_liteethudp_liteethudpdepacketizer_next_value_ce0 <= 1'd1;
				end
				if (top_rx_depacketizer_sink_last) begin
					liteethudp_liteethudpdepacketizer_next_state <= 1'd0;
				end
			end
		end
		2'd2: begin
			top_rx_depacketizer_source_valid <= top_rx_depacketizer_sink_valid;
			top_rx_depacketizer_source_first <= top_rx_depacketizer_data_copy_first;
			top_rx_depacketizer_source_last <= top_rx_depacketizer_sink_last;
			top_rx_depacketizer_sink_ready <= top_rx_depacketizer_source_ready;
			top_rx_depacketizer_source_payload_data <= top_rx_depacketizer_sink_payload_data;
			top_rx_depacketizer_source_be <= top_rx_depacketizer_sink_be;
			if ((top_rx_depacketizer_source_valid & top_rx_depacketizer_source_ready)) begin
				top_rx_depacketizer_data_copy_first_liteethudp_liteethudpdepacketizer_next_value2 <= 1'd0;
				top_rx_depacketizer_data_copy_first_liteethudp_liteethudpdepacketizer_next_value_ce2 <= 1'd1;
				top_rx_depacketizer_fsm_from_idle_liteethudp_liteethudpdepacketizer_next_value1 <= 1'd0;
				top_rx_depacketizer_fsm_from_idle_liteethudp_liteethudpdepacketizer_next_value_ce1 <= 1'd1;
				if (top_rx_depacketizer_source_last) begin
					liteethudp_liteethudpdepacketizer_next_state <= 1'd0;
				end
			end
		end
		default: begin
			top_rx_depacketizer_sink_ready <= 1'd1;
			top_rx_depacketizer_count_liteethudp_liteethudpdepacketizer_next_value0 <= 1'd1;
			top_rx_depacketizer_count_liteethudp_liteethudpdepacketizer_next_value_ce0 <= 1'd1;
			if (top_rx_depacketizer_sink_valid) begin
				top_rx_depacketizer_sr_shift <= 1'd1;
				top_rx_depacketizer_fsm_from_idle_liteethudp_liteethudpdepacketizer_next_value1 <= 1'd1;
				top_rx_depacketizer_fsm_from_idle_liteethudp_liteethudpdepacketizer_next_value_ce1 <= 1'd1;
				top_rx_depacketizer_data_copy_first_liteethudp_liteethudpdepacketizer_next_value2 <= 1'd1;
				top_rx_depacketizer_data_copy_first_liteethudp_liteethudpdepacketizer_next_value_ce2 <= 1'd1;
				if (1'd0) begin
					liteethudp_liteethudpdepacketizer_next_state <= 2'd2;
				end else begin
					liteethudp_liteethudpdepacketizer_next_state <= 1'd1;
				end
				if (($signed({1'd0, top_rx_depacketizer_sink_last}) & 1'sd1)) begin
					liteethudp_liteethudpdepacketizer_next_state <= 1'd0;
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_77 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_78;
// synthesis translate_on
always @(*) begin
	top_rx_is_ongoing0 <= 1'd0;
	top_rx_is_ongoing1 <= 1'd0;
	liteethudp_fsm_next_state <= 2'd0;
	top_rx_count_liteethudp_fsm_next_value <= 17'd0;
	top_rx_count_liteethudp_fsm_next_value_ce <= 1'd0;
	liteethudp_fsm_next_state <= liteethudp_fsm_state;
	case (liteethudp_fsm_state)
		1'd0: begin
			top_rx_is_ongoing0 <= 1'd1;
			if ((top_rx_source_source_valid & top_rx_source_source_ready)) begin
				top_rx_count_liteethudp_fsm_next_value <= (top_rx_end_count + 1'd1);
				top_rx_count_liteethudp_fsm_next_value_ce <= 1'd1;
				liteethudp_fsm_next_state <= 1'd0;
				if (top_rx_depacketizer_source_last) begin
					liteethudp_fsm_next_state <= 2'd2;
				end else begin
					if (top_rx_source_source_last) begin
						liteethudp_fsm_next_state <= 1'd1;
					end
				end
			end
		end
		1'd1: begin
			top_rx_is_ongoing1 <= 1'd1;
			if (((top_rx_depacketizer_source_valid & top_rx_depacketizer_source_last) & top_rx_depacketizer_source_ready)) begin
				liteethudp_fsm_next_state <= 2'd2;
			end
		end
		default: begin
			top_rx_count_liteethudp_fsm_next_value <= 1'd1;
			top_rx_count_liteethudp_fsm_next_value_ce <= 1'd1;
			if (top_rx_depacketizer_source_valid) begin
				liteethudp_fsm_next_state <= 1'd1;
				if (top_rx_accepted) begin
					liteethudp_fsm_next_state <= 1'd0;
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_78 <= dummy_s;
// synthesis translate_on
end
assign top_tx_cdc_sink_valid = top_user_port_sink_valid;
assign top_user_port_sink_ready = top_tx_cdc_sink_ready;
assign top_tx_cdc_sink_first = top_user_port_sink_first;
assign top_tx_cdc_sink_last = top_user_port_sink_last;
assign top_tx_cdc_sink_payload_data = top_user_port_sink_payload_data;
assign top_tx_cdc_sink_payload_be = top_user_port_sink_payload_be;
assign top_tx_cdc_sink_payload_error = top_user_port_sink_payload_error;
assign top_tx_cdc_sink_param_src_port = top_user_port_sink_param_src_port;
assign top_tx_cdc_sink_param_dst_port = top_user_port_sink_param_dst_port;
assign top_tx_cdc_sink_param_ip_address = top_user_port_sink_param_ip_address;
assign top_tx_cdc_sink_param_length = top_user_port_sink_param_length;
assign top_tx_converter_sink_sink_valid = top_tx_cdc_source_valid;
assign top_tx_cdc_source_ready = top_tx_converter_sink_sink_ready;
assign top_tx_converter_sink_sink_first = top_tx_cdc_source_first;
assign top_tx_converter_sink_sink_last = top_tx_cdc_source_last;
assign top_tx_converter_sink_sink_payload_data = top_tx_cdc_source_payload_data;
assign top_tx_converter_sink_sink_payload_be = top_tx_cdc_source_payload_be;
assign top_tx_converter_sink_sink_payload_error = top_tx_cdc_source_payload_error;
assign top_tx_converter_sink_sink_param_src_port = top_tx_cdc_source_param_src_port;
assign top_tx_converter_sink_sink_param_dst_port = top_tx_cdc_source_param_dst_port;
assign top_tx_converter_sink_sink_param_ip_address = top_tx_cdc_source_param_ip_address;
assign top_tx_converter_sink_sink_param_length = top_tx_cdc_source_param_length;
assign top_internal_port_sink_valid = top_tx_converter_source_source_valid;
assign top_tx_converter_source_source_ready = top_internal_port_sink_ready;
assign top_internal_port_sink_first = top_tx_converter_source_source_first;
assign top_internal_port_sink_last = top_tx_converter_source_source_last;
assign top_internal_port_sink_payload_data = top_tx_converter_source_source_payload_data;
assign top_internal_port_sink_payload_be = top_tx_converter_source_source_payload_be;
assign top_internal_port_sink_payload_error = top_tx_converter_source_source_payload_error;
assign top_internal_port_sink_param_src_port = top_tx_converter_source_source_param_src_port;
assign top_internal_port_sink_param_dst_port = top_tx_converter_source_source_param_dst_port;
assign top_internal_port_sink_param_ip_address = top_tx_converter_source_source_param_ip_address;
assign top_internal_port_sink_param_length = top_tx_converter_source_source_param_length;
assign top_rx_converter_sink_sink_valid = top_internal_port_source_valid;
assign top_internal_port_source_ready = top_rx_converter_sink_sink_ready;
assign top_rx_converter_sink_sink_first = top_internal_port_source_first;
assign top_rx_converter_sink_sink_last = top_internal_port_source_last;
assign top_rx_converter_sink_sink_payload_data = top_internal_port_source_payload_data;
assign top_rx_converter_sink_sink_payload_be = top_internal_port_source_payload_be;
assign top_rx_converter_sink_sink_payload_error = top_internal_port_source_payload_error;
assign top_rx_converter_sink_sink_param_src_port = top_internal_port_source_param_src_port;
assign top_rx_converter_sink_sink_param_dst_port = top_internal_port_source_param_dst_port;
assign top_rx_converter_sink_sink_param_ip_address = top_internal_port_source_param_ip_address;
assign top_rx_converter_sink_sink_param_length = top_internal_port_source_param_length;
assign top_rx_cdc_sink_valid = top_rx_converter_source_source_valid;
assign top_rx_converter_source_source_ready = top_rx_cdc_sink_ready;
assign top_rx_cdc_sink_first = top_rx_converter_source_source_first;
assign top_rx_cdc_sink_last = top_rx_converter_source_source_last;
assign top_rx_cdc_sink_payload_data = top_rx_converter_source_source_payload_data;
assign top_rx_cdc_sink_payload_be = top_rx_converter_source_source_payload_be;
assign top_rx_cdc_sink_payload_error = top_rx_converter_source_source_payload_error;
assign top_rx_cdc_sink_param_src_port = top_rx_converter_source_source_param_src_port;
assign top_rx_cdc_sink_param_dst_port = top_rx_converter_source_source_param_dst_port;
assign top_rx_cdc_sink_param_ip_address = top_rx_converter_source_source_param_ip_address;
assign top_rx_cdc_sink_param_length = top_rx_converter_source_source_param_length;
assign top_user_port_source_valid = top_rx_cdc_source_valid;
assign top_rx_cdc_source_ready = top_user_port_source_ready;
assign top_user_port_source_first = top_rx_cdc_source_first;
assign top_user_port_source_last = top_rx_cdc_source_last;
assign top_user_port_source_payload_data = top_rx_cdc_source_payload_data;
assign top_user_port_source_payload_be = top_rx_cdc_source_payload_be;
assign top_user_port_source_payload_error = top_rx_cdc_source_payload_error;
assign top_user_port_source_param_src_port = top_rx_cdc_source_param_src_port;
assign top_user_port_source_param_dst_port = top_rx_cdc_source_param_dst_port;
assign top_user_port_source_param_ip_address = top_rx_cdc_source_param_ip_address;
assign top_user_port_source_param_length = top_rx_cdc_source_param_length;

// synthesis translate_off
reg dummy_d_79;
// synthesis translate_on
always @(*) begin
	liteethudp_sel0 <= 1'd0;
	if ((top_crossbar_sink_param_dst_port == 16'd40000)) begin
		liteethudp_sel0 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_79 <= dummy_s;
// synthesis translate_on
end
assign top_tx_cdc_source_valid = top_tx_cdc_sink_valid;
assign top_tx_cdc_sink_ready = top_tx_cdc_source_ready;
assign top_tx_cdc_source_first = top_tx_cdc_sink_first;
assign top_tx_cdc_source_last = top_tx_cdc_sink_last;
assign top_tx_cdc_source_payload_data = top_tx_cdc_sink_payload_data;
assign top_tx_cdc_source_payload_be = top_tx_cdc_sink_payload_be;
assign top_tx_cdc_source_payload_error = top_tx_cdc_sink_payload_error;
assign top_tx_cdc_source_param_src_port = top_tx_cdc_sink_param_src_port;
assign top_tx_cdc_source_param_dst_port = top_tx_cdc_sink_param_dst_port;
assign top_tx_cdc_source_param_ip_address = top_tx_cdc_sink_param_ip_address;
assign top_tx_cdc_source_param_length = top_tx_cdc_sink_param_length;
assign top_tx_converter_converter_sink_valid = top_tx_converter_sink_sink_valid;
assign top_tx_converter_converter_sink_first = top_tx_converter_sink_sink_first;
assign top_tx_converter_converter_sink_last = top_tx_converter_sink_sink_last;
assign top_tx_converter_sink_sink_ready = top_tx_converter_converter_sink_ready;
assign top_tx_converter_converter_sink_payload_data = {top_tx_converter_sink_sink_payload_error, top_tx_converter_sink_sink_payload_be, top_tx_converter_sink_sink_payload_data};
assign top_tx_converter_source_source_valid = top_tx_converter_converter_source_valid;
assign top_tx_converter_source_source_first = top_tx_converter_converter_source_first;
assign top_tx_converter_source_source_last = top_tx_converter_converter_source_last;
assign top_tx_converter_converter_source_ready = top_tx_converter_source_source_ready;
assign {top_tx_converter_source_source_payload_error, top_tx_converter_source_source_payload_be, top_tx_converter_source_source_payload_data} = top_tx_converter_converter_source_payload_data;
assign top_tx_converter_source_source_param_src_port = top_tx_converter_sink_sink_param_src_port;
assign top_tx_converter_source_source_param_dst_port = top_tx_converter_sink_sink_param_dst_port;
assign top_tx_converter_source_source_param_ip_address = top_tx_converter_sink_sink_param_ip_address;
assign top_tx_converter_source_source_param_length = top_tx_converter_sink_sink_param_length;
assign top_tx_converter_converter_source_valid = top_tx_converter_converter_sink_valid;
assign top_tx_converter_converter_sink_ready = top_tx_converter_converter_source_ready;
assign top_tx_converter_converter_source_first = top_tx_converter_converter_sink_first;
assign top_tx_converter_converter_source_last = top_tx_converter_converter_sink_last;
assign top_tx_converter_converter_source_payload_data = top_tx_converter_converter_sink_payload_data;
assign top_tx_converter_converter_source_payload_valid_token_count = 1'd1;
assign top_rx_converter_converter_sink_valid = top_rx_converter_sink_sink_valid;
assign top_rx_converter_converter_sink_first = top_rx_converter_sink_sink_first;
assign top_rx_converter_converter_sink_last = top_rx_converter_sink_sink_last;
assign top_rx_converter_sink_sink_ready = top_rx_converter_converter_sink_ready;
assign top_rx_converter_converter_sink_payload_data = {top_rx_converter_sink_sink_payload_error, top_rx_converter_sink_sink_payload_be, top_rx_converter_sink_sink_payload_data};
assign top_rx_converter_source_source_valid = top_rx_converter_converter_source_valid;
assign top_rx_converter_source_source_first = top_rx_converter_converter_source_first;
assign top_rx_converter_source_source_last = top_rx_converter_converter_source_last;
assign top_rx_converter_converter_source_ready = top_rx_converter_source_source_ready;
assign {top_rx_converter_source_source_payload_error, top_rx_converter_source_source_payload_be, top_rx_converter_source_source_payload_data} = top_rx_converter_converter_source_payload_data;
assign top_rx_converter_source_source_param_src_port = top_rx_converter_sink_sink_param_src_port;
assign top_rx_converter_source_source_param_dst_port = top_rx_converter_sink_sink_param_dst_port;
assign top_rx_converter_source_source_param_ip_address = top_rx_converter_sink_sink_param_ip_address;
assign top_rx_converter_source_source_param_length = top_rx_converter_sink_sink_param_length;
assign top_rx_converter_converter_source_valid = top_rx_converter_converter_sink_valid;
assign top_rx_converter_converter_sink_ready = top_rx_converter_converter_source_ready;
assign top_rx_converter_converter_source_first = top_rx_converter_converter_sink_first;
assign top_rx_converter_converter_source_last = top_rx_converter_converter_sink_last;
assign top_rx_converter_converter_source_payload_data = top_rx_converter_converter_sink_payload_data;
assign top_rx_converter_converter_source_payload_valid_token_count = 1'd1;
assign top_rx_cdc_source_valid = top_rx_cdc_sink_valid;
assign top_rx_cdc_sink_ready = top_rx_cdc_source_ready;
assign top_rx_cdc_source_first = top_rx_cdc_sink_first;
assign top_rx_cdc_source_last = top_rx_cdc_sink_last;
assign top_rx_cdc_source_payload_data = top_rx_cdc_sink_payload_data;
assign top_rx_cdc_source_payload_be = top_rx_cdc_sink_payload_be;
assign top_rx_cdc_source_payload_error = top_rx_cdc_sink_payload_error;
assign top_rx_cdc_source_param_src_port = top_rx_cdc_sink_param_src_port;
assign top_rx_cdc_source_param_dst_port = top_rx_cdc_sink_param_dst_port;
assign top_rx_cdc_source_param_ip_address = top_rx_cdc_sink_param_ip_address;
assign top_rx_cdc_source_param_length = top_rx_cdc_sink_param_length;
assign top_crossbar_source_valid = top_internal_port_sink_valid;
assign top_internal_port_sink_ready = top_crossbar_source_ready;
assign top_crossbar_source_first = top_internal_port_sink_first;
assign top_crossbar_source_last = top_internal_port_sink_last;
assign top_crossbar_source_payload_data = top_internal_port_sink_payload_data;
assign top_crossbar_source_payload_be = top_internal_port_sink_payload_be;
assign top_crossbar_source_payload_error = top_internal_port_sink_payload_error;
assign top_crossbar_source_param_src_port = top_internal_port_sink_param_src_port;
assign top_crossbar_source_param_dst_port = top_internal_port_sink_param_dst_port;
assign top_crossbar_source_param_ip_address = top_internal_port_sink_param_ip_address;
assign top_crossbar_source_param_length = top_internal_port_sink_param_length;

// synthesis translate_off
reg dummy_d_80;
// synthesis translate_on
always @(*) begin
	liteethudp_sel1 <= 1'd0;
	if ((~liteethudp_sel_locked)) begin
		liteethudp_sel1 <= liteethudp_sel0;
	end else begin
		liteethudp_sel1 <= liteethudp_sel_ongoing;
	end
// synthesis translate_off
	dummy_d_80 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_81;
// synthesis translate_on
always @(*) begin
	top_crossbar_sink_ready <= 1'd0;
	top_internal_port_source_valid <= 1'd0;
	top_internal_port_source_first <= 1'd0;
	top_internal_port_source_last <= 1'd0;
	top_internal_port_source_payload_data <= 8'd0;
	top_internal_port_source_payload_be <= 1'd0;
	top_internal_port_source_payload_error <= 1'd0;
	top_internal_port_source_param_src_port <= 16'd0;
	top_internal_port_source_param_dst_port <= 16'd0;
	top_internal_port_source_param_ip_address <= 32'd0;
	top_internal_port_source_param_length <= 16'd0;
	case (liteethudp_sel1)
		1'd1: begin
			top_internal_port_source_valid <= top_crossbar_sink_valid;
			top_crossbar_sink_ready <= top_internal_port_source_ready;
			top_internal_port_source_first <= top_crossbar_sink_first;
			top_internal_port_source_last <= top_crossbar_sink_last;
			top_internal_port_source_payload_data <= top_crossbar_sink_payload_data;
			top_internal_port_source_payload_be <= top_crossbar_sink_payload_be;
			top_internal_port_source_payload_error <= top_crossbar_sink_payload_error;
			top_internal_port_source_param_src_port <= top_crossbar_sink_param_src_port;
			top_internal_port_source_param_dst_port <= top_crossbar_sink_param_dst_port;
			top_internal_port_source_param_ip_address <= top_crossbar_sink_param_ip_address;
			top_internal_port_source_param_length <= top_crossbar_sink_param_length;
		end
		default: begin
			top_crossbar_sink_ready <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_81 <= dummy_s;
// synthesis translate_on
end
assign liteethudp_last = ((top_crossbar_sink_valid & top_crossbar_sink_last) & top_crossbar_sink_ready);
assign liteethudp_ongoing0 = ((top_crossbar_sink_valid | liteethudp_ongoing1) & (~liteethudp_last));
assign top_arm_cdc_i = top_arm;
assign top_done = top_done_cdc_o;
assign top_done_cdc_i = (top_active & (top_index == 12'd4095));
assign top_wp_memory0_adr = top_index;
assign top_wp_memory0_dat_w = top_sampled0;
assign top_wp_memory0_we = top_active;
assign top_rp_memory0_adr = top_address;
assign top_wp_memory1_adr = top_index;
assign top_wp_memory1_dat_w = top_sampled1;
assign top_wp_memory1_we = top_active;
assign top_rp_memory1_adr = top_address;
assign top_wp_memory2_adr = top_index;
assign top_wp_memory2_dat_w = top_sampled2;
assign top_wp_memory2_we = top_active;
assign top_rp_memory2_adr = top_address;
assign top_wp_memory3_adr = top_index;
assign top_wp_memory3_dat_w = top_sampled3;
assign top_wp_memory3_we = top_active;
assign top_rp_memory3_adr = top_address;
assign top_wp_memory4_adr = top_index;
assign top_wp_memory4_dat_w = top_sampled4;
assign top_wp_memory4_we = top_active;
assign top_rp_memory4_adr = top_address;
assign top_wp_memory5_adr = top_index;
assign top_wp_memory5_dat_w = top_sampled5;
assign top_wp_memory5_we = top_active;
assign top_rp_memory5_adr = top_address;
assign top_wp_memory6_adr = top_index;
assign top_wp_memory6_dat_w = top_sampled6;
assign top_wp_memory6_we = top_active;
assign top_rp_memory6_adr = top_address;
assign top_wp_memory7_adr = top_index;
assign top_wp_memory7_dat_w = top_sampled7;
assign top_wp_memory7_we = top_active;
assign top_rp_memory7_adr = top_address;
assign top_wp_memory8_adr = top_index;
assign top_wp_memory8_dat_w = top_sampled8;
assign top_wp_memory8_we = top_active;
assign top_rp_memory8_adr = top_address;
assign top_wp_memory9_adr = top_index;
assign top_wp_memory9_dat_w = top_sampled9;
assign top_wp_memory9_we = top_active;
assign top_rp_memory9_adr = top_address;
assign top_wp_memory10_adr = top_index;
assign top_wp_memory10_dat_w = top_sampled10;
assign top_wp_memory10_we = top_active;
assign top_rp_memory10_adr = top_address;
assign top_wp_memory11_adr = top_index;
assign top_wp_memory11_dat_w = top_sampled11;
assign top_wp_memory11_we = top_active;
assign top_rp_memory11_adr = top_address;
assign top_arm_cdc_o = (top_arm_cdc_toggle_o ^ top_arm_cdc_toggle_o_r);
assign top_done_cdc_o = (top_done_cdc_toggle_o ^ top_done_cdc_toggle_o_r);
assign top_server_flags = {top_server_locked, top_server_link, top_server_valid};
assign top_user_port_source_ready = top_server_is_ongoing;
assign top_user_port_sink_payload_be = 1'd1;
assign top_user_port_sink_payload_error = 1'd0;
assign top_user_port_sink_param_src_port = 16'd40000;
assign top_user_port_sink_param_dst_port = top_server_remote_port;
assign top_user_port_sink_param_ip_address = top_server_remote_ip;
assign top_user_port_sink_param_length = ((top_server4 == 2'd2) ? 11'd1040 : 5'd16);
assign top_address = {top_server7[2:0], top_server_wordidx};

// synthesis translate_off
reg dummy_d_82;
// synthesis translate_on
always @(*) begin
	top_arm <= 1'd0;
	top_user_port_sink_valid <= 1'd0;
	top_user_port_sink_first <= 1'd0;
	top_user_port_sink_last <= 1'd0;
	top_user_port_sink_payload_data <= 8'd0;
	top_server_is_ongoing <= 1'd0;
	next_state <= 4'd0;
	next_value <= 8'd0;
	next_value_ce <= 1'd0;
	top_server_remote_ip_next_value0 <= 32'd0;
	top_server_remote_ip_next_value_ce0 <= 1'd0;
	top_server_remote_port_next_value1 <= 16'd0;
	top_server_remote_port_next_value_ce1 <= 1'd0;
	top_server_bad_next_value2 <= 1'd0;
	top_server_bad_next_value_ce2 <= 1'd0;
	top_server_count_next_value3 <= 4'd0;
	top_server_count_next_value_ce3 <= 1'd0;
	top_server_checked_next_value4 <= 32'd0;
	top_server_checked_next_value_ce4 <= 1'd0;
	top_server_hidx_next_value5 <= 4'd0;
	top_server_hidx_next_value_ce5 <= 1'd0;
	top_server_wordidx_next_value6 <= 9'd0;
	top_server_wordidx_next_value_ce6 <= 1'd0;
	top_server_ev_next_value7 <= 1'd0;
	top_server_ev_next_value_ce7 <= 1'd0;
	top_server_valid_next_value8 <= 1'd0;
	top_server_valid_next_value_ce8 <= 1'd0;
	top_server_settle_next_value9 <= 11'd0;
	top_server_settle_next_value_ce9 <= 1'd0;
	top_server_capture_id_next_value10 <= 32'd0;
	top_server_capture_id_next_value_ce10 <= 1'd0;
	top_server_word_next_value11 <= 16'd0;
	top_server_word_next_value_ce11 <= 1'd0;
	top_user_port_sink_valid <= 1'd0;
	top_user_port_sink_payload_data <= 1'd0;
	top_user_port_sink_first <= 1'd0;
	top_user_port_sink_last <= 1'd0;
	top_arm <= 1'd0;
	next_state <= state;
	case (state)
		1'd1: begin
			top_server_checked_next_value4 <= (top_server_checked + 1'd1);
			top_server_checked_next_value_ce4 <= 1'd1;
			top_server_count_next_value3 <= 1'd0;
			top_server_count_next_value_ce3 <= 1'd1;
			top_server_bad_next_value2 <= 1'd0;
			top_server_bad_next_value_ce2 <= 1'd1;
			top_server_hidx_next_value5 <= 1'd0;
			top_server_hidx_next_value_ce5 <= 1'd1;
			top_server_wordidx_next_value6 <= 1'd0;
			top_server_wordidx_next_value_ce6 <= 1'd1;
			if (((((((((top_server0 == 7'd65) & (top_server1 == 7'd68)) & (top_server2 == 7'd67)) & (top_server3 == 6'd49)) & (top_server4 <= 2'd2)) & (top_server5 < 4'd12)) & (top_server6 < 2'd2)) & (top_server7 < 4'd8))) begin
				if ((top_server4 == 1'd1)) begin
					top_server_ev_next_value7 <= top_server6[0];
					top_server_ev_next_value_ce7 <= 1'd1;
					top_server_valid_next_value8 <= 1'd0;
					top_server_valid_next_value_ce8 <= 1'd1;
					top_server_settle_next_value9 <= 10'd1000;
					top_server_settle_next_value_ce9 <= 1'd1;
					next_state <= 2'd2;
				end else begin
					if (((top_server4 == 2'd2) & ((~top_server_valid) | (top_server6[0] != top_server_ev)))) begin
						next_state <= 1'd0;
					end else begin
						next_state <= 3'd4;
					end
				end
			end else begin
				next_state <= 1'd0;
			end
		end
		2'd2: begin
			if ((top_server_settle == 1'd0)) begin
				top_arm <= 1'd1;
				next_state <= 2'd3;
			end else begin
				top_server_settle_next_value9 <= (top_server_settle - 1'd1);
				top_server_settle_next_value_ce9 <= 1'd1;
			end
		end
		2'd3: begin
			if (top_done) begin
				top_server_valid_next_value8 <= 1'd1;
				top_server_valid_next_value_ce8 <= 1'd1;
				top_server_capture_id_next_value10 <= (top_server_capture_id + 1'd1);
				top_server_capture_id_next_value_ce10 <= 1'd1;
				next_state <= 3'd4;
			end
		end
		3'd4: begin
			top_user_port_sink_valid <= 1'd1;
			top_user_port_sink_payload_data <= comb_rhs_self;
			top_user_port_sink_first <= (top_server_hidx == 1'd0);
			top_user_port_sink_last <= ((top_server4 != 2'd2) & (top_server_hidx == 4'd15));
			if (top_user_port_sink_ready) begin
				if ((top_server_hidx == 4'd15)) begin
					if ((top_server4 == 2'd2)) begin
						next_state <= 3'd5;
					end else begin
						next_state <= 1'd0;
					end
				end else begin
					top_server_hidx_next_value5 <= (top_server_hidx + 1'd1);
					top_server_hidx_next_value_ce5 <= 1'd1;
				end
			end
		end
		3'd5: begin
			next_state <= 3'd6;
		end
		3'd6: begin
			top_server_word_next_value11 <= comb_basiclowerer_self;
			top_server_word_next_value_ce11 <= 1'd1;
			next_state <= 3'd7;
		end
		3'd7: begin
			top_user_port_sink_valid <= 1'd1;
			top_user_port_sink_payload_data <= top_server_word[7:0];
			if (top_user_port_sink_ready) begin
				next_state <= 4'd8;
			end
		end
		4'd8: begin
			top_user_port_sink_valid <= 1'd1;
			top_user_port_sink_payload_data <= top_server_word[15:8];
			top_user_port_sink_last <= (top_server_wordidx == 9'd511);
			if (top_user_port_sink_ready) begin
				if ((top_server_wordidx == 9'd511)) begin
					next_state <= 1'd0;
				end else begin
					top_server_wordidx_next_value6 <= (top_server_wordidx + 1'd1);
					top_server_wordidx_next_value_ce6 <= 1'd1;
					next_state <= 3'd5;
				end
			end
		end
		default: begin
			top_server_is_ongoing <= 1'd1;
			if (top_user_port_source_valid) begin
				if ((top_server_count < 4'd8)) begin
					next_value <= top_user_port_source_payload_data;
					next_value_ce <= 1'd1;
				end
				if ((top_server_count == 1'd0)) begin
					top_server_remote_ip_next_value0 <= top_user_port_source_param_ip_address;
					top_server_remote_ip_next_value_ce0 <= 1'd1;
					top_server_remote_port_next_value1 <= top_user_port_source_param_src_port;
					top_server_remote_port_next_value_ce1 <= 1'd1;
				end
				if ((top_user_port_source_payload_error | (top_server_count >= 4'd8))) begin
					top_server_bad_next_value2 <= 1'd1;
					top_server_bad_next_value_ce2 <= 1'd1;
				end
				if (top_user_port_source_last) begin
					if (((((top_server_count == 3'd7) & (~top_server_bad)) & (~top_user_port_source_payload_error)) & (top_user_port_source_param_length == 4'd8))) begin
						next_state <= 1'd1;
					end else begin
						top_server_count_next_value3 <= 1'd0;
						top_server_count_next_value_ce3 <= 1'd1;
						top_server_bad_next_value2 <= 1'd0;
						top_server_bad_next_value_ce2 <= 1'd1;
					end
				end else begin
					if ((top_server_count < 4'd9)) begin
						top_server_count_next_value3 <= (top_server_count + 1'd1);
						top_server_count_next_value_ce3 <= 1'd1;
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_82 <= dummy_s;
// synthesis translate_on
end
assign complexslicelowerer_slice_proxy = {top_mac_core_tx_crc_value, top_mac_core_tx_crc_sink_payload_data[7:0]};
assign rhs_slice_proxy0 = top_mac_depacketizer_header[111:96];
assign rhs_slice_proxy1 = top_mac_depacketizer_header[111:96];
assign rhs_slice_proxy2 = top_mac_depacketizer_header[95:48];
assign rhs_slice_proxy3 = top_mac_depacketizer_header[95:48];
assign rhs_slice_proxy4 = top_mac_depacketizer_header[95:48];
assign rhs_slice_proxy5 = top_mac_depacketizer_header[95:48];
assign rhs_slice_proxy6 = top_mac_depacketizer_header[95:48];
assign rhs_slice_proxy7 = top_mac_depacketizer_header[95:48];
assign rhs_slice_proxy8 = top_mac_depacketizer_header[47:0];
assign rhs_slice_proxy9 = top_mac_depacketizer_header[47:0];
assign rhs_slice_proxy10 = top_mac_depacketizer_header[47:0];
assign rhs_slice_proxy11 = top_mac_depacketizer_header[47:0];
assign rhs_slice_proxy12 = top_mac_depacketizer_header[47:0];
assign rhs_slice_proxy13 = top_mac_depacketizer_header[47:0];
assign rhs_slice_proxy14 = top_arp_rx_depacketizer_header[39:32];
assign rhs_slice_proxy15 = top_arp_rx_depacketizer_header[15:0];
assign rhs_slice_proxy16 = top_arp_rx_depacketizer_header[15:0];
assign rhs_slice_proxy17 = top_arp_rx_depacketizer_header[63:48];
assign rhs_slice_proxy18 = top_arp_rx_depacketizer_header[63:48];
assign rhs_slice_proxy19 = top_arp_rx_depacketizer_header[31:16];
assign rhs_slice_proxy20 = top_arp_rx_depacketizer_header[31:16];
assign rhs_slice_proxy21 = top_arp_rx_depacketizer_header[47:40];
assign rhs_slice_proxy22 = top_arp_rx_depacketizer_header[143:112];
assign rhs_slice_proxy23 = top_arp_rx_depacketizer_header[143:112];
assign rhs_slice_proxy24 = top_arp_rx_depacketizer_header[143:112];
assign rhs_slice_proxy25 = top_arp_rx_depacketizer_header[143:112];
assign rhs_slice_proxy26 = top_arp_rx_depacketizer_header[111:64];
assign rhs_slice_proxy27 = top_arp_rx_depacketizer_header[111:64];
assign rhs_slice_proxy28 = top_arp_rx_depacketizer_header[111:64];
assign rhs_slice_proxy29 = top_arp_rx_depacketizer_header[111:64];
assign rhs_slice_proxy30 = top_arp_rx_depacketizer_header[111:64];
assign rhs_slice_proxy31 = top_arp_rx_depacketizer_header[111:64];
assign rhs_slice_proxy32 = top_arp_rx_depacketizer_header[223:192];
assign rhs_slice_proxy33 = top_arp_rx_depacketizer_header[223:192];
assign rhs_slice_proxy34 = top_arp_rx_depacketizer_header[223:192];
assign rhs_slice_proxy35 = top_arp_rx_depacketizer_header[223:192];
assign rhs_slice_proxy36 = top_arp_rx_depacketizer_header[191:144];
assign rhs_slice_proxy37 = top_arp_rx_depacketizer_header[191:144];
assign rhs_slice_proxy38 = top_arp_rx_depacketizer_header[191:144];
assign rhs_slice_proxy39 = top_arp_rx_depacketizer_header[191:144];
assign rhs_slice_proxy40 = top_arp_rx_depacketizer_header[191:144];
assign rhs_slice_proxy41 = top_arp_rx_depacketizer_header[191:144];
assign rhs_slice_proxy42 = top_ip_rx_depacketizer_header[95:80];
assign rhs_slice_proxy43 = top_ip_rx_depacketizer_header[95:80];
assign rhs_slice_proxy44 = top_ip_rx_depacketizer_header[63:48];
assign rhs_slice_proxy45 = top_ip_rx_depacketizer_header[63:48];
assign rhs_slice_proxy46 = top_ip_rx_depacketizer_header[47:32];
assign rhs_slice_proxy47 = top_ip_rx_depacketizer_header[47:32];
assign rhs_slice_proxy48 = top_ip_rx_depacketizer_header[3:0];
assign rhs_slice_proxy49 = top_ip_rx_depacketizer_header[79:72];
assign rhs_slice_proxy50 = top_ip_rx_depacketizer_header[127:96];
assign rhs_slice_proxy51 = top_ip_rx_depacketizer_header[127:96];
assign rhs_slice_proxy52 = top_ip_rx_depacketizer_header[127:96];
assign rhs_slice_proxy53 = top_ip_rx_depacketizer_header[127:96];
assign rhs_slice_proxy54 = top_ip_rx_depacketizer_header[159:128];
assign rhs_slice_proxy55 = top_ip_rx_depacketizer_header[159:128];
assign rhs_slice_proxy56 = top_ip_rx_depacketizer_header[159:128];
assign rhs_slice_proxy57 = top_ip_rx_depacketizer_header[159:128];
assign rhs_slice_proxy58 = top_ip_rx_depacketizer_header[31:16];
assign rhs_slice_proxy59 = top_ip_rx_depacketizer_header[31:16];
assign rhs_slice_proxy60 = top_ip_rx_depacketizer_header[71:64];
assign rhs_slice_proxy61 = top_ip_rx_depacketizer_header[7:4];
assign rhs_slice_proxy62 = top_icmp_rx_depacketizer_header[31:16];
assign rhs_slice_proxy63 = top_icmp_rx_depacketizer_header[31:16];
assign rhs_slice_proxy64 = top_icmp_rx_depacketizer_header[15:8];
assign rhs_slice_proxy65 = top_icmp_rx_depacketizer_header[7:0];
assign rhs_slice_proxy66 = top_icmp_rx_depacketizer_header[63:32];
assign rhs_slice_proxy67 = top_icmp_rx_depacketizer_header[63:32];
assign rhs_slice_proxy68 = top_icmp_rx_depacketizer_header[63:32];
assign rhs_slice_proxy69 = top_icmp_rx_depacketizer_header[63:32];
assign rhs_slice_proxy70 = top_rx_depacketizer_header[63:48];
assign rhs_slice_proxy71 = top_rx_depacketizer_header[63:48];
assign rhs_slice_proxy72 = top_rx_depacketizer_header[31:16];
assign rhs_slice_proxy73 = top_rx_depacketizer_header[31:16];
assign rhs_slice_proxy74 = top_rx_depacketizer_header[47:32];
assign rhs_slice_proxy75 = top_rx_depacketizer_header[47:32];
assign rhs_slice_proxy76 = top_rx_depacketizer_header[15:0];
assign rhs_slice_proxy77 = top_rx_depacketizer_header[15:0];

// synthesis translate_off
reg dummy_d_83;
// synthesis translate_on
always @(*) begin
	comb_rhs_self <= 8'd0;
	case (top_server_hidx)
		1'd0: begin
			comb_rhs_self <= 8'd65;
		end
		1'd1: begin
			comb_rhs_self <= 8'd68;
		end
		2'd2: begin
			comb_rhs_self <= 8'd67;
		end
		2'd3: begin
			comb_rhs_self <= 8'd49;
		end
		3'd4: begin
			comb_rhs_self <= (top_server4 | 8'd128);
		end
		3'd5: begin
			comb_rhs_self <= top_server5;
		end
		3'd6: begin
			comb_rhs_self <= top_server6;
		end
		3'd7: begin
			comb_rhs_self <= top_server7;
		end
		4'd8: begin
			comb_rhs_self <= top_server_capture_id[31:24];
		end
		4'd9: begin
			comb_rhs_self <= top_server_capture_id[23:16];
		end
		4'd10: begin
			comb_rhs_self <= top_server_capture_id[15:8];
		end
		4'd11: begin
			comb_rhs_self <= top_server_capture_id[7:0];
		end
		4'd12: begin
			comb_rhs_self <= top_server_flags[31:24];
		end
		4'd13: begin
			comb_rhs_self <= top_server_flags[23:16];
		end
		4'd14: begin
			comb_rhs_self <= top_server_flags[15:8];
		end
		default: begin
			comb_rhs_self <= top_server_flags[7:0];
		end
	endcase
// synthesis translate_off
	dummy_d_83 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_84;
// synthesis translate_on
always @(*) begin
	comb_basiclowerer_self <= 16'd0;
	case (top_server5)
		1'd0: begin
			comb_basiclowerer_self <= top_rp_memory0_dat_r;
		end
		1'd1: begin
			comb_basiclowerer_self <= top_rp_memory1_dat_r;
		end
		2'd2: begin
			comb_basiclowerer_self <= top_rp_memory2_dat_r;
		end
		2'd3: begin
			comb_basiclowerer_self <= top_rp_memory3_dat_r;
		end
		3'd4: begin
			comb_basiclowerer_self <= top_rp_memory4_dat_r;
		end
		3'd5: begin
			comb_basiclowerer_self <= top_rp_memory5_dat_r;
		end
		3'd6: begin
			comb_basiclowerer_self <= top_rp_memory6_dat_r;
		end
		3'd7: begin
			comb_basiclowerer_self <= top_rp_memory7_dat_r;
		end
		4'd8: begin
			comb_basiclowerer_self <= top_rp_memory8_dat_r;
		end
		4'd9: begin
			comb_basiclowerer_self <= top_rp_memory9_dat_r;
		end
		4'd10: begin
			comb_basiclowerer_self <= top_rp_memory10_dat_r;
		end
		default: begin
			comb_basiclowerer_self <= top_rp_memory11_dat_r;
		end
	endcase
// synthesis translate_off
	dummy_d_84 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_85;
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
	dummy_d_85 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_86;
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
	dummy_d_86 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_87;
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
	dummy_d_87 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_88;
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
	dummy_d_88 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_89;
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
	dummy_d_89 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_90;
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
	dummy_d_90 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_91;
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
	dummy_d_91 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_92;
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
	dummy_d_92 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_93;
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
	dummy_d_93 <= dummy_s;
// synthesis translate_on
end
assign xilinxasyncresetsynchronizerimpl0_async_reset = (~top_locked);
assign top_lp_abi_ping_toggle_o = xilinxmultiregimpl01;
assign top_lp_abi_pong_toggle_o = xilinxmultiregimpl11;
assign top_lp_abi_obuffer = xilinxmultiregimpl21;
assign top_seen_valid_ci_toggle_o = xilinxmultiregimpl31;
assign top_rx_config_reg_abi_toggle_o = xilinxmultiregimpl41;
assign top_rx_config_reg_ack_toggle_o = xilinxmultiregimpl51;
assign xilinxasyncresetsynchronizerimpl1_async_reset = (~top_pma_k7_gtx_basex_tx_mmcm_locked1);
assign xilinxasyncresetsynchronizerimpl2_async_reset = (~top_pma_k7_gtx_basex_rx_mmcm_locked1);
assign top_pma_k7_gtx_basex_gtxtxinit_plllock1 = xilinxmultiregimpl61;
assign top_pma_k7_gtx_basex_gtxtxinit_Xxresetdone1 = xilinxmultiregimpl71;
assign top_pma_k7_gtx_basex_gtxtxinit_Xxdlysresetdone1 = xilinxmultiregimpl81;
assign top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone1 = xilinxmultiregimpl91;
assign top_pma_k7_gtx_basex_gtxrxinit_plllock1 = xilinxmultiregimpl101;
assign top_pma_k7_gtx_basex_gtxrxinit_Xxresetdone1 = xilinxmultiregimpl111;
assign top_pma_k7_gtx_basex_gtxrxinit_Xxdlysresetdone1 = xilinxmultiregimpl121;
assign top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone1 = xilinxmultiregimpl131;
assign top_pma_k7_gtx_basex_toggle_o = xilinxmultiregimpl141;
assign top_mac_core_txdatapath_cdc_produce_rdomain = xilinxmultiregimpl151;
assign top_mac_core_txdatapath_cdc_consume_wdomain = xilinxmultiregimpl161;
assign top_mac_core_toggle_o = xilinxmultiregimpl171;
assign top_mac_core_rx_cdc_cdc_produce_rdomain = xilinxmultiregimpl181;
assign top_mac_core_rx_cdc_cdc_consume_wdomain = xilinxmultiregimpl191;
assign top_mac_core_pulsesynchronizer0_toggle_o = xilinxmultiregimpl201;
assign top_mac_core_pulsesynchronizer1_toggle_o = xilinxmultiregimpl211;
assign top_arm_cdc_toggle_o = xilinxmultiregimpl221;
assign top_done_cdc_toggle_o = xilinxmultiregimpl231;
assign top_sampled0 = xilinxmultiregimpl24_xilinxmultiregimpl241;
assign xilinxmultiregimpl24_i = {STR1, DI1};
assign top_sampled1 = xilinxmultiregimpl25_xilinxmultiregimpl251;
assign xilinxmultiregimpl25_i = {STR2, DI2};
assign top_sampled2 = xilinxmultiregimpl26_xilinxmultiregimpl261;
assign xilinxmultiregimpl26_i = {STR3, DI3};
assign top_sampled3 = xilinxmultiregimpl27_xilinxmultiregimpl271;
assign xilinxmultiregimpl27_i = {STR4, DI4};
assign top_sampled4 = xilinxmultiregimpl28_xilinxmultiregimpl281;
assign xilinxmultiregimpl28_i = {STR5, DI5};
assign top_sampled5 = xilinxmultiregimpl29_xilinxmultiregimpl291;
assign xilinxmultiregimpl29_i = {STR6, DI6};
assign top_sampled6 = xilinxmultiregimpl30_xilinxmultiregimpl301;
assign xilinxmultiregimpl30_i = {STR7, DI7};
assign top_sampled7 = xilinxmultiregimpl31_xilinxmultiregimpl311;
assign xilinxmultiregimpl31_i = {STR8, DI8};
assign top_sampled8 = xilinxmultiregimpl32_xilinxmultiregimpl321;
assign xilinxmultiregimpl32_i = {STR9, DI9};
assign top_sampled9 = xilinxmultiregimpl33_xilinxmultiregimpl331;
assign xilinxmultiregimpl33_i = {STR10, DI10};
assign top_sampled10 = xilinxmultiregimpl34_xilinxmultiregimpl341;
assign xilinxmultiregimpl34_i = {STR11, DI11};
assign top_sampled11 = xilinxmultiregimpl35_xilinxmultiregimpl351;
assign xilinxmultiregimpl35_i = {STR12, DI12};

always @(posedge cap_clk) begin
	if (top_arm_cdc_o) begin
		top_active <= 1'd1;
		top_index <= 1'd0;
	end else begin
		if (top_active) begin
			if ((top_index == 12'd4095)) begin
				top_active <= 1'd0;
			end else begin
				top_index <= (top_index + 1'd1);
			end
		end
	end
	top_arm_cdc_toggle_o_r <= top_arm_cdc_toggle_o;
	if (top_done_cdc_i) begin
		top_done_cdc_toggle_i <= (~top_done_cdc_toggle_i);
	end
	if (cap_rst) begin
		top_active <= 1'd0;
		top_index <= 12'd0;
	end
	xilinxmultiregimpl220 <= top_arm_cdc_toggle_i;
	xilinxmultiregimpl221 <= xilinxmultiregimpl220;
	xilinxmultiregimpl24_xilinxmultiregimpl240 <= {STR1, DI1};
	xilinxmultiregimpl24_xilinxmultiregimpl241 <= xilinxmultiregimpl24_xilinxmultiregimpl240;
	xilinxmultiregimpl25_xilinxmultiregimpl250 <= {STR2, DI2};
	xilinxmultiregimpl25_xilinxmultiregimpl251 <= xilinxmultiregimpl25_xilinxmultiregimpl250;
	xilinxmultiregimpl26_xilinxmultiregimpl260 <= {STR3, DI3};
	xilinxmultiregimpl26_xilinxmultiregimpl261 <= xilinxmultiregimpl26_xilinxmultiregimpl260;
	xilinxmultiregimpl27_xilinxmultiregimpl270 <= {STR4, DI4};
	xilinxmultiregimpl27_xilinxmultiregimpl271 <= xilinxmultiregimpl27_xilinxmultiregimpl270;
	xilinxmultiregimpl28_xilinxmultiregimpl280 <= {STR5, DI5};
	xilinxmultiregimpl28_xilinxmultiregimpl281 <= xilinxmultiregimpl28_xilinxmultiregimpl280;
	xilinxmultiregimpl29_xilinxmultiregimpl290 <= {STR6, DI6};
	xilinxmultiregimpl29_xilinxmultiregimpl291 <= xilinxmultiregimpl29_xilinxmultiregimpl290;
	xilinxmultiregimpl30_xilinxmultiregimpl300 <= {STR7, DI7};
	xilinxmultiregimpl30_xilinxmultiregimpl301 <= xilinxmultiregimpl30_xilinxmultiregimpl300;
	xilinxmultiregimpl31_xilinxmultiregimpl310 <= {STR8, DI8};
	xilinxmultiregimpl31_xilinxmultiregimpl311 <= xilinxmultiregimpl31_xilinxmultiregimpl310;
	xilinxmultiregimpl32_xilinxmultiregimpl320 <= {STR9, DI9};
	xilinxmultiregimpl32_xilinxmultiregimpl321 <= xilinxmultiregimpl32_xilinxmultiregimpl320;
	xilinxmultiregimpl33_xilinxmultiregimpl330 <= {STR10, DI10};
	xilinxmultiregimpl33_xilinxmultiregimpl331 <= xilinxmultiregimpl33_xilinxmultiregimpl330;
	xilinxmultiregimpl34_xilinxmultiregimpl340 <= {STR11, DI11};
	xilinxmultiregimpl34_xilinxmultiregimpl341 <= xilinxmultiregimpl34_xilinxmultiregimpl340;
	xilinxmultiregimpl35_xilinxmultiregimpl350 <= {STR12, DI12};
	xilinxmultiregimpl35_xilinxmultiregimpl351 <= xilinxmultiregimpl35_xilinxmultiregimpl350;
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
	if (top_mac_core_rx_packet_fifo_sink_sink_valid) begin
		top_mac_core_rx_packet_fifo_invalid <= (top_mac_core_rx_packet_fifo_invalid | top_mac_core_rx_packet_fifo_discard);
		if (((~top_mac_core_rx_packet_fifo_overflow) & (~top_mac_core_rx_packet_fifo_full))) begin
			top_mac_core_rx_packet_fifo_wr_ptr <= (top_mac_core_rx_packet_fifo_wr_ptr + 1'd1);
		end else begin
			top_mac_core_rx_packet_fifo_overflow <= 1'd1;
		end
		if (top_mac_core_rx_packet_fifo_sink_sink_last) begin
			top_mac_core_rx_packet_fifo_overflow <= 1'd0;
			top_mac_core_rx_packet_fifo_invalid <= 1'd0;
			if (top_mac_core_rx_packet_fifo_commit) begin
				top_mac_core_rx_packet_fifo_commit_ptr <= (top_mac_core_rx_packet_fifo_wr_ptr + 1'd1);
			end else begin
				top_mac_core_rx_packet_fifo_wr_ptr <= top_mac_core_rx_packet_fifo_commit_ptr;
			end
		end
	end
	if (top_mac_core_rx_packet_fifo_fetch) begin
		top_mac_core_rx_packet_fifo_rd_ptr <= (top_mac_core_rx_packet_fifo_rd_ptr + 1'd1);
		top_mac_core_rx_packet_fifo_out_valid <= 1'd1;
	end else begin
		if ((top_mac_core_rx_packet_fifo_source_source_valid & top_mac_core_rx_packet_fifo_source_source_ready)) begin
			top_mac_core_rx_packet_fifo_out_valid <= 1'd0;
		end
	end
	if (((top_mac_core_rx_packet_fifo_param_fifo_syncfifo_we & top_mac_core_rx_packet_fifo_param_fifo_syncfifo_writable) & (~top_mac_core_rx_packet_fifo_param_fifo_replace))) begin
		top_mac_core_rx_packet_fifo_param_fifo_produce <= (top_mac_core_rx_packet_fifo_param_fifo_produce + 1'd1);
	end
	if (top_mac_core_rx_packet_fifo_param_fifo_do_read) begin
		top_mac_core_rx_packet_fifo_param_fifo_consume <= (top_mac_core_rx_packet_fifo_param_fifo_consume + 1'd1);
	end
	if (((top_mac_core_rx_packet_fifo_param_fifo_syncfifo_we & top_mac_core_rx_packet_fifo_param_fifo_syncfifo_writable) & (~top_mac_core_rx_packet_fifo_param_fifo_replace))) begin
		if ((~top_mac_core_rx_packet_fifo_param_fifo_do_read)) begin
			top_mac_core_rx_packet_fifo_param_fifo_level <= (top_mac_core_rx_packet_fifo_param_fifo_level + 1'd1);
		end
	end else begin
		if (top_mac_core_rx_packet_fifo_param_fifo_do_read) begin
			top_mac_core_rx_packet_fifo_param_fifo_level <= (top_mac_core_rx_packet_fifo_param_fifo_level - 1'd1);
		end
	end
	if (top_mac_core_i) begin
		top_mac_core_toggle_i <= (~top_mac_core_toggle_i);
	end
	top_mac_core_rx_cdc_cdc_graycounter0_q_binary <= top_mac_core_rx_cdc_cdc_graycounter0_q_next_binary;
	top_mac_core_rx_cdc_cdc_graycounter0_q <= top_mac_core_rx_cdc_cdc_graycounter0_q_next;
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
		top_mac_core_rx_packet_fifo_param_fifo_level <= 3'd0;
		top_mac_core_rx_packet_fifo_param_fifo_produce <= 2'd0;
		top_mac_core_rx_packet_fifo_param_fifo_consume <= 2'd0;
		top_mac_core_rx_packet_fifo_wr_ptr <= 12'd0;
		top_mac_core_rx_packet_fifo_commit_ptr <= 12'd0;
		top_mac_core_rx_packet_fifo_rd_ptr <= 12'd0;
		top_mac_core_rx_packet_fifo_out_valid <= 1'd0;
		top_mac_core_rx_packet_fifo_overflow <= 1'd0;
		top_mac_core_rx_packet_fifo_invalid <= 1'd0;
		top_mac_core_rx_cdc_cdc_graycounter0_q <= 6'd0;
		top_mac_core_rx_cdc_cdc_graycounter0_q_binary <= 6'd0;
		clockdomainsrenamer1_state <= 3'd0;
	end
	xilinxmultiregimpl10 <= top_lp_abi_pong_toggle_i;
	xilinxmultiregimpl11 <= xilinxmultiregimpl10;
	xilinxmultiregimpl190 <= top_mac_core_rx_cdc_cdc_graycounter1_q;
	xilinxmultiregimpl191 <= xilinxmultiregimpl190;
end

always @(posedge eth_rx_half_clk) begin
	top_pma_k7_gtx_basex_phase_half_rereg <= top_pma_k7_gtx_basex_phase_half;
end

always @(posedge eth_tx_clk) begin
	top_checker_tick <= 1'd0;
	if ((top_checker_count == 1'd0)) begin
		top_checker_tick <= 1'd1;
		top_checker_count <= 20'd750000;
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
		top_waittimer0_count <= 21'd1250000;
	end
	if (top_waittimer1_wait) begin
		if ((~top_waittimer1_done)) begin
			top_waittimer1_count <= (top_waittimer1_count - 1'd1);
		end
	end else begin
		top_waittimer1_count <= 21'd1250000;
	end
	if (top_waittimer2_wait) begin
		if ((~top_waittimer2_done)) begin
			top_waittimer2_count <= (top_waittimer2_count - 1'd1);
		end
	end else begin
		top_waittimer2_count <= 18'd200000;
	end
	if (top_pma_k7_gtx_basex_i) begin
		top_pma_k7_gtx_basex_toggle_i <= (~top_pma_k7_gtx_basex_toggle_i);
	end
	top_pma_k7_gtx_basex_buf <= {top_pma_k7_gtx_basex_tx_data1, top_pma_k7_gtx_basex_buf[19:10]};
	if ((top_mac_core_txdatapath_cdc_re | (~top_mac_core_txdatapath_cdc_readable))) begin
		top_mac_core_txdatapath_cdc_dout <= top_mac_core_txdatapath_cdc_asyncfifo_dout;
		top_mac_core_txdatapath_cdc_readable <= top_mac_core_txdatapath_cdc_asyncfifo_readable;
	end
	top_mac_core_txdatapath_cdc_graycounter1_q_binary <= top_mac_core_txdatapath_cdc_graycounter1_q_next_binary;
	top_mac_core_txdatapath_cdc_graycounter1_q <= top_mac_core_txdatapath_cdc_graycounter1_q_next;
	if (top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_re) begin
		top_mac_core_tx_packet_fifo_payload_fifo_readable <= 1'd1;
	end else begin
		if (top_mac_core_tx_packet_fifo_payload_fifo_re) begin
			top_mac_core_tx_packet_fifo_payload_fifo_readable <= 1'd0;
		end
	end
	if (((top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_we & top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_writable) & (~top_mac_core_tx_packet_fifo_payload_fifo_replace))) begin
		top_mac_core_tx_packet_fifo_payload_fifo_produce <= (top_mac_core_tx_packet_fifo_payload_fifo_produce + 1'd1);
	end
	if (top_mac_core_tx_packet_fifo_payload_fifo_do_read) begin
		top_mac_core_tx_packet_fifo_payload_fifo_consume <= (top_mac_core_tx_packet_fifo_payload_fifo_consume + 1'd1);
	end
	if (((top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_we & top_mac_core_tx_packet_fifo_payload_fifo_syncfifo_writable) & (~top_mac_core_tx_packet_fifo_payload_fifo_replace))) begin
		if ((~top_mac_core_tx_packet_fifo_payload_fifo_do_read)) begin
			top_mac_core_tx_packet_fifo_payload_fifo_level0 <= (top_mac_core_tx_packet_fifo_payload_fifo_level0 + 1'd1);
		end
	end else begin
		if (top_mac_core_tx_packet_fifo_payload_fifo_do_read) begin
			top_mac_core_tx_packet_fifo_payload_fifo_level0 <= (top_mac_core_tx_packet_fifo_payload_fifo_level0 - 1'd1);
		end
	end
	if (top_mac_core_tx_packet_fifo_param_fifo_syncfifo_re) begin
		top_mac_core_tx_packet_fifo_param_fifo_readable <= 1'd1;
	end else begin
		if (top_mac_core_tx_packet_fifo_param_fifo_re) begin
			top_mac_core_tx_packet_fifo_param_fifo_readable <= 1'd0;
		end
	end
	if (((top_mac_core_tx_packet_fifo_param_fifo_syncfifo_we & top_mac_core_tx_packet_fifo_param_fifo_syncfifo_writable) & (~top_mac_core_tx_packet_fifo_param_fifo_replace))) begin
		if ((top_mac_core_tx_packet_fifo_param_fifo_produce == 3'd4)) begin
			top_mac_core_tx_packet_fifo_param_fifo_produce <= 1'd0;
		end else begin
			top_mac_core_tx_packet_fifo_param_fifo_produce <= (top_mac_core_tx_packet_fifo_param_fifo_produce + 1'd1);
		end
	end
	if (top_mac_core_tx_packet_fifo_param_fifo_do_read) begin
		if ((top_mac_core_tx_packet_fifo_param_fifo_consume == 3'd4)) begin
			top_mac_core_tx_packet_fifo_param_fifo_consume <= 1'd0;
		end else begin
			top_mac_core_tx_packet_fifo_param_fifo_consume <= (top_mac_core_tx_packet_fifo_param_fifo_consume + 1'd1);
		end
	end
	if (((top_mac_core_tx_packet_fifo_param_fifo_syncfifo_we & top_mac_core_tx_packet_fifo_param_fifo_syncfifo_writable) & (~top_mac_core_tx_packet_fifo_param_fifo_replace))) begin
		if ((~top_mac_core_tx_packet_fifo_param_fifo_do_read)) begin
			top_mac_core_tx_packet_fifo_param_fifo_level0 <= (top_mac_core_tx_packet_fifo_param_fifo_level0 + 1'd1);
		end
	end else begin
		if (top_mac_core_tx_packet_fifo_param_fifo_do_read) begin
			top_mac_core_tx_packet_fifo_param_fifo_level0 <= (top_mac_core_tx_packet_fifo_param_fifo_level0 - 1'd1);
		end
	end
	liteethmac_txdatapath_liteethmacgap_state <= liteethmac_txdatapath_liteethmacgap_next_state;
	if (top_mac_core_tx_gap_counter_liteethmaccore_clockdomainsrenamer3_next_value_ce) begin
		top_mac_core_tx_gap_counter <= top_mac_core_tx_gap_counter_liteethmaccore_clockdomainsrenamer3_next_value;
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
		top_waittimer0_count <= 21'd1250000;
		top_waittimer1_count <= 21'd1250000;
		top_waittimer2_count <= 18'd200000;
		top_checker_count <= 20'd0;
		top_checker_tick <= 1'd0;
		top_checker_error <= 1'd0;
		top_pma_k7_gtx_basex_buf <= 20'd0;
		top_mac_core_txdatapath_cdc_readable <= 1'd0;
		top_mac_core_txdatapath_cdc_graycounter1_q <= 6'd0;
		top_mac_core_txdatapath_cdc_graycounter1_q_binary <= 6'd0;
		top_mac_core_tx_packet_fifo_payload_fifo_readable <= 1'd0;
		top_mac_core_tx_packet_fifo_payload_fifo_level0 <= 12'd0;
		top_mac_core_tx_packet_fifo_payload_fifo_produce <= 11'd0;
		top_mac_core_tx_packet_fifo_payload_fifo_consume <= 11'd0;
		top_mac_core_tx_packet_fifo_param_fifo_readable <= 1'd0;
		top_mac_core_tx_packet_fifo_param_fifo_level0 <= 3'd0;
		top_mac_core_tx_packet_fifo_param_fifo_produce <= 3'd0;
		top_mac_core_tx_packet_fifo_param_fifo_consume <= 3'd0;
		clockdomainsrenamer0_state <= 3'd0;
		liteethmac_txdatapath_liteethmacgap_state <= 1'd0;
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
	xilinxmultiregimpl150 <= top_mac_core_txdatapath_cdc_graycounter0_q;
	xilinxmultiregimpl151 <= xilinxmultiregimpl150;
end

always @(posedge eth_tx_half_clk) begin
	top_pma_k7_gtx_basex_tx_data_half <= top_pma_k7_gtx_basex_buf;
end

always @(posedge sys_clk) begin
	top_tick <= (top_tick + 1'd1);
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
	liteethmac_txdatapath_liteethmacpaddinginserter_state <= liteethmac_txdatapath_liteethmacpaddinginserter_next_state;
	if (top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value_ce) begin
		top_mac_core_tx_padding_counter <= top_mac_core_tx_padding_counter_liteethmaccore_clockdomainsrenamer0_next_value;
	end
	if (top_mac_core_tx_crc_is_ongoing0) begin
		top_mac_core_tx_crc_cnt <= 2'd3;
	end else begin
		if ((top_mac_core_tx_crc_is_ongoing1 & (~top_mac_core_tx_crc_cnt_done))) begin
			top_mac_core_tx_crc_cnt <= (top_mac_core_tx_crc_cnt - top_mac_core_tx_crc_source_ready);
		end
	end
	if (top_mac_core_tx_crc_ce) begin
		top_mac_core_tx_crc_reg <= top_mac_core_tx_crc_crc_next;
	end
	if (top_mac_core_tx_crc_reset) begin
		top_mac_core_tx_crc_reg <= 32'd4294967295;
	end
	liteethmac_txdatapath_bufferizeendpoints_state <= liteethmac_txdatapath_bufferizeendpoints_next_state;
	if (top_mac_core_tx_crc_crc_packet_liteethmaccore_clockdomainsrenamer1_next_value_ce0) begin
		top_mac_core_tx_crc_crc_packet <= top_mac_core_tx_crc_crc_packet_liteethmaccore_clockdomainsrenamer1_next_value0;
	end
	if (top_mac_core_tx_crc_be0_liteethmaccore_clockdomainsrenamer1_next_value_ce1) begin
		top_mac_core_tx_crc_be0 <= top_mac_core_tx_crc_be0_liteethmaccore_clockdomainsrenamer1_next_value1;
	end
	if (((~top_mac_core_tx_crc_pipe_valid_source_valid) | top_mac_core_tx_crc_pipe_valid_source_ready)) begin
		top_mac_core_tx_crc_pipe_valid_source_valid <= top_mac_core_tx_crc_pipe_valid_sink_valid;
		top_mac_core_tx_crc_pipe_valid_source_first <= top_mac_core_tx_crc_pipe_valid_sink_first;
		top_mac_core_tx_crc_pipe_valid_source_last <= top_mac_core_tx_crc_pipe_valid_sink_last;
		top_mac_core_tx_crc_pipe_valid_source_payload_data <= top_mac_core_tx_crc_pipe_valid_sink_payload_data;
		top_mac_core_tx_crc_pipe_valid_source_payload_be <= top_mac_core_tx_crc_pipe_valid_sink_payload_be;
		top_mac_core_tx_crc_pipe_valid_source_payload_error <= top_mac_core_tx_crc_pipe_valid_sink_payload_error;
	end
	liteethmac_txdatapath_liteethmacpreambleinserter_state <= liteethmac_txdatapath_liteethmacpreambleinserter_next_state;
	if (top_mac_core_tx_preamble_count_liteethmaccore_clockdomainsrenamer2_next_value_ce) begin
		top_mac_core_tx_preamble_count <= top_mac_core_tx_preamble_count_liteethmaccore_clockdomainsrenamer2_next_value;
	end
	top_mac_core_txdatapath_cdc_graycounter0_q_binary <= top_mac_core_txdatapath_cdc_graycounter0_q_next_binary;
	top_mac_core_txdatapath_cdc_graycounter0_q <= top_mac_core_txdatapath_cdc_graycounter0_q_next;
	if (top_mac_core_o) begin
		top_mac_core_drops_status <= (top_mac_core_drops_status + 1'd1);
	end
	if (top_mac_core_pulsesynchronizer0_o) begin
		top_mac_core_preamble_errors_status <= (top_mac_core_preamble_errors_status + 1'd1);
	end
	if (top_mac_core_pulsesynchronizer1_o) begin
		top_mac_core_crc_errors_status <= (top_mac_core_crc_errors_status + 1'd1);
	end
	top_mac_core_toggle_o_r <= top_mac_core_toggle_o;
	if ((top_mac_core_rx_cdc_cdc_re | (~top_mac_core_rx_cdc_cdc_readable))) begin
		top_mac_core_rx_cdc_cdc_dout <= top_mac_core_rx_cdc_cdc_asyncfifo_dout;
		top_mac_core_rx_cdc_cdc_readable <= top_mac_core_rx_cdc_cdc_asyncfifo_readable;
	end
	top_mac_core_rx_cdc_cdc_graycounter1_q_binary <= top_mac_core_rx_cdc_cdc_graycounter1_q_next_binary;
	top_mac_core_rx_cdc_cdc_graycounter1_q <= top_mac_core_rx_cdc_cdc_graycounter1_q_next;
	liteethmac_rxdatapath_liteethmacpreamblechecker_state <= liteethmac_rxdatapath_liteethmacpreamblechecker_next_state;
	if (top_mac_core_pulsesynchronizer0_i) begin
		top_mac_core_pulsesynchronizer0_toggle_i <= (~top_mac_core_pulsesynchronizer0_toggle_i);
	end
	top_mac_core_pulsesynchronizer0_toggle_o_r <= top_mac_core_pulsesynchronizer0_toggle_o;
	if (top_mac_core_liteethmaccrc32checker_is_ongoing2) begin
		top_mac_core_liteethmaccrc32checker_packet_error <= 1'd0;
	end else begin
		if ((top_mac_core_liteethmaccrc32checker_sink_sink_valid & top_mac_core_liteethmaccrc32checker_sink_sink_ready)) begin
			top_mac_core_liteethmaccrc32checker_packet_error <= (top_mac_core_liteethmaccrc32checker_packet_error | ((top_mac_core_liteethmaccrc32checker_sink_sink_payload_error & top_mac_core_liteethmaccrc32checker_sink_sink_payload_be) != 1'd0));
		end
	end
	if (top_mac_core_liteethmaccrc32checker_crc_ce) begin
		top_mac_core_liteethmaccrc32checker_crc_reg <= top_mac_core_liteethmaccrc32checker_crc_crc_next;
	end
	if (top_mac_core_liteethmaccrc32checker_crc_reset) begin
		top_mac_core_liteethmaccrc32checker_crc_reg <= 32'd4294967295;
	end
	if (((top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_we & top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_writable) & (~top_mac_core_liteethmaccrc32checker_syncfifo_replace))) begin
		if ((top_mac_core_liteethmaccrc32checker_syncfifo_produce == 3'd4)) begin
			top_mac_core_liteethmaccrc32checker_syncfifo_produce <= 1'd0;
		end else begin
			top_mac_core_liteethmaccrc32checker_syncfifo_produce <= (top_mac_core_liteethmaccrc32checker_syncfifo_produce + 1'd1);
		end
	end
	if (top_mac_core_liteethmaccrc32checker_syncfifo_do_read) begin
		if ((top_mac_core_liteethmaccrc32checker_syncfifo_consume == 3'd4)) begin
			top_mac_core_liteethmaccrc32checker_syncfifo_consume <= 1'd0;
		end else begin
			top_mac_core_liteethmaccrc32checker_syncfifo_consume <= (top_mac_core_liteethmaccrc32checker_syncfifo_consume + 1'd1);
		end
	end
	if (((top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_we & top_mac_core_liteethmaccrc32checker_syncfifo_syncfifo_writable) & (~top_mac_core_liteethmaccrc32checker_syncfifo_replace))) begin
		if ((~top_mac_core_liteethmaccrc32checker_syncfifo_do_read)) begin
			top_mac_core_liteethmaccrc32checker_syncfifo_level <= (top_mac_core_liteethmaccrc32checker_syncfifo_level + 1'd1);
		end
	end else begin
		if (top_mac_core_liteethmaccrc32checker_syncfifo_do_read) begin
			top_mac_core_liteethmaccrc32checker_syncfifo_level <= (top_mac_core_liteethmaccrc32checker_syncfifo_level - 1'd1);
		end
	end
	if (top_mac_core_liteethmaccrc32checker_fifo_reset) begin
		top_mac_core_liteethmaccrc32checker_syncfifo_level <= 3'd0;
		top_mac_core_liteethmaccrc32checker_syncfifo_produce <= 3'd0;
		top_mac_core_liteethmaccrc32checker_syncfifo_consume <= 3'd0;
	end
	liteethmac_rxdatapath_bufferizeendpoints_state <= liteethmac_rxdatapath_bufferizeendpoints_next_state;
	if (top_mac_core_liteethmaccrc32checker_be_liteethmaccore_next_value_ce0) begin
		top_mac_core_liteethmaccrc32checker_be <= top_mac_core_liteethmaccrc32checker_be_liteethmaccore_next_value0;
	end
	if (top_mac_core_liteethmaccrc32checker_last_error_liteethmaccore_next_value_ce1) begin
		top_mac_core_liteethmaccrc32checker_last_error <= top_mac_core_liteethmaccrc32checker_last_error_liteethmaccore_next_value1;
	end
	if (((~top_mac_core_bufferizeendpoints_pipe_valid_source_valid) | top_mac_core_bufferizeendpoints_pipe_valid_source_ready)) begin
		top_mac_core_bufferizeendpoints_pipe_valid_source_valid <= top_mac_core_bufferizeendpoints_pipe_valid_sink_valid;
		top_mac_core_bufferizeendpoints_pipe_valid_source_first <= top_mac_core_bufferizeendpoints_pipe_valid_sink_first;
		top_mac_core_bufferizeendpoints_pipe_valid_source_last <= top_mac_core_bufferizeendpoints_pipe_valid_sink_last;
		top_mac_core_bufferizeendpoints_pipe_valid_source_payload_data <= top_mac_core_bufferizeendpoints_pipe_valid_sink_payload_data;
		top_mac_core_bufferizeendpoints_pipe_valid_source_payload_be <= top_mac_core_bufferizeendpoints_pipe_valid_sink_payload_be;
		top_mac_core_bufferizeendpoints_pipe_valid_source_payload_error <= top_mac_core_bufferizeendpoints_pipe_valid_sink_payload_error;
	end
	if (top_mac_core_pulsesynchronizer1_i) begin
		top_mac_core_pulsesynchronizer1_toggle_i <= (~top_mac_core_pulsesynchronizer1_toggle_i);
	end
	top_mac_core_pulsesynchronizer1_toggle_o_r <= top_mac_core_pulsesynchronizer1_toggle_o;
	if ((top_mac_core_rx_padding_sink_valid & top_mac_core_rx_padding_sink_ready)) begin
		if (top_mac_core_rx_padding_sink_last) begin
			top_mac_core_rx_padding_length <= 1'd0;
		end else begin
			top_mac_core_rx_padding_length <= (top_mac_core_rx_padding_length + top_mac_core_rx_padding_length_inc);
		end
	end
	case (liteethmac_grant)
		1'd0: begin
			if ((~liteethmac_request[0])) begin
				if (liteethmac_request[1]) begin
					liteethmac_grant <= 1'd1;
				end
			end
		end
		1'd1: begin
			if ((~liteethmac_request[1])) begin
				if (liteethmac_request[0]) begin
					liteethmac_grant <= 1'd0;
				end
			end
		end
	endcase
	liteethmac_status0_ongoing1 <= liteethmac_status0_ongoing0;
	if (liteethmac_status0_last) begin
		liteethmac_status0_first <= 1'd1;
	end else begin
		if ((top_arp_mac_port_sink_valid & top_arp_mac_port_sink_ready)) begin
			liteethmac_status0_first <= 1'd0;
		end
	end
	liteethmac_status1_ongoing1 <= liteethmac_status1_ongoing0;
	if (liteethmac_status1_last) begin
		liteethmac_status1_first <= 1'd1;
	end else begin
		if ((top_ip_mac_port_sink_valid & top_ip_mac_port_sink_ready)) begin
			liteethmac_status1_first <= 1'd0;
		end
	end
	if (liteethmac_last) begin
		liteethmac_sel_locked <= 1'd0;
	end else begin
		if (((liteethmac_first & top_mac_crossbar_sink_valid) & (~liteethmac_sel_locked))) begin
			liteethmac_sel_ongoing <= liteethmac_sel0;
			liteethmac_sel_locked <= 1'd1;
		end
	end
	liteethmac_ongoing1 <= liteethmac_ongoing0;
	if (liteethmac_last) begin
		liteethmac_first <= 1'd1;
	end else begin
		if ((top_mac_crossbar_sink_valid & top_mac_crossbar_sink_ready)) begin
			liteethmac_first <= 1'd0;
		end
	end
	liteethmac_liteethmacpacketizer_state <= liteethmac_liteethmacpacketizer_next_state;
	if (top_mac_packetizer_count_liteethmacpacketizer_next_value_ce) begin
		top_mac_packetizer_count <= top_mac_packetizer_count_liteethmacpacketizer_next_value;
	end
	if (top_mac_depacketizer_sr_shift) begin
		top_mac_depacketizer_sr <= {top_mac_depacketizer_sink_payload_data, top_mac_depacketizer_sr[111:8]};
	end
	if (top_mac_depacketizer_sr_shift_leftover) begin
		top_mac_depacketizer_sr <= {top_mac_depacketizer_sink_payload_data, top_mac_depacketizer_sr[111:0]};
	end
	liteethmac_liteethmacdepacketizer_state <= liteethmac_liteethmacdepacketizer_next_state;
	if (top_mac_depacketizer_count_liteethmacdepacketizer_next_value_ce0) begin
		top_mac_depacketizer_count <= top_mac_depacketizer_count_liteethmacdepacketizer_next_value0;
	end
	if (top_mac_depacketizer_fsm_from_idle_liteethmacdepacketizer_next_value_ce1) begin
		top_mac_depacketizer_fsm_from_idle <= top_mac_depacketizer_fsm_from_idle_liteethmacdepacketizer_next_value1;
	end
	if (top_mac_depacketizer_data_copy_first_liteethmacdepacketizer_next_value_ce2) begin
		top_mac_depacketizer_data_copy_first <= top_mac_depacketizer_data_copy_first_liteethmacdepacketizer_next_value2;
	end
	liteetharptx_liteetharppacketizer_state <= liteetharptx_liteetharppacketizer_next_state;
	if (top_arp_tx_packetizer_count_liteetharp_liteetharptx_liteetharppacketizer_next_value_ce) begin
		top_arp_tx_packetizer_count <= top_arp_tx_packetizer_count_liteetharp_liteetharptx_liteetharppacketizer_next_value;
	end
	liteetharptx_fsm_state <= liteetharptx_fsm_next_state;
	if (top_arp_tx_counter_liteetharp_liteetharptx_fsm_next_value_ce) begin
		top_arp_tx_counter <= top_arp_tx_counter_liteetharp_liteetharptx_fsm_next_value;
	end
	top_arp_rx_valid <= (((((top_arp_rx_depacketizer_source_valid & (top_arp_rx_depacketizer_source_param_hwtype == 1'd1)) & (top_arp_rx_depacketizer_source_param_proto == 12'd2048)) & (top_arp_rx_depacketizer_source_param_hwsize == 3'd6)) & (top_arp_rx_depacketizer_source_param_protosize == 3'd4)) & (top_arp_rx_depacketizer_source_param_target_ip == 32'd3232236272));
	if (top_arp_rx_depacketizer_sr_shift) begin
		top_arp_rx_depacketizer_sr <= {top_arp_rx_depacketizer_sink_payload_data, top_arp_rx_depacketizer_sr[223:8]};
	end
	if (top_arp_rx_depacketizer_sr_shift_leftover) begin
		top_arp_rx_depacketizer_sr <= {top_arp_rx_depacketizer_sink_payload_data, top_arp_rx_depacketizer_sr[223:0]};
	end
	liteetharprx_liteetharpdepacketizer_state <= liteetharprx_liteetharpdepacketizer_next_state;
	if (top_arp_rx_depacketizer_count_liteetharp_next_value_ce0) begin
		top_arp_rx_depacketizer_count <= top_arp_rx_depacketizer_count_liteetharp_next_value0;
	end
	if (top_arp_rx_depacketizer_fsm_from_idle_liteetharp_next_value_ce1) begin
		top_arp_rx_depacketizer_fsm_from_idle <= top_arp_rx_depacketizer_fsm_from_idle_liteetharp_next_value1;
	end
	if (top_arp_rx_depacketizer_data_copy_first_liteetharp_next_value_ce2) begin
		top_arp_rx_depacketizer_data_copy_first <= top_arp_rx_depacketizer_data_copy_first_liteetharp_next_value2;
	end
	liteetharprx_fsm_state <= liteetharprx_fsm_next_state;
	if (top_arp_table_request_timer_wait) begin
		if ((~top_arp_table_request_timer_done)) begin
			top_arp_table_request_timer_count <= (top_arp_table_request_timer_count - 1'd1);
		end
	end else begin
		top_arp_table_request_timer_count <= 22'd4000000;
	end
	if (top_arp_table_cache_wait) begin
		if ((~top_arp_table_cache_done)) begin
			top_arp_table_cache_count <= (top_arp_table_cache_count - 1'd1);
		end
	end else begin
		top_arp_table_cache_count <= 26'd40000000;
	end
	liteetharptable_liteetharpcache_state <= liteetharptable_liteetharpcache_next_state;
	if (top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce0) begin
		top_arp_table_cache_update_count <= top_arp_table_cache_update_count_liteetharp_liteetharptable_liteetharpcache_next_value0;
	end
	if (top_arp_table_cache_search_count_liteetharp_liteetharptable_liteetharpcache_next_value_ce1) begin
		top_arp_table_cache_search_count <= top_arp_table_cache_search_count_liteetharp_liteetharptable_liteetharpcache_next_value1;
	end
	if (top_arp_table_cache_error_liteetharp_liteetharptable_liteetharpcache_next_value_ce2) begin
		top_arp_table_cache_error <= top_arp_table_cache_error_liteetharp_liteetharptable_liteetharpcache_next_value2;
	end
	liteetharptable_fsm_state <= liteetharptable_fsm_next_state;
	if (top_arp_table_request_pending_liteetharp_liteetharptable_fsm_next_value_ce0) begin
		top_arp_table_request_pending <= top_arp_table_request_pending_liteetharp_liteetharptable_fsm_next_value0;
	end
	if (top_arp_table_response_response_payload_mac_address_liteetharp_liteetharptable_fsm_next_value_ce1) begin
		top_arp_table_response_response_payload_mac_address <= top_arp_table_response_response_payload_mac_address_liteetharp_liteetharptable_fsm_next_value1;
	end
	if (top_arp_table_response_response_payload_failed_liteetharp_liteetharptable_fsm_next_value_ce2) begin
		top_arp_table_response_response_payload_failed <= top_arp_table_response_response_payload_failed_liteetharp_liteetharptable_fsm_next_value2;
	end
	if (top_arp_table_request_counter_liteetharp_liteetharptable_fsm_next_value_ce3) begin
		top_arp_table_request_counter <= top_arp_table_request_counter_liteetharp_liteetharptable_fsm_next_value3;
	end
	if (top_arp_table_request_ip_address_liteetharp_liteetharptable_fsm_next_value_ce4) begin
		top_arp_table_request_ip_address <= top_arp_table_request_ip_address_liteetharp_liteetharptable_fsm_next_value4;
	end
	if (((~top_ip_tx_pipe_valid_source_valid) | top_ip_tx_pipe_valid_source_ready)) begin
		top_ip_tx_pipe_valid_source_valid <= top_ip_tx_pipe_valid_sink_valid;
		top_ip_tx_pipe_valid_source_first <= top_ip_tx_pipe_valid_sink_first;
		top_ip_tx_pipe_valid_source_last <= top_ip_tx_pipe_valid_sink_last;
		top_ip_tx_pipe_valid_source_payload_data <= top_ip_tx_pipe_valid_sink_payload_data;
		top_ip_tx_pipe_valid_source_payload_be <= top_ip_tx_pipe_valid_sink_payload_be;
		top_ip_tx_pipe_valid_source_payload_error <= top_ip_tx_pipe_valid_sink_payload_error;
		top_ip_tx_pipe_valid_source_param_length <= top_ip_tx_pipe_valid_sink_param_length;
		top_ip_tx_pipe_valid_source_param_protocol <= top_ip_tx_pipe_valid_sink_param_protocol;
		top_ip_tx_pipe_valid_source_param_ip_address <= top_ip_tx_pipe_valid_sink_param_ip_address;
	end
	if (top_ip_tx_ce) begin
		if ((~top_ip_tx_liteethipv4checksum_done)) begin
			top_ip_tx_liteethipv4checksum_r_next0 <= {top_ip_tx_liteethipv4checksum0, (top_ip_tx_liteethipv4checksum_s_next0[15:0] + top_ip_tx_liteethipv4checksum_s_next0[16])};
		end
		if ((~top_ip_tx_liteethipv4checksum_done)) begin
			top_ip_tx_liteethipv4checksum_r_next1 <= {top_ip_tx_liteethipv4checksum1, (top_ip_tx_liteethipv4checksum_s_next1[15:0] + top_ip_tx_liteethipv4checksum_s_next1[16])};
		end
		if ((~top_ip_tx_liteethipv4checksum_done)) begin
			top_ip_tx_liteethipv4checksum_r_next2 <= {top_ip_tx_liteethipv4checksum2, (top_ip_tx_liteethipv4checksum_s_next2[15:0] + top_ip_tx_liteethipv4checksum_s_next2[16])};
		end
		if ((~top_ip_tx_liteethipv4checksum_done)) begin
			top_ip_tx_liteethipv4checksum_r_next3 <= {top_ip_tx_liteethipv4checksum3, (top_ip_tx_liteethipv4checksum_s_next3[15:0] + top_ip_tx_liteethipv4checksum_s_next3[16])};
		end
		if ((~top_ip_tx_liteethipv4checksum_done)) begin
			top_ip_tx_liteethipv4checksum_r_next4 <= {top_ip_tx_liteethipv4checksum4, (top_ip_tx_liteethipv4checksum_s_next4[15:0] + top_ip_tx_liteethipv4checksum_s_next4[16])};
		end
		if ((~top_ip_tx_liteethipv4checksum_done)) begin
			top_ip_tx_liteethipv4checksum_r_next5 <= {top_ip_tx_liteethipv4checksum5, (top_ip_tx_liteethipv4checksum_s_next5[15:0] + top_ip_tx_liteethipv4checksum_s_next5[16])};
		end
		if ((~top_ip_tx_liteethipv4checksum_done)) begin
			top_ip_tx_liteethipv4checksum_r_next6 <= {top_ip_tx_liteethipv4checksum6, (top_ip_tx_liteethipv4checksum_s_next6[15:0] + top_ip_tx_liteethipv4checksum_s_next6[16])};
		end
		if ((~top_ip_tx_liteethipv4checksum_done)) begin
			top_ip_tx_liteethipv4checksum_r_next7 <= {top_ip_tx_liteethipv4checksum7, (top_ip_tx_liteethipv4checksum_s_next7[15:0] + top_ip_tx_liteethipv4checksum_s_next7[16])};
		end
		if ((~top_ip_tx_liteethipv4checksum_done)) begin
			top_ip_tx_liteethipv4checksum_r_next8 <= {top_ip_tx_liteethipv4checksum8, (top_ip_tx_liteethipv4checksum_s_next8[15:0] + top_ip_tx_liteethipv4checksum_s_next8[16])};
		end
		if (top_ip_tx_liteethipv4checksum_counter_ce) begin
			top_ip_tx_liteethipv4checksum_counter <= (top_ip_tx_liteethipv4checksum_counter + 1'd1);
		end
	end
	if (top_ip_tx_reset) begin
		top_ip_tx_liteethipv4checksum_counter <= 4'd0;
	end
	liteethip_liteethiptx_liteethipv4packetizer_state <= liteethip_liteethiptx_liteethipv4packetizer_next_state;
	if (top_ip_tx_packetizer_count_liteethip_liteethipv4packetizer_next_value_ce) begin
		top_ip_tx_packetizer_count <= top_ip_tx_packetizer_count_liteethip_liteethipv4packetizer_next_value;
	end
	liteethip_liteethiptx_fsm_state <= liteethip_liteethiptx_fsm_next_state;
	if (top_ip_tx_target_mac_liteethip_fsm_next_value_ce) begin
		top_ip_tx_target_mac <= top_ip_tx_target_mac_liteethip_fsm_next_value;
	end
	if (top_ip_rx_depacketizer_sr_shift) begin
		top_ip_rx_depacketizer_sr <= {top_ip_rx_depacketizer_sink_payload_data, top_ip_rx_depacketizer_sr[159:8]};
	end
	if (top_ip_rx_depacketizer_sr_shift_leftover) begin
		top_ip_rx_depacketizer_sr <= {top_ip_rx_depacketizer_sink_payload_data, top_ip_rx_depacketizer_sr[159:0]};
	end
	liteethip_liteethiprx_liteethipv4depacketizer_state <= liteethip_liteethiprx_liteethipv4depacketizer_next_state;
	if (top_ip_rx_depacketizer_count_liteethip_next_value_ce0) begin
		top_ip_rx_depacketizer_count <= top_ip_rx_depacketizer_count_liteethip_next_value0;
	end
	if (top_ip_rx_depacketizer_fsm_from_idle_liteethip_next_value_ce1) begin
		top_ip_rx_depacketizer_fsm_from_idle <= top_ip_rx_depacketizer_fsm_from_idle_liteethip_next_value1;
	end
	if (top_ip_rx_depacketizer_data_copy_first_liteethip_next_value_ce2) begin
		top_ip_rx_depacketizer_data_copy_first <= top_ip_rx_depacketizer_data_copy_first_liteethip_next_value2;
	end
	if (top_ip_rx_ce) begin
		if ((~top_ip_rx_liteethipv4checksum_done)) begin
			top_ip_rx_liteethipv4checksum_r_next0 <= {top_ip_rx_liteethipv4checksum0, (top_ip_rx_liteethipv4checksum_s_next0[15:0] + top_ip_rx_liteethipv4checksum_s_next0[16])};
		end
		if ((~top_ip_rx_liteethipv4checksum_done)) begin
			top_ip_rx_liteethipv4checksum_r_next1 <= {top_ip_rx_liteethipv4checksum1, (top_ip_rx_liteethipv4checksum_s_next1[15:0] + top_ip_rx_liteethipv4checksum_s_next1[16])};
		end
		if ((~top_ip_rx_liteethipv4checksum_done)) begin
			top_ip_rx_liteethipv4checksum_r_next2 <= {top_ip_rx_liteethipv4checksum2, (top_ip_rx_liteethipv4checksum_s_next2[15:0] + top_ip_rx_liteethipv4checksum_s_next2[16])};
		end
		if ((~top_ip_rx_liteethipv4checksum_done)) begin
			top_ip_rx_liteethipv4checksum_r_next3 <= {top_ip_rx_liteethipv4checksum3, (top_ip_rx_liteethipv4checksum_s_next3[15:0] + top_ip_rx_liteethipv4checksum_s_next3[16])};
		end
		if ((~top_ip_rx_liteethipv4checksum_done)) begin
			top_ip_rx_liteethipv4checksum_r_next4 <= {top_ip_rx_liteethipv4checksum4, (top_ip_rx_liteethipv4checksum_s_next4[15:0] + top_ip_rx_liteethipv4checksum_s_next4[16])};
		end
		if ((~top_ip_rx_liteethipv4checksum_done)) begin
			top_ip_rx_liteethipv4checksum_r_next5 <= {top_ip_rx_liteethipv4checksum5, (top_ip_rx_liteethipv4checksum_s_next5[15:0] + top_ip_rx_liteethipv4checksum_s_next5[16])};
		end
		if ((~top_ip_rx_liteethipv4checksum_done)) begin
			top_ip_rx_liteethipv4checksum_r_next6 <= {top_ip_rx_liteethipv4checksum6, (top_ip_rx_liteethipv4checksum_s_next6[15:0] + top_ip_rx_liteethipv4checksum_s_next6[16])};
		end
		if ((~top_ip_rx_liteethipv4checksum_done)) begin
			top_ip_rx_liteethipv4checksum_r_next7 <= {top_ip_rx_liteethipv4checksum7, (top_ip_rx_liteethipv4checksum_s_next7[15:0] + top_ip_rx_liteethipv4checksum_s_next7[16])};
		end
		if ((~top_ip_rx_liteethipv4checksum_done)) begin
			top_ip_rx_liteethipv4checksum_r_next8 <= {top_ip_rx_liteethipv4checksum8, (top_ip_rx_liteethipv4checksum_s_next8[15:0] + top_ip_rx_liteethipv4checksum_s_next8[16])};
		end
		if ((~top_ip_rx_liteethipv4checksum_done)) begin
			top_ip_rx_liteethipv4checksum_r_next9 <= {top_ip_rx_liteethipv4checksum9, (top_ip_rx_liteethipv4checksum_s_next9[15:0] + top_ip_rx_liteethipv4checksum_s_next9[16])};
		end
		if (top_ip_rx_liteethipv4checksum_counter_ce) begin
			top_ip_rx_liteethipv4checksum_counter <= (top_ip_rx_liteethipv4checksum_counter + 1'd1);
		end
	end
	if (top_ip_rx_reset) begin
		top_ip_rx_liteethipv4checksum_counter <= 4'd0;
	end
	liteethip_liteethiprx_fsm_state <= liteethip_liteethiprx_fsm_next_state;
	case (liteethip_grant)
		1'd0: begin
			if ((~liteethip_request[0])) begin
				if (liteethip_request[1]) begin
					liteethip_grant <= 1'd1;
				end
			end
		end
		1'd1: begin
			if ((~liteethip_request[1])) begin
				if (liteethip_request[0]) begin
					liteethip_grant <= 1'd0;
				end
			end
		end
	endcase
	liteethip_status0_ongoing1 <= liteethip_status0_ongoing0;
	if (liteethip_status0_last) begin
		liteethip_status0_first <= 1'd1;
	end else begin
		if ((top_icmp_sink_valid & top_icmp_sink_ready)) begin
			liteethip_status0_first <= 1'd0;
		end
	end
	liteethip_status1_ongoing1 <= liteethip_status1_ongoing0;
	if (liteethip_status1_last) begin
		liteethip_status1_first <= 1'd1;
	end else begin
		if ((top_ip_port_sink_valid & top_ip_port_sink_ready)) begin
			liteethip_status1_first <= 1'd0;
		end
	end
	if (liteethip_last) begin
		liteethip_sel_locked <= 1'd0;
	end else begin
		if (((liteethip_first & top_ip_crossbar_sink_valid) & (~liteethip_sel_locked))) begin
			liteethip_sel_ongoing <= liteethip_sel0;
			liteethip_sel_locked <= 1'd1;
		end
	end
	liteethip_ongoing1 <= liteethip_ongoing0;
	if (liteethip_last) begin
		liteethip_first <= 1'd1;
	end else begin
		if ((top_ip_crossbar_sink_valid & top_ip_crossbar_sink_ready)) begin
			liteethip_first <= 1'd0;
		end
	end
	if (top_icmp_tx_source_source_valid) begin
		if ((~top_icmp_tx_active)) begin
			top_icmp_tx_length <= (top_icmp_tx_sink_sink_param_length + 4'd8);
			top_icmp_tx_ip_address <= top_icmp_tx_sink_sink_param_ip_address;
			top_icmp_tx_active <= 1'd1;
		end
		if ((top_icmp_tx_source_source_ready & top_icmp_tx_source_source_last)) begin
			top_icmp_tx_active <= 1'd0;
		end
	end
	liteethicmp_state <= liteethicmp_next_state;
	if (top_icmp_tx_packetizer_count_liteethicmp_next_value_ce) begin
		top_icmp_tx_packetizer_count <= top_icmp_tx_packetizer_count_liteethicmp_next_value;
	end
	if ((top_icmp_rx_sink_sink_valid & top_icmp_rx_sink_sink_ready)) begin
		if ((~top_icmp_rx_active)) begin
			top_icmp_rx_length <= top_icmp_rx_sink_sink_param_length;
			top_icmp_rx_protocol <= top_icmp_rx_sink_sink_param_protocol;
			top_icmp_rx_ip_address <= top_icmp_rx_sink_sink_param_ip_address;
		end
		top_icmp_rx_active <= (~top_icmp_rx_sink_sink_last);
	end
	if (top_icmp_rx_depacketizer_sr_shift) begin
		top_icmp_rx_depacketizer_sr <= {top_icmp_rx_depacketizer_sink_payload_data, top_icmp_rx_depacketizer_sr[63:8]};
	end
	if (top_icmp_rx_depacketizer_sr_shift_leftover) begin
		top_icmp_rx_depacketizer_sr <= {top_icmp_rx_depacketizer_sink_payload_data, top_icmp_rx_depacketizer_sr[63:0]};
	end
	liteethicmp_liteethicmpdepacketizer_state <= liteethicmp_liteethicmpdepacketizer_next_state;
	if (top_icmp_rx_depacketizer_count_liteethicmp_liteethicmpdepacketizer_next_value_ce0) begin
		top_icmp_rx_depacketizer_count <= top_icmp_rx_depacketizer_count_liteethicmp_liteethicmpdepacketizer_next_value0;
	end
	if (top_icmp_rx_depacketizer_fsm_from_idle_liteethicmp_liteethicmpdepacketizer_next_value_ce1) begin
		top_icmp_rx_depacketizer_fsm_from_idle <= top_icmp_rx_depacketizer_fsm_from_idle_liteethicmp_liteethicmpdepacketizer_next_value1;
	end
	if (top_icmp_rx_depacketizer_data_copy_first_liteethicmp_liteethicmpdepacketizer_next_value_ce2) begin
		top_icmp_rx_depacketizer_data_copy_first <= top_icmp_rx_depacketizer_data_copy_first_liteethicmp_liteethicmpdepacketizer_next_value2;
	end
	liteethicmp_fsm_state <= liteethicmp_fsm_next_state;
	if (top_icmp_rx_count_liteethicmp_fsm_next_value_ce) begin
		top_icmp_rx_count <= top_icmp_rx_count_liteethicmp_fsm_next_value;
	end
	if ((top_icmp_echo_sink_sink_valid & top_icmp_echo_sink_sink_ready)) begin
		top_icmp_echo_busy <= 1'd1;
		top_icmp_echo_receiving <= (~top_icmp_echo_sink_sink_last);
	end
	if ((top_icmp_echo_buffer_drop | ((top_icmp_echo_source_source_valid & top_icmp_echo_source_source_ready) & top_icmp_echo_source_source_last))) begin
		top_icmp_echo_busy <= 1'd0;
	end
	if ((top_icmp_echo_sink_sink_valid & top_icmp_echo_sink_sink_ready)) begin
		if (top_icmp_echo_sink_sink_last) begin
			top_icmp_echo_count <= 1'd0;
		end else begin
			if ((top_icmp_echo_count <= 8'd128)) begin
				top_icmp_echo_count <= top_icmp_echo_size;
			end
		end
	end
	if (top_icmp_echo_buffer_sink_valid) begin
		top_icmp_echo_buffer_invalid <= (top_icmp_echo_buffer_invalid | top_icmp_echo_buffer_discard);
		if (((~top_icmp_echo_buffer_overflow) & (~top_icmp_echo_buffer_full))) begin
			top_icmp_echo_buffer_wr_ptr <= (top_icmp_echo_buffer_wr_ptr + 1'd1);
		end else begin
			top_icmp_echo_buffer_overflow <= 1'd1;
		end
		if (top_icmp_echo_buffer_sink_last) begin
			top_icmp_echo_buffer_overflow <= 1'd0;
			top_icmp_echo_buffer_invalid <= 1'd0;
			if (top_icmp_echo_buffer_commit) begin
				top_icmp_echo_buffer_commit_ptr <= (top_icmp_echo_buffer_wr_ptr + 1'd1);
			end else begin
				top_icmp_echo_buffer_wr_ptr <= top_icmp_echo_buffer_commit_ptr;
			end
		end
	end
	if (top_icmp_echo_buffer_fetch) begin
		top_icmp_echo_buffer_rd_ptr <= (top_icmp_echo_buffer_rd_ptr + 1'd1);
		top_icmp_echo_buffer_out_valid <= 1'd1;
	end else begin
		if ((top_icmp_echo_buffer_source_valid & top_icmp_echo_buffer_source_ready)) begin
			top_icmp_echo_buffer_out_valid <= 1'd0;
		end
	end
	if (((~top_icmp_echo_buffer_pipe_valid_source_valid) | top_icmp_echo_buffer_pipe_valid_source_ready)) begin
		top_icmp_echo_buffer_pipe_valid_source_valid <= top_icmp_echo_buffer_pipe_valid_sink_valid;
		top_icmp_echo_buffer_pipe_valid_source_first <= top_icmp_echo_buffer_pipe_valid_sink_first;
		top_icmp_echo_buffer_pipe_valid_source_last <= top_icmp_echo_buffer_pipe_valid_sink_last;
		top_icmp_echo_buffer_pipe_valid_source_param_checksum <= top_icmp_echo_buffer_pipe_valid_sink_param_checksum;
		top_icmp_echo_buffer_pipe_valid_source_param_code <= top_icmp_echo_buffer_pipe_valid_sink_param_code;
		top_icmp_echo_buffer_pipe_valid_source_param_msgtype <= top_icmp_echo_buffer_pipe_valid_sink_param_msgtype;
		top_icmp_echo_buffer_pipe_valid_source_param_quench <= top_icmp_echo_buffer_pipe_valid_sink_param_quench;
		top_icmp_echo_buffer_pipe_valid_source_param_ip_address <= top_icmp_echo_buffer_pipe_valid_sink_param_ip_address;
		top_icmp_echo_buffer_pipe_valid_source_param_length <= top_icmp_echo_buffer_pipe_valid_sink_param_length;
	end
	if (top_tx_source_source_valid) begin
		if ((~top_tx_active)) begin
			top_tx_length <= top_tx_packetizer_sink_param_length;
			top_tx_ip_address <= top_tx_sink_sink_param_ip_address;
			top_tx_active <= 1'd1;
		end
		if ((top_tx_source_source_ready & top_tx_source_source_last)) begin
			top_tx_active <= 1'd0;
		end
	end
	liteethudp_state <= liteethudp_next_state;
	if (top_tx_packetizer_count_liteethudp_next_value_ce) begin
		top_tx_packetizer_count <= top_tx_packetizer_count_liteethudp_next_value;
	end
	if ((top_rx_sink_sink_valid & top_rx_sink_sink_ready)) begin
		if ((~top_rx_active)) begin
			top_rx_length <= top_rx_sink_sink_param_length;
			top_rx_protocol <= top_rx_sink_sink_param_protocol;
			top_rx_ip_address <= top_rx_sink_sink_param_ip_address;
		end
		top_rx_active <= (~top_rx_sink_sink_last);
	end
	if (top_rx_depacketizer_sr_shift) begin
		top_rx_depacketizer_sr <= {top_rx_depacketizer_sink_payload_data, top_rx_depacketizer_sr[63:8]};
	end
	if (top_rx_depacketizer_sr_shift_leftover) begin
		top_rx_depacketizer_sr <= {top_rx_depacketizer_sink_payload_data, top_rx_depacketizer_sr[63:0]};
	end
	liteethudp_liteethudpdepacketizer_state <= liteethudp_liteethudpdepacketizer_next_state;
	if (top_rx_depacketizer_count_liteethudp_liteethudpdepacketizer_next_value_ce0) begin
		top_rx_depacketizer_count <= top_rx_depacketizer_count_liteethudp_liteethudpdepacketizer_next_value0;
	end
	if (top_rx_depacketizer_fsm_from_idle_liteethudp_liteethudpdepacketizer_next_value_ce1) begin
		top_rx_depacketizer_fsm_from_idle <= top_rx_depacketizer_fsm_from_idle_liteethudp_liteethudpdepacketizer_next_value1;
	end
	if (top_rx_depacketizer_data_copy_first_liteethudp_liteethudpdepacketizer_next_value_ce2) begin
		top_rx_depacketizer_data_copy_first <= top_rx_depacketizer_data_copy_first_liteethudp_liteethudpdepacketizer_next_value2;
	end
	liteethudp_fsm_state <= liteethudp_fsm_next_state;
	if (top_rx_count_liteethudp_fsm_next_value_ce) begin
		top_rx_count <= top_rx_count_liteethudp_fsm_next_value;
	end
	if (liteethudp_last) begin
		liteethudp_sel_locked <= 1'd0;
	end else begin
		if (((liteethudp_first & top_crossbar_sink_valid) & (~liteethudp_sel_locked))) begin
			liteethudp_sel_ongoing <= liteethudp_sel0;
			liteethudp_sel_locked <= 1'd1;
		end
	end
	liteethudp_ongoing1 <= liteethudp_ongoing0;
	if (liteethudp_last) begin
		liteethudp_first <= 1'd1;
	end else begin
		if ((top_crossbar_sink_valid & top_crossbar_sink_ready)) begin
			liteethudp_first <= 1'd0;
		end
	end
	if (top_arm_cdc_i) begin
		top_arm_cdc_toggle_i <= (~top_arm_cdc_toggle_i);
	end
	top_done_cdc_toggle_o_r <= top_done_cdc_toggle_o;
	if (((top_user_port_source_valid & top_user_port_source_ready) & top_user_port_source_last)) begin
		top_server_rx_count <= (top_server_rx_count + 1'd1);
	end
	if (((top_user_port_sink_valid & top_user_port_sink_ready) & top_user_port_sink_last)) begin
		top_server_tx_count <= (top_server_tx_count + 1'd1);
	end
	state <= next_state;
	if (next_value_ce) begin
		sync_lhs_self = next_value;
		case (top_server_count)
			1'd0: begin
				top_server0 <= sync_lhs_self;
			end
			1'd1: begin
				top_server1 <= sync_lhs_self;
			end
			2'd2: begin
				top_server2 <= sync_lhs_self;
			end
			2'd3: begin
				top_server3 <= sync_lhs_self;
			end
			3'd4: begin
				top_server4 <= sync_lhs_self;
			end
			3'd5: begin
				top_server5 <= sync_lhs_self;
			end
			3'd6: begin
				top_server6 <= sync_lhs_self;
			end
			default: begin
				top_server7 <= sync_lhs_self;
			end
		endcase
	end
	if (top_server_remote_ip_next_value_ce0) begin
		top_server_remote_ip <= top_server_remote_ip_next_value0;
	end
	if (top_server_remote_port_next_value_ce1) begin
		top_server_remote_port <= top_server_remote_port_next_value1;
	end
	if (top_server_bad_next_value_ce2) begin
		top_server_bad <= top_server_bad_next_value2;
	end
	if (top_server_count_next_value_ce3) begin
		top_server_count <= top_server_count_next_value3;
	end
	if (top_server_checked_next_value_ce4) begin
		top_server_checked <= top_server_checked_next_value4;
	end
	if (top_server_hidx_next_value_ce5) begin
		top_server_hidx <= top_server_hidx_next_value5;
	end
	if (top_server_wordidx_next_value_ce6) begin
		top_server_wordidx <= top_server_wordidx_next_value6;
	end
	if (top_server_ev_next_value_ce7) begin
		top_server_ev <= top_server_ev_next_value7;
	end
	if (top_server_valid_next_value_ce8) begin
		top_server_valid <= top_server_valid_next_value8;
	end
	if (top_server_settle_next_value_ce9) begin
		top_server_settle <= top_server_settle_next_value9;
	end
	if (top_server_capture_id_next_value_ce10) begin
		top_server_capture_id <= top_server_capture_id_next_value10;
	end
	if (top_server_word_next_value_ce11) begin
		top_server_word <= top_server_word_next_value11;
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
		top_mac_core_tx_padding_counter <= 16'd0;
		top_mac_core_tx_crc_reg <= 32'd4294967295;
		top_mac_core_tx_crc_cnt <= 2'd3;
		top_mac_core_tx_crc_pipe_valid_source_valid <= 1'd0;
		top_mac_core_txdatapath_cdc_graycounter0_q <= 6'd0;
		top_mac_core_txdatapath_cdc_graycounter0_q_binary <= 6'd0;
		top_mac_core_preamble_errors_status <= 32'd0;
		top_mac_core_crc_errors_status <= 32'd0;
		top_mac_core_drops_status <= 32'd0;
		top_mac_core_rx_cdc_cdc_readable <= 1'd0;
		top_mac_core_rx_cdc_cdc_graycounter1_q <= 6'd0;
		top_mac_core_rx_cdc_cdc_graycounter1_q_binary <= 6'd0;
		top_mac_core_liteethmaccrc32checker_crc_reg <= 32'd4294967295;
		top_mac_core_liteethmaccrc32checker_syncfifo_level <= 3'd0;
		top_mac_core_liteethmaccrc32checker_syncfifo_produce <= 3'd0;
		top_mac_core_liteethmaccrc32checker_syncfifo_consume <= 3'd0;
		top_mac_core_liteethmaccrc32checker_last_error <= 1'd0;
		top_mac_core_liteethmaccrc32checker_packet_error <= 1'd0;
		top_mac_core_bufferizeendpoints_pipe_valid_source_valid <= 1'd0;
		top_mac_core_rx_padding_length <= 11'd0;
		top_mac_packetizer_count <= 4'd0;
		top_mac_depacketizer_count <= 4'd0;
		top_mac_depacketizer_data_copy_first <= 1'd0;
		top_mac_depacketizer_fsm_from_idle <= 1'd0;
		top_arp_tx_packetizer_count <= 5'd0;
		top_arp_rx_depacketizer_count <= 5'd0;
		top_arp_rx_depacketizer_data_copy_first <= 1'd0;
		top_arp_rx_depacketizer_fsm_from_idle <= 1'd0;
		top_arp_table_request_pending <= 1'd0;
		top_arp_table_request_counter <= 3'd0;
		top_arp_table_request_timer_count <= 22'd4000000;
		top_arp_table_cache_update_count <= 1'd0;
		top_arp_table_cache_search_count <= 1'd0;
		top_arp_table_cache_error <= 1'd0;
		top_arp_table_cache_count <= 26'd40000000;
		top_ip_tx_pipe_valid_source_valid <= 1'd0;
		top_ip_tx_liteethipv4checksum_counter <= 4'd0;
		top_ip_tx_packetizer_count <= 5'd0;
		top_ip_rx_depacketizer_count <= 5'd0;
		top_ip_rx_depacketizer_data_copy_first <= 1'd0;
		top_ip_rx_depacketizer_fsm_from_idle <= 1'd0;
		top_ip_rx_liteethipv4checksum_counter <= 4'd0;
		top_icmp_tx_packetizer_count <= 3'd0;
		top_icmp_tx_active <= 1'd0;
		top_icmp_tx_length <= 16'd0;
		top_icmp_tx_ip_address <= 32'd0;
		top_icmp_rx_depacketizer_count <= 3'd0;
		top_icmp_rx_depacketizer_data_copy_first <= 1'd0;
		top_icmp_rx_depacketizer_fsm_from_idle <= 1'd0;
		top_icmp_rx_active <= 1'd0;
		top_icmp_rx_length <= 16'd0;
		top_icmp_rx_protocol <= 8'd0;
		top_icmp_rx_ip_address <= 32'd0;
		top_icmp_rx_count <= 17'd0;
		top_icmp_echo_buffer_pipe_valid_source_valid <= 1'd0;
		top_icmp_echo_buffer_wr_ptr <= 8'd0;
		top_icmp_echo_buffer_commit_ptr <= 8'd0;
		top_icmp_echo_buffer_rd_ptr <= 8'd0;
		top_icmp_echo_buffer_out_valid <= 1'd0;
		top_icmp_echo_buffer_overflow <= 1'd0;
		top_icmp_echo_buffer_invalid <= 1'd0;
		top_icmp_echo_busy <= 1'd0;
		top_icmp_echo_receiving <= 1'd0;
		top_icmp_echo_count <= 8'd0;
		top_tx_packetizer_count <= 3'd0;
		top_tx_active <= 1'd0;
		top_tx_length <= 16'd0;
		top_tx_ip_address <= 32'd0;
		top_rx_depacketizer_count <= 3'd0;
		top_rx_depacketizer_data_copy_first <= 1'd0;
		top_rx_depacketizer_fsm_from_idle <= 1'd0;
		top_rx_active <= 1'd0;
		top_rx_length <= 16'd0;
		top_rx_protocol <= 8'd0;
		top_rx_ip_address <= 32'd0;
		top_rx_count <= 17'd0;
		top_server_rx_count <= 32'd0;
		top_server_checked <= 32'd0;
		top_server_tx_count <= 32'd0;
		top_server_ev <= 1'd0;
		top_server_capture_id <= 32'd0;
		top_server_valid <= 1'd0;
		top_server_count <= 4'd0;
		top_server_bad <= 1'd0;
		top_server0 <= 8'd0;
		top_server1 <= 8'd0;
		top_server2 <= 8'd0;
		top_server3 <= 8'd0;
		top_server4 <= 8'd0;
		top_server5 <= 8'd0;
		top_server6 <= 8'd0;
		top_server7 <= 8'd0;
		top_server_remote_ip <= 32'd0;
		top_server_remote_port <= 16'd0;
		top_server_word <= 16'd0;
		top_server_wordidx <= 9'd0;
		top_server_hidx <= 4'd0;
		top_server_settle <= 11'd0;
		top_tick <= 32'd0;
		gtxtxinit_state <= 4'd0;
		gtxrxinit_state <= 4'd0;
		liteethmac_txdatapath_liteethmacpaddinginserter_state <= 1'd0;
		liteethmac_txdatapath_bufferizeendpoints_state <= 2'd0;
		liteethmac_txdatapath_liteethmacpreambleinserter_state <= 2'd0;
		liteethmac_rxdatapath_liteethmacpreamblechecker_state <= 1'd0;
		liteethmac_rxdatapath_bufferizeendpoints_state <= 2'd0;
		liteethmac_grant <= 1'd0;
		liteethmac_status0_first <= 1'd1;
		liteethmac_status0_ongoing1 <= 1'd0;
		liteethmac_status1_first <= 1'd1;
		liteethmac_status1_ongoing1 <= 1'd0;
		liteethmac_first <= 1'd1;
		liteethmac_ongoing1 <= 1'd0;
		liteethmac_sel_ongoing <= 2'd0;
		liteethmac_sel_locked <= 1'd0;
		liteethmac_liteethmacpacketizer_state <= 1'd1;
		liteethmac_liteethmacdepacketizer_state <= 2'd0;
		liteetharptx_liteetharppacketizer_state <= 1'd1;
		liteetharptx_fsm_state <= 1'd0;
		liteetharprx_liteetharpdepacketizer_state <= 2'd0;
		liteetharprx_fsm_state <= 2'd0;
		liteetharptable_liteetharpcache_state <= 3'd0;
		liteetharptable_fsm_state <= 3'd0;
		liteethip_liteethiptx_liteethipv4packetizer_state <= 1'd1;
		liteethip_liteethiptx_fsm_state <= 3'd2;
		liteethip_liteethiprx_liteethipv4depacketizer_state <= 2'd0;
		liteethip_liteethiprx_fsm_state <= 2'd1;
		liteethip_grant <= 1'd0;
		liteethip_status0_first <= 1'd1;
		liteethip_status0_ongoing1 <= 1'd0;
		liteethip_status1_first <= 1'd1;
		liteethip_status1_ongoing1 <= 1'd0;
		liteethip_first <= 1'd1;
		liteethip_ongoing1 <= 1'd0;
		liteethip_sel_ongoing <= 2'd0;
		liteethip_sel_locked <= 1'd0;
		liteethicmp_state <= 1'd1;
		liteethicmp_liteethicmpdepacketizer_state <= 2'd0;
		liteethicmp_fsm_state <= 2'd2;
		liteethudp_state <= 1'd1;
		liteethudp_liteethudpdepacketizer_state <= 2'd0;
		liteethudp_fsm_state <= 2'd2;
		liteethudp_first <= 1'd1;
		liteethudp_ongoing1 <= 1'd0;
		liteethudp_sel_ongoing <= 1'd0;
		liteethudp_sel_locked <= 1'd0;
		state <= 4'd0;
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
	xilinxmultiregimpl160 <= top_mac_core_txdatapath_cdc_graycounter1_q;
	xilinxmultiregimpl161 <= xilinxmultiregimpl160;
	xilinxmultiregimpl170 <= top_mac_core_toggle_i;
	xilinxmultiregimpl171 <= xilinxmultiregimpl170;
	xilinxmultiregimpl180 <= top_mac_core_rx_cdc_cdc_graycounter0_q;
	xilinxmultiregimpl181 <= xilinxmultiregimpl180;
	xilinxmultiregimpl200 <= top_mac_core_pulsesynchronizer0_toggle_i;
	xilinxmultiregimpl201 <= xilinxmultiregimpl200;
	xilinxmultiregimpl210 <= top_mac_core_pulsesynchronizer1_toggle_i;
	xilinxmultiregimpl211 <= xilinxmultiregimpl210;
	xilinxmultiregimpl230 <= top_done_cdc_toggle_i;
	xilinxmultiregimpl231 <= xilinxmultiregimpl230;
end

IBUFDS #(
	.DIFF_TERM("TRUE")
) IBUFDS (
	.I(MCLK1_P),
	.IB(MCLK1_N),
	.O(top_m)
);

BUFG BUFG(
	.I(top_m),
	.O(sys_clk)
);

IBUFDS_GTE2 IBUFDS_GTE2(
	.CEB(1'd0),
	.I(MGTCLK_P),
	.IB(MGTCLK_N),
	.O(top_ref)
);

BUFG BUFG_1(
	.I(top_clkout),
	.O(top_clkout_buf)
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
	.CPLL_FBDIV(3'd5),
	.CPLL_FBDIV_45(3'd5),
	.CPLL_INIT_CFG(5'd30),
	.CPLL_LOCK_CFG(9'd488),
	.CPLL_REFCLK_DIV(2'd2),
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

BUFG BUFG_2(
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

BUFG BUFG_3(
	.I(top_pma_k7_gtx_basex_s7mmcm1_clkout0),
	.O(top_pma_k7_gtx_basex_s7mmcm1_clkout_buf0)
);

BUFG BUFG_4(
	.I(top_pma_k7_gtx_basex_s7mmcm1_clkout1),
	.O(top_pma_k7_gtx_basex_s7mmcm1_clkout_buf1)
);

reg [11:0] storage[0:31];
reg [4:0] memadr_1;
reg [4:0] memadr_2;
always @(posedge sys_clk) begin : mem_write_block_1
	if (top_mac_core_txdatapath_cdc_wrport_we)
		storage[top_mac_core_txdatapath_cdc_wrport_adr] <= top_mac_core_txdatapath_cdc_wrport_dat_w;
	memadr_1 <= top_mac_core_txdatapath_cdc_wrport_adr;
end

always @(posedge eth_tx_clk) begin : mem_write_block_2
	memadr_2 <= top_mac_core_txdatapath_cdc_rdport_adr;
end

assign top_mac_core_txdatapath_cdc_wrport_dat_r = storage[memadr_1];
assign top_mac_core_txdatapath_cdc_rdport_dat_r = storage[memadr_2];

reg [11:0] storage_1[0:2047];
reg [11:0] memdat;
reg [11:0] memdat_1;
always @(posedge eth_tx_clk) begin : mem_write_block_3
	if (top_mac_core_tx_packet_fifo_payload_fifo_wrport_we)
		storage_1[top_mac_core_tx_packet_fifo_payload_fifo_wrport_adr] <= top_mac_core_tx_packet_fifo_payload_fifo_wrport_dat_w;
	memdat <= storage_1[top_mac_core_tx_packet_fifo_payload_fifo_wrport_adr];
end

always @(posedge eth_tx_clk) begin : mem_write_block_4
	if (top_mac_core_tx_packet_fifo_payload_fifo_rdport_re)
		memdat_1 <= storage_1[top_mac_core_tx_packet_fifo_payload_fifo_rdport_adr];
end

assign top_mac_core_tx_packet_fifo_payload_fifo_wrport_dat_r = memdat;
assign top_mac_core_tx_packet_fifo_payload_fifo_rdport_dat_r = memdat_1;

reg [2:0] storage_2[0:4];
reg [2:0] memdat_2;
reg [2:0] memdat_3;
always @(posedge eth_tx_clk) begin : mem_write_block_5
	if (top_mac_core_tx_packet_fifo_param_fifo_wrport_we)
		storage_2[top_mac_core_tx_packet_fifo_param_fifo_wrport_adr] <= top_mac_core_tx_packet_fifo_param_fifo_wrport_dat_w;
	memdat_2 <= storage_2[top_mac_core_tx_packet_fifo_param_fifo_wrport_adr];
end

always @(posedge eth_tx_clk) begin : mem_write_block_6
	if (top_mac_core_tx_packet_fifo_param_fifo_rdport_re)
		memdat_3 <= storage_2[top_mac_core_tx_packet_fifo_param_fifo_rdport_adr];
end

assign top_mac_core_tx_packet_fifo_param_fifo_wrport_dat_r = memdat_2;
assign top_mac_core_tx_packet_fifo_param_fifo_rdport_dat_r = memdat_3;

reg [2:0] storage_3[0:3];
reg [2:0] memdat_4;
always @(posedge eth_rx_clk) begin : mem_write_block_7
	if (top_mac_core_rx_packet_fifo_param_fifo_wrport_we)
		storage_3[top_mac_core_rx_packet_fifo_param_fifo_wrport_adr] <= top_mac_core_rx_packet_fifo_param_fifo_wrport_dat_w;
	memdat_4 <= storage_3[top_mac_core_rx_packet_fifo_param_fifo_wrport_adr];
end

always @(posedge eth_rx_clk) begin : mem_write_block_8
end

assign top_mac_core_rx_packet_fifo_param_fifo_wrport_dat_r = memdat_4;
assign top_mac_core_rx_packet_fifo_param_fifo_rdport_dat_r = storage_3[top_mac_core_rx_packet_fifo_param_fifo_rdport_adr];

reg [11:0] mem[0:2047];
reg [10:0] memadr_3;
reg [10:0] memadr_4;
always @(posedge eth_rx_clk) begin : mem_write_block_9
	if (top_mac_core_rx_packet_fifo_wr_port_we)
		mem[top_mac_core_rx_packet_fifo_wr_port_adr] <= top_mac_core_rx_packet_fifo_wr_port_dat_w;
	memadr_3 <= top_mac_core_rx_packet_fifo_wr_port_adr;
end

always @(posedge eth_rx_clk) begin : mem_write_block_10
	if (top_mac_core_rx_packet_fifo_rd_port_re)
		memadr_4 <= top_mac_core_rx_packet_fifo_rd_port_adr;
end

assign top_mac_core_rx_packet_fifo_wr_port_dat_r = mem[memadr_3];
assign top_mac_core_rx_packet_fifo_rd_port_dat_r = mem[memadr_4];

reg [11:0] storage_4[0:31];
reg [4:0] memadr_5;
reg [4:0] memadr_6;
always @(posedge eth_rx_clk) begin : mem_write_block_11
	if (top_mac_core_rx_cdc_cdc_wrport_we)
		storage_4[top_mac_core_rx_cdc_cdc_wrport_adr] <= top_mac_core_rx_cdc_cdc_wrport_dat_w;
	memadr_5 <= top_mac_core_rx_cdc_cdc_wrport_adr;
end

always @(posedge sys_clk) begin : mem_write_block_12
	memadr_6 <= top_mac_core_rx_cdc_cdc_rdport_adr;
end

assign top_mac_core_rx_cdc_cdc_wrport_dat_r = storage_4[memadr_5];
assign top_mac_core_rx_cdc_cdc_rdport_dat_r = storage_4[memadr_6];

reg [11:0] storage_5[0:4];
reg [11:0] memdat_5;
always @(posedge sys_clk) begin : mem_write_block_13
	if (top_mac_core_liteethmaccrc32checker_syncfifo_wrport_we)
		storage_5[top_mac_core_liteethmaccrc32checker_syncfifo_wrport_adr] <= top_mac_core_liteethmaccrc32checker_syncfifo_wrport_dat_w;
	memdat_5 <= storage_5[top_mac_core_liteethmaccrc32checker_syncfifo_wrport_adr];
end

always @(posedge sys_clk) begin : mem_write_block_14
end

assign top_mac_core_liteethmaccrc32checker_syncfifo_wrport_dat_r = memdat_5;
assign top_mac_core_liteethmaccrc32checker_syncfifo_rdport_dat_r = storage_5[top_mac_core_liteethmaccrc32checker_syncfifo_rdport_adr];

reg [80:0] mem_1[0:1];
reg [0:0] memadr_7;
always @(posedge sys_clk) begin : mem_write_block_15
	if (top_arp_table_cache_mem_wr_port_we)
		mem_1[top_arp_table_cache_mem_wr_port_adr] <= top_arp_table_cache_mem_wr_port_dat_w;
	memadr_7 <= top_arp_table_cache_mem_wr_port_adr;
end

always @(posedge sys_clk) begin : mem_write_block_16
end

assign top_arp_table_cache_mem_wr_port_dat_r = mem_1[memadr_7];
assign top_arp_table_cache_mem_rd_port_dat_r = mem_1[top_arp_table_cache_mem_rd_port_adr];

reg [11:0] mem_2[0:127];
reg [6:0] memadr_8;
reg [6:0] memadr_9;
always @(posedge sys_clk) begin : mem_write_block_17
	if (top_icmp_echo_buffer_wr_port_we)
		mem_2[top_icmp_echo_buffer_wr_port_adr] <= top_icmp_echo_buffer_wr_port_dat_w;
	memadr_8 <= top_icmp_echo_buffer_wr_port_adr;
end

always @(posedge sys_clk) begin : mem_write_block_18
	if (top_icmp_echo_buffer_rd_port_re)
		memadr_9 <= top_icmp_echo_buffer_rd_port_adr;
end

assign top_icmp_echo_buffer_wr_port_dat_r = mem_2[memadr_8];
assign top_icmp_echo_buffer_rd_port_dat_r = mem_2[memadr_9];

(* ram_style = "block" *) reg [15:0] adc_trace0[0:4095];
reg [11:0] memadr_10;
reg [15:0] memdat_6;
always @(posedge cap_clk) begin : mem_write_block_19
	if (top_wp_memory0_we)
		adc_trace0[top_wp_memory0_adr] <= top_wp_memory0_dat_w;
	memadr_10 <= top_wp_memory0_adr;
end

always @(posedge sys_clk) begin : mem_write_block_20
	memdat_6 <= adc_trace0[top_rp_memory0_adr];
end

assign top_wp_memory0_dat_r = adc_trace0[memadr_10];
assign top_rp_memory0_dat_r = memdat_6;

(* ram_style = "block" *) reg [15:0] adc_trace1[0:4095];
reg [11:0] memadr_11;
reg [15:0] memdat_7;
always @(posedge cap_clk) begin : mem_write_block_21
	if (top_wp_memory1_we)
		adc_trace1[top_wp_memory1_adr] <= top_wp_memory1_dat_w;
	memadr_11 <= top_wp_memory1_adr;
end

always @(posedge sys_clk) begin : mem_write_block_22
	memdat_7 <= adc_trace1[top_rp_memory1_adr];
end

assign top_wp_memory1_dat_r = adc_trace1[memadr_11];
assign top_rp_memory1_dat_r = memdat_7;

(* ram_style = "block" *) reg [15:0] adc_trace2[0:4095];
reg [11:0] memadr_12;
reg [15:0] memdat_8;
always @(posedge cap_clk) begin : mem_write_block_23
	if (top_wp_memory2_we)
		adc_trace2[top_wp_memory2_adr] <= top_wp_memory2_dat_w;
	memadr_12 <= top_wp_memory2_adr;
end

always @(posedge sys_clk) begin : mem_write_block_24
	memdat_8 <= adc_trace2[top_rp_memory2_adr];
end

assign top_wp_memory2_dat_r = adc_trace2[memadr_12];
assign top_rp_memory2_dat_r = memdat_8;

(* ram_style = "block" *) reg [15:0] adc_trace3[0:4095];
reg [11:0] memadr_13;
reg [15:0] memdat_9;
always @(posedge cap_clk) begin : mem_write_block_25
	if (top_wp_memory3_we)
		adc_trace3[top_wp_memory3_adr] <= top_wp_memory3_dat_w;
	memadr_13 <= top_wp_memory3_adr;
end

always @(posedge sys_clk) begin : mem_write_block_26
	memdat_9 <= adc_trace3[top_rp_memory3_adr];
end

assign top_wp_memory3_dat_r = adc_trace3[memadr_13];
assign top_rp_memory3_dat_r = memdat_9;

(* ram_style = "block" *) reg [15:0] adc_trace4[0:4095];
reg [11:0] memadr_14;
reg [15:0] memdat_10;
always @(posedge cap_clk) begin : mem_write_block_27
	if (top_wp_memory4_we)
		adc_trace4[top_wp_memory4_adr] <= top_wp_memory4_dat_w;
	memadr_14 <= top_wp_memory4_adr;
end

always @(posedge sys_clk) begin : mem_write_block_28
	memdat_10 <= adc_trace4[top_rp_memory4_adr];
end

assign top_wp_memory4_dat_r = adc_trace4[memadr_14];
assign top_rp_memory4_dat_r = memdat_10;

(* ram_style = "block" *) reg [15:0] adc_trace5[0:4095];
reg [11:0] memadr_15;
reg [15:0] memdat_11;
always @(posedge cap_clk) begin : mem_write_block_29
	if (top_wp_memory5_we)
		adc_trace5[top_wp_memory5_adr] <= top_wp_memory5_dat_w;
	memadr_15 <= top_wp_memory5_adr;
end

always @(posedge sys_clk) begin : mem_write_block_30
	memdat_11 <= adc_trace5[top_rp_memory5_adr];
end

assign top_wp_memory5_dat_r = adc_trace5[memadr_15];
assign top_rp_memory5_dat_r = memdat_11;

(* ram_style = "block" *) reg [15:0] adc_trace6[0:4095];
reg [11:0] memadr_16;
reg [15:0] memdat_12;
always @(posedge cap_clk) begin : mem_write_block_31
	if (top_wp_memory6_we)
		adc_trace6[top_wp_memory6_adr] <= top_wp_memory6_dat_w;
	memadr_16 <= top_wp_memory6_adr;
end

always @(posedge sys_clk) begin : mem_write_block_32
	memdat_12 <= adc_trace6[top_rp_memory6_adr];
end

assign top_wp_memory6_dat_r = adc_trace6[memadr_16];
assign top_rp_memory6_dat_r = memdat_12;

(* ram_style = "block" *) reg [15:0] adc_trace7[0:4095];
reg [11:0] memadr_17;
reg [15:0] memdat_13;
always @(posedge cap_clk) begin : mem_write_block_33
	if (top_wp_memory7_we)
		adc_trace7[top_wp_memory7_adr] <= top_wp_memory7_dat_w;
	memadr_17 <= top_wp_memory7_adr;
end

always @(posedge sys_clk) begin : mem_write_block_34
	memdat_13 <= adc_trace7[top_rp_memory7_adr];
end

assign top_wp_memory7_dat_r = adc_trace7[memadr_17];
assign top_rp_memory7_dat_r = memdat_13;

(* ram_style = "block" *) reg [15:0] adc_trace8[0:4095];
reg [11:0] memadr_18;
reg [15:0] memdat_14;
always @(posedge cap_clk) begin : mem_write_block_35
	if (top_wp_memory8_we)
		adc_trace8[top_wp_memory8_adr] <= top_wp_memory8_dat_w;
	memadr_18 <= top_wp_memory8_adr;
end

always @(posedge sys_clk) begin : mem_write_block_36
	memdat_14 <= adc_trace8[top_rp_memory8_adr];
end

assign top_wp_memory8_dat_r = adc_trace8[memadr_18];
assign top_rp_memory8_dat_r = memdat_14;

(* ram_style = "block" *) reg [15:0] adc_trace9[0:4095];
reg [11:0] memadr_19;
reg [15:0] memdat_15;
always @(posedge cap_clk) begin : mem_write_block_37
	if (top_wp_memory9_we)
		adc_trace9[top_wp_memory9_adr] <= top_wp_memory9_dat_w;
	memadr_19 <= top_wp_memory9_adr;
end

always @(posedge sys_clk) begin : mem_write_block_38
	memdat_15 <= adc_trace9[top_rp_memory9_adr];
end

assign top_wp_memory9_dat_r = adc_trace9[memadr_19];
assign top_rp_memory9_dat_r = memdat_15;

(* ram_style = "block" *) reg [15:0] adc_trace10[0:4095];
reg [11:0] memadr_20;
reg [15:0] memdat_16;
always @(posedge cap_clk) begin : mem_write_block_39
	if (top_wp_memory10_we)
		adc_trace10[top_wp_memory10_adr] <= top_wp_memory10_dat_w;
	memadr_20 <= top_wp_memory10_adr;
end

always @(posedge sys_clk) begin : mem_write_block_40
	memdat_16 <= adc_trace10[top_rp_memory10_adr];
end

assign top_wp_memory10_dat_r = adc_trace10[memadr_20];
assign top_rp_memory10_dat_r = memdat_16;

(* ram_style = "block" *) reg [15:0] adc_trace11[0:4095];
reg [11:0] memadr_21;
reg [15:0] memdat_17;
always @(posedge cap_clk) begin : mem_write_block_41
	if (top_wp_memory11_we)
		adc_trace11[top_wp_memory11_adr] <= top_wp_memory11_dat_w;
	memadr_21 <= top_wp_memory11_adr;
end

always @(posedge sys_clk) begin : mem_write_block_42
	memdat_17 <= adc_trace11[top_rp_memory11_adr];
end

assign top_wp_memory11_dat_r = adc_trace11[memadr_21];
assign top_rp_memory11_dat_r = memdat_17;

eth_jtag eth_jtag(
	.report(top_report),
	.command(top_cmd)
);

FDCE FDCE(
	.C(top_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(top_reset),
	.Q(reset0)
);

FDCE FDCE_1(
	.C(top_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(reset0),
	.Q(reset1)
);

FDCE FDCE_2(
	.C(top_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(reset1),
	.Q(reset2)
);

FDCE FDCE_3(
	.C(top_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(reset2),
	.Q(reset3)
);

FDCE FDCE_4(
	.C(top_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(reset3),
	.Q(reset4)
);

FDCE FDCE_5(
	.C(top_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(reset4),
	.Q(reset5)
);

FDCE FDCE_6(
	.C(top_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(reset5),
	.Q(reset6)
);

FDCE FDCE_7(
	.C(top_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(reset6),
	.Q(reset7)
);

MMCME2_ADV #(
	.BANDWIDTH("OPTIMIZED"),
	.CLKFBOUT_MULT_F(5'd24),
	.CLKIN1_PERIOD(25.0),
	.CLKOUT0_DIVIDE_F(2'd3),
	.CLKOUT0_PHASE(1'd0),
	.DIVCLK_DIVIDE(1'd1),
	.REF_JITTER1(0.01)
) MMCME2_ADV (
	.CLKFBIN(mmcm_fb),
	.CLKIN1(top_clkin_signal),
	.PWRDWN(top_power_down),
	.RST(reset7),
	.CLKFBOUT(mmcm_fb),
	.CLKOUT0(top_clkout),
	.LOCKED(top_locked)
);

FDCE FDCE_8(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(top_pma_k7_gtx_basex_tx_mmcm_reset1),
	.Q(s7mmcm0_reset0)
);

FDCE FDCE_9(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset0),
	.Q(s7mmcm0_reset1)
);

FDCE FDCE_10(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset1),
	.Q(s7mmcm0_reset2)
);

FDCE FDCE_11(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset2),
	.Q(s7mmcm0_reset3)
);

FDCE FDCE_12(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset3),
	.Q(s7mmcm0_reset4)
);

FDCE FDCE_13(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset4),
	.Q(s7mmcm0_reset5)
);

FDCE FDCE_14(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset5),
	.Q(s7mmcm0_reset6)
);

FDCE FDCE_15(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset6),
	.Q(s7mmcm0_reset7)
);

MMCME2_ADV #(
	.BANDWIDTH("OPTIMIZED"),
	.CLKFBOUT_MULT_F(5'd18),
	.CLKIN1_PERIOD(16.0),
	.CLKOUT0_DIVIDE_F(5'd18),
	.CLKOUT0_PHASE(1'd0),
	.CLKOUT1_DIVIDE(4'd9),
	.CLKOUT1_PHASE(1'd0),
	.DIVCLK_DIVIDE(1'd1),
	.REF_JITTER1(0.01)
) MMCME2_ADV_1 (
	.CLKFBIN(s7mmcm0_mmcm_fb),
	.CLKIN1(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.PWRDWN(top_pma_k7_gtx_basex_tx_mmcm_power_down),
	.RST(s7mmcm0_reset7),
	.CLKFBOUT(s7mmcm0_mmcm_fb),
	.CLKOUT0(top_pma_k7_gtx_basex_s7mmcm0_clkout0),
	.CLKOUT1(top_pma_k7_gtx_basex_s7mmcm0_clkout1),
	.LOCKED(top_pma_k7_gtx_basex_tx_mmcm_locked1)
);

FDCE FDCE_16(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(top_pma_k7_gtx_basex_rx_mmcm_reset1),
	.Q(s7mmcm1_reset0)
);

FDCE FDCE_17(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset0),
	.Q(s7mmcm1_reset1)
);

FDCE FDCE_18(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset1),
	.Q(s7mmcm1_reset2)
);

FDCE FDCE_19(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset2),
	.Q(s7mmcm1_reset3)
);

FDCE FDCE_20(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset3),
	.Q(s7mmcm1_reset4)
);

FDCE FDCE_21(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset4),
	.Q(s7mmcm1_reset5)
);

FDCE FDCE_22(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset5),
	.Q(s7mmcm1_reset6)
);

FDCE FDCE_23(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset6),
	.Q(s7mmcm1_reset7)
);

MMCME2_ADV #(
	.BANDWIDTH("OPTIMIZED"),
	.CLKFBOUT_MULT_F(5'd18),
	.CLKIN1_PERIOD(16.0),
	.CLKOUT0_DIVIDE_F(5'd18),
	.CLKOUT0_PHASE(1'd0),
	.CLKOUT1_DIVIDE(4'd9),
	.CLKOUT1_PHASE(1'd0),
	.DIVCLK_DIVIDE(1'd1),
	.REF_JITTER1(0.01)
) MMCME2_ADV_2 (
	.CLKFBIN(s7mmcm1_mmcm_fb),
	.CLKIN1(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.PWRDWN(top_pma_k7_gtx_basex_rx_mmcm_power_down),
	.RST(s7mmcm1_reset7),
	.CLKFBOUT(s7mmcm1_mmcm_fb),
	.CLKOUT0(top_pma_k7_gtx_basex_s7mmcm1_clkout0),
	.CLKOUT1(top_pma_k7_gtx_basex_s7mmcm1_clkout1),
	.LOCKED(top_pma_k7_gtx_basex_rx_mmcm_locked1)
);

(* ars_ff1 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE (
	.C(cap_clk),
	.CE(1'd1),
	.D(1'd0),
	.PRE(xilinxasyncresetsynchronizerimpl0_async_reset),
	.Q(xilinxasyncresetsynchronizerimpl0_rst_meta)
);

(* ars_ff2 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_1 (
	.C(cap_clk),
	.CE(1'd1),
	.D(xilinxasyncresetsynchronizerimpl0_rst_meta),
	.PRE(xilinxasyncresetsynchronizerimpl0_async_reset),
	.Q(cap_rst)
);

(* ars_ff1 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_2 (
	.C(eth_tx_clk),
	.CE(1'd1),
	.D(1'd0),
	.PRE(xilinxasyncresetsynchronizerimpl1_async_reset),
	.Q(xilinxasyncresetsynchronizerimpl1_rst_meta)
);

(* ars_ff2 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_3 (
	.C(eth_tx_clk),
	.CE(1'd1),
	.D(xilinxasyncresetsynchronizerimpl1_rst_meta),
	.PRE(xilinxasyncresetsynchronizerimpl1_async_reset),
	.Q(eth_tx_rst)
);

(* ars_ff1 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_4 (
	.C(eth_rx_clk),
	.CE(1'd1),
	.D(1'd0),
	.PRE(xilinxasyncresetsynchronizerimpl2_async_reset),
	.Q(xilinxasyncresetsynchronizerimpl2_rst_meta)
);

(* ars_ff2 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_5 (
	.C(eth_rx_clk),
	.CE(1'd1),
	.D(xilinxasyncresetsynchronizerimpl2_rst_meta),
	.PRE(xilinxasyncresetsynchronizerimpl2_async_reset),
	.Q(eth_rx_rst)
);

endmodule
