const { CollectStream } = require('./CollectStream');
const { DuplexMock } = require('stream-mock');

test('should collect values sent by the stream', async () => {
  const stream = new DuplexMock({ readableObjectMode: true, writableObjectMode: true });

  const results = await new CollectStream(stream).process(['1', '1', '1']);

  expect(results).toEqual(expect.arrayContaining(['1', '1', '1']));
});

test('should not collect values if the it has already collected', async () => {
  const stream = new DuplexMock({ readableObjectMode: true, writableObjectMode: true });

  let collectStream = new CollectStream(stream);
  await collectStream.process(['1', '1', '1']);

  try {
    await collectStream.process(['1', '1', '1']);
  } catch (e) {
    expect(collectStream.closed).toBe(true);
  }
});
