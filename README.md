mingw32-make dev

WEBPACK = .\node_modules\.bin\webpack
WEBPACK_DEV_SERVER = .\node_modules\.bin\webpack serve --mode development
npx webpack serve --mode development

exec node "./node_module/webpack/bin/webpack.js" "--mode development"
