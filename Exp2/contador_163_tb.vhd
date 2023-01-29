--------------------------------------------------------------------
-- Arquivo   : contador_163_tb.vhd
-- Projeto   : Experiencia 2 - Um Fluxo de Dados Simples
--------------------------------------------------------------------
-- Descricao : testbench para contador binario hexadecimal
--
--     1) plano de testes apresentado na Ativ.1 apostila da Exp.1
--     2) periodo de clock de 20 ns na placa DE0-CV (f=50MHz)
--                
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     07/01/2022  1.1     Edson Midorikawa  revisao
--     07/01/2023  1.2     Edson Midorikawa  revisao
--------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

entity contador_163_tb is
end entity;

architecture tb of contador_163_tb is
  
  -- Componente a ser testado (Device Under Test -- DUT)
  component contador_163 is
      port (
          clock : in  std_logic;
          clr   : in  std_logic;
          ld    : in  std_logic;
          ent   : in  std_logic;
          enp   : in  std_logic;
          D     : in  std_logic_vector (3 downto 0);
          Q     : out std_logic_vector (3 downto 0);
          rco   : out std_logic 
      );
  end component;
  
  -- Declaração de sinais para conectar o componente a ser testado (DUT)
  --   valores iniciais (somente) para fins de simulacao (GHDL ou ModelSim)
  signal clock_in : std_logic := '0';
  signal clr_in   : std_logic := '0';
  signal ld_in    : std_logic := '0';
  signal ent_in   : std_logic := '0';
  signal enp_in   : std_logic := '0';
  signal d_in     : std_logic_vector (3 downto 0) := "0000";
  signal q_out    : std_logic_vector (3 downto 0) := "0000";
  signal rco_out  : std_logic := '0';

  -- Configuração de tempo
  constant clockPeriod   : time := 20 ns;
  signal   numclocks     : integer;

  -- Identificacao de casos de teste
  signal caso : integer := 0;
  
begin
  
  -- Conecta DUT (Device Under Test)
  dut: contador_163
       port map ( 
           clock  => clock_in,
           clr    => clr_in,
           ld     => ld_in,
           ent    => ent_in,
           enp    => enp_in,
           D      => d_in,
           Q      => q_out,
           rco    => rco_out
      );

  -- geracao dos sinais de entrada (estimulos)
  stimulus: process is
  begin
  
    assert false report "Inicio da simulacao" severity note;
    
    ---- inicio: condicoes iniciais ----------------
    clock_in <= '0';
    clr_in   <= '1';
    ld_in    <= '1';
    ent_in   <= '0';
    enp_in   <= '0';
    d_in     <= "1111";
    wait for 5*clockPeriod; -- espera entre casos de teste

    ---- Teste 1 (aciona clock 2x com entradas inativadas)
    -- 2 bordas de clock
    caso <= 1;
    for cont in 1 to 2 loop
        clock_in   <= '1';
        wait for clockPeriod/2;
        clock_in   <= '0';
        wait for clockPeriod/2;
    end loop;
    ----
    wait for 5*clockPeriod; -- espera entre casos de teste

    ---- Teste 2 (aciona clock com clear ativado)
    caso       <= 2;
    clr_in     <= '0';  -- ativa clear (ativo baixo)
    clock_in   <= '1';
    wait for clockPeriod/2;
    clock_in   <= '0';
    wait for clockPeriod/2;
    -- desativa clear
    clr_in   <= '1'; 
	--
    wait for 5*clockPeriod; -- espera entre casos de teste
    
    ---- Teste 3 (aciona clock 5x com sinais de enable ativados)
    caso     <= 3;
    ent_in   <= '1';
    enp_in   <= '1';
    for cont in 1 to 5 loop
        clock_in   <= '1';
        wait for clockPeriod/2;
        clock_in   <= '0';
        wait for clockPeriod/2;
    end loop;
    ent_in   <= '0';
    enp_in   <= '0';
    ----
    wait for 5*clockPeriod; -- espera entre casos de teste

    ---- Teste 4 (aciona clock com load ativado e dado=1011)
    caso     <= 4;
    ld_in    <= '0';
	d_in     <= "1011";
    clock_in <= '1';
    wait for clockPeriod/2;
    clock_in   <= '0';
    wait for clockPeriod/2;
    ld_in    <= '1';
    ----
    wait for 5*clockPeriod; -- espera entre casos de teste

    ---- Teste 5 (aciona clock 4x com sinais de enable ativados)
    caso     <= 5;
    ent_in   <= '1';
    enp_in   <= '1';
    for cont in 1 to 4 loop
        clock_in   <= '1';
        wait for clockPeriod/2;
        clock_in   <= '0';
        wait for clockPeriod/2;
    end loop;
    ent_in   <= '0';
    enp_in   <= '0';
    ----
    wait for 5*clockPeriod; -- espera entre casos de teste


    ---- Teste 6 (aciona clock 2x com enp=0 e ent=1)
    caso     <= 6;
    ent_in   <= '1';
    enp_in   <= '0';
    for cont in 1 to 2 loop
        clock_in   <= '1';
        wait for clockPeriod/2;
        clock_in   <= '0';
        wait for clockPeriod/2;
    end loop;
    -- ent_in   <= '0';
    -- enp_in   <= '0';
    ----
    wait for 5*clockPeriod; -- espera entre casos de teste


    ---- Teste 7 (aciona clock 2x com enp=1 e ent=0)
    caso     <= 7;
    ent_in   <= '0';
    enp_in   <= '1';
    for cont in 1 to 2 loop
        clock_in   <= '1';
        wait for clockPeriod/2;
        clock_in   <= '0';
        wait for clockPeriod/2;
    end loop;
    ent_in   <= '0';
    enp_in   <= '0';
    ----
    wait for 5*clockPeriod; -- espera entre casos de teste

    ---- Teste 8 (aciona clock 2x com sinais de enable ativados)
    caso     <= 8;
    ent_in   <= '1';
    enp_in   <= '1';
    for cont in 1 to 2 loop
        clock_in   <= '1';
        wait for clockPeriod/2;
        clock_in   <= '0';
        wait for clockPeriod/2;
    end loop;
    ent_in   <= '0';
    enp_in   <= '0';
    ----
    wait for 5*clockPeriod; -- espera entre casos de teste

    ---- Teste 9 (aciona clock com clear e load ativados e dado=1001)
    caso     <= 9;
    clr_in   <= '0';
    ld_in    <= '0';
    d_in     <= "1001";

    clock_in <= '1';
    wait for clockPeriod/2;
    clock_in <= '0';
    wait for clockPeriod/2;
    clr_in   <= '1';
    ld_in    <= '1';
    ----
    wait for 5*clockPeriod; -- espera entre casos de teste

    ---- Teste 10 (aciona clock com load ativado e dado=1011)
    caso     <= 10;
    ld_in    <= '0';
    d_in     <= "1011";

    clock_in <= '1';
    wait for clockPeriod/2;
    clock_in <= '0';
    wait for clockPeriod/2;
    ld_in    <= '1';
    ----
    wait for 5*clockPeriod; -- espera entre casos de teste

    ---- Teste 11 (aciona clock 6x com sinais de enable ativados)
    caso     <= 11;
    ent_in   <= '1';
    enp_in   <= '1';
    for cont in 1 to 6 loop
        clock_in   <= '1';
        wait for clockPeriod/2;
        clock_in   <= '0';
        wait for clockPeriod/2;
    end loop;
    ----
    wait for 5*clockPeriod; -- espera entre casos de teste

    ---- final dos casos de teste  da simulacao
    assert false report "Fim da simulacao" severity note;
    
    wait; -- fim da simulação: aguarda indefinidamente
  end process;

end architecture;
