library ieee;
use ieee.std_logic_1164.all;

entity circuito_exp4_desafio is
    port (
        clock : in std_logic;
        reset : in std_logic;
        iniciar : in std_logic;
        chaves : in std_logic_vector (3 downto 0);
        pronto : out std_logic;
        acertou : out std_logic;
        errou : out std_logic;
        leds : out std_logic_vector (3 downto 0);
        db_igual : out std_logic;
        db_contagem : out std_logic_vector (6 downto 0);
        db_memoria : out std_logic_vector (6 downto 0);
        db_estado : out std_logic_vector (6 downto 0);
        db_jogadafeita : out std_logic_vector (6 downto 0);
        db_clock : out std_logic;
        db_tem_jogada : out std_logic;
		  db_timeout : out std_logic
    );
end entity;

architecture assemble of circuito_exp4_desafio is
    component fluxo_dados is
        port (
				clock 			: in std_logic;
				zeraC 			: in std_logic;
				contaC 			: in std_logic;
				escreveM 		: in std_logic;
				zeraR 			: in std_logic;
				registraR 		: in std_logic;
				chaves 			: in std_logic_vector (3 downto 0);
				reset_timeout   : in std_logic;
				igual 			: out std_logic;
				fimC 				: out std_logic;
				jogada_feita 	: out std_logic;
				time_out        : out std_logic;
				db_tem_jogada 	: out std_logic;
				db_contagem 	: out std_logic_vector (3 downto 0);
				db_memoria 		: out std_logic_vector (3 downto 0);
				db_jogada 		: out std_logic_vector (3 downto 0)
        );
    end component;

    component unidade_controle is
        port (
			  clock : in std_logic;
			  reset : in std_logic;
			  iniciar : in std_logic;
			  fim : in std_logic;
			  jogada : in std_logic;
			  igual : in std_logic;
			  time_out : in std_logic;
			  zeraC : out std_logic;
			  contaC : out std_logic;
			  zeraR : out std_logic;
			  zeraT	: out std_logic;
			  registraR : out std_logic;
			  acertou : out std_logic;
			  errou : out std_logic;
			  esgotou : out std_logic;
			  pronto : out std_logic;
			  db_estado : out std_logic_vector(3 downto 0)
        );
    end component;

    component hexa7seg is
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component;

    signal zeraC_sig, contaC_sig, zeraR_sig, registraR_sig, fimC_sig, igual_sig, jogada_feita_sig, timeout_sig, zeraT_sig: std_logic;
    signal out_estado, db_cont, db_mem, db_jogada, db_timeo: std_logic_vector (3 downto 0);
begin
    FD: fluxo_dados port map(
        clock => clock,
        zeraC => zeraC_sig,
        contaC => contaC_sig,
        escreveM => '0',
        zeraR => zeraR_sig,
        registraR => registraR_sig,
        chaves => chaves,
        igual => igual_sig,
        fimC => fimC_sig,
		  time_out => timeout_sig,
		  reset_timeout => zeraT_sig,
        jogada_feita => jogada_feita_sig,
        db_tem_jogada => db_tem_jogada,
        db_contagem => db_cont,
        db_memoria => db_mem,
        db_jogada => db_jogada
    );

    UC: unidade_controle port map(
        clock => clock,
        reset => reset,
        iniciar => iniciar,
        fim => fimC_sig,
        jogada => jogada_feita_sig,
        igual => igual_sig,
		  time_out => timeout_sig,
        zeraC => zeraC_sig,
        contaC => contaC_sig,
        zeraR => zeraR_sig,
		  zeraT => zeraT_sig,
        registraR => registraR_sig,
        acertou => acertou,
        errou => errou,
        pronto => pronto,
		  esgotou => db_timeout,
        db_estado => out_estado
    );
	 
    db_igual <= igual_sig;
    db_clock <= clock;
    leds <= db_mem;
    HEX0: hexa7seg port map(hexa => db_cont, sseg => db_contagem);

    HEX1: hexa7seg port map(hexa => db_mem, sseg => db_memoria);

    HEX2: hexa7seg port map(hexa => db_jogada, sseg => db_jogadafeita);

    HEX5: hexa7seg port map(hexa => out_estado, sseg => db_estado);

    end architecture;