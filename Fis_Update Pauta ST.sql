select MAP_PAUTAUFLOG.INDGERALOGREPLICACAO, MAP_PAUTAUFLOG.NROREGREPLICACAO, MAP_PAUTAUFLOG.SEQPAUTAUFLOG, MAP_PAUTAUFLOG.SEQPAUTA, MAP_PAUTAUFLOG.NROREGTRIBUTACAO, MAP_PAUTAUFLOG.UFORIGEM, MAP_PAUTAUFLOG.UFDESTINO, MAP_PAUTAUFLOG.DTAINICIO, MAP_PAUTAUFLOG.DTAFIM, MAP_PAUTAUFLOG.VLRBASEST, MAP_PAUTAUFLOG.FATORCONVERSAO, MAP_PAUTAUFLOG.APLICPERCACRESCST, MAP_PAUTAUFLOG.TIPCALCPAUTA, MAP_PAUTAUFLOG.SEQPORTARIA, MAP_PAUTAUFLOG.DTAALTERACAO, MAP_PAUTAUFLOG.USUALTERACAO                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
from MAP_PAUTAUFLOG Where  SEQPAUTA = 5333                           
       and  nroregtributacao = 2                                  
       Order By DTAINICIO DESC, DTAFIM DESC
       
UPDATE MAP_PAUTAUFLOG A SET A.TIPCALCPAUTA = 'M',
                            A.DTAALTERACAO = SYSDATE,
                            A.USUALTERACAO = 'CONSINCO'
 WHERE A.SEQPAUTA = 5333
   AND A.NROREGTRIBUTACAO = 2
   DTAFIM > DATE '2022-09-01';
   
   COMMIT;
