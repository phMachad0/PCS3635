library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados is
port (
		clock 			: in std_logic;
		zeraCR 			: in std_logic;
		contaCR 		: in std_logic;
        contaE          : in std_logic;
        zeraE           : in std_logic;
		escreve 		: in std_logic;
		zeraRC 			: in std_logic;
		registraRC 		: in std_logic;
		chaves 			: in std_logic_vector (3 downto 0);
        reset_timeout   : in std_logic;
		jogada_correta 	: out std_logic;
		fimCR 			: out std_logic;
        time_out        : out std_logic;
		db_tem_jogada 	: out std_logic;
		db_contagem 	: out std_logic_vector (3 downto 0);
		db_memoria 		: out std_logic_vector (3 downto 0);
		db_jogada 		: out std_logic_vector (3 downto 0);
        enderecoIgualRodada : out std_logic;
        jogada_feita    : out std_logic
    );
end entity fluxo_dados;

architecture estrutural of fluxo_dados is

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
  
  component edge_detector is
    port (
        clock  : in  std_logic;
        reset  : in  std_logic;
        sinal  : in  std_logic;
        pulso  : out std_logic
    );
  end component;

  component timeout is
    port(
        clock: in std_logic;
        reset: in std_logic;
        time_out: out std_logic
    );
  end component;

  signal s_enderecoCR    : std_logic_vector (3 downto 0);
  signal s_endereco    : std_logic_vector (3 downto 0);
  signal s_dado        : std_logic_vector (3 downto 0);
  signal s_jogada     : std_logic_vector (3 downto 0);
  signal s_not_zeraE    : std_logic;
  signal s_not_zeraCR    : std_logic;
  signal s_not_escreve : std_logic;
  signal s_chaveacionada : std_logic;
    
begin

    -- sinais de controle ativos em alto
    -- sinais dos componentes ativos em baixo
    s_not_zeraCR    <= not zeraCR;
    s_not_zeraE  <= not zeraE;
    s_not_escreve <= not escreve;
	 s_chaveacionada <= chaves(0) or chaves(1) or chaves(2) or chaves(3);
    
    contadorCR: contador_163
        port map (
            clock => clock,
            clr   => s_not_zeraCR,  -- clr ativo em baixo
            ld    => '1',
            ent   => '1',
            enp   => contaCR,
            D     => "0000",
            Q     => s_enderecoCR,
            rco   => fimCR
        );

    contadorE: contador_163
        port map (
            clock => clock,
            clr   => s_not_zeraE,  -- clr ativo em baixo
            ld    => '1',
            ent   => '1',
            enp   => contaE,
            D     => "0000",
            Q     => s_endereco,
            rco   => open
        );

        

    registrador: registrador_n
        generic map (
            N => 4
        )
        port map(
            clock => clock,
            clear => zeraRC, 
            enable => registraRC,
            D(0) => chaves(0),
            D(1) => chaves(1),
            D(2) => chaves(2),
            D(3) => chaves(3),
            Q => s_jogada
        );

    comparadorEnd: comparador_85
        port map (
            i_A3   => s_endereco(3),
            i_B3   => s_enderecoCR(3),
            i_A2   => s_endereco(2),
            i_B2   => s_enderecoCR(2),
            i_A1   => s_endereco(1),
            i_B1   => s_enderecoCR(1),
            i_A0   => s_endereco(0),
            i_B0   => s_enderecoCR(0),
            i_AGTB => '0',
            i_ALTB => '0',
            i_AEQB => '1',
            o_AGTB => open, -- saidas nao usadas
            o_ALTB => open,
            o_AEQB => enderecoIgualRodada
        );

    comparador: comparador_85
        port map (
            i_A3   => s_dado(3),
            i_B3   => s_jogada(3),
            i_A2   => s_dado(2),
            i_B2   => s_jogada(2),
            i_A1   => s_dado(1),
            i_B1   => s_jogada(1),
            i_A0   => s_dado(0),
            i_B0   => s_jogada(0),
            i_AGTB => '0',
            i_ALTB => '0',
            i_AEQB => '1',
            o_AGTB => open, -- saidas nao usadas
            o_ALTB => open,
            o_AEQB => jogada_correta
        );

    --memoria: entity work.ram_16x4 (ram_mif)  -- usar esta linha para Intel Quartus
    memoria: entity work.ram_16x4 (ram_modelsim) -- usar arquitetura para ModelSim
        port map (
            clk          => clock,
            endereco     => s_endereco,
            dado_entrada => chaves,
            we           => s_not_escreve,-- we ativo em baixo
            ce           => '0',
            dado_saida   => s_dado
        );
		  
    detector: edge_detector
        port map (
			  clock => clock,
			  reset => zeraCR,
			  sinal => s_chaveacionada,
			  pulso => jogada_feita
        );
    
    timeout_counter: timeout port map(
        clock => clock,
        reset => reset_timeout,
        time_out => time_out
    );
		  
    db_contagem <= s_endereco;
	 db_tem_jogada <= s_chaveacionada;
    db_memoria  <= s_dado;
	 db_jogada <= s_jogada;

end architecture estrutural;
