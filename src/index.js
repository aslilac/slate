import { Elm } from "./Main.elm";

const DAY = 1000 * 60 * 60 * 24;
const timezoneOffset = new Date().getTimezoneOffset() * 60 * 1000;
const dayOfGame = Math.floor((Date.now() - timezoneOffset) / DAY);

Elm.Main.init({
	node: document.querySelector("#app"),
	flags: { dayOfGame },
});
