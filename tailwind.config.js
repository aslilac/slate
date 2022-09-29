module.exports = {
	content: ["./src/**/*.elm"],
	plugins: [require("@tailwindcss/typography")],
	theme: {
		fontFamily: {
			slate: ['"Cormorant Infant"', "ui-sans-serif", "system-ui"],
		},
		extend: {},
	},
};
