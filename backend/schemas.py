from datetime import date

from pydantic import BaseModel


class TrainingPlanCreate(BaseModel):
    enterprise_id: int
    name: str
    position_type: str | None = None
    headcount: int
    budget: float | None = None
    education_requirements: str | None = None
    major_requirements: str | None = None
    skills_requirements: str | None = None
    start_date: date | None = None
    end_date: date | None = None
    location: str | None = None
    settlement_method: str = "Post"
    remark: str | None = None


class TrainingPlanRead(BaseModel):
    id: int
    enterprise_id: int
    name: str
    position_type: str | None
    headcount: int
    budget: float | None
    education_requirements: str | None
    major_requirements: str | None
    skills_requirements: str | None
    start_date: date | None
    end_date: date | None
    location: str | None
    settlement_method: str
    status: str
    remark: str | None

    class Config:
        from_attributes = True


