Phony: install-go-tools
install-go-tools:
	@echo Install tools from tools.go
	@command cat tools.go | grep _ | awk -F'"' '{print $$2}' | xargs -tI % go install %

Phony: install-crates
install-crates:
	@cargo install --locked < ./crates.txt

Phony: link
link:
	@dotfiles link
