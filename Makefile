TEST_FILE ?= .

test:
	nvim --headless -c "PlenaryBustedDirectory $(TEST_FILE)"

