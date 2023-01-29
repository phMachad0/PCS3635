--------------------------------------------------------------------
-- Arquivo   : circuito_exp2_ativ2.vhd.parcial.txt
-- Projeto   : Experiencia 2 - Um Fluxo de Dados Simples
--------------------------------------------------------------------
-- Descricao : ARQUIVO PARCIAL DO
--    Circuito do fluxo de dados da Atividade 2
--
-- COMPLETAR TRECHOS DE CODIGO ABAIXO
--
--    1) contem saidas de depuracao db_contagem e db_memoria
--    2) escolha da arquitetura do componente ram_16x4
--       para simulacao com ModelSim => ram_modelsim
--    3) escolha da arquitetura do componente ram_16x4
--       para sintese com Intel Quartus => ram_mif
--
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/01/2022  1.0     Edson Midorikawa  versao inicial
--     07/01/2023  1.1     Edson Midorikawa  revisao
--     10/02/2023  1.1.1   Edson Midorikawa  arquivo parcial
--------------------------------------------------------------------
--

library ieee;
use ieee.std_logic_1164.all;

entity circuito_exp2_desafio is
    port (
        clock       : in  std_logic;
        zera        : in  std_logic;
        conta       : in  std_logic;
        escreve     : in  std_logic;
        chaves      : in  std_logic_vector (3 downto 0);
        igual       : out std_logic;
        fim         : out std_logic;
        db_contagem : out std_logic_vector (6 downto 0);
        db_memoria  : out std_logic_vector (6 downto 0)
    );
end entity;

architecture estrutural of circuito_exp2_desafio is

  signal s_endereco    : std_logic_vector (3 downto 0);
  signal s_dado        : std_logic_vector (3 downto 0);
  signal s_memoria     : std_logic_vector (6 downto 0);
  signal s_contagem    : std_logic_vector (6 downto 0);
  signal s_not_zera    : std_logic;
  signal s_not_escreve : std_logic;

  component contador_163
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

  component comparador_85
    port (
        i_A3   : in  std_logic;
        i_B3   : in  std_logic;
        i_A2   : in  std_logic;
        i_B2   : in  std_logic;
        i_A1   : in  std_logic;
        i_B1   : in  std_logic;
        i_A0   : in  std_logic;
        i_B0   : in  std_logic;
        i_AGTB : in  std_logic;
        i_ALTB : in  std_logic;
        i_AEQB : in  std_logic;
        o_AGTB : out std_logic;
        o_ALTB : out std_logic;
        o_AEQB : out std_logic
    );
  end component;

  component ram_16x4 is
    port (
      clk          : in  std_logic;
      endereco     : in  std_logic_vector(3 downto 0);
      dado_entrada : in  std_logic_vector(3 downto 0);
      we           : in  std_logic;
      ce           : in  std_logic;
      dado_saida   : out std_logic_vector(3 downto 0)
    );
  end component;
  
  component hexa7seg is
    port (
        hexa : in  std_logic_vector(3 downto 0);
        sseg : out std_logic_vector(6 downto 0)
    );
  end component;

  

begin

  -- sinais de controle ativos em alto
  -- sinais dos componentes ativos em baixo
  s_not_zera    <= zera;
  s_not_escreve <= not escreve;
  
  contador: contador_163
    port map (
        clock => clock,
        clr   => s_not_zera,  -- clr ativo em baixo
        ld    => '1',
        ent   => conta,
        enp   => '1',
        D     => "0000",
        Q     => s_endereco,
        rco   => fim
    );

  comparador: comparador_85
    port map (
        i_A3   => s_dado(3),
        i_B3   => chaves(3),
        i_A2   => s_dado(2),
        i_B2   => chaves(2),
        i_A1   => s_dado(1),
        i_B1   => chaves(1),
        i_A0   => s_dado(0),
        i_B0   => chaves(0),
        i_AGTB => '0',
        i_ALTB => '0',
        i_AEQB => '1',
        o_AGTB => open, -- saidas nao usadas
        o_ALTB => open,
        o_AEQB => igual
    );

  -- memoria: entity work.ram_16x4 (ram_mif)  -- usar esta linha para Intel Quartus
  memoria: entity work.ram_16x4 (ram_modelsim) -- usar arquitetura para ModelSim
    port map (
       clk          => clock,
       endereco     => s_endereco,
       dado_entrada => chaves,
       we           => s_not_escreve,-- we ativo em baixo
       ce           => '0',
       dado_saida   => s_dado
    );
	 
	display1: hexa7seg
		port map(
			hexa => s_dado,
			sseg => s_memoria
		);
		
	display2: hexa7seg
		port map(
			hexa => s_endereco,
			sseg => s_contagem
		);

  db_contagem <= s_contagem;
  db_memoria  <= s_memoria;

end architecture estrutural;
