//DEMO DATA POINTS

//Contextual data points
MATCH (se:Service) RETURN se
MATCH (st:Service_Type) RETURN st
MATCH (dv:Delivery_Vector) RETURN dv

MATCH (dv:Delivery_Vector)<--(st:Service_Type) RETURN dv,st //Context specific relationship
MATCH (st:Service_Type)<--(se:Service) RETURN st,se

MATCH (dv:Delivery_Vector)<--(st:Service_Type)<--(se:Service) RETURN dv,st,se

MATCH ()-[r:DEVELOPS]->() RETURN r
MATCH (so:Software)<--(sd:Software_Developer) RETURN so,sd //Differences in returned data

MATCH (mo:Motive) RETURN no
MATCH (mo:Motive)-[*0..1]->(unk) RETURN mo,unk //New type of relationship, what if we don't know how things are related?

//Where are we getting this other stuff from
MATCH (is:Intel_Source) RETURN is
MATCH (in:Intel) RETURN in

MATCH (ex:Exploit) RETURN ex

//// Exploit kits their payloads and the intel associated
MATCH (ex:Exploit)-->(pa:Payload)<--(in:Intel) RETURN ex,pa,in

//// Exploit kits their payloads and the intel associated
MATCH (in2:Intel)-->(ex:Exploit)-->(pa:Payload)<--(in:Intel) RETURN ex,pa,in,in2 ///<--- slowish

//// Exploit Kits and their Vulnerabilities
MATCH ()-[r:EXPLOITS]->() RETURN r
MATCH (ex:Exploit)-->(vu:Vulnerability) RETURN ex,vu
MATCH (ex:Exploit)-->(vu:Vulnerability)-->(so:Software) RETURN ex,vu,so

//// Motive to payload to exploit to vuln
MATCH (mo:Motive {name:"Financial Extortion"})-->(pa:Payload)<--(ex:Exploit)-->(vu:Vulnerability)-->(so:Software) RETURN mo,pa,ex,vu,so

MATCH (mo:Motive {name:"Financial Extortion"})-->(pa:Payload)<--(ex:Exploit)-->(vu:Vulnerability)-->(so:Software) WHERE vu.date_disclosed =~ "2015-" RETURN mo,pa,ex,vu,so

MATCH (mo:Motive {name:"Financial Extortion"})-->(pa:Payload)<--(ex:Exploit)-->(vu:Vulnerability)-->(so:Software {name:"Flash Player"}) RETURN mo,pa,ex,vu,so

MATCH (sa:Sample)-[*0..2]->(unk) RETURN unk

MATCH n RETURN n;