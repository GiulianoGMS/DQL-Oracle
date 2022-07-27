SELECT seqmovtoestq,nroempresa,dtaentradasaida,seqproduto, 
                                        tiplancto,local,codgeraloper,tipusocgo, 
                                        qtdlancto,valorvlrnf,valoripi,valoricms, 
                                        valoricmsst,valordespnf,valordespforanf, 
            valordctoforanf, 
                                        valorcomissao,valoriss,valorpis,valorcofins, 
                                        nronfcupom,recalcustomedio,acmcompravenda,acmmediavenda, 
                                        geralteracaoestq,geralteracaoestqfisc,indusaverbabonif, 
                                        nrodocumento,dtahorlancto,usulancto,indgeracredipi, 
                                        vlricmsantecipado,vlricmspresumido,historico,motivomovto, 
                                        seqloteestoque,nrosegmento,perdespoperacional,ressarcstvenda FROM MRL_LANCTOESTOQUE A WHERE SEQPRODUTO = 42116 AND A.NROEMPRESA = 14
                                        AND QTDLANCTO = 0
