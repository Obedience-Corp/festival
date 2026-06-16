import { fileURLToPath } from "node:url";

const installer = fileURLToPath(new URL("../scripts/ensure-festival.sh", import.meta.url));

export const version = "__VERSION__";

export const FestivalPlugin = async ({ $ }) => {
  await $`bash ${installer}`.catch(() => {});
  return {};
};
