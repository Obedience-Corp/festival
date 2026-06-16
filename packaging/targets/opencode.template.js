import { fileURLToPath } from "node:url";

const installer = fileURLToPath(new URL("../scripts/ensure-festival.sh", import.meta.url));

export default async ({ $ }) => {
  await $`bash ${installer}`.catch(() => {});
  return {};
};
