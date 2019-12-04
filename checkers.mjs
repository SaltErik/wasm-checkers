import init from './init.mjs';

const BLACK = 1;
const WHITE = 2;
const CROWNED_BLACK = 5;
const CROWNED_WHITE = 6;

const assert = (predicate) => {
  if (!predicate) throw Error(`Assertion failed!`);
};

const test = async () => {
  const wasm = await init();
  console.dir(wasm);
  console.log(`Offset for 3,4 is`, wasm.offsetForPosition(3,4));
  console.log(`White is white?`, !!wasm.isWhite(WHITE));
  console.log(`Black is black?`, !!wasm.isBlack(BLACK));
  console.log(`Black is white?`, !!wasm.isWhite(BLACK));
  console.log(`White is black?`, !!wasm.isBlack(WHITE));
  console.log(`Uncrowned white`, !!wasm.isWhite(wasm.removeCrown(CROWNED_WHITE)));
  console.log(`Uncrowned black`, !!wasm.isBlack(wasm.removeCrown(CROWNED_BLACK)));
  console.log(`Crowned black is crowned`, !!wasm.isCrowned(CROWNED_BLACK));
  console.log(`Crowned white is crowned`, !!wasm.isCrowned(CROWNED_WHITE));
};

test();
