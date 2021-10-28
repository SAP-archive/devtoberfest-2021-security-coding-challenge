const cds = require('@sap/cds/lib');

const { expect, GET, POST, PATCH, DEL, data } = cds.test(
  'serve',
  '--in-memory',
  '--project',
  `${__dirname}/..`
);

data.autoReset(true); // delete + redeploy from CSV before each test

const test = {
  user: {
    username: 'user',
    password: 'user',
  },
  alice: {
    username: 'alice',
    password: '',
  },
  bob: {
    username: 'bob',
    password: '',
  },
};

let errorMsg;

describe('devtoberfest-2021-security-coding-challenge', () => {
  it('[CORS][Add A Content Security Policy] GET `/browse/$metadata` - serves ODATA with CORS protection', async () => {
    const { headers, status, data } = await GET('/browse/$metadata', {
      auth: test.alice,
    });
    expect(status).to.equal(200);
    expect(headers).to.contain({
      'access-control-allow-origin': 'http://localhost:4004',
      'access-control-allow-credentials': 'true',
      'content-security-policy':
        "default-src 'self';base-uri 'self';block-all-mixed-content;font-src 'self' https: data:;frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src 'self';script-src-attr 'none';style-src 'self' https: 'unsafe-inline';upgrade-insecure-requests",
    });
  });

  it('[Add authentication to your CAP Service] GET  `/inernal/Books` & `/browse/Books` no-existing-user - should return 401 - Unauthorized', async () => {
    try {
      const { headers, status, data } = await GET('/browse/Books', {
        auth: test.user,
      });
    } catch (error) {
      errorMsg = error.message;
    }
    expect(errorMsg).to.equal('401 - Unauthorized');

    try {
      const { headers, status, data } = await GET('/internal/Books', {
        auth: test.user,
      });
    } catch (error) {
      errorMsg = error.message;
    }
    expect(errorMsg).to.equal('401 - Unauthorized');
  });

  it('[Add authentication to your CAP Service] GET `/inernal/Books` bob - should return `403 - Forbidden`', async () => {
    try {
      const { headers, status, data } = await GET('/internal/Books', {
        auth: test.bob,
      });
    } catch (error) {
      errorMsg = error.message;
    }
    expect(errorMsg).to.equal('403 - Forbidden');
  });

  it('[Add Access Control to your CAP Model/Service] POST `/inernal/Books` & `/browse/Books` bob - should return `403 - Forbidden`', async () => {
    try {
      const { headers, status, data } = await POST(
        '/browse/Books',
        {},
        {
          auth: test.bob,
        }
      );
    } catch (error) {
      errorMsg = error.message;
    }
    expect(errorMsg).to.equal('403 - Forbidden');

    try {
      const { headers, status, data } = await POST(
        '/browse/Books',
        {},
        {
          auth: test.alice,
        }
      );
    } catch (error) {
      errorMsg = error.message;
    }
    expect(errorMsg).to.equal('403 - Forbidden');
  });

  it('[Add Access Control to your CAP Model/Service] POST `/inernal/Books` alice - should be succesful`', async () => {
    const { headers, status, data } = await POST(
      '/internal/Books',
      { ID: 77, title: 'test', stock: 10 },
      {
        auth: test.alice,
      }
    );
    expect(status).to.equal(201);
  });

  it('[Add Access Control to your CAP Model/Service] PATCH `/inernal/Books` alice - should return record with title updated', async () => {
    const { headers, status, data } = await PATCH(
      '/internal/Books(77)',
      { ID: 77, title: 'updated', stock: 10 },
      {
        auth: test.alice,
      }
    );
    expect(data.title).to.equal('updated');
  });

  it('[Add Access Control to your CAP Model/Service] DEL `/inernal/Books` alice - should return `405 - Entity "Books" is not deletable`', async () => {
    try {
      const { headers, status, data } = await DEL('/internal/Books(77)', {
        auth: test.alice,
      });
    } catch (error) {
      errorMsg = error.message;
    }
    expect(errorMsg).to.equal('405 - Entity "Books" is not deletable');
  });

  it('[Add Access Control to your CAP Model/Service] POST `/inernal/Books` bob - should return `403 - Forbidden`', async () => {
    try {
      const { headers, status, data } = await POST(
        '/internal/Books',
        { ID: 77, title: 'test', stock: 10 },
        {
          auth: test.bob,
        }
      );
    } catch (error) {
      errorMsg = error.message;
    }
    expect(errorMsg).to.equal('403 - Forbidden');
  });

  it('[Add Instance Based Authorization (Row Level Checks)] GET `/browse/Books` bob - should return 1 stock', async () => {
    const { headers, status, data } = await GET('/browse/Books/$count', {
      auth: test.bob,
    });
    expect(data).to.equal(1);
  });

  it('[Add Instance Based Authorization (Row Level Checks)] GET `/inernal/Book` alice - return 2 stock`', async () => {
    const { headers, status, data } = await GET('/internal/Books/$count', {
      auth: test.alice,
    });
    expect(data).to.equal(2);
  });

  it('[Add Instance Based Authorization (Row Level Checks)] GET `/inernal/Book` alice - return 1 stock`', async () => {
    const { headers, status, data } = await GET('/browse/Books/$count', {
      auth: test.alice,
    });
    expect(data).to.equal(1);
  });
});
