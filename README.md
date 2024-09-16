# Pydata Amsterdam 2024

Slides and code examples from the [GenAI Beyond Chat with RAG, Knowledge Graphs and Python talk](https://amsterdam2024.pydata.org/cfp/talk/F9AWKJ/) at Pydata Amsterdam 2024.

## OpenAI

You will need an OpenAI API key which you can get at [platform.openai.com](https://platform.openai.com).

## Database

You will need a Neo4j database loaded with the [recommendations dataset](https://github.com/neo4j-graph-examples/recommendations).

You can create a new _recommendations_ sandbox at [sandbox.neo4j.com](https://sandbox.neo4j.com).

If running your own Neo4j database, you will need to install [APOC](https://neo4j.com/docs/apoc/current/) and the [genai](https://neo4j.com/docs/cypher-manual/current/genai-integrations/) plugins.

Update the recommendations dataset with embeddings and vector indexes by running the `cypher\create_graph.cypher` Cypher script.

> You will need to add your own OpenAI API key to the script.

## Environment

Create a new `.env` file in the root of this respositoy.

Copy the contents of the `.env.example` file.

Add your Neo4j connection details and OpenAI key.

## Python install

You will need to install the Python pre-requisites.

```bash
pip install -r requirements.txt
```

:)