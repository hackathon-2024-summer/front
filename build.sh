#!/bin/bash
set -e

export $(xargs <.env)

DIR="react-app"

if [ -d $DIR ]; then
  cd ./react-app
else
  npm create vite@latest react-app -- --template react-swc
  cd ./react-app
  # npmライブラリはここに追加して下さい。
  yarn add react react-dom react-router-dom classnames sass react-hook-form react-select react-helmet-async react-icons
  yarn add vite-plugin-svgr @vitejs/plugin-react-swc tailwindcss postcss autoprefixer dayjs react-icons
  npx tailwindcss init -p
  cp ../vite.config.js ./vite.config.js
  # sed -i "s/content: \[\]/content: \[\".\/src\/\*\*\/\*.{js,jsx,ts,tsx}\"\]/" tailwind.config.js
  # cp ../index.css ./src/index.css
  # cp ../App.tsx ./src/App.tsx
  # cp ../App.css ./src/App.css
  # cp ../tailwind.config.js ./tailwind.config.js
fi

# clone直後はnode_modulesフォルダだけが無い。package.jsonに基づいてインストール
yarn

if [ "$NODE_ENV" = "development" ]; then
  yarn run dev
elif [ "$NODE_ENV" = "production" ]; then
  yarn remove @types/react-dom @vitejs/plugin-react-swc
  yarn add @types/react-dom @vitejs/plugin-react-swc
  yarn run build
fi

# tail -f /dev/null
