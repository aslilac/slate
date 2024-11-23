import ElmPlugin from "vite-plugin-elm";
import TailwindPlugin from "@tailwindcss/vite";

export default {
	root: "src/",
	plugins: [ElmPlugin(), TailwindPlugin()],
	base: "./",
	build: {
		emptyOutDir: true,
		outDir: "../build/",
	},
} satisfies import("vite").UserConfig;
