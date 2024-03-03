BUILD_DIR = build
CLEANCSS =  C:\Users\ASUS\Documents\Tools\jitsi-meet\node_modules\.bin\cleancss
DEPLOY_DIR = libs
LIBJITSIMEET_DIR = node_modules/lib-jitsi-meet
OLM_DIR = node_modules/@matrix-org/olm
TF_WASM_DIR = node_modules/@tensorflow/tfjs-backend-wasm/dist/
RNNOISE_WASM_DIR = node_modules/@jitsi/rnnoise-wasm/dist
EXCALIDRAW_DIR = node_modules/@jitsi/excalidraw/dist/excalidraw-assets
EXCALIDRAW_DIR_DEV = node_modules/@jitsi/excalidraw/dist/excalidraw-assets-dev
TFLITE_WASM = react/features/stream-effects/virtual-background/vendor/tflite
MEET_MODELS_DIR  = react/features/stream-effects/virtual-background/vendor/models
FACE_MODELS_DIR = node_modules/@vladmandic/human-models/models
NODE_SASS = C:\Users\ASUS\Documents\Tools\jitsi-meet\node_modules\.bin\sass
NPM = npm
OUTPUT_DIR = .
STYLES_BUNDLE = css/all.bundle.css
STYLES_DESTINATION = css/all.css
STYLES_MAIN = css/main.scss
ifeq ($(OS),Windows_NT)
	WEBPACK = .\node_modules\.bin\webpack
	WEBPACK_DEV_SERVER = .\node_modules\.bin\webpack serve --mode development
else
	WEBPACK = ./node_modules/.bin/webpack
	WEBPACK_DEV_SERVER = ./node_modules/.bin/webpack serve --mode development
endif

all: compile deploy clean

compile:
	NODE_OPTIONS=--max-old-space-size=8192 \
	$(WEBPACK)

clean:
	rm -fr $(BUILD_DIR)

.NOTPARALLEL:
deploy: deploy-init deploy-appbundle deploy-rnnoise-binary deploy-excalidraw deploy-tflite deploy-meet-models deploy-lib-jitsi-meet deploy-olm deploy-tf-wasm deploy-css deploy-local deploy-face-landmarks

deploy-init:
	rd /s /q "libs"
	mkdir $(DEPLOY_DIR)

deploy-appbundle:
	copy     $(BUILD_DIR)/app.bundle.min.js $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/app.bundle.min.js.map $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/external_api.min.js $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/external_api.min.js.map $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/alwaysontop.min.js $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/alwaysontop.min.js.map $(DEPLOY_DIR)
	copy     $(OUTPUT_DIR)/analytics-ga.js $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/analytics-ga.min.js $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/analytics-ga.min.js.map $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/face-landmarks-worker.min.js $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/face-landmarks-worker.min.js.map $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/noise-suppressor-worklet.min.js $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/noise-suppressor-worklet.min.js.map $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/screenshot-capture-worker.min.js $(DEPLOY_DIR)
	copy     $(BUILD_DIR)/screenshot-capture-worker.min.js.map $(DEPLOY_DIR)
	copy	 $(BUILD_DIR)/close3.min.js $(DEPLOY_DIR)
	copy	 $(BUILD_DIR)/close3.min.js.map $(DEPLOY_DIR)
deploy-lib-jitsi-meet:
	copy node_modules\lib-jitsi-meet\dist\umd\lib-jitsi-meet.* libs

deploy-olm:
	copy node_modules\@matrix-org\olm\olm.wasm libs

deploy-tf-wasm:
	copy node_modules\@tensorflow\tfjs-backend-wasm\dist\\*.wasm libs

deploy-rnnoise-binary:
	copy node_modules\@jitsi\rnnoise-wasm\dist\rnnoise.wasm libs

deploy-tflite:
	copy react\features\stream-effects\virtual-background\vendor\tflite\*.wasm libs

deploy-excalidraw:
	copy node_modules\@jitsi\excalidraw\dist\excalidraw-assets libs

deploy-excalidraw-dev:
	copy  react\features\stream-effects\virtual-background\vendor\models\*.tflite  libs

deploy-meet-models:
	copy react\features\stream-effects\virtual-background\vendor\models\*.tflite libs

deploy-face-landmarks:
	copy node_modules\@vladmandic\human-models\models\blazeface-front.bin  libs
	copy node_modules\@vladmandic\human-models\models\blazeface-front.json libs
	copy node_modules\@vladmandic\human-models\models\emotion.bin  libs
	copy node_modules\@vladmandic\human-models\models\emotion.json  libs
		

deploy-css:
	$(NODE_SASS) $(STYLES_MAIN) $(STYLES_BUNDLE) && \
	$(CLEANCSS) --skip-rebase $(STYLES_BUNDLE) > $(STYLES_DESTINATION) 

deploy-local:
	([ ! -x deploy-local.sh ] || ./deploy-local.sh)

.NOTPARALLEL:
dev: deploy-init deploy-css deploy-rnnoise-binary deploy-tflite deploy-meet-models deploy-lib-jitsi-meet deploy-olm deploy-tf-wasm deploy-excalidraw-dev deploy-face-landmarks
	$(WEBPACK_DEV_SERVER)

source-package:
	mkdir -p source_package/jitsi-meet/css && \
	copy -r *.js *.html resources/*.txt fonts images libs static sounds LICENSE lang source_package/jitsi-meet && \
	copy css/all.css source_package/jitsi-meet/css && \
	(cd source_package ; tar cjf ../jitsi-meet.tar.bz2 jitsi-meet) && \
	rm -rf source_package
