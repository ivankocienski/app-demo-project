all:
	elm make src/Main.elm --output=public/main.js

format:
	elm format
