import ElmPlugin from "vite-plugin-elm";

export default {
	root: "src/",
	plugins: [ElmPlugin()],
	base: "./",
	build: {
		emptyOutDir: true,
		outDir: "../build/",
	},
} satisfies import("vite").UserConfig;
