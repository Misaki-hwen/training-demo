import os

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base


db_host = os.getenv("DB_HOST", "localhost")
db_name = os.getenv("DB_NAME", "test")
db_user = os.getenv("DB_USER", "root")
db_password = os.getenv("DB_PASSWORD", "root")

DATABASE_URL = f"mysql+pymysql://{db_user}:{db_password}@{db_host}/{db_name}?charset=utf8mb4"

engine = create_engine(DATABASE_URL, echo=False, future=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

