from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from .. import models, schemas
from ..deps import get_db


router = APIRouter(prefix="/api/plans", tags=["training_plans"])


@router.get("/", response_model=List[schemas.TrainingPlanRead])
def list_plans(db: Session = Depends(get_db)) -> List[models.TrainingPlan]:
    return db.query(models.TrainingPlan).all()


@router.get("/{plan_id}", response_model=schemas.TrainingPlanRead)
def get_plan(plan_id: int, db: Session = Depends(get_db)) -> models.TrainingPlan:
    plan = db.query(models.TrainingPlan).filter(models.TrainingPlan.id == plan_id).first()
    if not plan:
        raise HTTPException(status_code=404, detail="plan not found")
    return plan


@router.post("/", response_model=schemas.TrainingPlanRead, status_code=status.HTTP_201_CREATED)
def create_plan(payload: schemas.TrainingPlanCreate, db: Session = Depends(get_db)) -> models.TrainingPlan:
    enterprise = db.query(models.Enterprise).filter(models.Enterprise.id == payload.enterprise_id).first()
    if not enterprise:
        raise HTTPException(status_code=400, detail="enterprise not found")
    plan = models.TrainingPlan(
        enterprise_id=payload.enterprise_id,
        name=payload.name,
        position_type=payload.position_type,
        headcount=payload.headcount,
        budget=payload.budget,
        education_requirements=payload.education_requirements,
        major_requirements=payload.major_requirements,
        skills_requirements=payload.skills_requirements,
        start_date=payload.start_date,
        end_date=payload.end_date,
        location=payload.location,
        settlement_method=payload.settlement_method,
        remark=payload.remark,
        status="Pending",
    )
    db.add(plan)
    db.commit()
    db.refresh(plan)
    return plan


@router.put("/{plan_id}", response_model=schemas.TrainingPlanRead)
def update_plan(plan_id: int, payload: schemas.TrainingPlanCreate, db: Session = Depends(get_db)) -> models.TrainingPlan:
    plan = db.query(models.TrainingPlan).filter(models.TrainingPlan.id == plan_id).first()
    if not plan:
        raise HTTPException(status_code=404, detail="plan not found")
    plan.name = payload.name
    plan.position_type = payload.position_type
    plan.headcount = payload.headcount
    plan.budget = payload.budget
    plan.education_requirements = payload.education_requirements
    plan.major_requirements = payload.major_requirements
    plan.skills_requirements = payload.skills_requirements
    plan.start_date = payload.start_date
    plan.end_date = payload.end_date
    plan.location = payload.location
    plan.settlement_method = payload.settlement_method
    plan.remark = payload.remark
    db.commit()
    db.refresh(plan)
    return plan

