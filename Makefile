TEST_FILE ?= lua/custom

# Run each spec file in its own nvim instance. PlenaryBustedDirectory crashes
# on Neovim 0.12 ("too many results to unpack" in plenary's on_exit handler
# when path_len > 1); invoking PlenaryBustedFile per-file stays on the
# path_len == 1 code path which streams output line-by-line and never calls
# unpack on a job result.
test:
	@fail=0; \
	for f in $$(find $(TEST_FILE) -name '*_spec.lua' -type f | sort); do \
		echo "==> $$f"; \
		nvim --headless -c "PlenaryBustedFile $$f" || fail=1; \
	done; \
	exit $$fail
