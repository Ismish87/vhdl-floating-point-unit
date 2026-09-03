LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY srLatch IS
	PORT(
		i_set, i_reset		: IN	STD_LOGIC;
		o_q, o_qBar		: OUT	STD_LOGIC);
END srLatch;

ARCHITECTURE rtl OF srLatch IS
	SIGNAL int_q, int_qBar : STD_LOGIC;
BEGIN

	--  Concurrent Signal Assignment

	int_q		<=	i_reset nor int_qBar;
	int_qBar	<=	int_q nor i_set;

	--  Output Driver

	o_q		<=	int_q;
	o_qBar		<=	int_qBar;

END rtl;

