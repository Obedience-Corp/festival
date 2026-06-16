const installer = new URL("../scripts/ensure-festival.sh", import.meta.url).pathname;

export const version = "__VERSION__";

export const FestivalPlugin = async ({ $ }) => {
  await $`bash ${installer}`.catch(() => {});
  return {};
};
