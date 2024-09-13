import os
from dotenv import load_dotenv
load_dotenv()

from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain.schema import StrOutputParser

chat_llm = ChatOpenAI(
    openai_api_key=os.getenv('OPENAI_API_KEY'),
    model='gpt-4')

prompt = ChatPromptTemplate.from_messages(
    [
        (
            'system',
            'You are a surfer dude, having a conversation about the surf conditions on the beach. Respond using surfer slang.',
        ),
        (
            'human', 
            '{question}'
        ),
    ]
)

chat_chain = prompt | chat_llm | StrOutputParser()

while True:
    question = input('> ')
    response = chat_chain.invoke({'question': question})
    print(response)
