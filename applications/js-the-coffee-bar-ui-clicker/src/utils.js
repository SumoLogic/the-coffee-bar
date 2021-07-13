const util = require('util');

const delay = util.promisify(setTimeout);

module.exports = {
    getItemFromList: function (list) {
        return list[Math.floor((Math.random() * list.length))];
    },

    sleep: async function (seconds) {
        return new Promise(resolve => setTimeout(resolve, seconds * 1000));
    },

    getRandomNumber: function (min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1) + min);
    },

    retry: async (fn, retryDelay = 10, numRetries = 3) => {
        for (let i = 0; i < numRetries; i++) {
            try {
                return await fn()
            } catch (e) {
                console.error(e)
                if (i === numRetries - 1) throw e
                await delay(retryDelay * 1000)
                retryDelay = retryDelay * 2
            }
        }
    }
}
