# Overcooked lessons: learners work lesson by lesson.
#   make test      → run the current lesson's suite (tofu test)
#   make hint      → print the current lesson's staged hints
#   make grade     → instructor scoreboard for all lessons
#   make grade L=05 → grade one lesson
L ?= 01

.PHONY: setup test hint grade grade-all clean-state

setup:
	./setup.sh

test:
	cd $(L) && tofu test

hint:
	cd $(L) && cat HINT.md

grade:
	./grade.sh

grade-all: grade

clean-state:
	find . -name "terraform.tfstate*" -delete
	find . -name ".terraform" -type d -exec rm -rf {} +