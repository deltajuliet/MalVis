//Common Query Templates 
// _'s are used to denote fields that need to be changed

// !!! ------ CREATE NODES ------ !!!
//CREATEs a node for the following common labels and properties
CREATE (bn:Botnet {name: '_NAME_' }) RETURN bn.name;
CREATE (dv:Delivery_Vector { name: '_NAME_' }) RETURN dv.name;
CREATE (dw:Downloader { name: '_NAME_' }) RETURN dw.name;
CREATE (ex:Exploit { name: '_NAME_' }) RETURN ex.name;
CREATE (in:Intel {name: '_NAME_', report_date: 'YYYY-MM-DD', url: '_URL_'}) RETURN in.name;
CREATE (is:Intel_Source { name: '_NAME_', url: '_URL_' }) RETURN is.name;
CREATE (mo:Motive { name: '_NAME_' }) RETURN mo.name;
CREATE (pa:Payload { name: '_NAME_' }) RETURN pa.name;
CREATE (sa:Sample { hash: '_HASH_' }, hash_type) RETURN sa.hash;
CREATE (se:Service { name: '_NAME_'}) RETURN se.name;
CREATE (st:Service_Type { name: '_NAME_' }) RETURN st.name;
CREATE (sw:Software { name: '_NAME_' }) RETURN sw.name;
CREATE (sd:Software_Developer { name: '_NAME_' }) RETURN sd.name;
CREATE (tr:Trojan {name: '_NAME_'}) RETURN tr.name;
CREATE (vu:Vulnerability { cve: '_VULNERABILITY_ID_', date_disclosed: 'YYYY-MM-DD', description: "VULN_DESCRIPTION" }) RETURN vu.name;

// !!! ------ CREATE CONSTRANTS AND INDEXES ------ !!!
CREATE CONSTRAINT ON (bn:Botnet) ASSERT bn.name IS UNIQUE;
CREATE CONSTRAINT ON (dn:Delivery_Vector) ASSERT dn.name IS UNIQUE;
CREATE CONSTRAINT ON (dw:Downloader) ASSERT dw.name IS UNIQUE;
CREATE CONSTRAINT ON (ex:Exploit) ASSERT ex.name IS UNIQUE;
CREATE CONSTRAINT ON (in:Intel) ASSERT in.name IS UNIQUE;
CREATE CONSTRAINT ON (mo:Motive) ASSERT mo.name IS UNIQUE;
CREATE CONSTRAINT ON (pa:Payload) ASSERT pa.name IS UNIQUE;
CREATE CONSTRAINT ON (sa:Sample) ASSERT sa.hash IS UNIQUE;
CREATE CONSTRAINT ON (se:Service) ASSERT se.name IS UNIQUE;
CREATE CONSTRAINT ON (st:Service_Type) ASSERT st.name IS UNIQUE;
CREATE CONSTRAINT ON (sw:Software) ASSERT sw.name IS UNIQUE;
CREATE CONSTRAINT ON (sd:Software_Developer) ASSERT sd.name IS UNIQUE;
CREATE CONSTRAINT ON (tr:Trojan) ASSERT tr.name IS UNIQUE;
CREATE CONSTRAINT ON (vu:Vulnerability) ASSERT vu.cve IS UNIQUE;

//NOTE CREATING A CONTSTRANT AUTOMATICALLY CREATES AN INDEX!!!

CREATE INDEX ON :Botnet(name);
CREATE INDEX ON :Delivery_Vector(name);
CREATE INDEX ON :Downloader(name);
CREATE INDEX ON :Exploit(name);
CREATE INDEX ON :Intel(name);
CREATE INDEX ON :Intel_Source(name);
CREATE INDEX ON :Motive(name);
CREATE INDEX ON :Payload(name);
CREATE INDEX ON :Sample(hash);
CREATE INDEX ON :Service(name);
CREATE INDEX ON :Service_Type(name);
CREATE INDEX ON :Software(name);
CREATE INDEX ON :Software_Developer(name);
CREATE INDEX ON :Trojan(name);
CREATE INDEX ON :Vulnerability(cve);

// !!! ------ CREATE RELATIONSHIPS ------ !!!
//Delivery of Downloader relationship
MATCH (dv:Delivery_Vector),(dw:Downloader)
WHERE dv.name = '_DELIVERY_VECTOR_NAME_' AND dw.name = '_DOWNLOADER_NAME_'
CREATE (dv) - [r:EXPOSES] -> (dw)
RETURN r;

//Delivery of Exploit relationship
MATCH (dv:Delivery_Vector),(ex:Exploit)
WHERE dv.name = '_DELIVERY_VECTOR_NAME_' AND ex.name = '_EXPLOIT_NAME_'
CREATE (dv) - [r:EXPOSES] -> (ex)
RETURN r;

//Downloader Payload relationship
MATCH (dw:Downloader),(pa:Payload)
WHERE dw.name = '_DOWNLOADER_NAME_' AND pa.name = '_PAYLOAD_NAME_'
CREATE (dw) - [r:DELIVERS] -> (pa)
RETURN r;

//Exploit Payload relationship
MATCH (ex:Exploit),(pa:Payload)
WHERE ex.name = '_EXPLOIT_NAME_' AND pa.name = '_PAYLOAD_NAME_'
CREATE (ex) - [r:DELIVERS] -> (pa)
RETURN r;

//Exploit Vuln relationship
MATCH (ex:Exploit),(vu:Vulnerability)
WHERE ex.name = '_EXPLOIT_NAME_' AND vu.cve = '_VULNERABILITY_ID_'
CREATE (ex) - [r:EXPLOITS] -> (vu)
RETURN r;

//Intel -> Downloader relationship
MATCH (in:Intel), (dw:Downloader)
WHERE in.name = '_INTEL_NAME_' AND dw.name = '_DOWNLOADER_NAME_'
CREATE (in) - [r:REPORTS] -> (dw)
RETURN r;

//Intel -> Exploit relationship
MATCH (in:Intel), (ex:Exploit)
WHERE in.name = '_INTEL_NAME_' AND ex.name = '_EXPLOIT_NAME_'
CREATE (in) - [r:REPORTS] -> (ex)
RETURN r;

//Intel -> Payload relationship
MATCH (in:Intel), (pa:Payload)
WHERE in.name = '_INTEL_NAME_' AND pa.name = '_PAYLOAD_NAME_'
CREATE (in) - [r:REPORTS] -> (pa)
RETURN r;

//Intel -> Trojan relationship
MATCH (in:Intel), (tr:Trojan)
WHERE in.name = '_INTEL_NAME_' AND tr.name = '_TROJAN_NAME_'
CREATE (in) - [r:REPORTS] -> (tr)
RETURN r;

//Intel -> Vulnerability relationship
MATCH (in:Intel), (vu:Vulnerability)
WHERE in.name = '_INTEL_NAME_' AND vu.cve = '_VULNERABILITY_CVE_'
CREATE (in) - [r:REPORTS] -> (vu)
RETURN r;

//Intel Source -> Intel relationship
MATCH (is:Intel_Source), (in:Intel)
WHERE is.name = '_INTEL_SOURCE_NAME_' AND in.name = '_INTEL_NAME_'
CREATE (is) - [r:REPORTS] -> (in)
RETURN r;

//Motive Payload relationship
MATCH (mo:Motive),(pa:Payload)
WHERE mo.name ='_MOTIVE_' AND pa.name = '_PAYLOAD_NAME_'
CREATE (mo) - [r:PROVOKES] -> (pa)
RETURN r;

//Payload Vuln relationship
MATCH (pa:Payload),(vu:Vulnerability)
WHERE pa.name = '_PAYLOAD_NAME_' AND vu.cve ='_VULNERABILITY_CVE_'
CREATE (pa) - [r:EXPLOITS] -> (vu)
RETURN r;

//Sample of Exploit relationship
MATCH (sa:Sample), (ex:Exploit)
WHERE sa.hash = '_HASH_' AND ex.name = '_EXPLOIT_NAME_'
CREATE (sa) - [r:EXAMPLE] -(ex)
RETURN r;

//Sample of Payload relationship
MATCH (sa:Sample), (pa:Payload)
WHERE sa.hash = '_HASH_' AND pa.name = '_PAYLOAD_NAME_'
CREATE (sa) - [r:EXAMPLE] -(pa)
RETURN r;

//Services related to Service Type
MATCH (se:Service),(st:Service_Type)
WHERE se.name = '_SERVICE_NAME_' AND st.name = '_SERVICE_NAME_'
CREATE (se) - [r:PROVIDES] -> (st)
RETURN r;

//Service Type provides delivery vector
MATCH (st:Service_Type),(dv:Delivery_Vector)
WHERE st.name = '_SERVICE_TYPE_NAME_' AND dv.name = '_DELIVERY_VECTOR_'
CREATE (st) - [r:ENABLES] -> (dv)
RETURN r;

//Software Developer related to Software
MATCH (sd:Software_Developer),(sw:Software)
WHERE sd.name = '_DEVELOPER_NAME_' AND sw.name = '_SOFTWARE_NAME_'
CREATE (sd) - [r:DEVELOPS] -> (sw)
RETURN r;

//Trojan -> Downloader
MATCH (tr:Trojan {name: '_TROJAN_NAME_'}),(dw:Downloader {name: '_DOWNLOADER_NAME_'})
CREATE (tr) - [r:INSTALLS] -> (dw);

//Trojan -> Payload
MATCH (tr:Trojan {name: '_TROJAN_NAME_'}),(pa:Payload {name: '_PAYLOAD_NAME_'})
CREATE (tr) - [r:INSTALLS] -> (pa);

//Vulnerability related to Software
MATCH (vu:Vulnerability),(sw:Software)
WHERE vu.cve = '_VULNERABILITY_CVE_' AND sw.name = '_SOFTWARE_NAME_'
CREATE (vu) - [r:TARGETS] -> (sw)
RETURN r;

// !!! ------ MATCH QUERIES (similar to SQL select) ------ !!!


// !!! ------ SIMPLE DELETE QUERIES ------ !!!
MATCH n
WHERE id(n) = _NODE_ID_
DELETE n


MATCH ()-[r]->()
WHERE id(r)= _RELATIONSHIP_ID_
DELETE r
