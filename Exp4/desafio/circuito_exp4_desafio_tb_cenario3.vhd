--------------------------------------------------------------------------
-- Arquivo   : circuito_exp4_desafio_tb_cenario2.vhd
-- Projeto   : Experiencia 04 - Desenvolvimento de Projeto de
--                              Circuitos Digitais com FPGA
--------------------------------------------------------------------------
-- Descricao : modelo de testbench para simulação com ModelSim
--
--             implementa um Cenário de Teste do circuito
--             que acerta as 3 primeiras jogadas e erra a 4a jogada


library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

-- entidade do testbench
entity circuito_exp4_desafio_tb_cenario3 is
end entity;

architecture tb of circuito_exp4_desafio_tb_cenario3 is

  -- Componente a ser testado (Device Under Test -- DUT)
  component circuito_exp4_desafio
    port (
        clock          : in  std_logic;
        reset          : in  std_logic;
        iniciar        : in  std_logic;
        chaves         : in  std_logic_vector (3 downto 0);
        pronto         : out std_logic;
        acertou        : out std_logic;
        errou          : out std_logic;
        leds           : out std_logic_vector (3 downto 0);
        db_igual       : out std_logic;
        db_contagem    : out std_logic_vector (6 downto 0);
        db_memoria     : out std_logic_vector (6 downto 0);
        db_estado      : out std_logic_vector (6 downto 0);
        db_jogadafeita : out std_logic_vector (6 downto 0);
        db_clock       : out std_logic;
        db_tem_jogada  : out std_logic;
        db_timeout     : out std_logic
    );
  end component;
  
  ---- Declaracao de sinais de entrada para conectar o componente
  signal clk_in     : std_logic := '0';
  signal rst_in     : std_logic := '0';
  signal iniciar_in : std_logic := '0';
  signal chaves_in  : std_logic_vector(3 downto 0) := "0000";

  ---- Declaracao dos sinais de saida
  signal igual_out      : std_logic := '0';
  signal acertou_out    : std_logic := '0';
  signal errou_out      : std_logic := '0';
  signal pronto_out     : std_logic := '0';
  signal leds_out       : std_logic_vector(3 downto 0) := "0000";
  signal clock_out      : std_logic := '0';
  signal tem_jogada_out : std_logic := '0';
  signal contagem_out   : std_logic_vector(6 downto 0) := "0000000";
  signal memoria_out    : std_logic_vector(6 downto 0) := "0000000";
  signal estado_out     : std_logic_vector(6 downto 0) := "0000000";
  signal jogada_out     : std_logic_vector(6 downto 0) := "0000000";
  signal timeout_out    : std_logic := '0';

  -- Configurações do clock
  signal keep_simulating: std_logic := '0'; -- delimita o tempo de geração do clock
  constant clockPeriod : time := 20 ns;     -- frequencia 50MHz
  
begin
  -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período especificado. 
  -- Quando keep_simulating=0, clock é interrompido, bem como a simulação de eventos
  clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
  
  ---- DUT para Simulacao
  dut: circuito_exp4_desafio
       port map
       (
          clock           => clk_in,
          reset           => rst_in,
          iniciar         => iniciar_in,
          chaves          => chaves_in,
          acertou         => acertou_out,
          errou           => errou_out,
          pronto          => pronto_out,
          leds            => leds_out,
          db_igual        => igual_out,
          db_contagem     => contagem_out,
          db_memoria      => memoria_out,
          db_estado       => estado_out,
          db_jogadafeita  => jogada_out,  
          db_clock        => clock_out,
          db_tem_jogada   => tem_jogada_out,
          db_timeout      => timeout_out
       );
 
  ---- Gera sinais de estimulo para a simulacao
  -- Cenario de Teste : acerta as 3 primeiras jogadas e erra a 4a jogada

  stimulus: process is
  begin

    -- inicio da simulacao
    assert false report "inicio da simulacao" severity note;
    keep_simulating <= '1';  -- inicia geracao do sinal de clock

    -- gera pulso de reset (1 periodo de clock)
    rst_in <= '1';
    wait for clockPeriod;
    rst_in <= '0';


    -- pulso do sinal de Iniciar (muda na borda de descida do clock)
    wait until falling_edge(clk_in);
    iniciar_in <= '1';
    wait until falling_edge(clk_in);
    iniciar_in <= '0';
    
    -- espera para inicio dos testes
    wait for 4*clockPeriod;
    wait until falling_edge(clk_in);

    -- Cenario de Teste - acerta as 3 primeiras jogadas e erra a 4a jogada

    ---- jogada #1
    chaves_in <= "0001";
    wait for 4*clockPeriod;
    chaves_in <= "0000";
    -- espera entre jogadas de 10 clocks
    wait for 4*clockPeriod;  

    ---- jogada #2
    chaves_in <= "0010";
    wait for 4*clockPeriod;
    chaves_in <= "0000";
    ---- espera entre jogadas
    wait for 4*clockPeriod;
 
    ---- jogada #3
    chaves_in <= "0100";
    wait for 4*clockPeriod;
    chaves_in <= "0000";
    -- espera entre jogadas
    wait for 4*clockPeriod;  

    ---- jogada (espera 5s)#4
    wait for 5050*clockPeriod;
 
    ---- final do testbench
    assert false report "fim da simulacao" severity note;
    keep_simulating <= '0';
    
    wait; -- fim da simulação: processo aguarda indefinidamente
  end process;


end architecture;
