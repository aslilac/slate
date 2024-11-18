import ElmPlugin from "vite-plugin-elm";

export default {
	root: "src/",
	plugins: [ElmPlugin()],
	build: {
		outDir: "../build/",
	},
} satisfies import("vite").UserConfig;
