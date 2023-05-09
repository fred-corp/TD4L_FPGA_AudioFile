library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;

entity audio_gain is
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
end entity audio_gain;

architecture rtl of audio_gain is

  signal rectify : std_logic_vector(1 downto 0);
  signal sig_out : signed(31 downto 0);

begin

  i2s_in_tready <= i2s_out_tready;

  sig_out <= signed(i2s_in_tdata);

  process_clk : process (clk_in) is
  begin

    if rising_edge(clk_in) then
      if (rectify = "01" and sig_out(31) = '1') then
        sig_out <= (others => 0);
      elsif (rectify = "10" and sig_out(31) = '1') then
        sig_out <= -sig_out;
      else
        sig_out <= sig_out;
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

            rectify <= pwdata(1 downto 0);

          when others =>

            null;

        end case;

      end if;
    end if;

  end process process_apb;

end architecture rtl;
