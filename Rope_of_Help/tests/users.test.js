const Users = require('../src/repositories/Users');

const users = new Users();

describe('users', () => {
    test('users.changeOfAccessLevel', async () => {
        expect(await users.changeOfAccessLevel(null,null)).toBe('error, no data');
    });

    test('users.deleteAlienAccount', async () => {
        expect(await users.deleteAlienAccount(null,null)).toBe('error, no data');
    });

    test('users.deleteOwnAccount', async () => {
        expect(await users.deleteOwnAccount(null,)).toBe('Nothing to delete');
    });

});