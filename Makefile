.PHONY: validate test lint run
validate:
	python scripts/validate_repository.py
lint:
	ruff format --check app tests
	ruff check app tests
	mypy app
test:
	PYTHONPATH=. pytest --cov=app --cov-branch --cov-report=term-missing --cov-fail-under=85
run:
	uvicorn app.main:app --reload --port 8000
