library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;

entity audio_saturation is
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
end entity audio_saturation;

architecture rtl of audio_saturation is

  signal saturation : signed(31 downto 0);
  signal sig_in     : signed(31 downto 0);
  signal sig_out    : signed(31 downto 0);

begin

  i2s_in_tready <= i2s_out_tready;

  sig_in <= signed(i2s_in_tdata);

  process_clk : process (clk_in) is
  begin

    if rising_edge(clk_in) then
      if (sig_out > saturation) then
        sig_out <= saturation;
      elsif (sig_out < (saturation or X"80000000")) then
        sig_out <= (saturation or X"80000000");
      end if;

      i2s_out_tdata  <= std_logic_vector(sig_out);
      i2s_out_tvalid <= i2s_in_tvalid;
      i2s_out_tid    <= i2s_in_tid;
    end if;

  end process process_clk;

  process_apb : process (clk_in) is
  begin

    if rising_edge(clk_in) then
      if (psel = '1' and penable = '1' and pwrite = '1') then

        case paddr(3 downto 0) is

          when X"0" =>

            saturation <= signed(pwdata);

          when others =>

            null;

        end case;

      end if;
    end if;

  end process process_apb;

end architecture rtl;
