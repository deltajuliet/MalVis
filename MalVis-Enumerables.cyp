CREATE CONSTRAINT ON (dn:Delivery_Vector) ASSERT dn.name IS UNIQUE;
CREATE (dv:Delivery_Vector { name: 'Compromised Website' }) RETURN dv.name;
CREATE (dv:Delivery_Vector { name: 'Malvertising' }) RETURN dv.name;
CREATE (dv:Delivery_Vector { name: 'Phishing' }) RETURN dv.name;
CREATE (dv:Delivery_Vector { name: 'Spearphising' }) RETURN dv.name;
CREATE (dv:Delivery_Vector { name: 'Traffic Delivery System' }) RETURN dv.name;

CREATE CONSTRAINT ON (mo:Motive) ASSERT mo.name IS UNIQUE;
CREATE (mo:Motive { name: 'Click-Fraud' }) RETURN mo.name;
CREATE (mo:Motive { name: 'Financial Extortion' }) RETURN mo.name;

CREATE CONSTRAINT ON (se:Service) ASSERT se.name IS UNIQUE;
CREATE (se:Service { name: 'SMTP'}) RETURN se.name;
CREATE (se:Service { name: 'SMTPS'}) RETURN se.name;
CREATE (se:Service { name: 'IMAP'}) RETURN se.name;
CREATE (se:Service { name: 'IMAP3'}) RETURN se.name;
CREATE (se:Service { name: 'IMAPS'}) RETURN se.name;
CREATE (se:Service { name: 'POP3'}) RETURN se.name;
CREATE (se:Service { name: 'POPS'}) RETURN se.name;

CREATE CONSTRAINT ON (st:Service_Type) ASSERT st.name IS UNIQUE;
CREATE (st:Service_Type { name: 'Email' }) RETURN st.name;

CREATE CONSTRAINT ON (se:Service) ASSERT se.name IS UNIQUE;
CREATE (se:Service { name: 'HTTP'}) RETURN se.name;
CREATE (se:Service { name: 'HTTPS'}) RETURN se.name;

CREATE CONSTRAINT ON (st:Service_Type) ASSERT st.name IS UNIQUE;
CREATE (st:Service_Type { name: 'Web' }) RETURN st.name;

CREATE INDEX ON :Delivery_Vector(name);
CREATE INDEX ON :Motive(name);
CREATE INDEX ON :Service(name);
CREATE INDEX ON :Service_Type(name);

//Service Types related to Services
MATCH (st:Service_Type),(se:Service)
WHERE st.name = 'Email' AND se.name = 'SMTP'
CREATE (se) - [r:PROVIDES] -> (st)
RETURN r;

//Service Types related to Services
MATCH (st:Service_Type),(se:Service)
WHERE st.name = 'Email' AND se.name = 'SMTPS'
CREATE (se) - [r:PROVIDES] -> (st)
RETURN r;

//Service Types related to Services
MATCH (st:Service_Type),(se:Service)
WHERE st.name = 'Email' AND se.name = 'IMAP'
CREATE (se) - [r:PROVIDES] -> (st)
RETURN r;

//Service Types related to Services
MATCH (st:Service_Type),(se:Service)
WHERE st.name = 'Email' AND se.name = 'IMAP3'
CREATE (se) - [r:PROVIDES] -> (st)
RETURN r;

//Service Types related to Services
MATCH (st:Service_Type),(se:Service)
WHERE st.name = 'Email' AND se.name = 'IMAPS'
CREATE (se) - [r:PROVIDES] -> (st)
RETURN r;

//Service Types related to Services
MATCH (st:Service_Type),(se:Service)
WHERE st.name = 'Email' AND se.name = 'POP3'
CREATE (se) - [r:PROVIDES] -> (st)
RETURN r;

//Service Types related to Services
MATCH (st:Service_Type),(se:Service)
WHERE st.name = 'Email' AND se.name = 'POPS'
CREATE (se) - [r:PROVIDES] -> (st)
RETURN r;

//Service Types related to Services
MATCH (st:Service_Type),(se:Service)
WHERE st.name = 'Web' AND se.name = 'HTTP'
CREATE (se) - [r:PROVIDES] -> (st)
RETURN r;
//Service Types related to Services
MATCH (st:Service_Type),(se:Service)
WHERE st.name = 'Web' AND se.name = 'HTTPS'
CREATE (se) - [r:PROVIDES] -> (st)
RETURN r;

//Service provides delivery vector
MATCH (st:Service_Type),(dv:Delivery_Vector)
WHERE st.name = 'Email' AND dv.name = 'Phishing'
CREATE (st) - [r:ENABLES] -> (dv)
RETURN r;

//Service provides delivery vector
MATCH (st:Service_Type),(dv:Delivery_Vector)
WHERE st.name = 'Email' AND dv.name = 'Spearphising'
CREATE (st) - [r:ENABLES] -> (dv)
RETURN r;

//Service provides delivery vector
MATCH (st:Service_Type),(dv:Delivery_Vector)
WHERE st.name = 'Web' AND dv.name = 'Compromised Website'
CREATE (st) - [r:ENABLES] -> (dv)
RETURN r;

//Service provides delivery vector
MATCH (st:Service_Type),(dv:Delivery_Vector)
WHERE st.name = 'Web' AND dv.name = 'Malvertising'
CREATE (st) - [r:ENABLES] -> (dv)
RETURN r;

//Service provides delivery vector
MATCH (st:Service_Type),(dv:Delivery_Vector)
WHERE st.name = 'Web' AND dv.name = 'Traffic Delivery System'
CREATE (st) - [r:ENABLES] -> (dv)
RETURN r;