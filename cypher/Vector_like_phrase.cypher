// Vector - like phrase
WITH genai.vector.encode(
    "A mysterious spaceship lands Earth",
    "OpenAI",
    { token: $token }) 
AS myMoviePlot

CALL db.index.vector.queryNodes('moviePlots', 6, myMoviePlot)

YIELD node, score

RETURN node.title, score, node.plot
