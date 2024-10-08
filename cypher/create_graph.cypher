// Create a 'recommendations' sandbox at sandbox.neo4j.com

// Set the OpenAI API token
:param {token: 'sk-...'};

// Load the data
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/rec-embed/movie-plot-embeddings-1k.csv'
AS row
MATCH (m:Movie {movieId: row.movieId})
CALL db.create.setNodeVectorProperty(m, 'plotEmbedding', apoc.convert.fromJsonList(row.embedding));

LOAD CSV WITH HEADERS FROM 'https://data.neo4j.com/rec-embed/movie-poster-embeddings-1k.csv' AS row
match (m:Movie {movieId:row.movieId})
WITH row,m
CALL db.create.setNodeVectorProperty(m, 'posterEmbedding', apoc.convert.fromJsonList(row.posterEmbedding));

// Create the vector indexes
CREATE VECTOR INDEX moviePlots IF NOT EXISTS
FOR (m:Movie)
ON m.plotEmbedding
OPTIONS {indexConfig: {
 `vector.dimensions`: 1536,
 `vector.similarity_function`: 'cosine'
}};

CREATE VECTOR INDEX moviePosters IF NOT EXISTS
FOR (m:Movie)
ON m.posterEmbedding
OPTIONS {indexConfig: {
 `vector.dimensions`: 512,
 `vector.similarity_function`: 'cosine'
}};

// Create loop track movie
MATCH (thriller:Genre{name: 'Thriller'})
MERGE (t:Person {name:'Thomas Sainsbury'})
SET t:Actor, t:Director
MERGE (n:Person {name:'Noa Campbell'})
SET n:Actor
MERGE (lt:Movie {title: 'Loop Track'})
SET 
    lt.plot = 'Ian wants to get as far away from humanity as possible and heads into the New Zealand bush, but a four day journey turns into a fight for survival.',
    lt.plotEmbedding = genai.vector.encode('Ian wants to get as far away from humanity as possible and heads into the New Zealand bush, but a four day journey turns into a fight for survival.', 'OpenAI', { token: $token })
MERGE (t)-[tr:ACTED_IN]->(lt)
SET tr.roles = ['Ian']
MERGE (n)-[nr:ACTED_IN]->(lt)
SET nr.roles = ['Danielle']
MERGE (t)-[:DIRECTED]->(lt)
MERGE (lt)-[:IN_GENRE]->(thriller);


// Create the GenAI Beyond Chat movie
MATCH (drama:Genre{name: 'Drama'})
MATCH (adventure:Genre{name: 'Adventure'})
MERGE (p:Person {name:'Martin O\'Hanlon'})
SET p:Actor, p:Director
MERGE (m:Movie {title: 'GenAI Beyond Chat'})
SET 
    m.plot = 'A GenAI talk, where you will learn how Knowledge Graphs, Vectors and Retrieval Augmented Generation (RAG) can support your projects.',
    m.plotEmbedding = genai.vector.encode('A GenAI talk, where you will learn how Knowledge Graphs, Vectors and Retrieval Augmented Generation (RAG) can support your projects.', 'OpenAI', { token: $token })
MERGE (p)-[:ACTED_IN]->(m)
MERGE (p)-[:DIRECTED]->(m)
MERGE (m)-[:IN_GENRE]->(drama)
MERGE (m)-[:IN_GENRE]->(adventure);