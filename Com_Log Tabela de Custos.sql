SELECT DISTINCT A.DTAULTALTERACAO, A.DTAINICIOVIGOR, A.DTAHORAPROVREPROV, A.USUAPROVREPROV, A.USUULTALTERACAO, A.VLRCUSTOBASE, A.VLRIPIPAUTA,
                       A.ALIQUOTAIPI, VLRIPI,
                       A.INDSOMAFRETEBASEIPI,
                       A.INDSOMADESPBASEIPI,
                       A.INDDESCONSIDIPISTDESP,
                       A.VLRIPI,
                       A.SITUACAONFIPI,
                       A.INDSOMAIPIBASEST, row_number() over (order by A.NRODIVISAO, A.UFEMPRESA, A.SEQCUSTOFORNEC desc) LINHA, A.*
            from    CONSINCO.MAC_CUSTOFORNECLOG A
            where   A.SEQFORNECEDOR    = 115780
            and     A.SEQFAMILIA       = 20408
            and     A.Nrodivisao       = 1
            and     A.UFEMPRESA        = 'SP'

ORDER BY 3 DESC
