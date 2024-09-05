import os
from dotenv import load_dotenv
load_dotenv()

from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain.schema import StrOutputParser
from langchain.tools import Tool
from langchain.agents import AgentExecutor, create_react_agent
from langchain import hub
from plot_retriever_with_graph import get_movie_plot

llm = ChatOpenAI(
    openai_api_key=os.getenv('OPENAI_API_KEY'),
    model="gpt-4")

chat_prompt = ChatPromptTemplate.from_messages(
    [
        ("system", "You are a movie expert providing information about movies."),
        ("human", "{input}"),
    ]
)

movie_chat = chat_prompt | llm | StrOutputParser()

tools = [
    Tool.from_function(
        name="General Chat",
        description="For general movie chat not covered by other tools",
        func=movie_chat.invoke,
    ), 
    Tool.from_function(
        name="Movie Plot Search",  
        description="For when you need to find information about movies based on a plot",
        func=get_movie_plot, 
    )
]

agent_prompt = hub.pull("hwchase17/react")
agent = create_react_agent(llm, tools, agent_prompt)
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=True
    )

while True:
    question = input("> ")
    response = agent_executor.invoke({"input": question})
    print(response["output"])
