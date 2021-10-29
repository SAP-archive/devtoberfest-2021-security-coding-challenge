const cds = require('@sap/cds/lib');
const user = require('@sap/cds/lib/req/user');

const { expect, GET, POST, PATCH, DEL, data } = cds.test(
  'serve',
  '--in-memory',
  '--project',
  `${__dirname}/..`
);
const { users } = require('./constants');
data.autoReset(true); // delete + redeploy from CSV before each test

// let errorMsg;

describe('devtoberfest-2021-security-coding-challenge', () => {
  it('[CORS][Add A Content Security Policy] GET `/browse/$metadata` - serves ODATA with CORS protection', async () => {
    const { headers, status } = await GET('/browse/$metadata', {
      auth: users.alice,
    });
    expect(status).to.equal(200);
    expect(headers).to.contain({
      'access-control-allow-origin': 'http://localhost:4004',
      'access-control-allow-credentials': 'true',
      'content-security-policy':
        "default-src 'self';base-uri 'self';block-all-mixed-content;font-src 'self' https: data:;frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src 'self';script-src-attr 'none';style-src 'self' https: 'unsafe-inline';upgrade-insecure-requests",
    });
  });

  it('[Add authentication to your CAP Service] GET  `/inernal/Books` & `/browse/Books` <no-existing-user> - should return 401 - Unauthorized', async () => {
    // https://cap.cloud.sap/docs/node.js/cds-test#be-relaxed-when-checking-error-messages
    await expect(GET('/browse/$metadata')).to.be.rejectedWith(/401/i);
    await expect(GET('/browse/Books')).to.be.rejectedWith(/401/i);
    await expect(GET('/internal/Books')).to.be.rejectedWith(/401/i);
  });

  it('[Add authentication to your CAP Service] GET `/inernal/Books` <bob> - should return `403 - Forbidden`', async () => {
    await expect(
      GET('/internal/Books', { auth: users.bob })
    ).to.be.rejectedWith(/403/i);
  });

  it('[Add Access Control to your CAP Model/Service] POST `/inernal/Books` & `/browse/Books` <bob> - should return `403 - Forbidden`', async () => {
    await expect(
      POST('/internal/Books', {}, { auth: users.bob })
    ).to.be.rejectedWith(/403/i);

    await expect(
      POST('/browse/Books', {}, { auth: users.bob })
    ).to.be.rejectedWith(/403/i);
  });

  it('[Add Access Control to your CAP Model/Service] POST `/inernal/Books` <alice> - should be succesful`', async () => {
    const { data } = await POST(
      '/internal/Books',
      { ID: 77, title: 'test', stock: 10 },
      { auth: users.alice }
    );
    // https://cap.cloud.sap/docs/node.js/cds-test#check-response-data-instead-of-status-codes
    // expect(status).to.equal(201);
    expect(data).to.containSubset({ ID: 77 });
  });

  it('[Add Access Control to your CAP Model/Service] PATCH `/inernal/Books` alice - should return record with title updated', async () => {
    const { data } = await PATCH(
      '/internal/Books(77)',
      { ID: 77, title: 'updated', stock: 10 },
      { auth: users.alice }
    );
    expect(data).to.containSubset({ title: 'updated' });
  });

  it('[Add Access Control to your CAP Model/Service] DEL `/inernal/Books` alice - should return `405 - Entity "Books" is not deletable`', async () => {
    await expect(
      DEL('/internal/Books(1)', { auth: users.alice })
    ).to.be.rejectedWith(/405/i);
  });

  it('[Add Access Control to your CAP Model/Service] POST `/inernal/Books` bob - should return `403 - Forbidden`', async () => {
    await expect(
      POST(
        '/internal/Books',
        { ID: 77, title: 'test', stock: 10 },
        { auth: users.bob }
      )
    ).to.be.rejectedWith(/403/i);
  });

  it('[Add Instance Based Authorization (Row Level Checks)] GET `/browse/Books` bob - should return 1 stock', async () => {
    const { data } = await GET('/browse/Books/$count', {
      auth: users.bob,
    });
    expect(data).to.equal(1);
  });

  it('[Add Instance Based Authorization (Row Level Checks)] GET `/inernal/Book` alice - return 2 stock`', async () => {
    const { data } = await GET('/internal/Books/$count', {
      auth: users.alice,
    });
    expect(data).to.equal(2);
  });

  it('[Add Instance Based Authorization (Row Level Checks)] GET `/inernal/Book` alice - return 1 stock`', async () => {
    const { data } = await GET('/browse/Books/$count', {
      auth: users.alice,
    });
    expect(data).to.equal(1);
  });
});
