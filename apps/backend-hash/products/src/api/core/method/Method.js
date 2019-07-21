class Method {
  async execute() {
    throw new Error('Not yet implemented');
  }

  asFunction() {
    return this.execute.bind(this);
  }

  userId(req) {
    return this.header(req, 'x-user-id');
  }

  header(req, name) {
    let data = req.metadata.get(name);
    return data && data[0];
  }
}

module.exports.Method = Method;
