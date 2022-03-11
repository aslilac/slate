import { Elm } from "./src/Main.elm";

const DAY = 1000 * 60 * 60 * 24;
const dayOfGame = Math.floor(Date.now() / DAY);

Elm.Main.init({
	node: document.querySelector("#app"),
	flags: { dayOfGame },
});
