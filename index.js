import { Elm } from "./src/Main.elm";

Elm.Main.init({
	node: document.querySelector("#app"),
	flags: { dayOfGame: 69 },
});
