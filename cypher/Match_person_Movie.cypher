// Match person->Movie
MATCH (p:Person {name: "Keanu Reeves"})-[:ACTED_IN]->(m:Movie)
RETURN p, m
