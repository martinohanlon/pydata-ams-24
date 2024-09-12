// Create a "recommendations" sandbox at sandbox.neo4j.com

// Load the data
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/rec-embed/movie-plot-embeddings-1k.csv'
AS row
MATCH (m:Movie {movieId: row.movieId})
CALL db.create.setNodeVectorProperty(m, 'plotEmbedding', apoc.convert.fromJsonList(row.embedding))

LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/rec-embed/movie-poster-embeddings-1k.csv" AS row
match (m:Movie {movieId:row.movieId})
WITH row,m
CALL db.create.setNodeVectorProperty(m, 'posterEmbedding', apoc.convert.fromJsonList(row.posterEmbedding))

// Create the vector indexes
CREATE VECTOR INDEX moviePlots IF NOT EXISTS
FOR (m:Movie)
ON m.plotEmbedding
OPTIONS {indexConfig: {
 `vector.dimensions`: 1536,
 `vector.similarity_function`: 'cosine'
}}

CREATE VECTOR INDEX moviePosters IF NOT EXISTS
FOR (m:Movie)
ON m.posterEmbedding
OPTIONS {indexConfig: {
 `vector.dimensions`: 512,
 `vector.similarity_function`: 'cosine'
}}

// Set the OpenAI API token
:param {token: 'sk-...'}

// Create the GenAI Beyond Chat movie
MATCH (drama:Genre{name: "Drama"})
MATCH (adventure:Genre{name: "Adventure"})
MERGE (p:Person {name:"Martin O'Hanlon"})
SET p:Actor, p:Director
MERGE (m:Movie {title: "GenAI Beyond Chat"})
SET 
    m.plot = "A GenAI talk, where you will learn how Knowledge Graphs, Vectors and Retrieval Augmented Generation (RAG) can support your projects.",
    m.plotEmbedding = genai.vector.encode("A GenAI talk, where you will learn how Knowledge Graphs, Vectors and Retrieval Augmented Generation (RAG) can support your projects.", 'OpenAI', { token: $token })
MERGE (p)-[:ACTED_IN]-(m)
MERGE (p)-[:DIRECTED]-(m)
MERGE (m)-[:IN_GENRE]-(drama)
MERGE (m)-[:IN_GENRE]-(adventure)