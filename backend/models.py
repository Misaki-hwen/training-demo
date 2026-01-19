from sqlalchemy import Column, BigInteger, String, Enum, Integer, Text, Date, DateTime, DECIMAL, ForeignKey, Boolean
from sqlalchemy.orm import relationship

from .database import Base


class User(Base):
    __tablename__ = "user"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    username = Column(String(64), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    role = Column(Enum("enterprise", "operation", "school", "student", name="user_role"), nullable=False)
    full_name = Column(String(100))
    email = Column(String(100))
    phone = Column(String(20))


class Enterprise(Base):
    __tablename__ = "enterprise"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id = Column(BigInteger, ForeignKey("user.id"), nullable=False)
    name = Column(String(200), nullable=False)
    contact_name = Column(String(100))
    contact_phone = Column(String(20))
    contact_email = Column(String(100))

    user = relationship("User")


class TrainingPlan(Base):
    __tablename__ = "training_plan"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    enterprise_id = Column(BigInteger, ForeignKey("enterprise.id"), nullable=False)
    name = Column(String(200), nullable=False)
    position_type = Column(String(100))
    headcount = Column(Integer, nullable=False)
    budget = Column(DECIMAL(12, 2))
    education_requirements = Column(String(255))
    major_requirements = Column(String(255))
    skills_requirements = Column(String(255))
    start_date = Column(Date)
    end_date = Column(Date)
    location = Column(String(100))
    settlement_method = Column(Enum("Post", "Phased", name="settlement_method"), default="Post")
    status = Column(Enum("Draft", "Pending", "Auditing", "Approved", "Rejected", name="plan_status"), default="Draft")
    remark = Column(Text)

    enterprise = relationship("Enterprise")


