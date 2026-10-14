/* Machine-generated using Migen */
module pm12_eth_diag(
	input MCLK1_P,
	input MCLK1_N,
	input MGTCLK_P,
	input MGTCLK_N,
	output TX_P,
	output TX_N,
	input RX_P,
	input RX_N
);

wire sys_clk;
reg sys_rst = 1'd0;
wire top_mclk;
wire top_ref;
wire top_refdiv;
wire refmon_clk;
reg top_pcstx_config_valid;
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
reg top_link_up;
reg top_restart;
reg top_align;
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
reg top_config_empty;
wire top_is_sgmii;
reg top_linkdown;
reg top_autoneg_ack;
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
reg top_waittimer0_wait;
wire top_waittimer0_done;
reg [20:0] top_waittimer0_count = 21'd1250000;
reg top_waittimer1_wait;
wire top_waittimer1_done;
reg [20:0] top_waittimer1_count = 21'd1250000;
reg top_waittimer2_wait;
wire top_waittimer2_done;
reg [17:0] top_waittimer2_count = 18'd200000;
reg [19:0] top_checker_count = 20'd0;
reg top_checker_tick = 1'd0;
reg top_checker_error = 1'd0;
wire top_sgmii_speed_valid;
wire [1:0] top_sgmii_tx_speed;
wire [1:0] top_sgmii_rx_speed;
reg [3:0] top_rx_config_reg_count = 4'd0;
reg [15:0] top_rx_config_reg_last = 16'd0;
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
reg [5:0] top_pma_k7_gtx_basex_gtxtxinit_init_delay_count = 6'd60;
reg top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_wait;
wire top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_done;
reg [10:0] top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_count = 11'd1024;
wire top_pma_k7_gtx_basex_gtxtxinit_watchdog_wait;
wire top_pma_k7_gtx_basex_gtxtxinit_watchdog_done;
reg [16:0] top_pma_k7_gtx_basex_gtxtxinit_watchdog_count = 17'd120000;
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
reg [5:0] top_pma_k7_gtx_basex_gtxrxinit_init_delay_count = 6'd60;
reg top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_wait;
wire top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_done;
reg [10:0] top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_count = 11'd1024;
wire top_pma_k7_gtx_basex_gtxrxinit_watchdog_wait;
wire top_pma_k7_gtx_basex_gtxrxinit_watchdog_done;
reg [16:0] top_pma_k7_gtx_basex_gtxrxinit_watchdog_count = 17'd120000;
wire top_pma_k7_gtx_basex_rx_init_reset;
wire top_pma_k7_gtx_basex_i;
wire top_pma_k7_gtx_basex_o;
reg top_pma_k7_gtx_basex_toggle_i = 1'd0;
wire top_pma_k7_gtx_basex_toggle_o;
reg top_pma_k7_gtx_basex_toggle_o_r = 1'd0;
reg [12:0] top_pma_k7_gtx_basex_cdr_lock_counter = 13'd0;
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
reg top_sink_first = 1'd0;
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
wire [15:0] top_cmd;
wire [15:0] top_cmd_async;
wire top_prbs_err;
wire top_ref_lost;
reg [31:0] top_tick = 32'd0;
reg [31:0] top_refcount = 32'd0;
wire [31:0] top_refsync;
wire top_errsync;
reg [31:0] top_prbscount = 32'd0;
reg [31:0] top_txcount = 32'd0;
reg [31:0] top_rxcount = 32'd0;
reg [31:0] top_badcount = 32'd0;
reg [31:0] top_rxbytes = 32'd0;
reg [5:0] top_txi = 6'd0;
reg [5:0] top_rxi = 6'd0;
reg [15:0] top_gap = 16'd1000;
reg top_bad = 1'd0;
wire top_fixed_mode;
reg top_fixed_up = 1'd0;
reg [19:0] top_idle_age = 20'd0;
wire top_link;
reg [31:0] top_ci_count = 32'd0;
reg [31:0] top_cfg_count = 32'd0;
reg [31:0] top_invalid_count = 32'd0;
reg [31:0] top_rx_mac_errors = 32'd0;
wire [31:0] top_raw;
wire [31:0] top_partner;
wire [31:0] top_flags;
wire [511:0] top_report;
reg [2:0] clockdomainsrenamer0_state = 3'd0;
reg [2:0] clockdomainsrenamer0_next_state;
reg top_pcstx_count0_clockdomainsrenamer0_next_value0;
reg top_pcstx_count0_clockdomainsrenamer0_next_value_ce0;
reg top_pcstx_ctype_clockdomainsrenamer0_next_value1;
reg top_pcstx_ctype_clockdomainsrenamer0_next_value_ce1;
reg [2:0] clockdomainsrenamer1_state = 3'd0;
reg [2:0] clockdomainsrenamer1_next_state;
reg top_pcsrx_count0_clockdomainsrenamer1_next_value0;
reg top_pcsrx_count0_clockdomainsrenamer1_next_value_ce0;
reg [7:0] clockdomainsrenamer1_next_value0;
reg clockdomainsrenamer1_next_value_ce0;
reg [7:0] clockdomainsrenamer1_next_value1;
reg clockdomainsrenamer1_next_value_ce1;
reg [2:0] clockdomainsrenamer2_state = 3'd0;
reg [2:0] clockdomainsrenamer2_next_state;
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
reg txdatapath_liteethmacpaddinginserter_state = 1'd0;
reg txdatapath_liteethmacpaddinginserter_next_state;
reg [15:0] top_tx_padding_counter_clockdomainsrenamer0_next_value2;
reg top_tx_padding_counter_clockdomainsrenamer0_next_value_ce2;
reg [1:0] txdatapath_bufferizeendpoints_state = 2'd0;
reg [1:0] txdatapath_bufferizeendpoints_next_state;
reg [31:0] top_tx_crc_crc_packet_clockdomainsrenamer1_next_value1;
reg top_tx_crc_crc_packet_clockdomainsrenamer1_next_value_ce1;
reg top_tx_crc_be0_clockdomainsrenamer1_next_value2;
reg top_tx_crc_be0_clockdomainsrenamer1_next_value_ce2;
reg [1:0] txdatapath_liteethmacpreambleinserter_state = 2'd0;
reg [1:0] txdatapath_liteethmacpreambleinserter_next_state;
reg [2:0] top_tx_preamble_count_clockdomainsrenamer2_next_value;
reg top_tx_preamble_count_clockdomainsrenamer2_next_value_ce;
reg txdatapath_liteethmacgap_state = 1'd0;
reg txdatapath_liteethmacgap_next_state;
reg [3:0] top_tx_gap_counter_clockdomainsrenamer3_next_value;
reg top_tx_gap_counter_clockdomainsrenamer3_next_value_ce;
reg rxdatapath_liteethmacpreamblechecker_state = 1'd0;
reg rxdatapath_liteethmacpreamblechecker_next_state;
reg [1:0] rxdatapath_bufferizeendpoints_state = 2'd0;
reg [1:0] rxdatapath_bufferizeendpoints_next_state;
reg top_liteethmaccrc32checker_be_next_value0;
reg top_liteethmaccrc32checker_be_next_value_ce0;
reg top_liteethmaccrc32checker_last_error_next_value1;
reg top_liteethmaccrc32checker_last_error_next_value_ce1;
wire [39:0] slice_proxy;
reg [7:0] self;
reg [2:0] t_rhs_self;
reg [2:0] f_t_self;
reg [2:0] f_f_self;
reg [5:0] f_rhs_self0;
reg f_rhs_self1;
reg f_rhs_self2;
reg [3:0] rhs_self0;
reg rhs_self1;
reg f_rhs_self3;
reg [7:0] basiclowerer_self;
reg [7:0] t_basiclowerer_self;
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
wire xilinxasyncresetsynchronizerimpl0_async_reset;
wire xilinxasyncresetsynchronizerimpl0_rst_meta;
wire xilinxasyncresetsynchronizerimpl1_async_reset;
wire xilinxasyncresetsynchronizerimpl1_rst_meta;
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
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl220 = 16'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [15:0] xilinxmultiregimpl221 = 16'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [31:0] xilinxmultiregimpl230 = 32'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg [31:0] xilinxmultiregimpl231 = 32'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl240 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl241 = 1'd0;
(* async_reg = "true", mr_ff = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl250 = 1'd0;
(* async_reg = "true", no_retiming = "true", no_shreg_extract = "true" *) reg xilinxmultiregimpl251 = 1'd0;
wire i;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign top_pma_k7_gtx_basex_reset = top_cmd[8];
assign top_sink_valid = (((top_gap == 1'd0) & (~top_cmd[4])) & (~top_cmd[8]));
assign top_sink_payload_data = (self ^ ((top_cmd[6] & (top_txi == 6'd59)) ? 1'd1 : 1'd0));
assign top_sink_last = (top_txi == 6'd59);
assign top_sink_payload_be = 1'd1;
assign top_sink_payload_error = 1'd0;
assign top_source_ready = 1'd1;
assign top_link = (top_fixed_mode ? top_fixed_up : top_link_up);
assign top_raw = {top_fixed_mode, top_fixed_up, top_linkdown, top_is_sgmii, top_pcsrx_decoder_invalid, top_pcsrx_decoder_k, top_pcsrx_decoder_d, top_pcsrx_decoder_input};
assign top_partner = {top_pcsrx_config_reg, top_lp_abi_o};
assign top_flags = {top_pma_k7_gtx_basex_rx_reset_done, top_pma_k7_gtx_basex_tx_reset_done, top_errsync, top_ref_lost, top_link, top_pma_k7_gtx_basex_rx_mmcm_locked1, top_pma_k7_gtx_basex_tx_mmcm_locked1, top_pma_k7_gtx_basex_gtxrxinit_done, top_pma_k7_gtx_basex_gtxtxinit_done, top_pma_k7_gtx_basex_pll_lock};
assign top_report = {top_rx_mac_errors, top_invalid_count, top_cfg_count, top_ci_count, top_partner, top_raw, top_rxbytes, top_prbscount, top_badcount, top_rxcount, top_txcount, top_refsync, 16'd0, top_cmd, top_flags, top_tick, 32'd1347282689};
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
assign top_is_sgmii = top_lp_abi_o[0];
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
	top_pcsrx_count0_clockdomainsrenamer1_next_value0 <= 1'd0;
	top_pcsrx_count0_clockdomainsrenamer1_next_value_ce0 <= 1'd0;
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
					top_pcsrx_count0_clockdomainsrenamer1_next_value0 <= (top_pcsrx_count0 + 1'd1);
					top_pcsrx_count0_clockdomainsrenamer1_next_value_ce0 <= 1'd1;
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
						top_pcsrx_count0_clockdomainsrenamer1_next_value0 <= 1'd0;
						top_pcsrx_count0_clockdomainsrenamer1_next_value_ce0 <= 1'd1;
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

// synthesis translate_off
reg dummy_d_8;
// synthesis translate_on
always @(*) begin
	top_pcstx_config_valid <= 1'd0;
	top_link_up <= 1'd0;
	top_restart <= 1'd0;
	top_align <= 1'd0;
	top_config_empty <= 1'd0;
	top_autoneg_ack <= 1'd0;
	top_waittimer0_wait <= 1'd0;
	top_waittimer1_wait <= 1'd0;
	top_waittimer2_wait <= 1'd0;
	clockdomainsrenamer2_next_state <= 3'd0;
	clockdomainsrenamer2_next_state <= clockdomainsrenamer2_state;
	case (clockdomainsrenamer2_state)
		1'd1: begin
			top_align <= 1'd1;
			top_pcstx_config_valid <= (1'd1 & (~top_fixed_mode));
			if (top_rx_config_reg_abi_o) begin
				clockdomainsrenamer2_next_state <= 2'd2;
			end
			if ((top_checker_tick & top_checker_error)) begin
				top_restart <= (1'd1 & (~top_fixed_mode));
				clockdomainsrenamer2_next_state <= 1'd0;
			end
		end
		2'd2: begin
			top_pcstx_config_valid <= (1'd1 & (~top_fixed_mode));
			top_autoneg_ack <= 1'd1;
			if (top_rx_config_reg_ack_o) begin
				clockdomainsrenamer2_next_state <= 2'd3;
			end
			if ((top_checker_tick & top_checker_error)) begin
				top_restart <= (1'd1 & (~top_fixed_mode));
				clockdomainsrenamer2_next_state <= 1'd0;
			end
		end
		2'd3: begin
			top_pcstx_config_valid <= (1'd1 & (~top_fixed_mode));
			top_autoneg_ack <= 1'd1;
			top_waittimer1_wait <= (~top_is_sgmii);
			top_waittimer2_wait <= top_is_sgmii;
			if (((top_is_sgmii & top_waittimer2_done) | ((~top_is_sgmii) & top_waittimer1_done))) begin
				clockdomainsrenamer2_next_state <= 3'd4;
			end
			if ((top_checker_tick & top_checker_error)) begin
				top_restart <= (1'd1 & (~top_fixed_mode));
				clockdomainsrenamer2_next_state <= 1'd0;
			end
		end
		3'd4: begin
			top_link_up <= (~top_linkdown);
			if (((top_checker_tick & top_checker_error) | top_linkdown)) begin
				top_restart <= (1'd1 & (~top_fixed_mode));
				clockdomainsrenamer2_next_state <= 1'd0;
			end
		end
		default: begin
			top_pcstx_config_valid <= (1'd1 & (~top_fixed_mode));
			top_config_empty <= 1'd1;
			top_waittimer0_wait <= 1'd1;
			if (top_waittimer0_done) begin
				clockdomainsrenamer2_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_8 <= dummy_s;
// synthesis translate_on
end
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
reg dummy_d_9;
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
	dummy_d_9 <= dummy_s;
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
reg dummy_d_10;
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
	dummy_d_10 <= dummy_s;
// synthesis translate_on
end
assign top_pma_k7_gtx_basex_gtxrxinit_init_delay_done = (top_pma_k7_gtx_basex_gtxrxinit_init_delay_count == 1'd0);
assign top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_done = (top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_count == 1'd0);
assign top_pma_k7_gtx_basex_gtxrxinit_watchdog_done = (top_pma_k7_gtx_basex_gtxrxinit_watchdog_count == 1'd0);
assign top_pma_k7_gtx_basex_o = (top_pma_k7_gtx_basex_toggle_o ^ top_pma_k7_gtx_basex_toggle_o_r);
assign top_tx_padding_counter_done = (top_tx_padding_counter >= 6'd59);

// synthesis translate_off
reg dummy_d_11;
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
	top_tx_padding_counter_clockdomainsrenamer0_next_value2 <= 16'd0;
	top_tx_padding_counter_clockdomainsrenamer0_next_value_ce2 <= 1'd0;
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
				top_tx_padding_counter_clockdomainsrenamer0_next_value2 <= (top_tx_padding_counter + 1'd1);
				top_tx_padding_counter_clockdomainsrenamer0_next_value_ce2 <= 1'd1;
				if (top_tx_padding_counter_done) begin
					top_tx_padding_counter_clockdomainsrenamer0_next_value2 <= 1'd0;
					top_tx_padding_counter_clockdomainsrenamer0_next_value_ce2 <= 1'd1;
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
				top_tx_padding_counter_clockdomainsrenamer0_next_value2 <= (top_tx_padding_counter + 1'd1);
				top_tx_padding_counter_clockdomainsrenamer0_next_value_ce2 <= 1'd1;
				if (top_tx_padding_sink_last) begin
					if ((~top_tx_padding_counter_done)) begin
						txdatapath_liteethmacpaddinginserter_next_state <= 1'd1;
					end else begin
						top_tx_padding_counter_clockdomainsrenamer0_next_value2 <= 1'd0;
						top_tx_padding_counter_clockdomainsrenamer0_next_value_ce2 <= 1'd1;
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_11 <= dummy_s;
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
reg dummy_d_12;
// synthesis translate_on
always @(*) begin
	top_tx_crc_value <= 32'd0;
	top_tx_crc_error <= 1'd0;
	if (top_tx_crc_be1) begin
		top_tx_crc_value <= ({top_tx_crc_crc_next[0], top_tx_crc_crc_next[1], top_tx_crc_crc_next[2], top_tx_crc_crc_next[3], top_tx_crc_crc_next[4], top_tx_crc_crc_next[5], top_tx_crc_crc_next[6], top_tx_crc_crc_next[7], top_tx_crc_crc_next[8], top_tx_crc_crc_next[9], top_tx_crc_crc_next[10], top_tx_crc_crc_next[11], top_tx_crc_crc_next[12], top_tx_crc_crc_next[13], top_tx_crc_crc_next[14], top_tx_crc_crc_next[15], top_tx_crc_crc_next[16], top_tx_crc_crc_next[17], top_tx_crc_crc_next[18], top_tx_crc_crc_next[19], top_tx_crc_crc_next[20], top_tx_crc_crc_next[21], top_tx_crc_crc_next[22], top_tx_crc_crc_next[23], top_tx_crc_crc_next[24], top_tx_crc_crc_next[25], top_tx_crc_crc_next[26], top_tx_crc_crc_next[27], top_tx_crc_crc_next[28], top_tx_crc_crc_next[29], top_tx_crc_crc_next[30], top_tx_crc_crc_next[31]} ^ 32'd4294967295);
		top_tx_crc_error <= (top_tx_crc_crc_next != 32'd3338984827);
	end
// synthesis translate_off
	dummy_d_12 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_13;
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
	dummy_d_13 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_14;
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
	top_tx_crc_crc_packet_clockdomainsrenamer1_next_value1 <= 32'd0;
	top_tx_crc_crc_packet_clockdomainsrenamer1_next_value_ce1 <= 1'd0;
	top_tx_crc_be0_clockdomainsrenamer1_next_value2 <= 1'd0;
	top_tx_crc_be0_clockdomainsrenamer1_next_value_ce2 <= 1'd0;
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
					top_tx_crc_crc_packet_clockdomainsrenamer1_next_value1 <= top_tx_crc_value;
					top_tx_crc_crc_packet_clockdomainsrenamer1_next_value_ce1 <= 1'd1;
					if (1'd0) begin
						top_tx_crc_be0_clockdomainsrenamer1_next_value2 <= (top_tx_crc_sink_payload_be >>> 3'd4);
						top_tx_crc_be0_clockdomainsrenamer1_next_value_ce2 <= 1'd1;
					end else begin
						top_tx_crc_be0_clockdomainsrenamer1_next_value2 <= top_tx_crc_sink_payload_be;
						top_tx_crc_be0_clockdomainsrenamer1_next_value_ce2 <= 1'd1;
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
	dummy_d_14 <= dummy_s;
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
reg dummy_d_15;
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
	top_tx_preamble_count_clockdomainsrenamer2_next_value <= 3'd0;
	top_tx_preamble_count_clockdomainsrenamer2_next_value_ce <= 1'd0;
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
					top_tx_preamble_count_clockdomainsrenamer2_next_value <= (top_tx_preamble_count + 1'd1);
					top_tx_preamble_count_clockdomainsrenamer2_next_value_ce <= 1'd1;
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
			top_tx_preamble_count_clockdomainsrenamer2_next_value <= 1'd0;
			top_tx_preamble_count_clockdomainsrenamer2_next_value_ce <= 1'd1;
			if (top_tx_preamble_sink_valid) begin
				top_tx_preamble_sink_ready <= 1'd0;
				txdatapath_liteethmacpreambleinserter_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_15 <= dummy_s;
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
reg dummy_d_16;
// synthesis translate_on
always @(*) begin
	top_txdatapath_cdc_graycounter0_q_next_binary <= 6'd0;
	if (top_txdatapath_cdc_graycounter0_ce) begin
		top_txdatapath_cdc_graycounter0_q_next_binary <= (top_txdatapath_cdc_graycounter0_q_binary + 1'd1);
	end else begin
		top_txdatapath_cdc_graycounter0_q_next_binary <= top_txdatapath_cdc_graycounter0_q_binary;
	end
// synthesis translate_off
	dummy_d_16 <= dummy_s;
// synthesis translate_on
end
assign top_txdatapath_cdc_graycounter0_q_next = (top_txdatapath_cdc_graycounter0_q_next_binary ^ top_txdatapath_cdc_graycounter0_q_next_binary[5:1]);

// synthesis translate_off
reg dummy_d_17;
// synthesis translate_on
always @(*) begin
	top_txdatapath_cdc_graycounter1_q_next_binary <= 6'd0;
	if (top_txdatapath_cdc_graycounter1_ce) begin
		top_txdatapath_cdc_graycounter1_q_next_binary <= (top_txdatapath_cdc_graycounter1_q_binary + 1'd1);
	end else begin
		top_txdatapath_cdc_graycounter1_q_next_binary <= top_txdatapath_cdc_graycounter1_q_binary;
	end
// synthesis translate_off
	dummy_d_17 <= dummy_s;
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
reg dummy_d_18;
// synthesis translate_on
always @(*) begin
	top_tx_packet_fifo_source_source_first <= 1'd0;
	top_tx_packet_fifo_source_source_first <= top_tx_packet_fifo_param_fifo_source_first;
	top_tx_packet_fifo_source_source_first <= top_tx_packet_fifo_payload_fifo_source_first;
// synthesis translate_off
	dummy_d_18 <= dummy_s;
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
reg dummy_d_19;
// synthesis translate_on
always @(*) begin
	top_tx_packet_fifo_payload_fifo_wrport_adr <= 11'd0;
	if (top_tx_packet_fifo_payload_fifo_replace) begin
		top_tx_packet_fifo_payload_fifo_wrport_adr <= (top_tx_packet_fifo_payload_fifo_produce - 1'd1);
	end else begin
		top_tx_packet_fifo_payload_fifo_wrport_adr <= top_tx_packet_fifo_payload_fifo_produce;
	end
// synthesis translate_off
	dummy_d_19 <= dummy_s;
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
reg dummy_d_20;
// synthesis translate_on
always @(*) begin
	top_tx_packet_fifo_param_fifo_wrport_adr <= 3'd0;
	if (top_tx_packet_fifo_param_fifo_replace) begin
		top_tx_packet_fifo_param_fifo_wrport_adr <= (top_tx_packet_fifo_param_fifo_produce - 1'd1);
	end else begin
		top_tx_packet_fifo_param_fifo_wrport_adr <= top_tx_packet_fifo_param_fifo_produce;
	end
// synthesis translate_off
	dummy_d_20 <= dummy_s;
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
reg dummy_d_21;
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
	top_tx_gap_counter_clockdomainsrenamer3_next_value <= 4'd0;
	top_tx_gap_counter_clockdomainsrenamer3_next_value_ce <= 1'd0;
	txdatapath_liteethmacgap_next_state <= txdatapath_liteethmacgap_state;
	case (txdatapath_liteethmacgap_state)
		1'd1: begin
			top_tx_gap_counter_clockdomainsrenamer3_next_value <= (top_tx_gap_counter - 1'd1);
			top_tx_gap_counter_clockdomainsrenamer3_next_value_ce <= 1'd1;
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
				top_tx_gap_counter_clockdomainsrenamer3_next_value <= 4'd12;
				top_tx_gap_counter_clockdomainsrenamer3_next_value_ce <= 1'd1;
				txdatapath_liteethmacgap_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_21 <= dummy_s;
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
reg dummy_d_22;
// synthesis translate_on
always @(*) begin
	top_rx_packet_fifo_param_fifo_wrport_adr <= 2'd0;
	if (top_rx_packet_fifo_param_fifo_replace) begin
		top_rx_packet_fifo_param_fifo_wrport_adr <= (top_rx_packet_fifo_param_fifo_produce - 1'd1);
	end else begin
		top_rx_packet_fifo_param_fifo_wrport_adr <= top_rx_packet_fifo_param_fifo_produce;
	end
// synthesis translate_off
	dummy_d_22 <= dummy_s;
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
reg dummy_d_23;
// synthesis translate_on
always @(*) begin
	top_rx_cdc_cdc_graycounter0_q_next_binary <= 6'd0;
	if (top_rx_cdc_cdc_graycounter0_ce) begin
		top_rx_cdc_cdc_graycounter0_q_next_binary <= (top_rx_cdc_cdc_graycounter0_q_binary + 1'd1);
	end else begin
		top_rx_cdc_cdc_graycounter0_q_next_binary <= top_rx_cdc_cdc_graycounter0_q_binary;
	end
// synthesis translate_off
	dummy_d_23 <= dummy_s;
// synthesis translate_on
end
assign top_rx_cdc_cdc_graycounter0_q_next = (top_rx_cdc_cdc_graycounter0_q_next_binary ^ top_rx_cdc_cdc_graycounter0_q_next_binary[5:1]);

// synthesis translate_off
reg dummy_d_24;
// synthesis translate_on
always @(*) begin
	top_rx_cdc_cdc_graycounter1_q_next_binary <= 6'd0;
	if (top_rx_cdc_cdc_graycounter1_ce) begin
		top_rx_cdc_cdc_graycounter1_q_next_binary <= (top_rx_cdc_cdc_graycounter1_q_binary + 1'd1);
	end else begin
		top_rx_cdc_cdc_graycounter1_q_next_binary <= top_rx_cdc_cdc_graycounter1_q_binary;
	end
// synthesis translate_off
	dummy_d_24 <= dummy_s;
// synthesis translate_on
end
assign top_rx_cdc_cdc_graycounter1_q_next = (top_rx_cdc_cdc_graycounter1_q_next_binary ^ top_rx_cdc_cdc_graycounter1_q_next_binary[5:1]);
assign top_rx_preamble_source_payload_data = top_rx_preamble_sink_payload_data;
assign top_rx_preamble_source_payload_be = top_rx_preamble_sink_payload_be;

// synthesis translate_off
reg dummy_d_25;
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
	dummy_d_25 <= dummy_s;
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
reg dummy_d_26;
// synthesis translate_on
always @(*) begin
	top_liteethmaccrc32checker_syncfifo_sink_valid <= 1'd0;
	top_liteethmaccrc32checker_syncfifo_sink_valid <= top_liteethmaccrc32checker_sink_sink_valid;
	top_liteethmaccrc32checker_syncfifo_sink_valid <= top_liteethmaccrc32checker_fifo_in;
// synthesis translate_off
	dummy_d_26 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_27;
// synthesis translate_on
always @(*) begin
	top_liteethmaccrc32checker_sink_sink_ready <= 1'd0;
	top_liteethmaccrc32checker_sink_sink_ready <= top_liteethmaccrc32checker_syncfifo_sink_ready;
	top_liteethmaccrc32checker_sink_sink_ready <= top_liteethmaccrc32checker_fifo_in;
// synthesis translate_off
	dummy_d_27 <= dummy_s;
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
reg dummy_d_28;
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
	dummy_d_28 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_29;
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
	dummy_d_29 <= dummy_s;
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
reg dummy_d_30;
// synthesis translate_on
always @(*) begin
	top_liteethmaccrc32checker_syncfifo_wrport_adr <= 3'd0;
	if (top_liteethmaccrc32checker_syncfifo_replace) begin
		top_liteethmaccrc32checker_syncfifo_wrport_adr <= (top_liteethmaccrc32checker_syncfifo_produce - 1'd1);
	end else begin
		top_liteethmaccrc32checker_syncfifo_wrport_adr <= top_liteethmaccrc32checker_syncfifo_produce;
	end
// synthesis translate_off
	dummy_d_30 <= dummy_s;
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
reg dummy_d_31;
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
	top_liteethmaccrc32checker_be_next_value0 <= 1'd0;
	top_liteethmaccrc32checker_be_next_value_ce0 <= 1'd0;
	top_liteethmaccrc32checker_last_error_next_value1 <= 1'd0;
	top_liteethmaccrc32checker_last_error_next_value_ce1 <= 1'd0;
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
					top_liteethmaccrc32checker_be_next_value0 <= (top_liteethmaccrc32checker_sink_sink_payload_be >>> 3'd4);
					top_liteethmaccrc32checker_be_next_value_ce0 <= 1'd1;
					top_liteethmaccrc32checker_last_error_next_value1 <= top_liteethmaccrc32checker_last_word_error;
					top_liteethmaccrc32checker_last_error_next_value_ce1 <= 1'd1;
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
	dummy_d_31 <= dummy_s;
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
reg dummy_d_32;
// synthesis translate_on
always @(*) begin
	top_rx_padding_source_payload_error <= 1'd0;
	if (((top_rx_padding_sink_valid & top_rx_padding_sink_last) & ((top_rx_padding_length + top_rx_padding_length_inc) < 6'd60))) begin
		top_rx_padding_source_payload_error <= {1{1'd1}};
	end else begin
		top_rx_padding_source_payload_error <= top_rx_padding_sink_payload_error;
	end
// synthesis translate_off
	dummy_d_32 <= dummy_s;
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
assign slice_proxy = {top_tx_crc_value, top_tx_crc_sink_payload_data[7:0]};

// synthesis translate_off
reg dummy_d_33;
// synthesis translate_on
always @(*) begin
	self <= 8'd0;
	case (top_txi)
		1'd0: begin
			self <= 8'd108;
		end
		1'd1: begin
			self <= 8'd43;
		end
		2'd2: begin
			self <= 8'd89;
		end
		2'd3: begin
			self <= 8'd244;
		end
		3'd4: begin
			self <= 8'd118;
		end
		3'd5: begin
			self <= 8'd232;
		end
		3'd6: begin
			self <= 8'd2;
		end
		3'd7: begin
			self <= 8'd0;
		end
		4'd8: begin
			self <= 8'd0;
		end
		4'd9: begin
			self <= 8'd0;
		end
		4'd10: begin
			self <= 8'd0;
		end
		4'd11: begin
			self <= 8'd2;
		end
		4'd12: begin
			self <= 8'd8;
		end
		4'd13: begin
			self <= 8'd0;
		end
		4'd14: begin
			self <= 8'd69;
		end
		4'd15: begin
			self <= 8'd0;
		end
		5'd16: begin
			self <= 8'd0;
		end
		5'd17: begin
			self <= 8'd46;
		end
		5'd18: begin
			self <= 8'd80;
		end
		5'd19: begin
			self <= 8'd77;
		end
		5'd20: begin
			self <= 8'd64;
		end
		5'd21: begin
			self <= 8'd0;
		end
		5'd22: begin
			self <= 8'd64;
		end
		5'd23: begin
			self <= 8'd17;
		end
		5'd24: begin
			self <= 8'd97;
		end
		5'd25: begin
			self <= 8'd64;
		end
		5'd26: begin
			self <= 8'd198;
		end
		5'd27: begin
			self <= 8'd18;
		end
		5'd28: begin
			self <= 8'd0;
		end
		5'd29: begin
			self <= 8'd12;
		end
		5'd30: begin
			self <= 8'd192;
		end
		5'd31: begin
			self <= 8'd168;
		end
		6'd32: begin
			self <= 8'd2;
		end
		6'd33: begin
			self <= 8'd107;
		end
		6'd34: begin
			self <= 8'd192;
		end
		6'd35: begin
			self <= 8'd2;
		end
		6'd36: begin
			self <= 8'd192;
		end
		6'd37: begin
			self <= 8'd3;
		end
		6'd38: begin
			self <= 8'd0;
		end
		6'd39: begin
			self <= 8'd26;
		end
		6'd40: begin
			self <= 8'd200;
		end
		6'd41: begin
			self <= 8'd240;
		end
		6'd42: begin
			self <= 8'd80;
		end
		6'd43: begin
			self <= 8'd77;
		end
		6'd44: begin
			self <= 8'd49;
		end
		6'd45: begin
			self <= 8'd50;
		end
		6'd46: begin
			self <= 8'd45;
		end
		6'd47: begin
			self <= 8'd83;
		end
		6'd48: begin
			self <= 8'd70;
		end
		6'd49: begin
			self <= 8'd80;
		end
		6'd50: begin
			self <= 8'd45;
		end
		6'd51: begin
			self <= 8'd85;
		end
		6'd52: begin
			self <= 8'd68;
		end
		6'd53: begin
			self <= 8'd80;
		end
		6'd54: begin
			self <= 8'd45;
		end
		6'd55: begin
			self <= 8'd84;
		end
		6'd56: begin
			self <= 8'd69;
		end
		6'd57: begin
			self <= 8'd83;
		end
		6'd58: begin
			self <= 8'd84;
		end
		default: begin
			self <= 8'd33;
		end
	endcase
// synthesis translate_off
	dummy_d_33 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_34;
// synthesis translate_on
always @(*) begin
	t_rhs_self <= 3'd0;
	case (top_pcsrx_decoder_input_msb_first[3:0])
		1'd0: begin
			t_rhs_self <= 1'd0;
		end
		1'd1: begin
			t_rhs_self <= 1'd0;
		end
		2'd2: begin
			t_rhs_self <= 3'd4;
		end
		2'd3: begin
			t_rhs_self <= 2'd3;
		end
		3'd4: begin
			t_rhs_self <= 1'd0;
		end
		3'd5: begin
			t_rhs_self <= 2'd2;
		end
		3'd6: begin
			t_rhs_self <= 3'd6;
		end
		3'd7: begin
			t_rhs_self <= 1'd0;
		end
		4'd8: begin
			t_rhs_self <= 3'd7;
		end
		4'd9: begin
			t_rhs_self <= 1'd1;
		end
		4'd10: begin
			t_rhs_self <= 3'd5;
		end
		4'd11: begin
			t_rhs_self <= 1'd0;
		end
		4'd12: begin
			t_rhs_self <= 1'd0;
		end
		4'd13: begin
			t_rhs_self <= 1'd0;
		end
		4'd14: begin
			t_rhs_self <= 1'd0;
		end
		default: begin
			t_rhs_self <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_34 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_35;
// synthesis translate_on
always @(*) begin
	f_t_self <= 3'd0;
	case (top_pcsrx_decoder_input_msb_first[3:0])
		1'd0: begin
			f_t_self <= 1'd0;
		end
		1'd1: begin
			f_t_self <= 1'd0;
		end
		2'd2: begin
			f_t_self <= 1'd0;
		end
		2'd3: begin
			f_t_self <= 1'd0;
		end
		3'd4: begin
			f_t_self <= 1'd0;
		end
		3'd5: begin
			f_t_self <= 3'd5;
		end
		3'd6: begin
			f_t_self <= 1'd1;
		end
		3'd7: begin
			f_t_self <= 3'd7;
		end
		4'd8: begin
			f_t_self <= 1'd0;
		end
		4'd9: begin
			f_t_self <= 3'd6;
		end
		4'd10: begin
			f_t_self <= 2'd2;
		end
		4'd11: begin
			f_t_self <= 1'd0;
		end
		4'd12: begin
			f_t_self <= 2'd3;
		end
		4'd13: begin
			f_t_self <= 3'd4;
		end
		4'd14: begin
			f_t_self <= 1'd0;
		end
		default: begin
			f_t_self <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_35 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_36;
// synthesis translate_on
always @(*) begin
	f_f_self <= 3'd0;
	case (top_pcsrx_decoder_input_msb_first[3:0])
		1'd0: begin
			f_f_self <= 1'd0;
		end
		1'd1: begin
			f_f_self <= 3'd7;
		end
		2'd2: begin
			f_f_self <= 3'd4;
		end
		2'd3: begin
			f_f_self <= 2'd3;
		end
		3'd4: begin
			f_f_self <= 1'd0;
		end
		3'd5: begin
			f_f_self <= 2'd2;
		end
		3'd6: begin
			f_f_self <= 3'd6;
		end
		3'd7: begin
			f_f_self <= 3'd7;
		end
		4'd8: begin
			f_f_self <= 3'd7;
		end
		4'd9: begin
			f_f_self <= 1'd1;
		end
		4'd10: begin
			f_f_self <= 3'd5;
		end
		4'd11: begin
			f_f_self <= 1'd0;
		end
		4'd12: begin
			f_f_self <= 2'd3;
		end
		4'd13: begin
			f_f_self <= 3'd4;
		end
		4'd14: begin
			f_f_self <= 3'd7;
		end
		default: begin
			f_f_self <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_36 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_37;
// synthesis translate_on
always @(*) begin
	f_rhs_self0 <= 6'd0;
	case (top_pcstx_encoder_d[4:0])
		1'd0: begin
			f_rhs_self0 <= 5'd24;
		end
		1'd1: begin
			f_rhs_self0 <= 6'd34;
		end
		2'd2: begin
			f_rhs_self0 <= 5'd18;
		end
		2'd3: begin
			f_rhs_self0 <= 6'd49;
		end
		3'd4: begin
			f_rhs_self0 <= 4'd10;
		end
		3'd5: begin
			f_rhs_self0 <= 6'd41;
		end
		3'd6: begin
			f_rhs_self0 <= 5'd25;
		end
		3'd7: begin
			f_rhs_self0 <= 3'd7;
		end
		4'd8: begin
			f_rhs_self0 <= 3'd6;
		end
		4'd9: begin
			f_rhs_self0 <= 6'd37;
		end
		4'd10: begin
			f_rhs_self0 <= 5'd21;
		end
		4'd11: begin
			f_rhs_self0 <= 6'd52;
		end
		4'd12: begin
			f_rhs_self0 <= 4'd13;
		end
		4'd13: begin
			f_rhs_self0 <= 6'd44;
		end
		4'd14: begin
			f_rhs_self0 <= 5'd28;
		end
		4'd15: begin
			f_rhs_self0 <= 6'd40;
		end
		5'd16: begin
			f_rhs_self0 <= 6'd36;
		end
		5'd17: begin
			f_rhs_self0 <= 6'd35;
		end
		5'd18: begin
			f_rhs_self0 <= 5'd19;
		end
		5'd19: begin
			f_rhs_self0 <= 6'd50;
		end
		5'd20: begin
			f_rhs_self0 <= 4'd11;
		end
		5'd21: begin
			f_rhs_self0 <= 6'd42;
		end
		5'd22: begin
			f_rhs_self0 <= 5'd26;
		end
		5'd23: begin
			f_rhs_self0 <= 3'd5;
		end
		5'd24: begin
			f_rhs_self0 <= 4'd12;
		end
		5'd25: begin
			f_rhs_self0 <= 6'd38;
		end
		5'd26: begin
			f_rhs_self0 <= 5'd22;
		end
		5'd27: begin
			f_rhs_self0 <= 4'd9;
		end
		5'd28: begin
			f_rhs_self0 <= 4'd14;
		end
		5'd29: begin
			f_rhs_self0 <= 5'd17;
		end
		5'd30: begin
			f_rhs_self0 <= 6'd33;
		end
		default: begin
			f_rhs_self0 <= 5'd20;
		end
	endcase
// synthesis translate_off
	dummy_d_37 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_38;
// synthesis translate_on
always @(*) begin
	f_rhs_self1 <= 1'd0;
	case (top_pcstx_encoder_d[4:0])
		1'd0: begin
			f_rhs_self1 <= 1'd1;
		end
		1'd1: begin
			f_rhs_self1 <= 1'd1;
		end
		2'd2: begin
			f_rhs_self1 <= 1'd1;
		end
		2'd3: begin
			f_rhs_self1 <= 1'd0;
		end
		3'd4: begin
			f_rhs_self1 <= 1'd1;
		end
		3'd5: begin
			f_rhs_self1 <= 1'd0;
		end
		3'd6: begin
			f_rhs_self1 <= 1'd0;
		end
		3'd7: begin
			f_rhs_self1 <= 1'd0;
		end
		4'd8: begin
			f_rhs_self1 <= 1'd1;
		end
		4'd9: begin
			f_rhs_self1 <= 1'd0;
		end
		4'd10: begin
			f_rhs_self1 <= 1'd0;
		end
		4'd11: begin
			f_rhs_self1 <= 1'd0;
		end
		4'd12: begin
			f_rhs_self1 <= 1'd0;
		end
		4'd13: begin
			f_rhs_self1 <= 1'd0;
		end
		4'd14: begin
			f_rhs_self1 <= 1'd0;
		end
		4'd15: begin
			f_rhs_self1 <= 1'd1;
		end
		5'd16: begin
			f_rhs_self1 <= 1'd1;
		end
		5'd17: begin
			f_rhs_self1 <= 1'd0;
		end
		5'd18: begin
			f_rhs_self1 <= 1'd0;
		end
		5'd19: begin
			f_rhs_self1 <= 1'd0;
		end
		5'd20: begin
			f_rhs_self1 <= 1'd0;
		end
		5'd21: begin
			f_rhs_self1 <= 1'd0;
		end
		5'd22: begin
			f_rhs_self1 <= 1'd0;
		end
		5'd23: begin
			f_rhs_self1 <= 1'd1;
		end
		5'd24: begin
			f_rhs_self1 <= 1'd1;
		end
		5'd25: begin
			f_rhs_self1 <= 1'd0;
		end
		5'd26: begin
			f_rhs_self1 <= 1'd0;
		end
		5'd27: begin
			f_rhs_self1 <= 1'd1;
		end
		5'd28: begin
			f_rhs_self1 <= 1'd0;
		end
		5'd29: begin
			f_rhs_self1 <= 1'd1;
		end
		5'd30: begin
			f_rhs_self1 <= 1'd1;
		end
		default: begin
			f_rhs_self1 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_38 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_39;
// synthesis translate_on
always @(*) begin
	f_rhs_self2 <= 1'd0;
	case (top_pcstx_encoder_d[4:0])
		1'd0: begin
			f_rhs_self2 <= 1'd1;
		end
		1'd1: begin
			f_rhs_self2 <= 1'd1;
		end
		2'd2: begin
			f_rhs_self2 <= 1'd1;
		end
		2'd3: begin
			f_rhs_self2 <= 1'd0;
		end
		3'd4: begin
			f_rhs_self2 <= 1'd1;
		end
		3'd5: begin
			f_rhs_self2 <= 1'd0;
		end
		3'd6: begin
			f_rhs_self2 <= 1'd0;
		end
		3'd7: begin
			f_rhs_self2 <= 1'd1;
		end
		4'd8: begin
			f_rhs_self2 <= 1'd1;
		end
		4'd9: begin
			f_rhs_self2 <= 1'd0;
		end
		4'd10: begin
			f_rhs_self2 <= 1'd0;
		end
		4'd11: begin
			f_rhs_self2 <= 1'd0;
		end
		4'd12: begin
			f_rhs_self2 <= 1'd0;
		end
		4'd13: begin
			f_rhs_self2 <= 1'd0;
		end
		4'd14: begin
			f_rhs_self2 <= 1'd0;
		end
		4'd15: begin
			f_rhs_self2 <= 1'd1;
		end
		5'd16: begin
			f_rhs_self2 <= 1'd1;
		end
		5'd17: begin
			f_rhs_self2 <= 1'd0;
		end
		5'd18: begin
			f_rhs_self2 <= 1'd0;
		end
		5'd19: begin
			f_rhs_self2 <= 1'd0;
		end
		5'd20: begin
			f_rhs_self2 <= 1'd0;
		end
		5'd21: begin
			f_rhs_self2 <= 1'd0;
		end
		5'd22: begin
			f_rhs_self2 <= 1'd0;
		end
		5'd23: begin
			f_rhs_self2 <= 1'd1;
		end
		5'd24: begin
			f_rhs_self2 <= 1'd1;
		end
		5'd25: begin
			f_rhs_self2 <= 1'd0;
		end
		5'd26: begin
			f_rhs_self2 <= 1'd0;
		end
		5'd27: begin
			f_rhs_self2 <= 1'd1;
		end
		5'd28: begin
			f_rhs_self2 <= 1'd0;
		end
		5'd29: begin
			f_rhs_self2 <= 1'd1;
		end
		5'd30: begin
			f_rhs_self2 <= 1'd1;
		end
		default: begin
			f_rhs_self2 <= 1'd1;
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
	rhs_self0 <= 4'd0;
	case (top_pcstx_encoder_d[7:5])
		1'd0: begin
			rhs_self0 <= 3'd4;
		end
		1'd1: begin
			rhs_self0 <= 4'd9;
		end
		2'd2: begin
			rhs_self0 <= 3'd5;
		end
		2'd3: begin
			rhs_self0 <= 2'd3;
		end
		3'd4: begin
			rhs_self0 <= 2'd2;
		end
		3'd5: begin
			rhs_self0 <= 4'd10;
		end
		3'd6: begin
			rhs_self0 <= 3'd6;
		end
		default: begin
			rhs_self0 <= 1'd1;
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
	rhs_self1 <= 1'd0;
	case (top_pcstx_encoder_d[7:5])
		1'd0: begin
			rhs_self1 <= 1'd1;
		end
		1'd1: begin
			rhs_self1 <= 1'd0;
		end
		2'd2: begin
			rhs_self1 <= 1'd0;
		end
		2'd3: begin
			rhs_self1 <= 1'd0;
		end
		3'd4: begin
			rhs_self1 <= 1'd1;
		end
		3'd5: begin
			rhs_self1 <= 1'd0;
		end
		3'd6: begin
			rhs_self1 <= 1'd0;
		end
		default: begin
			rhs_self1 <= 1'd1;
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
	f_rhs_self3 <= 1'd0;
	case (top_pcstx_encoder_d[7:5])
		1'd0: begin
			f_rhs_self3 <= 1'd1;
		end
		1'd1: begin
			f_rhs_self3 <= 1'd0;
		end
		2'd2: begin
			f_rhs_self3 <= 1'd0;
		end
		2'd3: begin
			f_rhs_self3 <= 1'd1;
		end
		3'd4: begin
			f_rhs_self3 <= 1'd1;
		end
		3'd5: begin
			f_rhs_self3 <= 1'd0;
		end
		3'd6: begin
			f_rhs_self3 <= 1'd0;
		end
		default: begin
			f_rhs_self3 <= 1'd1;
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
	basiclowerer_self <= 8'd0;
	case (top_rxi)
		1'd0: begin
			basiclowerer_self <= 8'd108;
		end
		1'd1: begin
			basiclowerer_self <= 8'd43;
		end
		2'd2: begin
			basiclowerer_self <= 8'd89;
		end
		2'd3: begin
			basiclowerer_self <= 8'd244;
		end
		3'd4: begin
			basiclowerer_self <= 8'd118;
		end
		3'd5: begin
			basiclowerer_self <= 8'd232;
		end
		3'd6: begin
			basiclowerer_self <= 8'd2;
		end
		3'd7: begin
			basiclowerer_self <= 8'd0;
		end
		4'd8: begin
			basiclowerer_self <= 8'd0;
		end
		4'd9: begin
			basiclowerer_self <= 8'd0;
		end
		4'd10: begin
			basiclowerer_self <= 8'd0;
		end
		4'd11: begin
			basiclowerer_self <= 8'd2;
		end
		4'd12: begin
			basiclowerer_self <= 8'd8;
		end
		4'd13: begin
			basiclowerer_self <= 8'd0;
		end
		4'd14: begin
			basiclowerer_self <= 8'd69;
		end
		4'd15: begin
			basiclowerer_self <= 8'd0;
		end
		5'd16: begin
			basiclowerer_self <= 8'd0;
		end
		5'd17: begin
			basiclowerer_self <= 8'd46;
		end
		5'd18: begin
			basiclowerer_self <= 8'd80;
		end
		5'd19: begin
			basiclowerer_self <= 8'd77;
		end
		5'd20: begin
			basiclowerer_self <= 8'd64;
		end
		5'd21: begin
			basiclowerer_self <= 8'd0;
		end
		5'd22: begin
			basiclowerer_self <= 8'd64;
		end
		5'd23: begin
			basiclowerer_self <= 8'd17;
		end
		5'd24: begin
			basiclowerer_self <= 8'd97;
		end
		5'd25: begin
			basiclowerer_self <= 8'd64;
		end
		5'd26: begin
			basiclowerer_self <= 8'd198;
		end
		5'd27: begin
			basiclowerer_self <= 8'd18;
		end
		5'd28: begin
			basiclowerer_self <= 8'd0;
		end
		5'd29: begin
			basiclowerer_self <= 8'd12;
		end
		5'd30: begin
			basiclowerer_self <= 8'd192;
		end
		5'd31: begin
			basiclowerer_self <= 8'd168;
		end
		6'd32: begin
			basiclowerer_self <= 8'd2;
		end
		6'd33: begin
			basiclowerer_self <= 8'd107;
		end
		6'd34: begin
			basiclowerer_self <= 8'd192;
		end
		6'd35: begin
			basiclowerer_self <= 8'd2;
		end
		6'd36: begin
			basiclowerer_self <= 8'd192;
		end
		6'd37: begin
			basiclowerer_self <= 8'd3;
		end
		6'd38: begin
			basiclowerer_self <= 8'd0;
		end
		6'd39: begin
			basiclowerer_self <= 8'd26;
		end
		6'd40: begin
			basiclowerer_self <= 8'd200;
		end
		6'd41: begin
			basiclowerer_self <= 8'd240;
		end
		6'd42: begin
			basiclowerer_self <= 8'd80;
		end
		6'd43: begin
			basiclowerer_self <= 8'd77;
		end
		6'd44: begin
			basiclowerer_self <= 8'd49;
		end
		6'd45: begin
			basiclowerer_self <= 8'd50;
		end
		6'd46: begin
			basiclowerer_self <= 8'd45;
		end
		6'd47: begin
			basiclowerer_self <= 8'd83;
		end
		6'd48: begin
			basiclowerer_self <= 8'd70;
		end
		6'd49: begin
			basiclowerer_self <= 8'd80;
		end
		6'd50: begin
			basiclowerer_self <= 8'd45;
		end
		6'd51: begin
			basiclowerer_self <= 8'd85;
		end
		6'd52: begin
			basiclowerer_self <= 8'd68;
		end
		6'd53: begin
			basiclowerer_self <= 8'd80;
		end
		6'd54: begin
			basiclowerer_self <= 8'd45;
		end
		6'd55: begin
			basiclowerer_self <= 8'd84;
		end
		6'd56: begin
			basiclowerer_self <= 8'd69;
		end
		6'd57: begin
			basiclowerer_self <= 8'd83;
		end
		6'd58: begin
			basiclowerer_self <= 8'd84;
		end
		default: begin
			basiclowerer_self <= 8'd33;
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
	t_basiclowerer_self <= 8'd0;
	case (top_rxi)
		1'd0: begin
			t_basiclowerer_self <= 8'd108;
		end
		1'd1: begin
			t_basiclowerer_self <= 8'd43;
		end
		2'd2: begin
			t_basiclowerer_self <= 8'd89;
		end
		2'd3: begin
			t_basiclowerer_self <= 8'd244;
		end
		3'd4: begin
			t_basiclowerer_self <= 8'd118;
		end
		3'd5: begin
			t_basiclowerer_self <= 8'd232;
		end
		3'd6: begin
			t_basiclowerer_self <= 8'd2;
		end
		3'd7: begin
			t_basiclowerer_self <= 8'd0;
		end
		4'd8: begin
			t_basiclowerer_self <= 8'd0;
		end
		4'd9: begin
			t_basiclowerer_self <= 8'd0;
		end
		4'd10: begin
			t_basiclowerer_self <= 8'd0;
		end
		4'd11: begin
			t_basiclowerer_self <= 8'd2;
		end
		4'd12: begin
			t_basiclowerer_self <= 8'd8;
		end
		4'd13: begin
			t_basiclowerer_self <= 8'd0;
		end
		4'd14: begin
			t_basiclowerer_self <= 8'd69;
		end
		4'd15: begin
			t_basiclowerer_self <= 8'd0;
		end
		5'd16: begin
			t_basiclowerer_self <= 8'd0;
		end
		5'd17: begin
			t_basiclowerer_self <= 8'd46;
		end
		5'd18: begin
			t_basiclowerer_self <= 8'd80;
		end
		5'd19: begin
			t_basiclowerer_self <= 8'd77;
		end
		5'd20: begin
			t_basiclowerer_self <= 8'd64;
		end
		5'd21: begin
			t_basiclowerer_self <= 8'd0;
		end
		5'd22: begin
			t_basiclowerer_self <= 8'd64;
		end
		5'd23: begin
			t_basiclowerer_self <= 8'd17;
		end
		5'd24: begin
			t_basiclowerer_self <= 8'd97;
		end
		5'd25: begin
			t_basiclowerer_self <= 8'd64;
		end
		5'd26: begin
			t_basiclowerer_self <= 8'd198;
		end
		5'd27: begin
			t_basiclowerer_self <= 8'd18;
		end
		5'd28: begin
			t_basiclowerer_self <= 8'd0;
		end
		5'd29: begin
			t_basiclowerer_self <= 8'd12;
		end
		5'd30: begin
			t_basiclowerer_self <= 8'd192;
		end
		5'd31: begin
			t_basiclowerer_self <= 8'd168;
		end
		6'd32: begin
			t_basiclowerer_self <= 8'd2;
		end
		6'd33: begin
			t_basiclowerer_self <= 8'd107;
		end
		6'd34: begin
			t_basiclowerer_self <= 8'd192;
		end
		6'd35: begin
			t_basiclowerer_self <= 8'd2;
		end
		6'd36: begin
			t_basiclowerer_self <= 8'd192;
		end
		6'd37: begin
			t_basiclowerer_self <= 8'd3;
		end
		6'd38: begin
			t_basiclowerer_self <= 8'd0;
		end
		6'd39: begin
			t_basiclowerer_self <= 8'd26;
		end
		6'd40: begin
			t_basiclowerer_self <= 8'd200;
		end
		6'd41: begin
			t_basiclowerer_self <= 8'd240;
		end
		6'd42: begin
			t_basiclowerer_self <= 8'd80;
		end
		6'd43: begin
			t_basiclowerer_self <= 8'd77;
		end
		6'd44: begin
			t_basiclowerer_self <= 8'd49;
		end
		6'd45: begin
			t_basiclowerer_self <= 8'd50;
		end
		6'd46: begin
			t_basiclowerer_self <= 8'd45;
		end
		6'd47: begin
			t_basiclowerer_self <= 8'd83;
		end
		6'd48: begin
			t_basiclowerer_self <= 8'd70;
		end
		6'd49: begin
			t_basiclowerer_self <= 8'd80;
		end
		6'd50: begin
			t_basiclowerer_self <= 8'd45;
		end
		6'd51: begin
			t_basiclowerer_self <= 8'd85;
		end
		6'd52: begin
			t_basiclowerer_self <= 8'd68;
		end
		6'd53: begin
			t_basiclowerer_self <= 8'd80;
		end
		6'd54: begin
			t_basiclowerer_self <= 8'd45;
		end
		6'd55: begin
			t_basiclowerer_self <= 8'd84;
		end
		6'd56: begin
			t_basiclowerer_self <= 8'd69;
		end
		6'd57: begin
			t_basiclowerer_self <= 8'd83;
		end
		6'd58: begin
			t_basiclowerer_self <= 8'd84;
		end
		default: begin
			t_basiclowerer_self <= 8'd33;
		end
	endcase
// synthesis translate_off
	dummy_d_44 <= dummy_s;
// synthesis translate_on
end
assign top_lp_abi_ping_toggle_o = xilinxmultiregimpl01;
assign top_lp_abi_pong_toggle_o = xilinxmultiregimpl11;
assign top_lp_abi_obuffer = xilinxmultiregimpl21;
assign top_seen_valid_ci_toggle_o = xilinxmultiregimpl31;
assign top_rx_config_reg_abi_toggle_o = xilinxmultiregimpl41;
assign top_rx_config_reg_ack_toggle_o = xilinxmultiregimpl51;
assign xilinxasyncresetsynchronizerimpl0_async_reset = (~top_pma_k7_gtx_basex_tx_mmcm_locked1);
assign xilinxasyncresetsynchronizerimpl1_async_reset = (~top_pma_k7_gtx_basex_rx_mmcm_locked1);
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
assign top_cmd = xilinxmultiregimpl221;
assign top_refsync = xilinxmultiregimpl231;
assign top_errsync = xilinxmultiregimpl241;
assign top_fixed_mode = xilinxmultiregimpl251;
assign i = top_cmd[11];

always @(posedge eth_rx_clk) begin
	if (top_pcsrx_seen_valid_ci) begin
		top_ci_count <= (top_ci_count + 1'd1);
	end
	if (top_pcsrx_seen_config_reg) begin
		top_cfg_count <= (top_cfg_count + 1'd1);
	end
	if (top_pcsrx_decoder_invalid) begin
		top_invalid_count <= (top_invalid_count + 1'd1);
	end
	if (top_pcsrx_seen_config_reg) begin
		top_rx_config_reg_last <= top_pcsrx_config_reg;
		if ((top_pcsrx_config_reg != top_rx_config_reg_last)) begin
			top_rx_config_reg_count <= 3'd7;
		end else begin
			if ((top_rx_config_reg_count != 1'd0)) begin
				top_rx_config_reg_count <= (top_rx_config_reg_count - 1'd1);
			end else begin
				if (top_pcsrx_config_reg[14]) begin
					top_rx_config_reg_ack_i <= 1'd1;
				end else begin
					top_rx_config_reg_abi_i <= 1'd1;
				end
			end
		end
		top_lp_abi_i <= top_pcsrx_config_reg;
	end
	if (top_pcsrx_decoder_ce) begin
		top_pcsrx_decoder_k <= 1'd0;
		if ((top_pcsrx_decoder_input_msb_first[9:4] == 4'd15)) begin
			top_pcsrx_decoder_k <= 1'd1;
			top_pcsrx_decoder_code3b <= t_rhs_self;
		end else begin
			if ((top_pcsrx_decoder_input_msb_first[9:4] == 6'd48)) begin
				top_pcsrx_decoder_k <= 1'd1;
				top_pcsrx_decoder_code3b <= f_t_self;
			end else begin
				if (((top_pcsrx_decoder_input_msb_first[3:0] == 3'd7) | (top_pcsrx_decoder_input_msb_first[3:0] == 4'd8))) begin
					if (((((((top_pcsrx_decoder_input_msb_first[9:4] != 6'd35) & (top_pcsrx_decoder_input_msb_first[9:4] != 5'd19)) & (top_pcsrx_decoder_input_msb_first[9:4] != 4'd11)) & (top_pcsrx_decoder_input_msb_first[9:4] != 6'd52)) & (top_pcsrx_decoder_input_msb_first[9:4] != 6'd44)) & (top_pcsrx_decoder_input_msb_first[9:4] != 5'd28))) begin
						top_pcsrx_decoder_k <= 1'd1;
					end
				end
				top_pcsrx_decoder_code3b <= f_f_self;
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
	if (top_pcsrx_count0_clockdomainsrenamer1_next_value_ce0) begin
		top_pcsrx_count0 <= top_pcsrx_count0_clockdomainsrenamer1_next_value0;
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
		top_lp_abi_i <= 16'd0;
		top_lp_abi_starter <= 1'd1;
		top_lp_abi_count <= 8'd128;
		top_rx_config_reg_abi_i <= 1'd0;
		top_rx_config_reg_ack_i <= 1'd0;
		top_rx_config_reg_count <= 4'd0;
		top_rx_config_reg_last <= 16'd0;
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
		top_ci_count <= 32'd0;
		top_cfg_count <= 32'd0;
		top_invalid_count <= 32'd0;
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
	if (top_seen_valid_ci_o) begin
		top_idle_age <= 1'd0;
		top_fixed_up <= 1'd1;
	end else begin
		if ((top_idle_age < 20'd750000)) begin
			top_idle_age <= (top_idle_age + 1'd1);
		end else begin
			top_fixed_up <= 1'd0;
		end
	end
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
			top_pcstx_encoder_code6b <= f_rhs_self0;
			top_pcstx_encoder_code6b_unbalanced <= f_rhs_self1;
			top_pcstx_encoder_code6b_flip <= f_rhs_self2;
		end
		top_pcstx_encoder_code4b <= rhs_self0;
		top_pcstx_encoder_code4b_unbalanced <= rhs_self1;
		if (top_pcstx_encoder_k) begin
			top_pcstx_encoder_code4b_flip <= 1'd1;
		end else begin
			top_pcstx_encoder_code4b_flip <= f_rhs_self3;
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
	clockdomainsrenamer2_state <= clockdomainsrenamer2_next_state;
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
	if (top_tx_gap_counter_clockdomainsrenamer3_next_value_ce) begin
		top_tx_gap_counter <= top_tx_gap_counter_clockdomainsrenamer3_next_value;
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
		top_lp_abi_ping_o1 <= 1'd0;
		top_waittimer0_count <= 21'd1250000;
		top_waittimer1_count <= 21'd1250000;
		top_waittimer2_count <= 18'd200000;
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
		top_fixed_up <= 1'd0;
		top_idle_age <= 20'd0;
		clockdomainsrenamer0_state <= 3'd0;
		clockdomainsrenamer2_state <= 3'd0;
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
	xilinxmultiregimpl250 <= top_cmd[11];
	xilinxmultiregimpl251 <= xilinxmultiregimpl250;
end

always @(posedge eth_tx_half_clk) begin
	top_pma_k7_gtx_basex_tx_data_half <= top_pma_k7_gtx_basex_buf;
end

always @(posedge refmon_clk) begin
	top_refcount <= (top_refcount + 1'd1);
end

always @(posedge sys_clk) begin
	top_tick <= (top_tick + 1'd1);
	if ((top_errsync & top_cmd[4])) begin
		top_prbscount <= (top_prbscount + 1'd1);
	end
	if ((top_gap != 1'd0)) begin
		top_gap <= (top_gap - 1'd1);
	end else begin
		if ((top_sink_valid & top_sink_ready)) begin
			if ((top_txi == 6'd59)) begin
				top_txi <= 1'd0;
				top_gap <= 16'd60000;
				top_txcount <= (top_txcount + 1'd1);
			end else begin
				top_txi <= (top_txi + 1'd1);
			end
		end
	end
	if (top_source_valid) begin
		top_rxbytes <= (top_rxbytes + 1'd1);
		if ((top_source_payload_data != basiclowerer_self)) begin
			top_bad <= 1'd1;
		end
		if (top_source_payload_error) begin
			top_bad <= 1'd1;
		end
		if (top_source_last) begin
			top_rxcount <= (top_rxcount + 1'd1);
			if ((((top_bad | (top_rxi != 6'd59)) | (top_source_payload_data != t_basiclowerer_self)) | top_source_payload_error)) begin
				top_badcount <= (top_badcount + 1'd1);
			end
			top_rxi <= 1'd0;
			top_bad <= 1'd0;
		end else begin
			if ((top_rxi < 6'd59)) begin
				top_rxi <= (top_rxi + 1'd1);
			end else begin
				top_bad <= 1'd1;
			end
		end
	end
	if (((top_source_valid & top_source_last) & top_source_payload_error)) begin
		top_rx_mac_errors <= (top_rx_mac_errors + 1'd1);
	end
	top_pma_k7_gtx_basex_tx_mmcm_reset0 <= (~top_pma_k7_gtx_basex_pll_lock);
	if (top_pma_k7_gtx_basex_rx_reset) begin
		top_pma_k7_gtx_basex_cdr_locked <= 1'd0;
		top_pma_k7_gtx_basex_cdr_lock_counter <= 1'd0;
	end else begin
		if ((top_pma_k7_gtx_basex_cdr_lock_counter != 13'd4800)) begin
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
		top_pma_k7_gtx_basex_gtxtxinit_init_delay_count <= 6'd60;
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
		top_pma_k7_gtx_basex_gtxtxinit_watchdog_count <= 17'd120000;
	end
	if (top_pma_k7_gtx_basex_tx_init_reset) begin
		top_pma_k7_gtx_basex_gtxtxinit_pllreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_gtXxreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_gtXxpd0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_Xxdlysreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone_r <= 1'd1;
		top_pma_k7_gtx_basex_gtxtxinit_init_delay_count <= 6'd60;
		top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_count <= 11'd1024;
		top_pma_k7_gtx_basex_gtxtxinit_watchdog_count <= 17'd120000;
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
		top_pma_k7_gtx_basex_gtxrxinit_init_delay_count <= 6'd60;
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
		top_pma_k7_gtx_basex_gtxrxinit_watchdog_count <= 17'd120000;
	end
	if (top_pma_k7_gtx_basex_rx_init_reset) begin
		top_pma_k7_gtx_basex_gtxrxinit_pllreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_gtXxreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_gtXxpd0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_Xxdlysreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone_r <= 1'd1;
		top_pma_k7_gtx_basex_gtxrxinit_init_delay_count <= 6'd60;
		top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_count <= 11'd1024;
		top_pma_k7_gtx_basex_gtxrxinit_watchdog_count <= 17'd120000;
		gtxrxinit_state <= 4'd0;
	end
	top_pma_k7_gtx_basex_toggle_o_r <= top_pma_k7_gtx_basex_toggle_o;
	txdatapath_liteethmacpaddinginserter_state <= txdatapath_liteethmacpaddinginserter_next_state;
	if (top_tx_padding_counter_clockdomainsrenamer0_next_value_ce2) begin
		top_tx_padding_counter <= top_tx_padding_counter_clockdomainsrenamer0_next_value2;
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
	if (top_tx_crc_crc_packet_clockdomainsrenamer1_next_value_ce1) begin
		top_tx_crc_crc_packet <= top_tx_crc_crc_packet_clockdomainsrenamer1_next_value1;
	end
	if (top_tx_crc_be0_clockdomainsrenamer1_next_value_ce2) begin
		top_tx_crc_be0 <= top_tx_crc_be0_clockdomainsrenamer1_next_value2;
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
	if (top_tx_preamble_count_clockdomainsrenamer2_next_value_ce) begin
		top_tx_preamble_count <= top_tx_preamble_count_clockdomainsrenamer2_next_value;
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
	if (top_liteethmaccrc32checker_be_next_value_ce0) begin
		top_liteethmaccrc32checker_be <= top_liteethmaccrc32checker_be_next_value0;
	end
	if (top_liteethmaccrc32checker_last_error_next_value_ce1) begin
		top_liteethmaccrc32checker_last_error <= top_liteethmaccrc32checker_last_error_next_value1;
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
	if (sys_rst) begin
		top_pma_k7_gtx_basex_tx_mmcm_reset0 <= 1'd1;
		top_pma_k7_gtx_basex_rx_mmcm_reset0 <= 1'd1;
		top_pma_k7_gtx_basex_gtxtxinit_pllreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_gtXxreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_gtXxpd0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_Xxdlysreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_Xxuserrdy0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxtxinit_Xxphaligndone_r <= 1'd1;
		top_pma_k7_gtx_basex_gtxtxinit_init_delay_count <= 6'd60;
		top_pma_k7_gtx_basex_gtxtxinit_cdr_lock_timer_count <= 11'd1024;
		top_pma_k7_gtx_basex_gtxtxinit_watchdog_count <= 17'd120000;
		top_pma_k7_gtx_basex_gtxrxinit_pllreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_gtXxreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_gtXxpd0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_Xxdlysreset0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_Xxuserrdy0 <= 1'd0;
		top_pma_k7_gtx_basex_gtxrxinit_Xxphaligndone_r <= 1'd1;
		top_pma_k7_gtx_basex_gtxrxinit_init_delay_count <= 6'd60;
		top_pma_k7_gtx_basex_gtxrxinit_cdr_lock_timer_count <= 11'd1024;
		top_pma_k7_gtx_basex_gtxrxinit_watchdog_count <= 17'd120000;
		top_pma_k7_gtx_basex_cdr_lock_counter <= 13'd0;
		top_pma_k7_gtx_basex_cdr_locked <= 1'd0;
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
		top_tick <= 32'd0;
		top_prbscount <= 32'd0;
		top_txcount <= 32'd0;
		top_rxcount <= 32'd0;
		top_badcount <= 32'd0;
		top_rxbytes <= 32'd0;
		top_txi <= 6'd0;
		top_rxi <= 6'd0;
		top_gap <= 16'd1000;
		top_bad <= 1'd0;
		top_rx_mac_errors <= 32'd0;
		gtxtxinit_state <= 4'd0;
		gtxrxinit_state <= 4'd0;
		txdatapath_liteethmacpaddinginserter_state <= 1'd0;
		txdatapath_bufferizeendpoints_state <= 2'd0;
		txdatapath_liteethmacpreambleinserter_state <= 2'd0;
		rxdatapath_liteethmacpreamblechecker_state <= 1'd0;
		rxdatapath_bufferizeendpoints_state <= 2'd0;
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
	xilinxmultiregimpl220 <= top_cmd_async;
	xilinxmultiregimpl221 <= xilinxmultiregimpl220;
	xilinxmultiregimpl230 <= top_refcount;
	xilinxmultiregimpl231 <= xilinxmultiregimpl230;
	xilinxmultiregimpl240 <= top_prbs_err;
	xilinxmultiregimpl241 <= xilinxmultiregimpl240;
end

IBUFDS IBUFDS(
	.I(MCLK1_P),
	.IB(MCLK1_N),
	.O(top_mclk)
);

BUFG BUFG(
	.I(top_mclk),
	.O(sys_clk)
);

IBUFDS_GTE2 IBUFDS_GTE2(
	.CEB(1'd0),
	.I(MGTCLK_P),
	.IB(MGTCLK_N),
	.O(top_ref),
	.ODIV2(top_refdiv)
);

BUFG BUFG_1(
	.I(top_refdiv),
	.O(refmon_clk)
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
	.LOOPBACK(top_cmd[2:0]),
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
	.RXPOLARITY(top_cmd[9]),
	.RXPRBSCNTRESET(1'd0),
	.RXPRBSSEL((top_cmd[5] ? 2'd2 : (top_cmd[4] ? 1'd1 : 1'd0))),
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
	.TXPOLARITY(top_cmd[10]),
	.TXPOSTCURSOR(1'd0),
	.TXPOSTCURSORINV(1'd0),
	.TXPRBSFORCEERR(1'd0),
	.TXPRBSSEL((top_cmd[4] ? 1'd1 : 1'd0)),
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
	.CPLLREFCLKLOST(top_ref_lost),
	.DMONITOROUT(top_pma_k7_gtx_basex5),
	.DRPDO(top_pma_k7_gtx_basex2),
	.DRPRDY(top_pma_k7_gtx_basex3),
	.EYESCANDATAERROR(top_pma_k7_gtx_basex8),
	.GTREFCLKMONITOR(top_pma_k7_gtx_basex4),
	.GTXTXN(TX_N),
	.GTXTXP(TX_P),
	.PCSRSVDOUT(top_pma_k7_gtx_basex40),
	.PHYSTATUS(top_pma_k7_gtx_basex6),
	.RXBUFSTATUS(top_pma_k7_gtx_basex12),
	.RXBYTEISALIGNED(top_pma_k7_gtx_basex18),
	.RXBYTEREALIGN(top_pma_k7_gtx_basex19),
	.RXCDRLOCK(top_pma_k7_gtx_basex9),
	.RXCHANBONDSEQ(top_pma_k7_gtx_basex21),
	.RXCHANISALIGNED(top_pma_k7_gtx_basex23),
	.RXCHANREALIGN(top_pma_k7_gtx_basex24),
	.RXCHARISCOMMA(top_pma_k7_gtx_basex37),
	.RXCHARISK({top_pma_k7_gtx_basex_rx_data0[18], top_pma_k7_gtx_basex_rx_data0[8]}),
	.RXCHBONDO(top_pma_k7_gtx_basex22),
	.RXCLKCORCNT(top_pma_k7_gtx_basex10),
	.RXCOMINITDET(top_pma_k7_gtx_basex35),
	.RXCOMMADET(top_pma_k7_gtx_basex20),
	.RXCOMSASDET(top_pma_k7_gtx_basex33),
	.RXCOMWAKEDET(top_pma_k7_gtx_basex34),
	.RXDATA({top_pma_k7_gtx_basex_rx_data0[17:10], top_pma_k7_gtx_basex_rx_data0[7:0]}),
	.RXDATAVALID(top_pma_k7_gtx_basex29),
	.RXDLYSRESETDONE(top_pma_k7_gtx_basex13),
	.RXELECIDLE(top_pma_k7_gtx_basex36),
	.RXHEADER(top_pma_k7_gtx_basex30),
	.RXHEADERVALID(top_pma_k7_gtx_basex31),
	.RXMONITOROUT(top_pma_k7_gtx_basex25),
	.RXNOTINTABLE(top_pma_k7_gtx_basex11),
	.RXOUTCLK(top_pma_k7_gtx_basex_rxoutclk),
	.RXOUTCLKFABRIC(top_pma_k7_gtx_basex27),
	.RXOUTCLKPCS(top_pma_k7_gtx_basex28),
	.RXPHALIGNDONE(top_pma_k7_gtx_basex14),
	.RXPHMONITOR(top_pma_k7_gtx_basex15),
	.RXPHSLIPMONITOR(top_pma_k7_gtx_basex16),
	.RXPRBSERR(top_prbs_err),
	.RXQPISENN(top_pma_k7_gtx_basex38),
	.RXQPISENP(top_pma_k7_gtx_basex39),
	.RXRATEDONE(top_pma_k7_gtx_basex26),
	.RXRESETDONE(top_pma_k7_gtx_basex_rx_reset_done),
	.RXSTARTOFSEQ(top_pma_k7_gtx_basex32),
	.RXSTATUS(top_pma_k7_gtx_basex17),
	.RXVALID(top_pma_k7_gtx_basex7),
	.TSTOUT(top_pma_k7_gtx_basex1),
	.TXBUFSTATUS(top_pma_k7_gtx_basex44),
	.TXCOMFINISH(top_pma_k7_gtx_basex49),
	.TXDLYSRESETDONE(top_pma_k7_gtx_basex41),
	.TXGEARBOXREADY(top_pma_k7_gtx_basex48),
	.TXOUTCLK(top_pma_k7_gtx_basex_txoutclk),
	.TXOUTCLKFABRIC(top_pma_k7_gtx_basex45),
	.TXOUTCLKPCS(top_pma_k7_gtx_basex46),
	.TXPHALIGNDONE(top_pma_k7_gtx_basex42),
	.TXPHINITDONE(top_pma_k7_gtx_basex43),
	.TXQPISENN(top_pma_k7_gtx_basex50),
	.TXQPISENP(top_pma_k7_gtx_basex51),
	.TXRATEDONE(top_pma_k7_gtx_basex47),
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

always @(posedge sys_clk) begin : mem_write_block_12
	memadr_6 <= top_rx_cdc_cdc_rdport_adr;
end

assign top_rx_cdc_cdc_wrport_dat_r = storage_4[memadr_5];
assign top_rx_cdc_cdc_rdport_dat_r = storage_4[memadr_6];

reg [11:0] storage_5[0:4];
reg [11:0] memdat_5;
always @(posedge sys_clk) begin : mem_write_block_13
	if (top_liteethmaccrc32checker_syncfifo_wrport_we)
		storage_5[top_liteethmaccrc32checker_syncfifo_wrport_adr] <= top_liteethmaccrc32checker_syncfifo_wrport_dat_w;
	memdat_5 <= storage_5[top_liteethmaccrc32checker_syncfifo_wrport_adr];
end

always @(posedge sys_clk) begin : mem_write_block_14
end

assign top_liteethmaccrc32checker_syncfifo_wrport_dat_r = memdat_5;
assign top_liteethmaccrc32checker_syncfifo_rdport_dat_r = storage_5[top_liteethmaccrc32checker_syncfifo_rdport_adr];

eth_jtag eth_jtag(
	.report(top_report),
	.command(top_cmd_async)
);

FDCE FDCE(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(top_pma_k7_gtx_basex_tx_mmcm_reset1),
	.Q(s7mmcm0_reset0)
);

FDCE FDCE_1(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset0),
	.Q(s7mmcm0_reset1)
);

FDCE FDCE_2(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset1),
	.Q(s7mmcm0_reset2)
);

FDCE FDCE_3(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset2),
	.Q(s7mmcm0_reset3)
);

FDCE FDCE_4(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset3),
	.Q(s7mmcm0_reset4)
);

FDCE FDCE_5(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset4),
	.Q(s7mmcm0_reset5)
);

FDCE FDCE_6(
	.C(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm0_reset5),
	.Q(s7mmcm0_reset6)
);

FDCE FDCE_7(
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
) MMCME2_ADV (
	.CLKFBIN(s7mmcm0_mmcm_fb),
	.CLKIN1(top_pma_k7_gtx_basex_s7mmcm0_clkin_signal),
	.PWRDWN(top_pma_k7_gtx_basex_tx_mmcm_power_down),
	.RST(s7mmcm0_reset7),
	.CLKFBOUT(s7mmcm0_mmcm_fb),
	.CLKOUT0(top_pma_k7_gtx_basex_s7mmcm0_clkout0),
	.CLKOUT1(top_pma_k7_gtx_basex_s7mmcm0_clkout1),
	.LOCKED(top_pma_k7_gtx_basex_tx_mmcm_locked1)
);

FDCE FDCE_8(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(top_pma_k7_gtx_basex_rx_mmcm_reset1),
	.Q(s7mmcm1_reset0)
);

FDCE FDCE_9(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset0),
	.Q(s7mmcm1_reset1)
);

FDCE FDCE_10(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset1),
	.Q(s7mmcm1_reset2)
);

FDCE FDCE_11(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset2),
	.Q(s7mmcm1_reset3)
);

FDCE FDCE_12(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset3),
	.Q(s7mmcm1_reset4)
);

FDCE FDCE_13(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset4),
	.Q(s7mmcm1_reset5)
);

FDCE FDCE_14(
	.C(top_pma_k7_gtx_basex_s7mmcm1_clkin_signal),
	.CE(1'd1),
	.CLR(1'd0),
	.D(s7mmcm1_reset5),
	.Q(s7mmcm1_reset6)
);

FDCE FDCE_15(
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
) MMCME2_ADV_1 (
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
	.C(eth_tx_clk),
	.CE(1'd1),
	.D(1'd0),
	.PRE(xilinxasyncresetsynchronizerimpl0_async_reset),
	.Q(xilinxasyncresetsynchronizerimpl0_rst_meta)
);

(* ars_ff2 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_1 (
	.C(eth_tx_clk),
	.CE(1'd1),
	.D(xilinxasyncresetsynchronizerimpl0_rst_meta),
	.PRE(xilinxasyncresetsynchronizerimpl0_async_reset),
	.Q(eth_tx_rst)
);

(* ars_ff1 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_2 (
	.C(eth_rx_clk),
	.CE(1'd1),
	.D(1'd0),
	.PRE(xilinxasyncresetsynchronizerimpl1_async_reset),
	.Q(xilinxasyncresetsynchronizerimpl1_rst_meta)
);

(* ars_ff2 = "true", async_reg = "true" *) FDPE #(
	.INIT(1'd1)
) FDPE_3 (
	.C(eth_rx_clk),
	.CE(1'd1),
	.D(xilinxasyncresetsynchronizerimpl1_rst_meta),
	.PRE(xilinxasyncresetsynchronizerimpl1_async_reset),
	.Q(eth_rx_rst)
);

endmodule
