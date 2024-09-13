// Match person->Movie
MATCH (p:Person {title: "Keanu Reeves"})-[:ACTED_IN]->(m:Movie)
RETURN p, m
