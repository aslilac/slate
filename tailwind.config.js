module.exports = {
	content: ["./src/**/*.elm"],
	plugins: [require("@tailwindcss/typography")],
	theme: {
		fontFamily: {
			hello: [
				'"Cormorant Infant"',
				'"Alegreya Sans"',
				'"Nanum Gothic"',
				"ui-sans-serif",
				"system-ui",
			],
			serif: ["ui-serif", "Georgia"],
			mono: ["ui-monospace", "SFMono-Regular"],
			display: ["Oswald"],
			body: ['"Open Sans"'],
			// --font-code: "JetBrains Mono", monospace;
			// --font-decor: , sans-serif;
			// --font-mono: "Cutive Mono", monospace;
			// --font-sans-serif: "Nanum Gothic", sans-serif;
			// --font-serif: "Cormorant Infant", serif;
			// --font-soft: "Nunito", sans-serif;
		},
		extend: {},
	},
};
