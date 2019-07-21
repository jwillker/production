class CollectStream {
  constructor(stream) {
    this.stream = stream;
    this.result = [];
    this.closed = false;
  }

  /** Collects all data from a stream into a list of responses given a
   * initial list of requests.
   *
   * Prematurely returns the collected array in case the stream errors.
   *
   * Closes the stream after all the requests have been returned.
   *
   * @param requests {Array<Object>} - list of requests to be written in the stream
   * @returns {Promise<Array<Object>>} - list of responses collected
   */
  process(requests) {
    return new Promise((resolve, reject) => {
      if (this.closed) reject(new Error('Stream is closed'));

      this.stream.on('data', response => this.onData(requests, response));
      this.stream.on('error', () => resolve(this.result));
      this.stream.on('end', () => resolve(this.result));
      requests.forEach(req => this.stream.write(req));
    });
  }

  onData(requests, response) {
    this.result.push(response);
    if (requests.length === this.result.length) {
      this.closed = true;
      this.stream.end();
    }
  }
}

module.exports.CollectStream = CollectStream;
