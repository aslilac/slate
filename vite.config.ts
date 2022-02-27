import type { UserConfig } from "vite";
import elmPlugin from "vite-plugin-elm";

export default {
	build: { outDir: "./build/" },
	publicDir: "./build/",
	plugins: [elmPlugin()],
} as UserConfig;
