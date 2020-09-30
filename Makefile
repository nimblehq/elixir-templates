.PHONY: install_phoenix create_project inject_dependency apply_template

install_phoenix:
	printf "Y\n" | mix archive.install hex phx_new ${PHOENIX_VERSION}

create_project:
	mix phx.new ${PROJECT_PATH}

inject_dependency:
	cd ${PROJECT_PATH} && \
	echo '{:nimble_phx_gen_template, path: "../"},' > nimble_phx_gen_template.txt && \
	sed -i -e '/{:phoenix, "~> /r nimble_phx_gen_template.txt' mix.exs && \
	rm nimble_phx_gen_template.txt && \
	mix deps.get && \
	mix format

apply_template:
	cd ${PROJECT_PATH} && \
	printf "Y\nY\nY\nY\n" | mix nimble.phx.gen.template --${VARIANT}
