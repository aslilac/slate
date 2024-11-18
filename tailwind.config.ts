import Typography from "@tailwindcss/typography";

export default {
	content: ["./**/*.elm"],
	plugins: [Typography],
	theme: {
		fontFamily: {
			title: ['"Cormorant"', "ui-serif", "system-ui"],
			sans: ["Outfit", "ui-sans-serif", "sans-serif"],
		},
		extend: {},
	},
} satisfies import("tailwindcss").Config;
