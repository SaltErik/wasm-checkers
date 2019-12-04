export default async function init() {
  const response = await fetch(`./checkers.wasm`);
  const buffer = await response.arrayBuffer();
  const { instance } = await WebAssembly.instantiate(buffer);
  const { exports } = instance;
  return await exports;
}
