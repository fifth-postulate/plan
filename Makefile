SERVER_DIR=server
CLIENT_DIR=client
SOURCE_LOCATION=src/Main.elm
OUTPUT_DIR=static/js
OUTPUT_NAME=plan
OUTPUT_FILE=$(OUTPUT_NAME).js
MINIFIED_OUTPUT_FILE=$(OUTPUT_NAME).min.js

$(SERVER_DIR)/$(OUTPUT_DIR)/$(MINIFIED_OUTPUT_FILE): $(SERVER_DIR)/$(OUTPUT_DIR)/$(OUTPUT_FILE)
	uglifyjs $< --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=$@


$(SERVER_DIR)/$(OUTPUT_DIR)/$(OUTPUT_FILE): $(CLIENT_DIR)/$(SOURCE_LOCATION)
	cd client; elm make --optimize --output ../$@ $(subst $(CLIENT_DIR)/,,$<)
