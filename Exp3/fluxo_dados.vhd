library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados is
port (
    clock : in std_logic;
    zeraC : in std_logic;
    contaC : in std_logic;
    escreveM : in std_logic;
    zeraR : in std_logic;
    registraR : in std_logic;
    chaves : in std_logic_vector (3 downto 0);
    chavesIgualMemoria : out std_logic;
    fimC : out std_logic;
    db_contagem : out std_logic_vector (3 downto 0);
    db_memoria : out std_logic_vector (3 downto 0);
    db_chaves : out std_logic_vector (3 downto 0)
    );
end entity fluxo_dados;

architecture estrutural of fluxo_dados is

  signal s_endereco    : std_logic_vector (3 downto 0);
  signal s_dado        : std_logic_vector (3 downto 0);
  signal s_chaves     : std_logic_vector (3 downto 0);
  signal s_igual    : std_logic;
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
  
  component registrador_n is
    generic (
        constant N: integer := 8 
    );
    port (
        clock  : in  std_logic;
        clear  : in  std_logic;
        enable : in  std_logic;
        D      : in  std_logic_vector (N-1 downto 0);
        Q      : out std_logic_vector (N-1 downto 0) 
    );
  end component;
    
begin

    -- sinais de controle ativos em alto
    -- sinais dos componentes ativos em baixo
    s_not_zera    <= zeraC;
    s_not_escreve <= not escreveM;
    
    contador: contador_163
        port map (
            clock => clock,
            clr   => s_not_zera,  -- clr ativo em baixo
            ld    => '1',
            ent   => contaC,
            enp   => '1',
            D     => "0000",
            Q     => s_endereco,
            rco   => fimC
        );


    registrador: registrador_n
        generic map (
            N => 4
        )
        port map(
            clock => clock,
            clear => zeraR, 
            enable => registraR,
            D(0) => chaves(0),
            D(1) => chaves(1),
            D(2) => chaves(2),
            D(3) => chaves(3),
            Q => s_chaves
        );

    comparador: comparador_85
        port map (
            i_A3   => s_dado(3),
            i_B3   => s_chaves(3),
            i_A2   => s_dado(2),
            i_B2   => s_chaves(2),
            i_A1   => s_dado(1),
            i_B1   => s_chaves(1),
            i_A0   => s_dado(0),
            i_B0   => s_chaves(0),
            i_AGTB => '0',
            i_ALTB => '0',
            i_AEQB => '1',
            o_AGTB => open, -- saidas nao usadas
            o_ALTB => open,
            o_AEQB => s_igual
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

    db_contagem <= s_endereco;
    db_memoria  <= s_dado;
    db_chaves  <= s_chaves;
	chavesIgualMemoria <= s_igual;

end architecture estrutural;