Select Initcap(Nvl(Gv$session.Username, '{Oracle}')), Gv$session.Sid, Gv$session.Serial#, Trim(To_Char(Trunc(Gv$session.Last_Call_Et / 60 / 60))) || ':' || 
        Trim(To_Char(Trunc(Mod(Gv$session.Last_Call_Et, 3600) / 60), '00')) || ':' || 
        Trim(To_Char(Mod(Mod(Gv$session.Last_Call_Et, 3600), 60), '00')) lastcall, Gv$instance.inst_id, Initcap(Gv$instance.instance_name), Decode(Gv$session.Blocking_Session, Null, Null, 'SID ' || Gv$session.Blocking_Session) , Initcap(Gv$session.Status) , Initcap(Gv$session.Osuser), Initcap(Gv$session.Machine), Initcap(Gv$session.Program), Initcap(Decode( 
Dba_Scheduler_Running_Jobs.Job_Name, Null,  
Decode(Dba_Jobs_Running.Job, Null, Gv$session.Module, 'Job ' || Dba_Jobs_Running.Job), 'Sch ' || dba_Scheduler_Running_Jobs.Job_Name)), Gv$session.Logon_time, Gv$session.Client_Info From Gv$session, Gv$sess_Io, Gv$process, Gv$instance, Dba_Jobs_Running, Dba_Scheduler_Running_Jobs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Where  Gv$session.Sid = Gv$sess_Io.Sid(+) 
           And Gv$session.Inst_Id = Gv$sess_Io.Inst_Id(+) 
           And Gv$session.Paddr = Gv$process.Addr(+) 
           And Gv$session.Inst_Id = Gv$process.Inst_Id 
           And Gv$session.Inst_Id = Gv$instance.Inst_Id 
         And Gv$session.Sid = Dba_Jobs_Running.Sid(+) 
         And Gv$session.Sid = Dba_Scheduler_Running_Jobs.Session_id(+) And Gv$session.Username Is Not Null And Gv$session.status = 'ACTIVE'  Order By Gv$session.sid
