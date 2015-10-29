//MalVis File Based Import
//Loads all possible data points in bulk



// !!! ------ CREATE NODES ------ !!!
CREATE CONSTRAINT ON (bn:Botnet) ASSERT bn.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-botnets.csv" AS csvLine
CREATE (bn:Botnet { name: csvLine.name })
RETURN bn;

CREATE CONSTRAINT ON (dn:Delivery_Vector) ASSERT dn.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-delivery_vectors.csv" AS csvLine
CREATE (dv:Delivery_Vector { name: csvLine.name });

CREATE CONSTRAINT ON (dw:Downloader) ASSERT dw.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-downloaders.csv" AS csvLine
CREATE (dw:Downloader { name: csvLine.name });

CREATE CONSTRAINT ON (ex:Exploit) ASSERT ex.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-exploits.csv" AS csvLine
CREATE (ex:Exploit { name: csvLine.name });

CREATE CONSTRAINT ON (in:Intel) ASSERT in.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-intel.csv" AS csvLine
CREATE (in:Intel { name: csvLine.name, report_date: csvLine.report_date, url:csvLine.url });

CREATE CONSTRAINT ON (is:Intel_Source) ASSERT is.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-intel_sources.csv" AS csvLine
CREATE (is:Intel_Source { name: csvLine.name, url: csvLine.url });

CREATE CONSTRAINT ON (mo:Motive) ASSERT mo.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-motives.csv" AS csvLine
CREATE (mo:Motive { name: csvLine.name });

CREATE CONSTRAINT ON (pa:Payload) ASSERT pa.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-payloads.csv" AS csvLine
CREATE (pa:Payload { name: csvLine.name });

CREATE CONSTRAINT ON (sa:Sample) ASSERT sa.hash IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-samples.csv" AS csvLine
CREATE (sa:Sample { hash: csvLine.hash, hash_type:csvLine.hash_type });

CREATE CONSTRAINT ON (se:Service) ASSERT se.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-services.csv" AS csvLine
CREATE (se:Service { name: csvLine.name });

CREATE CONSTRAINT ON (st:Service_Type) ASSERT st.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-service_types.csv" AS csvLine
CREATE (st:Service_Type { name: csvLine.name });

CREATE CONSTRAINT ON (sw:Software) ASSERT sw.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-software.csv" AS csvLine
CREATE (sw:Software { name: csvLine.name });

CREATE CONSTRAINT ON (sd:Software_Developer) ASSERT sd.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-software_developers.csv" AS csvLine
CREATE (sd:Software_Developer { name: csvLine.name });

CREATE CONSTRAINT ON (tr:Trojan) ASSERT tr.name IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-trojans.csv" AS csvLine
CREATE (tr:Trojan { name: csvLine.name });

CREATE CONSTRAINT ON (vu:Vulnerability) ASSERT vu.cve IS UNIQUE;
LOAD CSV WITH HEADERS FROM "file://_PATH_/nodes-vulnerabilities.csv" AS csvLine
CREATE (vu:Vulnerability { cve: csvLine.cve, date_disclosed: csvLine.date_disclosed, description: csvLine.description });

// !!! ------ CREATE RELATIONSHIPS ------ !!!
//Delivery of Downloader relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-delivery_vector>downloader.csv" AS csvLine
MATCH (dv:Delivery_Vector {name: csvLine.deliveryVectorNAME}),(dw:Downloader {name: csvLine.downloaderNAME})
CREATE (dv) - [r:EXPOSES] -> (dw);

//Delivery of Exploit relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-delivery_vector>exploit.csv" AS csvLine
MATCH (dv:Delivery_Vector {name: csvLine.deliveryVectorNAME}),(ex:Exploit {name: csvLine.exploitNAME})
CREATE (dv) - [r:EXPOSES] -> (ex);

//Delivery Vector -> Trojan
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-delivery_vector>trojan.csv" AS csvLine
MATCH (dv:Delivery_Vector {name: csvLine.deliveryVectorNAME}),(tr:Trojan {name: csvLine.trojanNAME})
CREATE (dv) - [r:EXPOSES] -> (tr);

//Downloader Payload relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-downloader>payload.csv" AS csvLine
MATCH (dw:Downloader {name: csvLine.downloaderNAME}),(pa:Payload {name: csvLine.payloadNAME})
CREATE (dw) - [r:DELIVERS] -> (pa);

//Exploit Payload relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-exploit>payload.csv" AS csvLine
MATCH (ex:Exploit {name: csvLine.exploitNAME}),(pa:Payload {name: csvLine.payloadNAME})
CREATE (ex) - [r:DELIVERS] -> (pa);

//Exploit Vuln relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-exploit>vulnerability.csv" AS csvLine
MATCH (ex:Exploit {name: csvLine.exploitNAME}),(vu:Vulnerability {cve: csvLine.vulnerabilityCVE})
CREATE (ex) - [r:EXPLOITS] -> (vu);

//Intel -> Downloader relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-intel>downloader.csv" AS csvLine
MATCH (in:Intel {name: csvLine.intelNAME}),(dw:Downloader {name: csvLine.downloaderNAME})
CREATE (in) - [r:REPORTS] -> (dw);

//Intel -> Exploit relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-intel>exploit.csv" AS csvLine
MATCH (in:Intel {name: csvLine.intelNAME}),(ex:Exploit {name: csvLine.exploitNAME})
CREATE (in) - [r:REPORTS] -> (ex);

//Intel -> Payload relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-intel>payload.csv" AS csvLine
MATCH (in:Intel {name: csvLine.intelNAME}),(pa:Payload {name: csvLine.payloadNAME})
CREATE (in) - [r:REPORTS] -> (pa);

//Intel -> Trojan relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-intel>trojan.csv" AS csvLine
MATCH (in:Intel {name: csvLine.intelNAME}),(tr:Trojan {name: csvLine.trojanNAME})
CREATE (in) - [r:REPORTS] -> (tr);

//Intel -> Vulnerability relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-intel>vulnerability.csv" AS csvLine
MATCH (in:Intel {name: csvLine.intelNAME}),(vu:Vulnerability {name: csvLine.vulnerabilityCVE})
CREATE (in) - [r:REPORTS] -> (vu);

//Intel Source -> Intel relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-intel_source>intel.csv" AS csvLine
MATCH (is:Intel_Source {name: csvLine.intelSourceNAME}),(in:Intel {name: csvLine.intelNAME})
CREATE (is) - [r:REPORTS] -> (in);

//Motive Payload relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-motive>payload.csv" AS csvLine
MATCH (mo:Motive {name: csvLine.motiveNAME}),(pa:Payload {name: csvLine.payloadNAME})
CREATE (mo) - [r:PROVOKES] -> (pa);

//Payload Vuln relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-payload>vulnerability.csv" AS csvLine
MATCH (pa:Payload {name: csvLine.payloadNAME}),(vu:Vulnerability {cve: csvLine.vulnerabilityCVE})
CREATE (pa) - [r:EXPLOITS] -> (vu);

//Sample of Exploit relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-sample>exploit.csv" AS csvLine
MATCH (sa:Sample {hash: csvLine.sampleHASH}),(ex:Exploit {name: csvLine.exploitNAME})
CREATE (sa) - [r:EXAMPLE] -> (ex);

//Sample of Payload relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-sample>payload.csv" AS csvLine
MATCH (sa:Sample {hash: csvLine.sampleHASH}),(pa:Payload {name: csvLine.payloadNAME})
CREATE (sa) - [r:EXAMPLE] -> (pa);

//Sample of Payload relationship
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-sample>trojan.csv" AS csvLine
MATCH (sa:Sample {hash: csvLine.sampleHASH}),(tr:Trojan {name: csvLine.trojanNAME})
CREATE (sa) - [r:EXAMPLE] -> (tr);

//Services related to Service Type
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-service>service_type.csv" AS csvLine
MATCH (se:Service {name: csvLine.serviceNAME}),(st:Service_Type {name: csvLine.serviceTypeNAME})
CREATE (se) - [r:PROVIDES] -> (st);

//Service Type provides delivery vector
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-service_type>delivery_vector.csv" AS csvLine
MATCH (st:Service_Type {name: csvLine.serviceTypeNAME}),(dv:Delivery_Vector {name: csvLine.deliveryVectorNAME})
CREATE (st) - [r:ENABLES] -> (dv);

//Software Developer related to Software
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-software_developer>software.csv" AS csvLine
MATCH (sd:Software_Developer {name: csvLine.softwareDeveloperNAME}),(sw:Software {name: csvLine.softwareNAME})
CREATE (sd) - [r:DEVELOPS] -> (sw);

//Trojan -> Downloader
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-trojan>downloader.csv" AS csvLine
MATCH (tr:Trojan {name: csvLine.trojanNAME}),(dw:Downloader {name: csvLine.downloaderNAME})
CREATE (tr) - [r:INSTALLS] -> (dw);

//Vulnerability related to Software
LOAD CSV WITH HEADERS FROM "file://_PATH_/relationships-vulnerability>software.csv" AS csvLine
MATCH (vu:Vulnerability {cve: csvLine.vulnerabilityCVE}),(sw:Software {name: csvLine.softwareNAME})
CREATE (vu) - [r:TARGETS] -> (sw);