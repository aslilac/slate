module.exports = {
	content: ["./**/*.elm"],
	plugins: [require("@tailwindcss/typography")],
	theme: {
		fontFamily: {
			slate: ['"Cormorant Infant"', "ui-sans-serif", "system-ui"],
		},
		extend: {},
	},
};
