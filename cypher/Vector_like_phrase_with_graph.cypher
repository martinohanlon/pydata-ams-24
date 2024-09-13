// Vector - like phrase with graph
WITH genai.vector.encode(
    "A mysterious spaceship lands Earth",
    "OpenAI",
    { token: $token }) 
AS myMoviePlot

CALL db.index.vector.queryNodes('moviePlots', 6, myMoviePlot)

YIELD node, score

RETURN 
    node.title, score, node.plot AS text, node.tmdbId,
    [ (person)-[:DIRECTED]->(node) | person.name ] as directors,
    [ (person)-[r:ACTED_IN]->(node) | [person.name, r.role] ] as actors,
    [ (node)-[:IN_GENRE]->(genre) | genre.name ] as genres