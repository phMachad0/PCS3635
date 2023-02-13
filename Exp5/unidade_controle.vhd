--------------------------------------------------------------------
-- Arquivo   : unidade_controle.vhd
-- Projeto   : Experiencia 3 - Projeto de uma unidade de controle
--------------------------------------------------------------------
-- Descricao : unidade de controle 
--
--             1) codificação VHDL (maquina de Moore)
--
--             2) definicao de valores da saida de depuracao
--                db_estado
-- 
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     20/01/2022  1.0     Edson Midorikawa  versao inicial
--     22/01/2023  1.1     Edson Midorikawa  revisao
--------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is
    port (
        clock : in std_logic;
        reset : in std_logic;
        iniciar : in std_logic;
        fim_rodada : in std_logic;
        fim_jogo    : in std_logic;
        jogada : in std_logic;
        igual : in std_logic;
		time_out : in std_logic;
        zeraCR : out std_logic;
        contaCR : out std_logic;
        zeraE : out std_logic;
        contaE : out std_logic;
        zeraR : out std_logic;
		zeraT	: out std_logic;
        registraR : out std_logic;
        acertou : out std_logic;
        errou : out std_logic;
		db_esgotou : out std_logic;
        pronto : out std_logic;
        db_estado : out std_logic_vector(3 downto 0)
    );
end entity;

architecture fsm of unidade_controle is
    type t_estado is (inicial, preparacao, ini_rodada, espera, registra, comparacao, ultima_jogada, proxima_jogada, proxima_rodada, acerto, erro, esgotado);
    signal Eatual, Eprox: t_estado;
begin

    -- memoria de estado
    process (clock,reset)
    begin
        if reset='1' then
            Eatual <= inicial;
        elsif clock'event and clock = '1' then
            Eatual <= Eprox; 
        end if;
    end process;

    -- logica de proximo estado
    Eprox <=
        inicial     when Eatual = inicial and iniciar='0' else
        preparacao  when (Eatual=inicial or Eatual=acerto or Eatual=erro or Eatual=esgotado) and iniciar='1' else
        ini_rodada  when Eatual = preparacao or Eatual = proxima_rodada else
        espera      when Eatual = ini_rodada or Eatual = proxima_jogada or (Eatual=espera and jogada='0' and time_out='0') else
        esgotado    when Eatual = espera and jogada='0' and time_out = '1' else
        registra    when  Eatual=espera and jogada='1' else
        comparacao  when Eatual = registra else
        proxima_jogada    when Eatual = comparacao and fim_rodada = '0' and igual = '1' else
        ultima_jogada     when Eatual = comparacao and fim_rodada = '1' and igual = '1' else
        erro              when (Eatual = comparacao and igual = '0') or (Eatual = erro and iniciar='0') else
        acerto            when (Eatual = ultima_jogada and fim_jogo = '1') or (Eatual = acerto and iniciar='0') else 
        proxima_rodada    when (Eatual = ultima_jogada and fim_jogo = '0') else
        Eatual;

    -- logica de saída (maquina de Moore)
    with Eatual select
        zeraCR <=      '1' when preparacao,
                      '0' when others;

    with Eatual select
        zeraE <=      '1' when preparacao | ini_rodada,
                      '0' when others;
    
    with Eatual select
        zeraR <=      '1' when inicial | preparacao,
                      '0' when others;
    
    with Eatual select
        registraR <=  '1' when registra,
                      '0' when others;

    with Eatual select
        contaE <=    '1' when proxima_jogada,
                      '0' when others;

    with Eatual select
        contaCR <=    '1' when proxima_rodada,
                      '0' when others;
    
    with Eatual select
        pronto <=     '1' when acerto | erro | esgotado,
                      '0' when others;

    with Eatual select
        acertou <=     '1' when acerto,
                       '0' when others;
    
    with Eatual select
        errou <=       '1' when erro | esgotado,
                       '0' when others;

    with Eatual select
        db_esgotou <=     '1' when esgotado,
                       '0' when others;
							  
    with Eatual select
        zeraT <=       '1' when ini_rodada | proxima_jogada,
                       '0' when others;

    -- saida de depuracao (db_estado)
    with Eatual select
        db_estado <= "0000" when inicial,     -- 0
                     "0001" when preparacao,  -- 1
                     "0010" when espera,      -- 2
                     "0011" when ini_rodada,   -- 3
                     "0100" when registra,    -- 4
                     "0101" when comparacao,  -- 5
                     "0110" when proxima_jogada,   -- 6
                     "0111" when ultima_jogada,     -- 7
                     "1000" when proxima_rodada,    -- 8
                     "1100" when acerto,      -- C
                     "1101" when erro,        -- D
							"1110" when esgotado,     -- E
                     "1111" when others;      -- F

end architecture fsm;
