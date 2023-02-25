library ieee;
use ieee.std_logic_1164.all;

entity circuito_exp5 is
    port (
        clock : in std_logic;
        reset : in std_logic;
        iniciar : in std_logic;
        chaves : in std_logic_vector (3 downto 0);
        pronto : out std_logic;
        acertou : out std_logic;
        errou : out std_logic;
        leds : out std_logic_vector (3 downto 0);
        db_jogada_correta : out std_logic;
		  db_fim_rodada : out std_logic;
        db_contagem : out std_logic_vector (6 downto 0);
        db_memoria : out std_logic_vector (6 downto 0);
        db_estado : out std_logic_vector (6 downto 0);
        db_jogadafeita : out std_logic_vector (6 downto 0);
        db_clock : out std_logic;
        db_tem_jogada : out std_logic;
		  db_timeout : out std_logic;
		  db_rodada : out std_logic_vector (6 downto 0);
		  db_ultima_rodada : out std_logic;
		  estado_atual : out std_logic_vector(3 downto 0)
    );
end entity;

architecture assemble of circuito_exp5 is
    component fluxo_dados is
		port (
        clock 			: in std_logic;
        zeraCR 			: in std_logic;
        contaCR 		: in std_logic;
        contaE          : in std_logic;
        zeraE           : in std_logic;
        resetP           : in std_logic;
        escreve 		: in std_logic;
        zeraRC 			: in std_logic;
        registraRC 		: in std_logic;
        in_prep : in std_logic;
		  leds            : out std_logic_vector (3 downto 0);
        chaves 			: in std_logic_vector (3 downto 0);
        reset_timeout   : in std_logic;
        jogada_correta 	: out std_logic;
        fimCR 			: out std_logic;
        time_out        : out std_logic;
        db_tem_jogada 	: out std_logic;
        fim_prep 	: out std_logic;
        db_contagem 	: out std_logic_vector (3 downto 0);
        db_memoria 		: out std_logic_vector (3 downto 0);
        db_jogada 		: out std_logic_vector (3 downto 0);
		  rodada       : out std_logic_vector (3 downto 0);
        enderecoIgualRodada : out std_logic;
        jogada_feita    : out std_logic
			 );
		end component;

    component unidade_controle is
		 port (
        clock : in std_logic;
        reset : in std_logic;
        iniciar : in std_logic;
        fim_rodada : in std_logic;
        fim_jogo    : in std_logic;
        jogada : in std_logic;
        fim_prep : in std_logic;
        igual : in std_logic;
		  time_out : in std_logic;
		  primeira_rodada : in std_logic;
        zeraCR : out std_logic;
        resetP : out std_logic;
        contaCR : out std_logic;
        zeraE : out std_logic;
        contaE : out std_logic;
        zeraR : out std_logic;
		  zeraT	: out std_logic;
        registraR : out std_logic;
		  escreve : out std_logic;
        acertou : out std_logic;
        in_prep : out std_logic;
        errou : out std_logic;
		  db_esgotou : out std_logic;
        pronto : out std_logic;
        db_estado : out std_logic_vector(3 downto 0);
		  db_ultima_rodada : out std_logic
			);
		end component;

    component hexa7seg is
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component;

    signal resetP_sig, fim_prep_sig, in_prep_sig, zeraCR_sig, contaCR_sig, zeraE_sig, contaE_sig, zeraRC_sig, registraRC_sig, fimCR_sig, jogada_correta_sig, enderecoIgualRodada_sig, jogada_feita_sig, timeout_sig, zeraT_sig: std_logic;
    signal out_estado, db_cont, db_mem, db_jogada, db_timeo: std_logic_vector (3 downto 0);
	 signal rodada_sig  : std_logic_vector (3 downto 0);
	 signal escreve_sig : std_logic;
	 signal primeira_rodada_sig : std_logic;
begin
    FD: fluxo_dados port map(
      resetP => resetP_sig,
      in_prep => in_prep_sig,
      fim_prep => fim_prep_sig,
        clock => clock,
        zeraCR => zeraCR_sig,
        contaCR => contaCR_sig,
		  zeraE => zeraE_sig,
        contaE => contaE_sig,
        escreve => escreve_sig,
        zeraRC => zeraRC_sig,
        registraRC => registraRC_sig,
        chaves => chaves,
		  leds => leds,
        jogada_correta => jogada_correta_sig,
		  enderecoIgualRodada => enderecoIgualRodada_sig,
        fimCR => fimCR_sig,
		  time_out => timeout_sig,
		  reset_timeout => zeraT_sig,
        jogada_feita => jogada_feita_sig,
        db_tem_jogada => db_tem_jogada,
        db_contagem => db_cont,
        db_memoria => db_mem,
        db_jogada => db_jogada,
		  rodada => rodada_sig
    );

    UC: unidade_controle port map(
        resetP => resetP_sig,
        in_prep => in_prep_sig,
        fim_prep => fim_prep_sig,
        clock => clock,
        reset => reset,
        iniciar => iniciar,
        fim_jogo => fimCR_sig,
		  fim_rodada => enderecoIgualRodada_sig,
		  igual => jogada_correta_sig,
        jogada => jogada_feita_sig,
		  time_out => timeout_sig,
		  primeira_rodada => primeira_rodada_sig,
        zeraCR => zeraCR_sig,
        contaCR => contaCR_sig,
		  zeraE => zeraE_sig,
        contaE => contaE_sig,
        zeraR => zeraRC_sig,
		  zeraT => zeraT_sig,
        registraR => registraRC_sig,
		  escreve => escreve_sig,
        acertou => acertou,
        errou => errou,
        pronto => pronto,
		  db_esgotou => db_timeout,
        db_estado => out_estado,
		  db_ultima_rodada => db_ultima_rodada
    );
	 primeira_rodada_sig <= '1' when rodada_sig = "0000" else
									'0';
	 db_jogada_correta <= jogada_correta_sig;
	 db_fim_rodada <= enderecoIgualRodada_sig;
    db_clock <= clock;
	 estado_atual <= out_estado;
    HEX0: hexa7seg port map(hexa => db_cont, sseg => db_contagem);

    HEX1: hexa7seg port map(hexa => db_mem, sseg => db_memoria);

    HEX2: hexa7seg port map(hexa => db_jogada, sseg => db_jogadafeita);
	 
	 HEX3: hexa7seg port map(hexa => rodada_sig, sseg => db_rodada);

    HEX5: hexa7seg port map(hexa => out_estado, sseg => db_estado);

    end architecture;