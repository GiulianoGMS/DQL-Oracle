/* Inativa todos os códigos do segmento Mixter da LJ 54*/

UPDATE CONSINCO.MRL_PRODEMPSEG A
          SET  A.STATUSVENDA   = 'I',
               A.USUALTERACAO  = 'GIGOMES',
               A.INDREPLICACAO = 'S',
               A.DTAALTERACAO  = SYSDATE,
               A.MARGEMLUCROPRODEMPSEG = Null,
               A.DTAAPROVASTATUSVDA    = Null,
               A.USUAPROVASTATUSVDA    = Null  
               
       WHERE A.NROEMPRESA   = 54
         AND A.NROSEGMENTO  = 4
         AND A.STATUSVENDA  = 'A';
             
COMMIT;

/* Inativa todos os códigos no segmento Híbrido com qtd emb > 1 */

UPDATE CONSINCO.MRL_PRODEMPSEG A
          SET  A.STATUSVENDA   = 'I',
               A.USUALTERACAO  = 'GIGOMES',
               A.INDREPLICACAO = 'S',
               A.DTAALTERACAO  = SYSDATE,
               A.MARGEMLUCROPRODEMPSEG = Null,
               A.DTAAPROVASTATUSVDA    = Null,
               A.USUAPROVASTATUSVDA    = Null  
               
       WHERE A.NROEMPRESA   = 54
         AND A.NROSEGMENTO  = 7
         AND A.STATUSVENDA  = 'A'
         AND A.QTDEMBALAGEM > 1;
         --AND A.SEQPRODUTO NOT IN (620093,788274,147002,106740,444644,290418,208929,569354,159623,248890,733793,330527,124669,248541,312738,797672,592499,149211,290562,243520,121385,225836,192200,139151,166027,113090,229688,532402,713634,723671,449571,248414,592482,213533,479639,247142,676434,798839,100069,571944,109154,280761,212556,202886,217691,149303,414609,293303,805810,248191,138628,247057,270175,757294,850384,359504,216900,249848,528511,202862,524094,181471,210538,175005,228677,144575,438285,231804,243643,248197,112833,210021,195249,228755,282307,106818,860420,282260,187923,226875,209074,220527,403238,210552,414272,198899,836227,528382,234907,242216,218733,528450,217729,402194,249851,249854,235113,214273,247430,590044,401166,149242,249860,187398,249852,243810,229336,243251,220251,528559,249731,424677,240356,528481,249362,532747,218473,291927,621496,239802,835978,120050,368520,514675,249327,359467,835923,209575,248885,303965,481281,309950,835985,510790,257275,209574,752121,223378,800402,798945,218570,449557,249246,245969,322492,152426,818254,299343,218288,291903,455251,177054,740876,249859,228093,250482,209977,732840,284486,303941,835992,247940,100010,359498,836241,528443,217690,249855,220150,893435,248574,829724,233231,122795,269940,217110,387354,796408,156882,676465,194549,835916,152419,240360,445085,246868,218475,299671,216809,616348,248192,676427,189392,248540,857246,218323,150057,103787,220885,213062,133678,218569,249774,218571,517690,244423,187916,207978,250235,234003,474979,213059,241115,836135,299336,700665,246269,245972,178013,207587,243511,303972,769709,211669,543804,332989,679664,887502,226245,243371,538893,248895,104548,820776,382403,248894,218333,487726,313551,850117,463805,187374,821452,248889,291767,227259,217632,865388,248888,238987,721547,425445,392853,209570,797795,374989,143271,187930,374996,240358,194136,205487,300315,827430,227260,528474,585378,233205,243317,114981,248816,207278,226596,249135,122931,210926,210805,700634,242779,188098,242482,223193,275286,195218,249856,249861,290449,743143,268196,249583,862721,228058,692311,230202,248138,216796,790048,218369,247682,595919,241543,218091,445498,774598,242678,433969,192972,207273,156899,854795,241871,216810,295024,239066,387422,230658,236936,234015,618670,211646,242257,171311,245971,528399,282390,249168,241160,230654,118170,298568,207279,241873,210782,207277,282659,248892,248214,528498,210163,311519,245125,137201,232979,207274,207275,232981,368896,216795,216791,243957,207734,232983,246188,234021,739658,226860,207733,231658,359474,230660,248215,231674,245676,246827,234019,303996,517720,209881,428484,242254,249793,782074,122238,582056,524100,414012,301121,392884,5043,340892,186971,242221,240191,249794,840033,313575,216529,812092,237940,359481,206207,241265,284684,470643,343329,215672,400442,678759,177269,303989,243154,218668,249858,216433,218324,598736,303927,818216,249212,284592,480710,798587,238988,578523,240140,149556,153119,231683,239697,700597,104401,773775,213253,146999,240917,509145,795791,224426,232987,247677,249857,445092,906302,230308,847223,179799,102155,207737,226882,184311,284431,241161,100847,906296,751544,413930,773768,380386,240229,368872,869096,399227,392921,133900,249902,335225,176354,795937,317580,243612,509091,232993,797429,474849,218476,89746,197274,137027,221909,290579,802772,739634,240920,213844,242907,239231,719612,248559,247873,276665,208030,214851,739276,437813,906975,240188,243568,240362,234943,221915,206087,157292,115590,237418,212660,220135,222400,226868,270151,335218,767163,248487,224958,117715,286459,449106,236997,244509,739641,813105,616355,231655,444651,248212,248205,232009,509107,224959,226984,796385,104043,237769,592734,871358,853934,676519,218390,395366,813150,240190,238346,188050,368506,243405,385848,784702,273251,244062,160094,248292,870511,228773,372404,389655,246377,820516,223191,241565,714174,769884,232008,212449,291934,285551,590068,735636,237939,136518,282314,234661,261258,227530,292146,247802,243365,247896,168168,247486,243257,210521,262606,290203,248144,220057,249539,830942,241162,138352,785389,732741,454834,304887,742849,110501,243293,862738,162913,523462,209960,712088,249729,217649,231362,214926,211670,232969,348959,292245,184335,136235,291910,232985,184212,153287,189378,543767,234127,232977,534673,293334,9188,231787,242901,229423,217677,234151,232995,490115,167628,238630,198851,390972,206154,368889,220032,866279,340977,212123,217963,553650,230656,838054,222588,797740,620871,240359,246726,241159,439480,232967,853651,238057,135559,679657,249862,676403,532662,206235,249703,311540,250475,133111,212252,237212,282628,363532,178945,510455,563420,243364,847230,243896,767040,578004,273800,900676,184816,232997,160926,797719,545907,220909,856317,712699,485784,278164,209882,174893,207276,860604,209454,676373,184250,311489,526203,224957,232989,341424,118392,232971,487733,412636,290128,433952,249540,115780,132350,242796,487740,244044,220890,616331,241277,387613,242719,209075,228753,241291,510608,243366,246436,109772,420105,468572,833097,243792,224966,184465,239740,290586,214180,250097,208448,179782,678643,237190,149563,869102,218769,246376,532426,282321,208037,220291,174862,286824,223413,241346,312745,108997,282826,248824,46268,240369,110620,146982,161008,810005,247421,291323,239945,243690,349024,869751,873161,133999,248166,238897,149259,232999,220151,735858,212121,900645,187282,378321,246264,212139,180856,862745,584715,100854,847278,829748,742832,374927,744638,248213,833783,536820,860611,132343,295017,214902,700627,498272,240182,143295,249701,174848,676410,138857,508735,242774,444569,212910,313896,242679,617321,821810,212120,243668,275934,241600,241155,572828,189491,828291,206787,813174,840590,410021,174756,205407,188609,278751,283830,248830,222935,223415,197830,13007369,184731,220516,231314,948784,194402,241562,246080,241163,223120,220528,236635,590150,218389,174886,121280,193030,186858,241156,222934,205839,246466,136850,339599,108980,178051,243636,240187,214173,246079,948753,454841,237217,313957,174879,220005,246381,395175,205538,205539,110590,249953,453820,249538,180986,206967,243392,228101,174770,223882,231783,378215,168151,222332,212140,109789,193276,404990,620154,631921,579247,770118,222587,249977,509251,825955,207147,535632,900652,586351,205265,247916,243321,249367,186520,186544,186537,311496,404655
         --);
COMMIT;

/* Reconfere se todas as famílias e embalagens específicas estão ativas, ativa as que não estiverem ativadas (Não Utilizado)

UPDATE CONSINCO.MRL_PRODEMPSEG A
          SET  A.STATUSVENDA   = 'A',
               A.USUALTERACAO  = 'GIGOMES',
               A.INDREPLICACAO = 'S',
               A.DTAALTERACAO  = SYSDATE,
               A.MARGEMLUCROPRODEMPSEG = Null,
               A.DTAAPROVASTATUSVDA    = Null,
               A.USUAPROVASTATUSVDA    = Null  
               
       WHERE A.NROEMPRESA   = 54
         AND A.NROSEGMENTO  = 7
         AND A.STATUSVENDA  = 'I'
         AND A.SEQPRODUTO IN    (620093,788274,147002,106740,444644,290418,208929,569354,159623,248890,733793,330527,124669,248541,312738,797672,592499,149211,290562,243520,121385,225836,192200,139151,166027,113090,229688,532402,713634,723671,449571,248414,592482,213533,479639,247142,676434,798839,100069,571944,109154,280761,212556,202886,217691,149303,414609,293303,805810,248191,138628,247057,270175,757294,850384,359504,216900,249848,528511,202862,524094,181471,210538,175005,228677,144575,438285,231804,243643,248197,112833,210021,195249,228755,282307,106818,860420,282260,187923,226875,209074,220527,403238,210552,414272,198899,836227,528382,234907,242216,218733,528450,217729,402194,249851,249854,235113,214273,247430,590044,401166,149242,249860,187398,249852,243810,229336,243251,220251,528559,249731,424677,240356,528481,249362,532747,218473,291927,621496,239802,835978,120050,368520,514675,249327,359467,835923,209575,248885,303965,481281,309950,835985,510790,257275,209574,752121,223378,800402,798945,218570,449557,249246,245969,322492,152426,818254,299343,218288,291903,455251,177054,740876,249859,228093,250482,209977,732840,284486,303941,835992,247940,100010,359498,836241,528443,217690,249855,220150,893435,248574,829724,233231,122795,269940,217110,387354,796408,156882,676465,194549,835916,152419,240360,445085,246868,218475,299671,216809,616348,248192,676427,189392,248540,857246,218323,150057,103787,220885,213062,133678,218569,249774,218571,517690,244423,187916,207978,250235,234003,474979,213059,241115,836135,299336,700665,246269,245972,178013,207587,243511,303972,769709,211669,543804,332989,679664,887502,226245,243371,538893,248895,104548,820776,382403,248894,218333,487726,313551,850117,463805,187374,821452,248889,291767,227259,217632,865388,248888,238987,721547,425445,392853,209570,797795,374989,143271,187930,374996,240358,194136,205487,300315,827430,227260,528474,585378,233205,243317,114981,248816,207278,226596,249135,122931,210926,210805,700634,242779,188098,242482,223193,275286,195218,249856,249861,290449,743143,268196,249583,862721,228058,692311,230202,248138,216796,790048,218369,247682,595919,241543,218091,445498,774598,242678,433969,192972,207273,156899,854795,241871,216810,295024,239066,387422,230658,236936,234015,618670,211646,242257,171311,245971,528399,282390,249168,241160,230654,118170,298568,207279,241873,210782,207277,282659,248892,248214,528498,210163,311519,245125,137201,232979,207274,207275,232981,368896,216795,216791,243957,207734,232983,246188,234021,739658,226860,207733,231658,359474,230660,248215,231674,245676,246827,234019,303996,517720,209881,428484,242254,249793,782074,122238,582056,524100,414012,301121,392884,5043,340892,186971,242221,240191,249794,840033,313575,216529,812092,237940,359481,206207,241265,284684,470643,343329,215672,400442,678759,177269,303989,243154,218668,249858,216433,218324,598736,303927,818216,249212,284592,480710,798587,238988,578523,240140,149556,153119,231683,239697,700597,104401,773775,213253,146999,240917,509145,795791,224426,232987,247677,249857,445092,906302,230308,847223,179799,102155,207737,226882,184311,284431,241161,100847,906296,751544,413930,773768,380386,240229,368872,869096,399227,392921,133900,249902,335225,176354,795937,317580,243612,509091,232993,797429,474849,218476,89746,197274,137027,221909,290579,802772,739634,240920,213844,242907,239231,719612,248559,247873,276665,208030,214851,739276,437813,906975,240188,243568,240362,234943,221915,206087,157292,115590,237418,212660,220135,222400,226868,270151,335218,767163,248487,224958,117715,286459,449106,236997,244509,739641,813105,616355,231655,444651,248212,248205,232009,509107,224959,226984,796385,104043,237769,592734,871358,853934,676519,218390,395366,813150,240190,238346,188050,368506,243405,385848,784702,273251,244062,160094,248292,870511,228773,372404,389655,246377,820516,223191,241565,714174,769884,232008,212449,291934,285551,590068,735636,237939,136518,282314,234661,261258,227530,292146,247802,243365,247896,168168,247486,243257,210521,262606,290203,248144,220057,249539,830942,241162,138352,785389,732741,454834,304887,742849,110501,243293,862738,162913,523462,209960,712088,249729,217649,231362,214926,211670,232969,348959,292245,184335,136235,291910,232985,184212,153287,189378,543767,234127,232977,534673,293334,9188,231787,242901,229423,217677,234151,232995,490115,167628,238630,198851,390972,206154,368889,220032,866279,340977,212123,217963,553650,230656,838054,222588,797740,620871,240359,246726,241159,439480,232967,853651,238057,135559,679657,249862,676403,532662,206235,249703,311540,250475,133111,212252,237212,282628,363532,178945,510455,563420,243364,847230,243896,767040,578004,273800,900676,184816,232997,160926,797719,545907,220909,856317,712699,485784,278164,209882,174893,207276,860604,209454,676373,184250,311489,526203,224957,232989,341424,118392,232971,487733,412636,290128,433952,249540,115780,132350,242796,487740,244044,220890,616331,241277,387613,242719,209075,228753,241291,510608,243366,246436,109772,420105,468572,833097,243792,224966,184465,239740,290586,214180,250097,208448,179782,678643,237190,149563,869102,218769,246376,532426,282321,208037,220291,174862,286824,223413,241346,312745,108997,282826,248824,46268,240369,110620,146982,161008,810005,247421,291323,239945,243690,349024,869751,873161,133999,248166,238897,149259,232999,220151,735858,212121,900645,187282,378321,246264,212139,180856,862745,584715,100854,847278,829748,742832,374927,744638,248213,833783,536820,860611,132343,295017,214902,700627,498272,240182,143295,249701,174848,676410,138857,508735,242774,444569,212910,313896,242679,617321,821810,212120,243668,275934,241600,241155,572828,189491,828291,206787,813174,840590,410021,174756,205407,188609,278751,283830,248830,222935,223415,197830,13007369,184731,220516,231314,948784,194402,241562,246080,241163,223120,220528,236635,590150,218389,174886,121280,193030,186858,241156,222934,205839,246466,136850,339599,108980,178051,243636,240187,214173,246079,948753,454841,237217,313957,174879,220005,246381,395175,205538,205539,110590,249953,453820,249538,180986,206967,243392,228101,174770,223882,231783,378215,168151,222332,212140,109789,193276,404990,620154,631921,579247,770118,222587,249977,509251,825955,207147,535632,900652,586351,205265,247916,243321,249367,186520,186544,186537,311496,404655        
         );
COMMIT; */