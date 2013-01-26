// Generated by CoffeeScript 1.4.0
(function() {
  var Api, ProxyFrame;

  Api = window.zooniverse.Api;

  ProxyFrame = window.zooniverse.ProxyFrame;

  describe('Api', function() {
    describe('with an available host', function() {
      before(function() {
        return this.api = new Api({
          project: 'test',
          host: "" + location.protocol + "//" + location.host,
          path: '/test/helpers/proxy#for-api-tests'
        });
      });
      after(function() {
        return this.api.destroy();
      });
      it('creates a new ProxyFrame', function() {
        return expect(this.api.proxyFrame.el.parent()).to.match('body');
      });
      it('has an associated project', function() {
        return expect(this.api.project).to.equal('test');
      });
      it('marks itself as "current"', function() {
        return expect(Api.current).to.be(this.api);
      });
      it('can make a GET request', function(done) {
        return this.api.get('/marco', function(response) {
          if (response === 'polo') {
            return done();
          }
        });
      });
      it('can make a POST request', function(done) {
        return this.api.post('/marco', function(response) {
          if (response === 'polo') {
            return done();
          }
        });
      });
      it('can make a PUT request', function(done) {
        return this.api.put('/marco', function(response) {
          if (response === 'polo') {
            return done();
          }
        });
      });
      return it('can make a DELETE request', function(done) {
        return this.api["delete"]('/marco', function(response) {
          if (response === 'polo') {
            return done();
          }
        });
      });
    });
    return describe('with an unavailable host', function() {
      before(function() {
        return this.api = new Api({
          projecy: 'test',
          host: "" + location.protocol + "//" + location.host,
          path: '/bad-path-for-api-tests',
          loadTimeout: 100
        });
      });
      after(function() {
        return this.api.destroy();
      });
      it('rejects a GET request immediately', function(done) {
        return this.api.get('/marco', {}, null, function(response) {
          expect(response).to.equal(ProxyFrame.REJECTION);
          return done();
        });
      });
      it('rejects a POST request immediately', function(done) {
        return this.api.post('/marco', {}, null, function(response) {
          expect(response).to.equal(ProxyFrame.REJECTION);
          return done();
        });
      });
      it('rejects a PUT request immediately', function(done) {
        return this.api.put('/marco', {}, null, function(response) {
          expect(response).to.equal(ProxyFrame.REJECTION);
          return done();
        });
      });
      return it('rejects a DELETE request immediately', function(done) {
        return this.api["delete"]('/marco', {}, null, function(response) {
          expect(response).to.equal(ProxyFrame.REJECTION);
          return done();
        });
      });
    });
  });

}).call(this);
