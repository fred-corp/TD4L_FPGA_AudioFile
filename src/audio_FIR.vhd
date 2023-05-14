library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;

entity audio_fir is
  port (
    i2s_in_tdata  : in    std_logic_vector(31 downto 0);
    i2s_in_tvalid : in    std_logic;
    i2s_in_tid    : in    std_logic_vector(2 downto 0);
    i2s_in_tready : out   std_logic;

    i2s_out_tdata  : out   std_logic_vector(31 downto 0);
    i2s_out_tvalid : out   std_logic;
    i2s_out_tid    : out   std_logic_vector(2 downto 0);
    i2s_out_tready : in    std_logic;

    clk_in : in    std_logic;

    paddr   : in    std_logic_vector(31 downto 0);
    psel    : in    std_logic;
    penable : in    std_logic;
    pwrite  : in    std_logic;
    pwdata  : in    std_logic_vector(31 downto 0);
    pstrb   : in    std_logic_vector(3 downto 0);

    pready : out   std_logic;
    prdata : out   std_logic_vector(31 downto 0)
  );
end entity audio_fir;

architecture rtl of audio_fir is

begin

  process_clk : process (clk_in) is
  begin

  end process process_clk;

end architecture rtl;
