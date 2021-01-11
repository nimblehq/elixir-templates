.PHONY: install_phoenix create_phoenix_project apply_phoenix_template create_mix_project apply_mix_template remove_nimble_template

# Y - in response to Are you sure you want to install "phx_new-${PHOENIX_VERSION}.ez"?
install_phoenix:
	printf "Y\n" | mix archive.install hex phx_new ${PHOENIX_VERSION}

create_phoenix_project:
	mix phx.new ${PROJECT_DIRECTORY} ${OPTIONS}
	
create_mix_project:
	mix new ${PROJECT_DIRECTORY} ${OPTIONS}

# Y - in response to Will you host this project on Github?
# Y - in response to Do you want to generate the .github/ISSUE_TEMPLATE and .github/PULL_REQUEST_TEMPLATE?
# Y - in response to Do you want to generate the Github Action workflow?
# Y - in response to Would you like to add the Oban addon?
common_addon_prompts = Y\nY\nY\nY\n

web_addon_prompts = 

api_addon_prompts = 

live_addon_prompts = 

# Y - in response to Will you host this project on Github?
# Y - in response to Do you want to generate the .github/ISSUE_TEMPLATE and .github/PULL_REQUEST_TEMPLATE?
# Y - in response to Do you want to generate the Github Action workflow?
# Y - in response to Would you like to add the Mimic addon?
mix_addon_prompts = Y\nY\nY\nY\n

# Y - in response to Fetch and install dependencies?
post_setup_addon_prompts = Y\n

apply_phoenix_template:
	cd ${PROJECT_DIRECTORY} && \
	echo '{:nimble_template, path: "../", only: :dev, runtime: false},' > nimble_template.txt && \
	sed -i -e '/{:phoenix, "~> /r nimble_template.txt' mix.exs && \
	rm nimble_template.txt && \
	mix deps.get && \
	mix format && \
	if [ $(VARIANT) = web ]; then \
		printf "${common_addon_prompts}${web_addon_prompts}${post_setup_addon_prompts}" | mix nimble_template.gen --web; \
	elif [ $(VARIANT) = api ]; then \
		printf "${common_addon_prompts}${api_addon_prompts}${post_setup_addon_prompts}" | mix nimble_template.gen --api; \
	elif [ $(VARIANT) = live ]; then \
		printf "${common_addon_prompts}${web_addon_prompts}${live_addon_prompts}${post_setup_addon_prompts}" | mix nimble_template.gen --live; \
	fi;
	
apply_mix_template:
	cd ${PROJECT_DIRECTORY} && \
	echo '{:nimble_template, path: "../", only: :dev, runtime: false}' > nimble_template.txt && \
	sed -i -e '/# {:dep_from_git, /r nimble_template.txt' mix.exs && \
	rm nimble_template.txt && \
	mix deps.get && \
	mix format && \
	printf "${mix_addon_prompts}${post_setup_addon_prompts}" | mix nimble_template.gen --mix; \

remove_nimble_template:
	cd ${PROJECT_DIRECTORY} && \
	sed -i -e 's/{:nimble_template, path: "..\/"},//' mix.exs
