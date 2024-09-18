import os
from dotenv import load_dotenv
load_dotenv()

from langchain_openai import ChatOpenAI
from langchain_openai import OpenAIEmbeddings
from langchain_community.graphs import Neo4jGraph
from langchain_community.vectorstores.neo4j_vector import Neo4jVector
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain.chains import create_retrieval_chain
from langchain_core.prompts import ChatPromptTemplate

llm = ChatOpenAI(
    openai_api_key=os.getenv('OPENAI_API_KEY'),
    model='gpt-4'
    )

embeddings = OpenAIEmbeddings(openai_api_key=os.getenv('OPENAI_API_KEY'))

graph = Neo4jGraph(
    url=os.getenv('NEO4J_URI'),
    username=os.getenv('NEO4J_USERNAME'),
    password=os.getenv('NEO4J_PASSWORD'),
)

neo4jvector = Neo4jVector.from_existing_index(
    embeddings,
    graph=graph,
    index_name='moviePlots',
    node_label='Movie',
    text_node_property='plot',
    embedding_node_property='plotEmbedding',
    retrieval_query='''
RETURN
    node.title + ' - ' + node.plot AS text,
    score,
    {
        title: node.title,
        directors: [ (person)-[:DIRECTED]->(node) | person.name ],
        actors: [ (person)-[r:ACTED_IN]->(node) | [person.name, r.role] ],
        genres: [ (node)-[:IN_GENRE]->(genre) | genre.name ],
        tmdbId: node.tmdbId,
        source: 'https://www.themoviedb.org/movie/'+ node.tmdbId
    } AS metadata
'''
)

retriever = neo4jvector.as_retriever()

instructions = (
    'Use the given context to answer the question.'
    'If you dont know the answer, say you dont know.'
    'Context: {context}'
)

prompt = ChatPromptTemplate.from_messages(
    [
        ('system', instructions),
        ('human', '{input}'),
    ]
)

question_answer_chain = create_stuff_documents_chain(llm, prompt)
plot_retriever = create_retrieval_chain(
    retriever, 
    question_answer_chain
)

def get_movie_plot(input):
    return plot_retriever.invoke({'input': input})

if __name__ == '__main__':

    plot = input('> ')
    response = get_movie_plot(plot)
    print(response)



















# Queries

# a hilarious road trip
# Toys come alive
# get as far away from humanity as possible