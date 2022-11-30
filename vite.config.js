import elmPlugin from "vite-plugin-elm";

/**
 * @type {import("vite").UserConfig}
 */
export default {
	build: { outDir: "./build/" },
	plugins: [elmPlugin()],
};
