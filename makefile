.SILENT: setup
TEMPLATE_APP_NAME=Nimble
TEMPLATE_OTP_NAME=nimble
setup:
	echo "Bootstraping $(APP_NAME)"

	echo "🤖 Renaming modules and variables"
	find . ! -path "./deps/*" -name "*.ex*" -print0 | xargs -0 sed -i '' -e "s/Nimble/$(APP_NAME)/g"
	find . ! -path "./deps/*" -name "*.ex*" -print0 | xargs -0 sed -i '' -e "s/nimble/$(OTP_NAME)/g"

	echo "📝 Renaming files"
	mv lib/nimble.ex lib/$(OTP_NAME).ex
	mv lib/nimble_web.ex lib/$(OTP_NAME)_web.ex
	mv lib/nimble lib/$(OTP_NAME)
	mv lib/nimble_web lib/$(OTP_NAME)_web

	if [ -d test/$(TEMPLATE_OTP_NAME) ]; then \
		mv test/$(TEMPLATE_OTP_NAME) test/$(OTP_NAME); \
	fi

	if [ -d test/$(TEMPLATE_OTP_NAME)_web ]; then \
		mv test/$(TEMPLATE_OTP_NAME)_web test/$(OTP_NAME)_web; \
	fi

	echo "\n\n❗️If you cloned this template from Github, you may want to reinitialize git:"
	echo "    rm -rf .git/"
	echo ""
	