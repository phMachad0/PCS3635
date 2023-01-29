library ieee;
use ieee.std_logic_1164.all

entity circuito_exp3 is
    port (
        clock : in std_logic;
        reset : in std_logic;
        iniciar : in std_logic;
        chaves : in std_logic_vector (3 downto 0);
        pronto : out std_logic;
        db_igual : out std_logic;
        db_iniciar : out std_logic;
        db_contagem : out std_logic_vector (6 downto 0);
        db_memoria : out std_logic_vector (6 downto 0);
        db_chaves : out std_logic_vector (6 downto 0);
        db_estado : out std_logic_vector (6 downto 0)
    );
end entity;

architecture behh of circuito_exp3 is
    component fluxo_dados is
        port (
            clock               : in  std_logic;
            zeraC               : in  std_logic;
            contaC              : in  std_logic;
            escreveM            : in  std_logic;
            zeraR               : in  std_logic;
            registraR           : in  std_logic;
            chaves              : in  std_logic_vector (3 downto 0);
            chavesIgualMemoria  : out std_logic;
            fimC                : out std_logic;
            db_contagem         : out std_logic_vector (3 downto 0);
            db_memoria          : out std_logic_vector (3 downto 0);
            db_chaves           : out std_logic_vector (3 downto 0)
        );
      end component;

    component unidade_controle is 
        port ( 
            clock     : in  std_logic; 
            reset     : in  std_logic; 
            iniciar   : in  std_logic;
            fimC      : in  std_logic;
            zeraC     : out std_logic;
            contaC    : out std_logic;
            zeraR     : out std_logic;
            registraR : out std_logic;
            pronto    : out std_logic;
            db_estado : out std_logic_vector(3 downto 0)
        );
    end component;
        signal zeraC_sig, contaC_sig, zeraR_sig, registraR_sig, fimC_sig : std_logic;
        signal out_estado, out_cont, out_mem, out_chaves: std_logic_vector (3 downto 0)
begin
    FD: fluxo_dados port map(
        clock => clock,
        zeraC => zeraC_sig
        contaC => contaC_sig
        escreveM => '0'
        zeraR => zeraR_sig
        registraR => registraR_sig
        chaves => chaves
        chavesIgualMemoria => db_igual
        fimC => fimC_sig
        db_contagem => out_cont
        db_memoria => out_mem
        db_chaves => out_chaves
    );

    UC: unidade_controle port map(
        clock => clock,
        reset => reset
        iniciar => iniciar
        fimC => fimC_sig
        zeraC => zeraC_sig
        contaC => contaC_sig
        zeraR => zeraR_sig
        registraR => registraR_sig
        pronto => pronto
        db_estado => out_estado
    );

    HEX0: 

    HEX1

    HEX2

    HEX5