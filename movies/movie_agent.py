import os
from dotenv import load_dotenv
load_dotenv()

from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain.schema import StrOutputParser
from langchain.tools import Tool
from langchain.agents import AgentExecutor, create_react_agent
from langchain import hub

llm = ChatOpenAI(
    openai_api_key=os.getenv('OPENAI_API_KEY'),
    model='gpt-4')

chat_prompt = ChatPromptTemplate.from_messages(
    [
        ('system', 'You are a movie expert providing information about movies.'),
        ('human', '{input}'),
    ]
)

movie_chat = chat_prompt | llm | StrOutputParser()

tools = [
    Tool.from_function(
        name='General Chat',
        description='For general movie chat not covered by other tools',
        func=movie_chat.invoke,
    ),
]

agent_prompt = hub.pull('hwchase17/react')
agent = create_react_agent(llm, tools, agent_prompt)
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=True
    )

while True:
    question = input('> ')
    response = agent_executor.invoke({'input': question})
    print(response['output'])










# Questions

# no retriever:
# what are the best comedy movies?
# tell me about the movie Loop Track

# with retriever:
# find a movie about friendly ghosts in a haunted house
# find a movie about wanting to get as far away from humanity as possible?


# with graph retriever:
# what genres are movies about aliens landing on earth in?
# who acted in movies with plots about aliens landing on earth?
# who directed the movie that is about vectors, knowledge graphs and genai?





# snippets
# importtool
# tool